const std = @import("std");
const pd_api = @import("playdate.zig");
const PlaydateAPI = pd_api.PlaydateAPI;
const LCDSprite = pd_api.LCDSprite;
const LCDBitmap = pd_api.LCDBitmap;
const PDButtons = pd_api.PDButtons;
const PDSystemEvent = pd_api.PDSystemEvent;
const PDRect = pd_api.PDRect;
const PDRectMake = pd_api.PDRectMake;
const LCDBitmapFlip = pd_api.LCDBitmapFlip;
const SpriteCollisionResponseType = pd_api.SpriteCollisionResponseType;

var rng: std.Random = undefined;
var pd: *const PlaydateAPI = undefined;

var score: c_int = 0;
var max_background_planes: c_int = 10;
var background_plane_count: c_int = 0;
var background_plane_height: f32 = 0;

var max_enemies: c_int = 10;
var enemy_count: c_int = 0;
var enemy_plane_height: f32 = 0;

var player: *LCDSprite = undefined;
var bullet_height: f32 = 0;

var background_sprite: *LCDSprite = undefined;
var background_image: *LCDBitmap = undefined;
var bg_y: c_int = 0;
var bg_h: c_int = 0;

var explosion_images: [8]*LCDBitmap = undefined;
var bullet_image: *LCDBitmap = undefined;
var enemy_plane_image: *LCDBitmap = undefined;
var background_plane_image: *LCDBitmap = undefined;

const SpriteType = enum(u8) {
    Player = 0,
    PlayerBullet = 1,
    EnemyPlane = 2,
};

fn load_image_at_path(path: [*]const u8) !*LCDBitmap {
    var err: ?[*]const u8 = null;
    const img = pd.graphics.loadBitmap(path, &err);

    if (img == null) {
        pd.system.logToConsole("Error loading image at path '%s': %s", path, err);
        return error.LoadFailed;
    }

    return img.?;
}

export fn eventHandler(playdate: *PlaydateAPI, event: PDSystemEvent, _: u32) c_int {
    if (event == PDSystemEvent.Init) {
        pd = playdate;
        pd.display.setRefreshRate(20);
        pd.system.setUpdateCallback(update, null);
        setup_game();
    }

    return 0;
}

export fn update(_: ?*anyopaque) c_int {
    check_buttons();
    check_crank();

    spawn_enemy_if_needed();
    spawn_background_plane_if_needed();

    pd.sprite.updateAndDrawSprites();

    return 1;
}

fn check_buttons() void {
    var pushed: PDButtons = undefined;
    pd.system.getButtonState(null, &pushed, null);

    if (pushed.A or pushed.B) {
        player_fire();
    }
}

fn check_crank() void {
    const change = pd.system.getCrankChange();

    if (change > 1) {
        max_enemies += 1;
        if (max_enemies > 119) max_enemies = 119;
        pd.system.logToConsole("Maximum number of enemy planes: %d", max_enemies);
    } else if (change < -1) {
        max_enemies -= 1;
        if (max_enemies < 0) max_enemies = 0;
        pd.system.logToConsole("Maximum number of enemy planes: %d", max_enemies);
    }
}

fn setup_game() void {
    const seed = pd.system.getSecondsSinceEpoch(null);
    var prng = std.Random.DefaultPrng.init(seed);
    rng = prng.random();

    setup_background();
    player = create_player(200, 180);
    preload_images();
}

fn preload_images() void {
    for (0..8) |i| {
        var path: ?[*]u8 = null;
        _ = pd.system.formatString(&path, "images/explosion/%d", i + 1);
        if (path == null) {
            pd.system.logToConsole("Error preloading images");
        } else {
            explosion_images[i] = load_image_at_path(path.?) catch unreachable;
            _ = pd.system.realloc(path, 0);
            path = null;
        }
    }

    bullet_image = load_image_at_path("images/doubleBullet") catch unreachable;
    enemy_plane_image = load_image_at_path("images/plane1") catch unreachable;
    background_plane_image = load_image_at_path("images/plane2") catch unreachable;
}

// Background

fn draw_background_sprite(_: *LCDSprite, _: PDRect, _: PDRect) callconv(.C) void {
    pd.graphics.drawBitmap(background_image, 0, bg_y, LCDBitmapFlip.Unflipped);
    pd.graphics.drawBitmap(background_image, 0, bg_y - bg_h, LCDBitmapFlip.Unflipped);
}

fn update_background_sprite(_: *LCDSprite) callconv(.C) void {
    bg_y += 1;
    if (bg_y > bg_h) {
        bg_y = 0;
    }

    pd.sprite.markDirty(background_sprite);
}

fn setup_background() void {
    background_sprite = pd.sprite.newSprite();

    background_image = load_image_at_path("images/background") catch unreachable;
    pd.graphics.getBitmapData(background_image, null, &bg_h, null, null, null);

    pd.sprite.setUpdateFunction(background_sprite, update_background_sprite);
    pd.sprite.setDrawFunction(background_sprite, draw_background_sprite);

    const bg_bounds = PDRectMake(0, 0, 400, 240);
    pd.sprite.setBounds(background_sprite, bg_bounds);

    pd.sprite.setZIndex(background_sprite, 0);

    pd.sprite.addSprite(background_sprite);
}

