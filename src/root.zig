const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cDefine("TARGET_EXTENSION", "1");
    @cDefine("TARGET_SIMULATOR", "1");
    @cInclude("/home/sam/.local/share/playdate-sdk/C_API/pd_api.h");
});

var pd: *const c.PlaydateAPI = undefined;

var score: c_int = 0;
var max_background_planes: c_int = 10;
var background_plane_count: c_int = 0;
var background_plane_height: f32 = 0;

var max_enemies: c_int = 10;
var enemy_count: c_int = 0;
var enemy_plane_height: f32 = 0;

var player: ?*c.LCDSprite = undefined;
var bullet_height: f32 = 0;

var background_sprite: ?*c.LCDSprite = undefined;
var background_image: ?*c.LCDBitmap = undefined;
var bg_y: c_int = 0;
var bg_h: c_int = 0;

var explosion_images: [8]?*c.LCDBitmap = undefined;
var bullet_image: ?*c.LCDBitmap = undefined;
var enemy_plane_image: ?*c.LCDBitmap = undefined;
var background_plane_image: ?*c.LCDBitmap = undefined;

const SpriteType = enum(u8) {
    kPlayer = 0,
    kPlayerBullet = 1,
    kEnemyPlane = 2,
};

fn load_image_at_path(path: [*c]const u8) ?*c.LCDBitmap {
    var err: ?*const u8 = null;
    const img = pd.graphics.*.loadBitmap.?(path, &err);

    if (err != null) {
        pd.system.*.logToConsole.?("Error loading image at path '%s': %s", path, err);
    }

    return img;
}

export fn eventHandler(playdate: [*c]c.PlaydateAPI, event: c.PDSystemEvent, _: u32) c_int {
    if (event == c.kEventInit) {
        pd = playdate;
        pd.display.*.setRefreshRate.?(20);
        pd.system.*.setUpdateCallback.?(update, null);
        setup_game();
    }

    return 0;
}

export fn update(_: ?*anyopaque) c_int {
    check_buttons();
    check_crank();

    spawn_enemy_if_needed();
    spawn_background_plane_if_needed();

    pd.sprite.*.updateAndDrawSprites.?();

    return 1;
}

fn check_buttons() void {
    var pushed: u32 = undefined;
    pd.system.*.getButtonState.?(null, &pushed, null);

    if (pushed & c.kButtonA != 0 or pushed & c.kButtonB != 0) {
        player_fire();
    }
}

fn check_crank() void {
    const change = pd.system.*.getCrankChange.?();

    if (change > 1) {
        max_enemies += 1;
        if (max_enemies > 119) max_enemies = 119;
        pd.system.*.logToConsole.?("Maximum number of enemy planes: %d", max_enemies);
    } else if (change < -1) {
        max_enemies -= 1;
        if (max_enemies < 0) max_enemies = 0;
        pd.system.*.logToConsole.?("Maximum number of enemy planes: %d", max_enemies);
    }
}

fn setup_game() void {
    c.srand(pd.system.*.getSecondsSinceEpoch.?(null));

    setup_background();
    player = create_player(200, 180);
    preload_images();
}

fn preload_images() void {
    for (0..8) |i| {
        var path: ?[*]u8 = null;
        _ = pd.system.*.formatString.?(&path, "images/explosion/%d", i + 1);
        if (path == null) {
            pd.system.*.logToConsole.?("Error preloading images");
        } else {
            explosion_images[i] = load_image_at_path(path.?);
            _ = pd.system.*.realloc.?(path, 0);
            path = null;
        }
    }

    bullet_image = load_image_at_path("images/doubleBullet");
    enemy_plane_image = load_image_at_path("images/plane1");
    background_plane_image = load_image_at_path("images/plane2");
}

// Background

fn draw_background_sprite(_: ?*c.LCDSprite, _: c.PDRect, _: c.PDRect) callconv(.C) void {
    pd.graphics.*.drawBitmap.?(background_image, 0, bg_y, 0);
    pd.graphics.*.drawBitmap.?(background_image, 0, bg_y - bg_h, 0);
}