// Explosions

fn update_explosion(sprite: *LCDSprite) callconv(.C) void {
    const frame_number = pd.sprite.getTag(sprite) + 1;

    if (frame_number > 7) {
        pd.sprite.removeSprite(sprite);
        pd.sprite.freeSprite(sprite);
    } else {
        pd.sprite.setTag(sprite, frame_number);
        pd.sprite.setImage(sprite, explosion_images[frame_number], LCDBitmapFlip.Unflipped);
    }
}

fn create_explosion(x: f32, y: f32) void {
    const sprite = pd.sprite.newSprite();

    pd.sprite.setUpdateFunction(sprite, update_explosion);
    pd.sprite.setImage(sprite, explosion_images[0], LCDBitmapFlip.Unflipped);
    pd.sprite.moveTo(sprite, x, y);
    pd.sprite.setZIndex(sprite, 2000);
    pd.sprite.addSprite(sprite);
    pd.sprite.setTag(sprite, 1);
}

// Enemy planes

fn update_enemy_plane(sprite: *LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.getPosition(sprite, &x, &y);

    const new_y = y + 4;

    if (new_y > 400 + enemy_plane_height) {
        pd.sprite.removeSprite(sprite);
        pd.sprite.freeSprite(sprite);
        enemy_count -= 1;
    } else {
        pd.sprite.moveTo(sprite, x, new_y);
    }
}

fn enemy_plane_collision_response(_: *LCDSprite, _: *LCDSprite) callconv(.C) SpriteCollisionResponseType {
    pd.system.logToConsole("return Overlap from enemy plane!");
    return SpriteCollisionResponseType.Overlap;
}

fn create_enemy_plane() *LCDSprite {
    const plane = pd.sprite.newSprite();

    pd.sprite.setUpdateFunction(plane, update_enemy_plane);
    pd.sprite.setCollisionResponseFunction(plane, enemy_plane_collision_response);

    var w: c_int = undefined;
    var tmp_enemy_plane_height: c_int = undefined;
    pd.graphics.getBitmapData(enemy_plane_image, &w, &tmp_enemy_plane_height, null, null, null);
    enemy_plane_height = @floatFromInt(tmp_enemy_plane_height);
    pd.sprite.setImage(plane, enemy_plane_image, LCDBitmapFlip.Unflipped);

    const cr = PDRectMake(0, 0, @as(f32, @floatFromInt(w)), enemy_plane_height);
    pd.sprite.setCollideRect(plane, cr);

    const rand = @as(c_int, @intCast(rng.uintAtMost(c_uint, std.math.maxInt(c_int))));
    pd.sprite.moveTo(plane, @floatFromInt(@rem(rand, 400) - @divFloor(w, 2)), -@as(f32, @floatFromInt(@rem(rand, 30))) - enemy_plane_height);

    pd.sprite.setZIndex(plane, 500);
    pd.sprite.addSprite(plane);

    pd.sprite.setTag(plane, @intFromEnum(SpriteType.EnemyPlane));

    enemy_count += 1;

    return plane;
}

fn destroy_enemy_plane(plane: *LCDSprite) void {
    var x: f32 = undefined;
    var y: f32 = undefined;

    pd.sprite.getPosition(plane, &x, &y);
    create_explosion(x, y);

    pd.sprite.removeSprite(plane);
    pd.sprite.freeSprite(plane);
    enemy_count -= 1;
}

fn spawn_enemy_if_needed() void {
    if (enemy_count >= max_enemies) {
        return;
    }

    const rand = @as(c_int, @intCast(rng.uintAtMost(c_uint, std.math.maxInt(c_int))));
    if (@divFloor(@rem(rand, 120), max_enemies) == 0) {
        _ = create_enemy_plane();
    }
}

// background planes

fn update_background_plane(sprite: *LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.getPosition(sprite, &x, &y);

    const new_y = y + 2;

    if (new_y > 400 + background_plane_height) {
        pd.sprite.removeSprite(sprite);
        pd.sprite.freeSprite(sprite);
        background_plane_count -= 1;
    } else {
        pd.sprite.moveTo(sprite, x, new_y);
    }
}

fn create_background_plane() *LCDSprite {
    const plane = pd.sprite.newSprite();

    pd.sprite.setUpdateFunction(plane, update_background_plane);

    var w: c_int = undefined;
    var tmp_background_plane_height: c_int = undefined;
    pd.graphics.getBitmapData(background_plane_image, &w, &tmp_background_plane_height, null, null, null);
    background_plane_height = @floatFromInt(tmp_background_plane_height);

    pd.sprite.setImage(plane, background_plane_image, LCDBitmapFlip.Unflipped);

    const rand = rng.uintAtMost(c_uint, std.math.maxInt(c_int));
    pd.sprite.moveTo(plane, @floatFromInt(@divFloor(@rem(rand, 400) - 2, 2)), -background_plane_height);

    pd.sprite.setZIndex(plane, 100);
    pd.sprite.addSprite(plane);

    background_plane_count += 1;

    return plane;
}