fn update_background_sprite(_: ?*c.LCDSprite) callconv(.C) void {
    bg_y += 1;
    if (bg_y > bg_h) {
        bg_y = 0;
    }

    pd.sprite.*.markDirty.?(background_sprite);
}

fn setup_background() void {
    background_sprite = pd.sprite.*.newSprite.?().?;

    background_image = load_image_at_path("images/background");
    pd.graphics.*.getBitmapData.?(background_image, null, &bg_h, null, null, null);

    pd.sprite.*.setUpdateFunction.?(background_sprite, update_background_sprite);
    pd.sprite.*.setDrawFunction.?(background_sprite, draw_background_sprite);

    const bg_bounds = c.PDRectMake(0, 0, 400, 240);
    pd.sprite.*.setBounds.?(background_sprite, bg_bounds);

    pd.sprite.*.setZIndex.?(background_sprite, 0);

    pd.sprite.*.addSprite.?(background_sprite);
}

// Explosions

fn update_explosion(sprite: ?*c.LCDSprite) callconv(.C) void {
    const frame_number = pd.sprite.*.getTag.?(sprite) + 1;

    if (frame_number > 7) {
        pd.sprite.*.removeSprite.?(sprite);
        pd.sprite.*.freeSprite.?(sprite);
    } else {
        pd.sprite.*.setTag.?(sprite, frame_number);

        const frame_image = explosion_images[frame_number];
        if (frame_image == null) {
            pd.system.*.logToConsole.?("NULL FRAME %d", frame_number);
        }

        pd.sprite.*.setImage.?(sprite, explosion_images[frame_number], c.kBitmapUnflipped);
    }
}

fn create_explosion(x: f32, y: f32) void {
    const sprite = pd.sprite.*.newSprite.?();

    pd.sprite.*.setUpdateFunction.?(sprite, update_explosion);
    pd.sprite.*.setImage.?(sprite, explosion_images[0], c.kBitmapUnflipped);
    pd.sprite.*.moveTo.?(sprite, x, y);
    pd.sprite.*.setZIndex.?(sprite, 2000);
    pd.sprite.*.addSprite.?(sprite);
    pd.sprite.*.setTag.?(sprite, 1);
}

// Enemy planes

fn update_enemy_plane(sprite: ?*c.LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.*.getPosition.?(sprite, &x, &y);

    const new_y = y + 4;

    if (new_y > 400 + enemy_plane_height) {
        pd.sprite.*.removeSprite.?(sprite);
        pd.sprite.*.freeSprite.?(sprite);
        enemy_count -= 1;
    } else {
        pd.sprite.*.moveTo.?(sprite, x, new_y);
    }
}

fn enemy_plane_collision_response(_: ?*c.LCDSprite, _: ?*c.LCDSprite) callconv(.C) c.SpriteCollisionResponseType {
    pd.system.*.logToConsole.?("return Overlap from enemy plane!");
    return c.kCollisionTypeOverlap;
}

fn create_enemy_plane() ?*c.LCDSprite {
    const plane = pd.sprite.*.newSprite.?();

    pd.sprite.*.setUpdateFunction.?(plane, update_enemy_plane);
    pd.sprite.*.setCollisionResponseFunction.?(plane, enemy_plane_collision_response);

    var w: c_int = undefined;
    var tmp_enemy_plane_height: c_int = undefined;
    pd.graphics.*.getBitmapData.?(enemy_plane_image, &w, &tmp_enemy_plane_height, null, null, null);
    enemy_plane_height = @floatFromInt(tmp_enemy_plane_height);
    pd.sprite.*.setImage.?(plane, enemy_plane_image, c.kBitmapUnflipped);

    const cr = c.PDRectMake(0, 0, @as(f32, @floatFromInt(w)), enemy_plane_height);
    pd.sprite.*.setCollideRect.?(plane, cr);

    pd.sprite.*.moveTo.?(plane, @floatFromInt(@rem(c.rand(), 400) - @divFloor(w, 2)), -@as(f32, @floatFromInt(@rem(c.rand(), 30))) - enemy_plane_height);

    pd.sprite.*.setZIndex.?(plane, 500);
    pd.sprite.*.addSprite.?(plane);

    pd.sprite.*.setTag.?(plane, @intFromEnum(SpriteType.kEnemyPlane));

    enemy_count += 1;

    return plane;
}

fn destroy_enemy_plane(plane: ?*c.LCDSprite) void {
    var x: f32 = undefined;
    var y: f32 = undefined;

    pd.sprite.*.getPosition.?(plane, &x, &y);
    create_explosion(x, y);

    pd.sprite.*.removeSprite.?(plane);
    pd.sprite.*.freeSprite.?(plane);
    enemy_count -= 1;
}

fn spawn_enemy_if_needed() void {
    if (enemy_count >= max_enemies) {
        return;
    }

    if (@divFloor(@rem(c.rand(), 120), max_enemies) == 0) {
        _ = create_enemy_plane();
    }
}

// background planes

fn update_background_plane(sprite: ?*c.LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.*.getPosition.?(sprite, &x, &y);

    const new_y = y + 2;

    if (new_y > 400 + background_plane_height) {
        pd.sprite.*.removeSprite.?(sprite);
        pd.sprite.*.freeSprite.?(sprite);
        background_plane_count -= 1;
    } else {
        pd.sprite.*.moveTo.?(sprite, x, new_y);
    }
}

fn create_background_plane() ?*c.LCDSprite {
    const plane = pd.sprite.*.newSprite.?();

    pd.sprite.*.setUpdateFunction.?(plane, update_background_plane);

    var w: c_int = undefined;
    var tmp_background_plane_height: c_int = undefined;
    pd.graphics.*.getBitmapData.?(background_plane_image, &w, &tmp_background_plane_height, null, null, null);
    background_plane_height = @floatFromInt(tmp_background_plane_height);

    pd.sprite.*.setImage.?(plane, background_plane_image, c.kBitmapUnflipped);

    pd.sprite.*.moveTo.?(plane, @floatFromInt(@divFloor(@rem(c.rand(), 400) - 2, 2)), -background_plane_height);

    pd.sprite.*.setZIndex.?(plane, 100);
    pd.sprite.*.addSprite.?(plane);

    background_plane_count += 1;

    return plane;
}

fn spawn_background_plane_if_needed() void {
    if (background_plane_count >= max_background_planes) {
        return;
    }

    if (@rem(c.rand(), @divFloor(120, max_background_planes)) == 0) {
        _ = create_background_plane();
    }
}

// player plane

fn player_fire_collision_response(_: ?*c.LCDSprite, _: ?*c.LCDSprite) callconv(.C) c.SpriteCollisionResponseType {
    return c.kCollisionTypeOverlap;
}

fn update_player_fire(sprite: ?*c.LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.*.getPosition.?(sprite, &x, &y);

    const new_y: f32 = y - 20.0;

    if (new_y < -bullet_height) {
        pd.sprite.*.removeSprite.?(sprite);
        pd.sprite.*.freeSprite.?(sprite);
    } else {
        var len: c_int = undefined;
        const collision_info = pd.sprite.*.moveWithCollisions.?(sprite, x, new_y, null, null, &len);

        var hit = false;

        for (0..@intCast(len)) |i| {
            const info = collision_info[i];

            if (pd.sprite.*.getTag.?(info.other) == @intFromEnum(SpriteType.kEnemyPlane)) {
                destroy_enemy_plane(info.other);
                hit = true;
                score += 1;
                pd.system.*.logToConsole.?("Score: %d", score);
            }
        }

        if (hit) {
            pd.sprite.*.removeSprite.?(sprite);
            pd.sprite.*.freeSprite.?(sprite);
        }

        _ = pd.system.*.realloc.?(collision_info, 0);
    }
}