fn spawn_background_plane_if_needed() void {
    if (background_plane_count >= max_background_planes) {
        return;
    }

    const rand = @as(c_int, @intCast(std.Random.uintAtMost(rng, c_uint, std.math.maxInt(c_int))));
    if (@rem(rand, @divFloor(120, max_background_planes)) == 0) {
        _ = create_background_plane();
    }
}

// player plane

fn player_fire_collision_response(_: *LCDSprite, _: *LCDSprite) callconv(.C) SpriteCollisionResponseType {
    return SpriteCollisionResponseType.Overlap;
}

fn update_player_fire(sprite: *LCDSprite) callconv(.C) void {
    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.getPosition(sprite, &x, &y);

    const new_y: f32 = y - 20.0;

    if (new_y < -bullet_height) {
        pd.sprite.removeSprite(sprite);
        pd.sprite.freeSprite(sprite);
    } else {
        var len: c_int = undefined;
        const collision_info = pd.sprite.moveWithCollisions(sprite, x, new_y, null, null, &len);

        var hit = false;

        for (0..@intCast(len)) |i| {
            const info = collision_info[i];

            if (pd.sprite.getTag(info.other) == @intFromEnum(SpriteType.EnemyPlane)) {
                destroy_enemy_plane(info.other);
                hit = true;
                score += 1;
                pd.system.logToConsole("Score: %d", score);
            }
        }

        if (hit) {
            pd.sprite.removeSprite(sprite);
            pd.sprite.freeSprite(sprite);
        }

        _ = pd.system.realloc(collision_info, 0);
    }
}

fn player_fire() void {
    const bullet = pd.sprite.newSprite();

    pd.sprite.setUpdateFunction(bullet, update_player_fire);

    var w: c_int = undefined;
    var tmp_bullet_height: c_int = undefined;
    pd.graphics.getBitmapData(bullet_image, &w, &tmp_bullet_height, null, null, null);
    bullet_height = @floatFromInt(tmp_bullet_height);

    pd.sprite.setImage(bullet, bullet_image, LCDBitmapFlip.Unflipped);

    const cr = PDRectMake(0, 0, @floatFromInt(w), bullet_height);
    pd.sprite.setCollideRect(bullet, cr);

    pd.sprite.setCollisionResponseFunction(bullet, player_fire_collision_response);

    const bounds = pd.sprite.getBounds(player);

    pd.sprite.moveTo(bullet, bounds.x + bounds.width / 2, bounds.y);
    pd.sprite.setZIndex(bullet, 999);
    pd.sprite.addSprite(bullet);

    pd.sprite.setTag(bullet, @intFromEnum(SpriteType.PlayerBullet));
}

fn player_collision_response(_: *LCDSprite, _: *LCDSprite) callconv(.C) SpriteCollisionResponseType {
    return SpriteCollisionResponseType.Overlap;
}

fn update_player(sprite: *LCDSprite) callconv(.C) void {
    var current: pd_api.PDButtons = undefined;
    pd.system.getButtonState(&current, null, null);

    var dx: f32 = 0;
    var dy: f32 = 0;

    if (current.Up) {
        dy = -4;
    } else if (current.Down) {
        dy = 4;
    }

    if (current.Left) {
        dx = -4;
    } else if (current.Right) {
        dx = 4;
    }

    var x: f32 = undefined;
    var y: f32 = undefined;
    pd.sprite.getPosition(sprite, &x, &y);

    var len: c_int = undefined;
    const collision_info = pd.sprite.moveWithCollisions(sprite, x + dx, y + dy, null, null, &len);

    for (0..@intCast(len)) |i| {
        const info = collision_info[i];

        if (pd.sprite.getTag(info.other) == @intFromEnum(SpriteType.EnemyPlane)) {
            destroy_enemy_plane(info.other);
            score -= 1;
            pd.system.logToConsole("Score: %d", score);
        }
    }

    _ = pd.system.realloc(collision_info, 0);
}

fn create_player(center_x: f32, center_y: f32) *LCDSprite {
    const plane = pd.sprite.newSprite();

    pd.sprite.setUpdateFunction(plane, update_player);

    const plane_image = load_image_at_path("images/player") catch unreachable;
    var w: c_int = undefined;
    var h: c_int = undefined;
    pd.graphics.getBitmapData(plane_image, &w, &h, null, null, null);

    pd.sprite.setImage(plane, plane_image, LCDBitmapFlip.Unflipped);

    const cr = PDRectMake(5, 5, @as(f32, @floatFromInt(w)) - 10, @as(f32, @floatFromInt(h)) - 10);
    pd.sprite.setCollideRect(plane, cr);
    pd.sprite.setCollisionResponseFunction(plane, player_collision_response);

    pd.sprite.moveTo(plane, center_x, center_y);

    pd.sprite.setZIndex(plane, 1000);
    pd.sprite.addSprite(plane);

    pd.sprite.setTag(plane, @intFromEnum(SpriteType.Player));

    background_plane_count += 1;

    return plane;
}