fn player_fire() void {
    const bullet = pd.sprite.*.newSprite.?();

    pd.sprite.*.setUpdateFunction.?(bullet, update_player_fire);

    var w: c_int = undefined;
    var tmp_bullet_height: c_int = undefined;
    pd.graphics.*.getBitmapData.?(bullet_image, &w, &tmp_bullet_height, null, null, null);
    bullet_height = @floatFromInt(tmp_bullet_height);

    pd.sprite.*.setImage.?(bullet, bullet_image, c.kBitmapUnflipped);

    const cr = c.PDRectMake(0, 0, @floatFromInt(w), bullet_height);
    pd.sprite.*.setCollideRect.?(bullet, cr);

    pd.sprite.*.setCollisionResponseFunction.?(bullet, player_fire_collision_response);

    const bounds = pd.sprite.*.getBounds.?(player);

    pd.sprite.*.moveTo.?(bullet, bounds.x + bounds.width / 2, bounds.y);
    pd.sprite.*.setZIndex.?(bullet, 999);
    pd.sprite.*.addSprite.?(bullet);

    pd.sprite.*.setTag.?(bullet, @intFromEnum(SpriteType.kPlayerBullet));
}

fn player_collision_response(_: ?*c.LCDSprite, _: ?*c.LCDSprite) callconv(.C) c.SpriteCollisionResponseType {
    return c.kCollisionTypeOverlap;
}

fn update_player(sprite: ?*c.LCDSprite) callconv(.C) void {
    var current: u32 = undefined;
    pd.system.*.getButtonState.?(&current, null, null);

    var dx: f32 = 0;
    var dy: f32 = 0;

    if (current & c.kButtonUp != 0) {
        dy = -4;
    } else if (current & c.kButtonDown != 0) {
        dy = 4;
    }

    if (current & c.kButtonLeft != 0) {
        dx = -4;
    } else if (current & c.kButtonRight != 0) {
        dx = 4;
    }

    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.*.getPosition.?(sprite, &x, &y);

    var len: c_int = undefined;
    const collision_info = pd.sprite.*.moveWithCollisions.?(sprite, x + dx, y + dy, null, null, &len);

    for (0..@intCast(len)) |i| {
        const info = collision_info[i];

        if (pd.sprite.*.getTag.?(info.other) == @intFromEnum(SpriteType.kEnemyPlane)) {
            destroy_enemy_plane(info.other);
            score -= 1;
            pd.system.*.logToConsole.?("Score: %d", score);
        }
    }

    _ = pd.system.*.realloc.?(collision_info, 0);
}

fn create_player(center_x: f32, center_y: f32) ?*c.LCDSprite {
    const plane = pd.sprite.*.newSprite.?();

    pd.sprite.*.setUpdateFunction.?(plane, update_player);

    const plane_image = load_image_at_path("images/player");
    var w: c_int = undefined;
    var h: c_int = undefined;
    pd.graphics.*.getBitmapData.?(plane_image, &w, &h, null, null, null);

    pd.sprite.*.setImage.?(plane, plane_image, c.kBitmapUnflipped);

    const cr = c.PDRectMake(5, 5, @as(f32, @floatFromInt(w)) - 10, @as(f32, @floatFromInt(h)) - 10);
    pd.sprite.*.setCollideRect.?(plane, cr);
    pd.sprite.*.setCollisionResponseFunction.?(plane, player_collision_response);

    pd.sprite.*.moveTo.?(plane, center_x, center_y);

    pd.sprite.*.setZIndex.?(plane, 1000);
    pd.sprite.*.addSprite.?(plane);

    pd.sprite.*.setTag.?(plane, @intFromEnum(SpriteType.kPlayer));

    background_plane_count += 1;

    return plane;
}
