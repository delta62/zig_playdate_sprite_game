const mem = @import("std").mem;

pub const LCDRect = extern struct {
    left: c_int = mem.zeroes(c_int),
    right: c_int = mem.zeroes(c_int),
    top: c_int = mem.zeroes(c_int),
    bottom: c_int = mem.zeroes(c_int),
};

pub fn LCDMakeRect(x: c_int, y: c_int, width: c_int, height: c_int) callconv(.C) LCDRect {
    return LCDRect{
        .left = x,
        .right = x + width,
        .top = y,
        .bottom = y + height,
    };
}

pub fn LCDRect_translate(r: LCDRect, dx: c_int, dy: c_int) callconv(.C) LCDRect {
    return LCDRect{
        .left = r.left + dx,
        .right = r.right + dx,
        .top = r.top + dy,
        .bottom = r.bottom + dy,
    };
}

pub const LCDBitmapDrawMode = enum(c_uint) {
    Copy = 0,
    WhiteTransparent = 1,
    BlackTransparent = 2,
    FillWhite = 3,
    FillBlack = 4,
    XOR = 5,
    NXOR = 6,
    Inverted = 7,
};

pub const LCDBitmapFlip = enum(c_uint) {
    Unflipped = 0,
    FlippedX = 1,
    FlippedY = 2,
    FlippedXY = 3,
};

const LCDSolidColor = enum(c_uint) {
    Black = 0,
    White = 1,
    Clear = 2,
    XOR = 3,
};

pub const LCDLineCapStyle = enum(c_uint) {
    Butt = 0,
    Square = 1,
    Round = 2,
};

pub const LCDFontLanguage = enum(c_uint) {
    English = 0,
    Japanese = 1,
    Unknown = 3,
};

pub const PDStringEncoding = enum(c_uint) {
    ASCII = 0,
    UTF8 = 1,
    SixteenBitLE = 2,
};

pub const LCDPattern = [16]u8;

pub const LCDColor = usize;

pub const LCDPolygonFillRule = enum(c_uint) {
    NonZero = 0,
    EvenOdd = 1,
};

pub const struct_LCDBitmap = opaque {};
pub const LCDBitmap = struct_LCDBitmap;
pub const struct_LCDBitmapTable = opaque {};
pub const LCDBitmapTable = struct_LCDBitmapTable;
pub const struct_LCDFont = opaque {};
pub const LCDFont = struct_LCDFont;
pub const struct_LCDFontData = opaque {};
pub const LCDFontData = struct_LCDFontData;
pub const struct_LCDFontPage = opaque {};
pub const LCDFontPage = struct_LCDFontPage;
pub const struct_LCDFontGlyph = opaque {};
pub const LCDFontGlyph = struct_LCDFontGlyph;
pub const struct_LCDVideoPlayer = opaque {};
pub const LCDVideoPlayer = struct_LCDVideoPlayer;

pub const struct_playdate_video = extern struct {
    loadVideo: *const fn (path: [*]const u8) callconv(.C) ?*LCDVideoPlayer,
    freePlayer: *const fn (player: *LCDVideoPlayer) callconv(.C) void,
    setContext: *const fn (player: *LCDVideoPlayer, context: *LCDBitmap) callconv(.C) c_int,
    useScreenContext: *const fn (player: *LCDVideoPlayer) callconv(.C) void,
    renderFrame: *const fn (player: *LCDVideoPlayer, n: c_int) callconv(.C) c_int,
    getError: *const fn (player: *LCDVideoPlayer) callconv(.C) ?[*]const u8,
    getInfo: *const fn (player: *LCDVideoPlayer, out_width: ?*c_int, out_height: ?*c_int, out_frame_rate: ?*f32, out_frame_count: ?*c_int, out_current_frame: ?*c_int) callconv(.C) void,
    getContext: *const fn (player: *LCDVideoPlayer) callconv(.C) *LCDBitmap,
};

pub const struct_playdate_graphics = extern struct {
    video: *const playdate_video,
    clear: *const fn (color: LCDColor) callconv(.C) void,
    setBackgroundColor: *const fn (color: LCDSolidColor) callconv(.C) void,
    setStencil: *const fn (stencil: *LCDBitmap) callconv(.C) void,
    setDrawMode: *const fn (mode: LCDBitmapDrawMode) callconv(.C) LCDBitmapDrawMode,
    setDrawOffset: *const fn (dx: c_int, dy: c_int) callconv(.C) void,
    setClipRect: *const fn (x: c_int, y: c_int, width: c_int, height: c_int) callconv(.C) void,
    clearClipRect: *const fn () callconv(.C) void,
    setLineCapStyle: *const fn (style: LCDLineCapStyle) callconv(.C) void,
    setFont: *const fn (font: ?*LCDFont) callconv(.C) void,
    setTextTracking: *const fn (tracking: c_int) callconv(.C) void,
    pushContext: *const fn (context: *LCDBitmap) callconv(.C) void,
    popContext: *const fn () callconv(.C) void,
    drawBitmap: *const fn (bitmap: *LCDBitmap, x: c_int, y: c_int, flip: LCDBitmapFlip) callconv(.C) void,
    tileBitmap: *const fn (bitmap: *LCDBitmap, x: c_int, y: c_int, width: c_int, height: c_int, flip: LCDBitmapFlip) callconv(.C) void,
    drawLine: *const fn (x1: c_int, y1: c_int, x2: c_int, y2: c_int, width: c_int, color: LCDColor) callconv(.C) void,
    fillTriangle: *const fn (x1: c_int, y1: c_int, x2: c_int, y2: c_int, x3: c_int, y3: c_int, color: LCDColor) callconv(.C) void,
    drawRect: *const fn (x: c_int, y: c_int, width: c_int, height: c_int, color: LCDColor) callconv(.C) void,
    fillRect: *const fn (x: c_int, y: c_int, width: c_int, height: c_int, color: LCDColor) callconv(.C) void,
    drawEllipse: *const fn (x: c_int, y: c_int, width: c_int, height: c_int, line_width: c_int, start_angle: f32, end_angle: f32, color: LCDColor) callconv(.C) void,
    fillEllipse: *const fn (x: c_int, y: c_int, width: c_int, height: c_int, start_angle: f32, end_angle: f32, color: LCDColor) callconv(.C) void,
    drawScaledBitmap: *const fn (bitmap: *LCDBitmap, x: c_int, y: c_int, x_scale: f32, y_scale: f32) callconv(.C) void,
    drawText: *const fn (text: *const anyopaque, len: usize, encoding: PDStringEncoding, x: c_int, y: c_int) callconv(.C) c_int,
    newBitmap: *const fn (width: c_int, height: c_int, background_color: LCDColor) callconv(.C) *LCDBitmap,
    freeBitmap: *const fn (*LCDBitmap) callconv(.C) void,
    loadBitmap: *const fn (path: [*]const u8, out_err: *?[*]const u8) callconv(.C) ?*LCDBitmap,
    copyBitmap: *const fn (*LCDBitmap) callconv(.C) *LCDBitmap,
    loadIntoBitmap: *const fn (path: [*]const u8, bitmap: *LCDBitmap, out_err: *?[*]const u8) callconv(.C) void,
    getBitmapData: *const fn (bitmap: *LCDBitmap, width: ?*c_int, height: ?*c_int, row_bytes: ?*c_int, mask: ?*[*]u8, data: ?*[*]u8) callconv(.C) void,
    clearBitmap: *const fn (bitmap: *LCDBitmap, color: LCDColor) callconv(.C) void,
    rotatedBitmap: *const fn (bitmap: *LCDBitmap, rotation: f32, x_scale: f32, y_scale: f32, allocated_size: *c_int) callconv(.C) *LCDBitmap,
    newBitmapTable: *const fn (count: c_int, width: c_int, height: c_int) callconv(.C) *LCDBitmapTable,
    freeBitmapTable: *const fn (*LCDBitmapTable) callconv(.C) void,
    loadBitmapTable: *const fn (path: [*]const u8, out_err: *?[*]const u8) callconv(.C) ?*LCDBitmapTable,
    loadIntoBitmapTable: *const fn (path: *const u8, table: *LCDBitmapTable, out_err: *?[*]const u8) callconv(.C) void,
    getTableBitmap: *const fn (table: *LCDBitmapTable, index: c_int) callconv(.C) ?*LCDBitmap,
    loadFont: *const fn (path: [*]const u8, out_err: *?[*]const u8) callconv(.C) ?*LCDFont,
    getFontPage: *const fn (font: *LCDFont, char: u32) callconv(.C) ?*LCDFontPage,
    getPageGlyph: *const fn (font: *LCDFontPage, char: u32, bitmap: ?**LCDBitmap, advance: ?*c_int) callconv(.C) ?*LCDFontGlyph,
    getGlyphKerning: *const fn (glyph: *LCDFontGlyph, char1: u32, char2: u32) callconv(.C) c_int,
    getTextWidth: *const fn (font: *LCDFont, text: *const anyopaque, len: usize, encoding: PDStringEncoding, c_int) callconv(.C) c_int,
    getFrame: *const fn () callconv(.C) [*]u8,
    getDisplayFrame: *const fn () callconv(.C) [*]u8,
    getDebugBitmap: ?*const fn () callconv(.C) *LCDBitmap,
    copyFrameBufferBitmap: *const fn () callconv(.C) *LCDBitmap,
    markUpdatedRows: *const fn (start: c_int, end: c_int) callconv(.C) void,
    display: *const fn () callconv(.C) void,
    setColorToPattern: *const fn (color: *LCDColor, bitmap: *LCDBitmap, x: c_int, y: c_int) callconv(.C) void,
    checkMaskCollision: *const fn (bitmap1: *LCDBitmap, x1: c_int, y1: c_int, flip1: LCDBitmapFlip, bitmap2: *LCDBitmap, x2: c_int, y2: c_int, flip2: LCDBitmapFlip, rect: LCDRect) callconv(.C) c_int,
    setScreenClipRect: *const fn (x: c_int, y: c_int, width: c_int, height: c_int) callconv(.C) void,
    fillPolygon: *const fn (n_points: c_int, points: [*]c_int, color: LCDColor, fill_rule: LCDPolygonFillRule) callconv(.C) void,
    getFontHeight: *const fn (font: *LCDFont) callconv(.C) u8,
    getDisplayBufferBitmap: *const fn () callconv(.C) *LCDBitmap,
    drawRotatedBitmap: *const fn (bitmap: *LCDBitmap, x: c_int, y: c_int, degrees: f32, center_x: f32, center_y: f32, x_scale: f32, y_scale: f32) callconv(.C) void,
    setTextLeading: *const fn (leading: c_int) callconv(.C) void,
    setBitmapMask: *const fn (bitmap: *LCDBitmap, maks: *LCDBitmap) callconv(.C) c_int,
    getBitmapMask: *const fn (bitmap: *LCDBitmap) callconv(.C) ?*LCDBitmap,
    setStencilImage: *const fn (stencil: *LCDBitmap, c_int) callconv(.C) void,
    makeFontFromData: *const fn (data: *LCDFontData, wide: c_int) callconv(.C) *LCDFont,
    getTextTracking: *const fn () callconv(.C) c_int,
    setPixel: *const fn (x: c_int, y: c_int, color: LCDColor) callconv(.C) void,
    getBitmapPixel: *const fn (bitmap: *LCDBitmap, x: c_int, y: c_int) callconv(.C) LCDSolidColor,
    getBitmapTableInfo: *const fn (table: *LCDBitmapTable, count: ?*c_int, cells_wide: ?*c_int) callconv(.C) void,
};

pub const struct___va_list_tag_2 = extern struct {
    gp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    fp_offset: c_uint = @import("std").mem.zeroes(c_uint),
    overflow_arg_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reg_save_area: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const __builtin_va_list = [1]struct___va_list_tag_2;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __builtin_va_list;

pub const kButtonLeft: c_int = 1;
pub const kButtonRight: c_int = 2;
pub const kButtonUp: c_int = 4;
pub const kButtonDown: c_int = 8;
pub const kButtonB: c_int = 16;
pub const kButtonA: c_int = 32;

pub const PDButtons = packed struct {
    Left: bool,
    Right: bool,
    Up: bool,
    Down: bool,
    B: bool,
    A: bool,
    _padding: u26 = 0,

    comptime {
        @import("std").debug.assert(@sizeOf(@This()) == @sizeOf(c_uint));
        @import("std").debug.assert(@bitSizeOf(@This()) == @bitSizeOf(c_uint));
    }
};

// PDLanguage
pub const Language = enum(c_uint) {
    English = 0,
    Japanese = 1,
    Unknown = 2,
};

pub const struct_PDDateTime = extern struct {
    year: u16 = mem.zeroes(u16),
    month: u8 = mem.zeroes(u8),
    day: u8 = mem.zeroes(u8),
    weekday: u8 = mem.zeroes(u8),
    hour: u8 = mem.zeroes(u8),
    minute: u8 = mem.zeroes(u8),
    second: u8 = mem.zeroes(u8),
};

// PDMenuItem
pub const MenuItem = opaque {};

// PDPeripherals
pub const Peripherals = enum(c_uint) {
    None = 0,
    Accelerometer = 1,
    All = 65535,
};

// PDCallbackFunction
pub const UpdateCallback = fn (userdata: ?*anyopaque) callconv(.C) c_int;
// PDMenuItemCallbackFunction
pub const MenuItemCallback = fn (userdata: ?*anyopaque) callconv(.C) void;
// PDButtonCallbackFunction
pub const ButtonCallback = fn (button: PDButtons, down: c_int, when: u32, userdata: ?*anyopaque) callconv(.C) c_int;

pub const struct_playdate_sys = extern struct {
    realloc: *const fn (ptr: ?*anyopaque, size: usize) callconv(.C) ?*anyopaque,
    formatString: *const fn (out_string: *?[*]u8, format: [*]const u8, ...) callconv(.C) c_int,
    logToConsole: *const fn (format: [*]const u8, ...) callconv(.C) void,
    @"error": *const fn (format: [*]const u8, ...) callconv(.C) void,
    getLanguage: *const fn () callconv(.C) Language,
    getCurrentTimeMilliseconds: *const fn () callconv(.C) c_uint,
    getSecondsSinceEpoch: *const fn (milliseconds: ?*c_uint) callconv(.C) c_uint,
    drawFPS: *const fn (x: c_int, y: c_int) callconv(.C) void,
    setUpdateCallback: *const fn (update: *const UpdateCallback, userdata: ?*anyopaque) callconv(.C) void,
    getButtonState: *const fn (current: ?*PDButtons, pushed: ?*PDButtons, released: ?*PDButtons) callconv(.C) void,
    setPeripheralsEnabled: *const fn (mask: Peripherals) callconv(.C) void,
    getAccelerometer: *const fn (out_x: *f32, out_y: *f32, out_z: *f32) callconv(.C) void,
    getCrankChange: *const fn () callconv(.C) f32,
    getCrankAngle: *const fn () callconv(.C) f32,
    isCrankDocked: *const fn () callconv(.C) c_int,
    setCrankSoundsDisabled: *const fn (disable: c_int) callconv(.C) c_int,
    getFlipped: *const fn () callconv(.C) c_int,
    setAutoLockDisabled: *const fn (disable: c_int) callconv(.C) void,
    setMenuImage: *const fn (bitmap: ?*LCDBitmap, x_offset: c_int) callconv(.C) void,
    addMenuItem: *const fn (title: [*]const u8, callback: *const MenuItemCallback, userdata: ?*anyopaque) callconv(.C) *MenuItem,
    addCheckmarkMenuItem: *const fn (title: [*]const u8, value: c_int, callback: *const MenuItemCallback, userdata: ?*anyopaque) callconv(.C) *MenuItem,
    addOptionsMenuItem: *const fn (title: [*]const u8, options: *[*]const u8, options_count: c_int, callback: *const MenuItemCallback, userdata: ?*anyopaque) callconv(.C) *MenuItem,
    removeAllMenuItems: *const fn () callconv(.C) void,
    removeMenuItem: *const fn (menu_item: *MenuItem) callconv(.C) void,
    getMenuItemValue: *const fn (menu_item: *MenuItem) callconv(.C) c_int,
    setMenuItemValue: *const fn (menu_item: *MenuItem, value: c_int) callconv(.C) void,
    getMenuItemTitle: *const fn (menu_item: *MenuItem) callconv(.C) [*c]const u8,
    setMenuItemTitle: *const fn (menu_item: *MenuItem, title: [*]const u8) callconv(.C) void,
    getMenuItemUserdata: *const fn (menu_item: *MenuItem) callconv(.C) ?*anyopaque,
    setMenuItemUserdata: *const fn (menu_item: *MenuItem, userdata: ?*anyopaque) callconv(.C) void,
    getReduceFlashing: *const fn () callconv(.C) c_int,
    getElapsedTime: *const fn () callconv(.C) f32,
    resetElapsedTime: *const fn () callconv(.C) void,
    getBatteryPercentage: *const fn () callconv(.C) f32,
    getBatteryVoltage: *const fn () callconv(.C) f32,
    getTimezoneOffset: *const fn () callconv(.C) i32,
    shouldDisplay24HourTime: *const fn () callconv(.C) c_int,
    convertEpochToDateTime: *const fn (epoch: u32, datetime: *struct_PDDateTime) callconv(.C) void,
    convertDateTimeToEpoch: *const fn (datetime: *struct_PDDateTime) callconv(.C) u32,
    clearICache: *const fn () callconv(.C) void,
    setButtonCallback: *const fn (callback: *const ButtonCallback, userdata: ?*anyopaque, queuesize: c_int) callconv(.C) void,
    setSerialMessageCallback: *const fn (callback: *const fn (message: [*]const u8) callconv(.C) void) callconv(.C) void,
    vaFormatString: *const fn (ret: *[*]u8, format: [*]const u8, [*c]struct___va_list_tag_2) callconv(.C) c_int,
    parseString: *const fn (str: [*]const u8, format: [*]const u8, ...) callconv(.C) c_int,
};

pub const lua_State = ?*anyopaque;
pub const lua_CFunction = ?*const fn ([*c]lua_State) callconv(.C) c_int;
pub const struct_LuaUDObject = opaque {};
pub const LuaUDObject = struct_LuaUDObject;
pub const struct_LCDSprite = opaque {};
pub const LCDSprite = struct_LCDSprite;
pub const kInt: c_int = 0;
pub const kFloat: c_int = 1;
pub const kStr: c_int = 2;
pub const l_valtype = c_uint;
pub const lua_reg = extern struct {
    name: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    func: lua_CFunction = @import("std").mem.zeroes(lua_CFunction),
};
pub const kTypeNil: c_int = 0;
pub const kTypeBool: c_int = 1;
pub const kTypeInt: c_int = 2;
pub const kTypeFloat: c_int = 3;
pub const kTypeString: c_int = 4;
pub const kTypeTable: c_int = 5;
pub const kTypeFunction: c_int = 6;
pub const kTypeThread: c_int = 7;
pub const kTypeObject: c_int = 8;
pub const enum_LuaType = c_uint;
const union_unnamed_3 = extern union {
    intval: c_uint,
    floatval: f32,
    strval: [*c]const u8,
};
pub const lua_val = extern struct {
    name: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    type: l_valtype = @import("std").mem.zeroes(l_valtype),
    v: union_unnamed_3 = @import("std").mem.zeroes(union_unnamed_3),
};
pub const struct_playdate_lua = extern struct {
    addFunction: ?*const fn (lua_CFunction, [*c]const u8, [*c][*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (lua_CFunction, [*c]const u8, [*c][*c]const u8) callconv(.C) c_int),
    registerClass: ?*const fn ([*c]const u8, [*c]const lua_reg, [*c]const lua_val, c_int, [*c][*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, [*c]const lua_reg, [*c]const lua_val, c_int, [*c][*c]const u8) callconv(.C) c_int),
    pushFunction: ?*const fn (lua_CFunction) callconv(.C) void = @import("std").mem.zeroes(?*const fn (lua_CFunction) callconv(.C) void),
    indexMetatable: ?*const fn () callconv(.C) c_int = @import("std").mem.zeroes(?*const fn () callconv(.C) c_int),
    stop: ?*const fn () callconv(.C) void = @import("std").mem.zeroes(?*const fn () callconv(.C) void),
    start: ?*const fn () callconv(.C) void = @import("std").mem.zeroes(?*const fn () callconv(.C) void),
    getArgCount: ?*const fn () callconv(.C) c_int = @import("std").mem.zeroes(?*const fn () callconv(.C) c_int),
    getArgType: ?*const fn (c_int, [*c][*c]const u8) callconv(.C) enum_LuaType = @import("std").mem.zeroes(?*const fn (c_int, [*c][*c]const u8) callconv(.C) enum_LuaType),
    argIsNil: ?*const fn (c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) c_int),
    getArgBool: ?*const fn (c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) c_int),
    getArgInt: ?*const fn (c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) c_int),
    getArgFloat: ?*const fn (c_int) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) f32),
    getArgString: ?*const fn (c_int) callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) [*c]const u8),
    getArgBytes: ?*const fn (c_int, [*c]usize) callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn (c_int, [*c]usize) callconv(.C) [*c]const u8),
    getArgObject: ?*const fn (c_int, [*c]u8, [*c]?*LuaUDObject) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn (c_int, [*c]u8, [*c]?*LuaUDObject) callconv(.C) ?*anyopaque),
    getBitmap: ?*const fn (c_int) callconv(.C) ?*LCDBitmap = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) ?*LCDBitmap),
    getSprite: ?*const fn (c_int) callconv(.C) ?*LCDSprite = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) ?*LCDSprite),
    pushNil: ?*const fn () callconv(.C) void = @import("std").mem.zeroes(?*const fn () callconv(.C) void),
    pushBool: ?*const fn (c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) void),
    pushInt: ?*const fn (c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) void),
    pushFloat: ?*const fn (f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (f32) callconv(.C) void),
    pushString: ?*const fn ([*c]const u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]const u8) callconv(.C) void),
    pushBytes: ?*const fn ([*c]const u8, usize) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]const u8, usize) callconv(.C) void),
    pushBitmap: ?*const fn (?*LCDBitmap) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*LCDBitmap) callconv(.C) void),
    pushSprite: ?*const fn (?*LCDSprite) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*LCDSprite) callconv(.C) void),
    pushObject: ?*const fn (?*anyopaque, [*c]u8, c_int) callconv(.C) ?*LuaUDObject = @import("std").mem.zeroes(?*const fn (?*anyopaque, [*c]u8, c_int) callconv(.C) ?*LuaUDObject),
    retainObject: ?*const fn (?*LuaUDObject) callconv(.C) ?*LuaUDObject = @import("std").mem.zeroes(?*const fn (?*LuaUDObject) callconv(.C) ?*LuaUDObject),
    releaseObject: ?*const fn (?*LuaUDObject) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*LuaUDObject) callconv(.C) void),
    setUserValue: ?*const fn (?*LuaUDObject, c_uint) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*LuaUDObject, c_uint) callconv(.C) void),
    getUserValue: ?*const fn (?*LuaUDObject, c_uint) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*LuaUDObject, c_uint) callconv(.C) c_int),
    callFunction_deprecated: ?*const fn ([*c]const u8, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]const u8, c_int) callconv(.C) void),
    callFunction: ?*const fn ([*c]const u8, c_int, [*c][*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, c_int, [*c][*c]const u8) callconv(.C) c_int),
};
pub const kJSONNull: c_int = 0;
pub const kJSONTrue: c_int = 1;
pub const kJSONFalse: c_int = 2;
pub const kJSONInteger: c_int = 3;
pub const kJSONFloat: c_int = 4;
pub const kJSONString: c_int = 5;
pub const kJSONArray: c_int = 6;
pub const kJSONTable: c_int = 7;
pub const json_value_type = c_uint;
const union_unnamed_5 = extern union {
    intval: c_int,
    floatval: f32,
    stringval: [*c]u8,
    arrayval: ?*anyopaque,
    tableval: ?*anyopaque,
};
pub const json_value = extern struct {
    type: u8 = @import("std").mem.zeroes(u8),
    data: union_unnamed_5 = @import("std").mem.zeroes(union_unnamed_5),
};
pub fn json_intValue(value: json_value) callconv(.C) c_int {
    while (true) {
        switch (@as(c_int, @bitCast(@as(c_uint, value.type)))) {
            @as(c_int, 3) => return value.data.intval,
            @as(c_int, 4) => return @as(c_int, @intFromFloat(value.data.floatval)),
            @as(c_int, 5) => {
                const numeric: c_long = @truncate(@import("std").fmt.parseInt(c_long, value.data.stringval, 10));
                return @as(c_int, @bitCast(@as(c_int, numeric)));
            },
            @as(c_int, 1) => return 1,
            else => return 0,
        }
        break;
    }
    return 0;
}
pub fn json_floatValue(arg_value: json_value) callconv(.C) f32 {
    var value = arg_value;
    _ = &value;
    while (true) {
        switch (@as(c_int, @bitCast(@as(c_uint, value.type)))) {
            @as(c_int, 3) => return @as(f32, @floatFromInt(value.data.intval)),
            @as(c_int, 4) => return value.data.floatval,
            @as(c_int, 5) => return 0,
            @as(c_int, 1) => return @as(f32, @floatCast(1.0)),
            else => return @as(f32, @floatCast(0.0)),
        }
        break;
    }
    return 0;
}
pub fn json_boolValue(value: json_value) callconv(.C) c_int {
    return if (@as(c_int, @bitCast(@as(c_uint, value.type))) == kJSONString)
        @intFromBool(@import("std").zig.c_builtins.__builtin_strcmp(value.data.stringval, "") != @as(c_int, 0))
    else
        json_intValue(value);
}
pub fn json_stringValue(value: json_value) callconv(.C) [*c]u8 {
    return if (@as(c_int, @bitCast(@as(c_uint, value.type))) == kJSONString) value.data.stringval else null;
}
pub const json_decoder = struct_json_decoder;
pub const struct_json_decoder = extern struct {
    decodeError: ?*const fn ([*c]json_decoder, [*c]const u8, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, [*c]const u8, c_int) callconv(.C) void),
    willDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) void),
    shouldDecodeTableValueForKey: ?*const fn ([*c]json_decoder, [*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, [*c]const u8) callconv(.C) c_int),
    didDecodeTableValue: ?*const fn ([*c]json_decoder, [*c]const u8, json_value) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, [*c]const u8, json_value) callconv(.C) void),
    shouldDecodeArrayValueAtIndex: ?*const fn ([*c]json_decoder, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, c_int) callconv(.C) c_int),
    didDecodeArrayValue: ?*const fn ([*c]json_decoder, c_int, json_value) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, c_int, json_value) callconv(.C) void),
    didDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) ?*anyopaque),
    userdata: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    returnString: c_int = @import("std").mem.zeroes(c_int),
    path: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
};
pub fn json_setTableDecode(arg_decoder: [*c]json_decoder, arg_willDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) void, arg_didDecodeTableValue: ?*const fn ([*c]json_decoder, [*c]const u8, json_value) callconv(.C) void, arg_didDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) ?*anyopaque) callconv(.C) void {
    var decoder = arg_decoder;
    _ = &decoder;
    var willDecodeSublist = arg_willDecodeSublist;
    _ = &willDecodeSublist;
    var didDecodeTableValue = arg_didDecodeTableValue;
    _ = &didDecodeTableValue;
    var didDecodeSublist = arg_didDecodeSublist;
    _ = &didDecodeSublist;
    decoder.*.didDecodeTableValue = didDecodeTableValue;
    decoder.*.didDecodeArrayValue = null;
    decoder.*.willDecodeSublist = willDecodeSublist;
    decoder.*.didDecodeSublist = didDecodeSublist;
}
pub fn json_setArrayDecode(arg_decoder: [*c]json_decoder, arg_willDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) void, arg_didDecodeArrayValue: ?*const fn ([*c]json_decoder, c_int, json_value) callconv(.C) void, arg_didDecodeSublist: ?*const fn ([*c]json_decoder, [*c]const u8, json_value_type) callconv(.C) ?*anyopaque) callconv(.C) void {
    var decoder = arg_decoder;
    _ = &decoder;
    var willDecodeSublist = arg_willDecodeSublist;
    _ = &willDecodeSublist;
    var didDecodeArrayValue = arg_didDecodeArrayValue;
    _ = &didDecodeArrayValue;
    var didDecodeSublist = arg_didDecodeSublist;
    _ = &didDecodeSublist;
    decoder.*.didDecodeTableValue = null;
    decoder.*.didDecodeArrayValue = didDecodeArrayValue;
    decoder.*.willDecodeSublist = willDecodeSublist;
    decoder.*.didDecodeSublist = didDecodeSublist;
}
pub const json_readFunc = fn (?*anyopaque, [*c]u8, c_int) callconv(.C) c_int;
pub const json_reader = extern struct {
    read: ?*const json_readFunc = @import("std").mem.zeroes(?*const json_readFunc),
    userdata: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const json_writeFunc = fn (?*anyopaque, [*c]const u8, c_int) callconv(.C) void;
// /home/sam/.local/share/playdate-sdk/C_API/pd_api/pd_api_json.h:136:6: warning: struct demoted to opaque type - has bitfield
pub const struct_json_encoder = opaque {};
pub const json_encoder = struct_json_encoder;
pub const struct_playdate_json = extern struct {
    initEncoder: ?*const fn (?*json_encoder, ?*const json_writeFunc, ?*anyopaque, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*json_encoder, ?*const json_writeFunc, ?*anyopaque, c_int) callconv(.C) void),
    decode: ?*const fn ([*c]struct_json_decoder, json_reader, [*c]json_value) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]struct_json_decoder, json_reader, [*c]json_value) callconv(.C) c_int),
    decodeString: ?*const fn ([*c]struct_json_decoder, [*c]const u8, [*c]json_value) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]struct_json_decoder, [*c]const u8, [*c]json_value) callconv(.C) c_int),
};
pub const SDFile = anyopaque;

pub const FileOptions = packed struct {
    Read: bool,
    ReadData: bool,
    Write: bool,
    Append: bool,
    _padding: u28 = 0,

    comptime {
        @import("std").debug.assert(@sizeOf(@This()) == @sizeOf(c_uint));
        @import("std").debug.assert(@bitSizeOf(@This()) == @bitSizeOf(c_uint));
    }
};

pub const FileStat = extern struct {
    isdir: c_int = @import("std").mem.zeroes(c_int),
    size: c_uint = @import("std").mem.zeroes(c_uint),
    m_year: c_int = @import("std").mem.zeroes(c_int),
    m_month: c_int = @import("std").mem.zeroes(c_int),
    m_day: c_int = @import("std").mem.zeroes(c_int),
    m_hour: c_int = @import("std").mem.zeroes(c_int),
    m_minute: c_int = @import("std").mem.zeroes(c_int),
    m_second: c_int = @import("std").mem.zeroes(c_int),
};
pub const struct_playdate_file = extern struct {
    geterr: ?*const fn () callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn () callconv(.C) [*c]const u8),
    listfiles: ?*const fn ([*c]const u8, ?*const fn ([*c]const u8, ?*anyopaque) callconv(.C) void, ?*anyopaque, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, ?*const fn ([*c]const u8, ?*anyopaque) callconv(.C) void, ?*anyopaque, c_int) callconv(.C) c_int),
    stat: ?*const fn ([*c]const u8, [*c]FileStat) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, [*c]FileStat) callconv(.C) c_int),
    mkdir: ?*const fn ([*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8) callconv(.C) c_int),
    unlink: ?*const fn ([*c]const u8, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, c_int) callconv(.C) c_int),
    rename: ?*const fn ([*c]const u8, [*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, [*c]const u8) callconv(.C) c_int),
    open: ?*const fn ([*c]const u8, FileOptions) callconv(.C) ?*SDFile = @import("std").mem.zeroes(?*const fn ([*c]const u8, FileOptions) callconv(.C) ?*SDFile),
    close: ?*const fn (?*SDFile) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile) callconv(.C) c_int),
    read: ?*const fn (?*SDFile, ?*anyopaque, c_uint) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile, ?*anyopaque, c_uint) callconv(.C) c_int),
    write: ?*const fn (?*SDFile, ?*const anyopaque, c_uint) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile, ?*const anyopaque, c_uint) callconv(.C) c_int),
    flush: ?*const fn (?*SDFile) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile) callconv(.C) c_int),
    tell: ?*const fn (?*SDFile) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile) callconv(.C) c_int),
    seek: ?*const fn (?*SDFile, c_int, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SDFile, c_int, c_int) callconv(.C) c_int),
};

pub const SpriteCollisionResponseType = enum(c_uint) {
    Slide = 0,
    Freeze = 1,
    Overlap = 2,
    Bounce = 3,
};

pub const PDRect = extern struct {
    x: f32 = mem.zeroes(f32),
    y: f32 = mem.zeroes(f32),
    width: f32 = mem.zeroes(f32),
    height: f32 = mem.zeroes(f32),
};
pub fn PDRectMake(arg_x: f32, arg_y: f32, arg_width: f32, arg_height: f32) callconv(.C) PDRect {
    var x = arg_x;
    _ = &x;
    var y = arg_y;
    _ = &y;
    var width = arg_width;
    _ = &width;
    var height = arg_height;
    _ = &height;
    var r: PDRect = PDRect{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
    _ = &r;
    return r;
}
pub const CollisionPoint = extern struct {
    x: f32 = @import("std").mem.zeroes(f32),
    y: f32 = @import("std").mem.zeroes(f32),
};
pub const CollisionVector = extern struct {
    x: c_int = @import("std").mem.zeroes(c_int),
    y: c_int = @import("std").mem.zeroes(c_int),
};
pub const struct_SpriteCollisionInfo = extern struct {
    sprite: *LCDSprite,
    other: *LCDSprite,
    responseType: SpriteCollisionResponseType,
    overlaps: u8,
    ti: f32,
    move: CollisionPoint,
    normal: CollisionVector,
    touch: CollisionPoint,
    spriteRect: PDRect,
    otherRect: PDRect,
};
pub const SpriteCollisionInfo = struct_SpriteCollisionInfo;
pub const struct_SpriteQueryInfo = extern struct {
    sprite: ?*LCDSprite = @import("std").mem.zeroes(?*LCDSprite),
    ti1: f32 = @import("std").mem.zeroes(f32),
    ti2: f32 = @import("std").mem.zeroes(f32),
    entryPoint: CollisionPoint = @import("std").mem.zeroes(CollisionPoint),
    exitPoint: CollisionPoint = @import("std").mem.zeroes(CollisionPoint),
};
pub const SpriteQueryInfo = struct_SpriteQueryInfo;
pub const struct_CWCollisionInfo = opaque {};
pub const CWCollisionInfo = struct_CWCollisionInfo;
pub const struct_CWItemInfo = opaque {};
pub const CWItemInfo = struct_CWItemInfo;
pub const LCDSpriteDrawFunction = fn (*LCDSprite, PDRect, PDRect) callconv(.C) void;
pub const LCDSpriteUpdateFunction = fn (*LCDSprite) callconv(.C) void;
pub const LCDSpriteCollisionFilterProc = fn (*LCDSprite, *LCDSprite) callconv(.C) SpriteCollisionResponseType;

pub const struct_playdate_sprite = extern struct {
    setAlwaysRedraw: *const fn (flag: c_int) callconv(.C) void,
    addDirtyRect: *const fn (dirty_rect: LCDRect) callconv(.C) void,
    drawSprites: *const fn () callconv(.C) void,
    updateAndDrawSprites: *const fn () callconv(.C) void,
    newSprite: *const fn () callconv(.C) *LCDSprite,
    freeSprite: *const fn (*LCDSprite) callconv(.C) void,
    copy: *const fn (*LCDSprite) callconv(.C) *LCDSprite,
    addSprite: *const fn (*LCDSprite) callconv(.C) void,
    removeSprite: *const fn (*LCDSprite) callconv(.C) void,
    removeSprites: *const fn ([*]*LCDSprite, c_int) callconv(.C) void,
    removeAllSprites: *const fn () callconv(.C) void,
    getSpriteCount: *const fn () callconv(.C) c_int,
    setBounds: *const fn (*LCDSprite, PDRect) callconv(.C) void,
    getBounds: *const fn (*LCDSprite) callconv(.C) PDRect,
    moveTo: *const fn (*LCDSprite, f32, f32) callconv(.C) void,
    moveBy: *const fn (*LCDSprite, f32, f32) callconv(.C) void,
    setImage: *const fn (*LCDSprite, ?*LCDBitmap, LCDBitmapFlip) callconv(.C) void,
    getImage: *const fn (*LCDSprite) callconv(.C) ?*LCDBitmap,
    setSize: *const fn (*LCDSprite, f32, f32) callconv(.C) void,
    setZIndex: *const fn (*LCDSprite, i16) callconv(.C) void,
    getZIndex: *const fn (*LCDSprite) callconv(.C) i16,
    setDrawMode: *const fn (*LCDSprite, LCDBitmapDrawMode) callconv(.C) void,
    setImageFlip: *const fn (*LCDSprite, LCDBitmapFlip) callconv(.C) void,
    getImageFlip: *const fn (*LCDSprite) callconv(.C) LCDBitmapFlip,
    setStencil: *const fn (*LCDSprite, ?*LCDBitmap) callconv(.C) void,
    setClipRect: *const fn (*LCDSprite, LCDRect) callconv(.C) void,
    clearClipRect: *const fn (*LCDSprite) callconv(.C) void,
    setClipRectsInRange: *const fn (LCDRect, c_int, c_int) callconv(.C) void,
    clearClipRectsInRange: *const fn (c_int, c_int) callconv(.C) void,
    setUpdatesEnabled: *const fn (*LCDSprite, c_int) callconv(.C) void,
    updatesEnabled: *const fn (*LCDSprite) callconv(.C) c_int,
    setCollisionsEnabled: *const fn (*LCDSprite, c_int) callconv(.C) void,
    collisionsEnabled: *const fn (*LCDSprite) callconv(.C) c_int,
    setVisible: *const fn (*LCDSprite, c_int) callconv(.C) void,
    isVisible: *const fn (*LCDSprite) callconv(.C) c_int,
    setOpaque: *const fn (*LCDSprite, c_int) callconv(.C) void,
    markDirty: *const fn (*LCDSprite) callconv(.C) void,
    setTag: *const fn (*LCDSprite, u8) callconv(.C) void,
    getTag: *const fn (*LCDSprite) callconv(.C) u8,
    setIgnoresDrawOffset: *const fn (*LCDSprite, c_int) callconv(.C) void,
    setUpdateFunction: *const fn (*LCDSprite, *const LCDSpriteUpdateFunction) callconv(.C) void,
    setDrawFunction: *const fn (*LCDSprite, *const LCDSpriteDrawFunction) callconv(.C) void,
    getPosition: *const fn (*LCDSprite, *f32, *f32) callconv(.C) void,
    resetCollisionWorld: *const fn () callconv(.C) void,
    setCollideRect: *const fn (*LCDSprite, PDRect) callconv(.C) void,
    getCollideRect: *const fn (*LCDSprite) callconv(.C) PDRect,
    clearCollideRect: *const fn (*LCDSprite) callconv(.C) void,
    setCollisionResponseFunction: *const fn (*LCDSprite, *const LCDSpriteCollisionFilterProc) callconv(.C) void,
    checkCollisions: *const fn (*LCDSprite, f32, f32, ?*f32, ?*f32, *c_int) callconv(.C) [*]SpriteCollisionInfo,
    moveWithCollisions: *const fn (*LCDSprite, f32, f32, ?*f32, ?*f32, *c_int) callconv(.C) [*]SpriteCollisionInfo,
    querySpritesAtPoint: *const fn (f32, f32, *c_int) callconv(.C) [*]*LCDSprite,
    querySpritesInRect: *const fn (f32, f32, f32, f32, *c_int) callconv(.C) [*]*LCDSprite,
    querySpritesAlongLine: *const fn (f32, f32, f32, f32, *c_int) callconv(.C) [*]*LCDSprite,
    querySpriteInfoAlongLine: *const fn (f32, f32, f32, f32, *c_int) callconv(.C) [*]SpriteQueryInfo,
    overlappingSprites: *const fn (*LCDSprite, *c_int) callconv(.C) [*]*LCDSprite,
    allOverlappingSprites: *const fn (*c_int) callconv(.C) [*]*LCDSprite,
    setStencilPattern: *const fn (*LCDSprite, [*:8]u8) callconv(.C) void,
    clearStencil: *const fn (*LCDSprite) callconv(.C) void,
    setUserdata: *const fn (*LCDSprite, ?*anyopaque) callconv(.C) void,
    getUserdata: *const fn (*LCDSprite) callconv(.C) ?*anyopaque,
    setStencilImage: *const fn (*LCDSprite, ?*LCDBitmap, c_int) callconv(.C) void,
    setCenter: *const fn (*LCDSprite, f32, f32) callconv(.C) void,
    getCenter: *const fn (*LCDSprite, *f32, *f32) callconv(.C) void,
};

pub const kSound8bitMono: c_int = 0;
pub const kSound8bitStereo: c_int = 1;
pub const kSound16bitMono: c_int = 2;
pub const kSound16bitStereo: c_int = 3;
pub const kSoundADPCMMono: c_int = 4;
pub const kSoundADPCMStereo: c_int = 5;
pub const SoundFormat = c_uint;
pub fn SoundFormat_bytesPerFrame(arg_fmt: SoundFormat) callconv(.C) u32 {
    var fmt = arg_fmt;
    _ = &fmt;
    return @as(u32, @bitCast((if ((fmt & @as(c_uint, @bitCast(@as(c_int, 1)))) != 0) @as(c_int, 2) else @as(c_int, 1)) * (if (fmt >= @as(c_uint, @bitCast(kSound16bitMono))) @as(c_int, 2) else @as(c_int, 1))));
}
pub const MIDINote = f32;
pub extern var signgam: c_int;
pub const FP_NAN: c_int = 0;
pub const FP_INFINITE: c_int = 1;
pub const FP_ZERO: c_int = 2;
pub const FP_SUBNORMAL: c_int = 3;
pub const FP_NORMAL: c_int = 4;
const enum_unnamed_6 = c_uint;
pub fn pd_noteToFrequency(n: MIDINote) callconv(.C) f32 {
    return @as(f32, @floatFromInt(@as(c_int, 440))) * @import("std").math.pow(@as(f32, @floatCast(2.0)), (n - @as(MIDINote, @floatFromInt(@as(c_int, 69)))) / 12.0);
}
pub fn pd_frequencyToNote(f: f32) callconv(.C) MIDINote {
    return (@as(f32, @floatFromInt(@as(c_int, 12))) * @log2(f)) - 36.37631607055664;
}
pub const struct_SoundSource = opaque {};
pub const SoundSource = struct_SoundSource;
pub const sndCallbackProc = fn (?*SoundSource, ?*anyopaque) callconv(.C) void;
pub const struct_playdate_sound_source = extern struct {
    setVolume: ?*const fn (?*SoundSource, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSource, f32, f32) callconv(.C) void),
    getVolume: ?*const fn (?*SoundSource, [*c]f32, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSource, [*c]f32, [*c]f32) callconv(.C) void),
    isPlaying: ?*const fn (?*SoundSource) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSource) callconv(.C) c_int),
    setFinishCallback: ?*const fn (?*SoundSource, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSource, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
};
pub const struct_FilePlayer = opaque {};
pub const FilePlayer = struct_FilePlayer;
pub const struct_playdate_sound_fileplayer = extern struct {
    newPlayer: ?*const fn () callconv(.C) ?*FilePlayer = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*FilePlayer),
    freePlayer: ?*const fn (?*FilePlayer) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) void),
    loadIntoPlayer: ?*const fn (?*FilePlayer, [*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*FilePlayer, [*c]const u8) callconv(.C) c_int),
    setBufferLength: ?*const fn (?*FilePlayer, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32) callconv(.C) void),
    play: ?*const fn (?*FilePlayer, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*FilePlayer, c_int) callconv(.C) c_int),
    isPlaying: ?*const fn (?*FilePlayer) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) c_int),
    pause: ?*const fn (?*FilePlayer) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) void),
    stop: ?*const fn (?*FilePlayer) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) void),
    setVolume: ?*const fn (?*FilePlayer, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32, f32) callconv(.C) void),
    getVolume: ?*const fn (?*FilePlayer, [*c]f32, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, [*c]f32, [*c]f32) callconv(.C) void),
    getLength: ?*const fn (?*FilePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) f32),
    setOffset: ?*const fn (?*FilePlayer, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32) callconv(.C) void),
    setRate: ?*const fn (?*FilePlayer, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32) callconv(.C) void),
    setLoopRange: ?*const fn (?*FilePlayer, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32, f32) callconv(.C) void),
    didUnderrun: ?*const fn (?*FilePlayer) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) c_int),
    setFinishCallback: ?*const fn (?*FilePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
    setLoopCallback: ?*const fn (?*FilePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
    getOffset: ?*const fn (?*FilePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) f32),
    getRate: ?*const fn (?*FilePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*FilePlayer) callconv(.C) f32),
    setStopOnUnderrun: ?*const fn (?*FilePlayer, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, c_int) callconv(.C) void),
    fadeVolume: ?*const fn (?*FilePlayer, f32, f32, i32, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, f32, f32, i32, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
    setMP3StreamSource: ?*const fn (?*FilePlayer, ?*const fn ([*c]u8, c_int, ?*anyopaque) callconv(.C) c_int, ?*anyopaque, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*FilePlayer, ?*const fn ([*c]u8, c_int, ?*anyopaque) callconv(.C) c_int, ?*anyopaque, f32) callconv(.C) void),
};
pub const struct_AudioSample = opaque {};
pub const AudioSample = struct_AudioSample;
pub const struct_SamplePlayer = opaque {};
pub const SamplePlayer = struct_SamplePlayer;
pub const struct_playdate_sound_sample = extern struct {
    newSampleBuffer: ?*const fn (c_int) callconv(.C) ?*AudioSample = @import("std").mem.zeroes(?*const fn (c_int) callconv(.C) ?*AudioSample),
    loadIntoSample: ?*const fn (?*AudioSample, [*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*AudioSample, [*c]const u8) callconv(.C) c_int),
    load: ?*const fn ([*c]const u8) callconv(.C) ?*AudioSample = @import("std").mem.zeroes(?*const fn ([*c]const u8) callconv(.C) ?*AudioSample),
    newSampleFromData: ?*const fn ([*c]u8, SoundFormat, u32, c_int, c_int) callconv(.C) ?*AudioSample = @import("std").mem.zeroes(?*const fn ([*c]u8, SoundFormat, u32, c_int, c_int) callconv(.C) ?*AudioSample),
    getData: ?*const fn (?*AudioSample, [*c][*c]u8, [*c]SoundFormat, [*c]u32, [*c]u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*AudioSample, [*c][*c]u8, [*c]SoundFormat, [*c]u32, [*c]u32) callconv(.C) void),
    freeSample: ?*const fn (?*AudioSample) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*AudioSample) callconv(.C) void),
    getLength: ?*const fn (?*AudioSample) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*AudioSample) callconv(.C) f32),
    decompress: ?*const fn (?*AudioSample) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*AudioSample) callconv(.C) c_int),
};
pub const struct_playdate_sound_sampleplayer = extern struct {
    newPlayer: ?*const fn () callconv(.C) ?*SamplePlayer = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*SamplePlayer),
    freePlayer: ?*const fn (?*SamplePlayer) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) void),
    setSample: ?*const fn (?*SamplePlayer, ?*AudioSample) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, ?*AudioSample) callconv(.C) void),
    play: ?*const fn (?*SamplePlayer, c_int, f32) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, c_int, f32) callconv(.C) c_int),
    isPlaying: ?*const fn (?*SamplePlayer) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) c_int),
    stop: ?*const fn (?*SamplePlayer) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) void),
    setVolume: ?*const fn (?*SamplePlayer, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, f32, f32) callconv(.C) void),
    getVolume: ?*const fn (?*SamplePlayer, [*c]f32, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, [*c]f32, [*c]f32) callconv(.C) void),
    getLength: ?*const fn (?*SamplePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) f32),
    setOffset: ?*const fn (?*SamplePlayer, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, f32) callconv(.C) void),
    setRate: ?*const fn (?*SamplePlayer, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, f32) callconv(.C) void),
    setPlayRange: ?*const fn (?*SamplePlayer, c_int, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, c_int, c_int) callconv(.C) void),
    setFinishCallback: ?*const fn (?*SamplePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
    setLoopCallback: ?*const fn (?*SamplePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, ?*const sndCallbackProc, ?*anyopaque) callconv(.C) void),
    getOffset: ?*const fn (?*SamplePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) f32),
    getRate: ?*const fn (?*SamplePlayer) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*SamplePlayer) callconv(.C) f32),
    setPaused: ?*const fn (?*SamplePlayer, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SamplePlayer, c_int) callconv(.C) void),
};
pub const struct_PDSynthSignalValue = opaque {};
pub const PDSynthSignalValue = struct_PDSynthSignalValue;
pub const struct_PDSynthSignal = opaque {};
pub const PDSynthSignal = struct_PDSynthSignal;
pub const signalStepFunc = ?*const fn (?*anyopaque, [*c]c_int, [*c]f32) callconv(.C) f32;
pub const signalNoteOnFunc = ?*const fn (?*anyopaque, MIDINote, f32, f32) callconv(.C) void;
pub const signalNoteOffFunc = ?*const fn (?*anyopaque, c_int, c_int) callconv(.C) void;
pub const signalDeallocFunc = ?*const fn (?*anyopaque) callconv(.C) void;
pub const struct_playdate_sound_signal = extern struct {
    newSignal: ?*const fn (signalStepFunc, signalNoteOnFunc, signalNoteOffFunc, signalDeallocFunc, ?*anyopaque) callconv(.C) ?*PDSynthSignal = @import("std").mem.zeroes(?*const fn (signalStepFunc, signalNoteOnFunc, signalNoteOffFunc, signalDeallocFunc, ?*anyopaque) callconv(.C) ?*PDSynthSignal),
    freeSignal: ?*const fn (?*PDSynthSignal) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthSignal) callconv(.C) void),
    getValue: ?*const fn (?*PDSynthSignal) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*PDSynthSignal) callconv(.C) f32),
    setValueScale: ?*const fn (?*PDSynthSignal, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthSignal, f32) callconv(.C) void),
    setValueOffset: ?*const fn (?*PDSynthSignal, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthSignal, f32) callconv(.C) void),
};
pub const kLFOTypeSquare: c_int = 0;
pub const kLFOTypeTriangle: c_int = 1;
pub const kLFOTypeSine: c_int = 2;
pub const kLFOTypeSampleAndHold: c_int = 3;
pub const kLFOTypeSawtoothUp: c_int = 4;
pub const kLFOTypeSawtoothDown: c_int = 5;
pub const kLFOTypeArpeggiator: c_int = 6;
pub const kLFOTypeFunction: c_int = 7;
pub const LFOType = c_uint;
pub const struct_PDSynthLFO = opaque {};
pub const PDSynthLFO = struct_PDSynthLFO;
pub const struct_playdate_sound_lfo = extern struct {
    newLFO: ?*const fn (LFOType) callconv(.C) ?*PDSynthLFO = @import("std").mem.zeroes(?*const fn (LFOType) callconv(.C) ?*PDSynthLFO),
    freeLFO: ?*const fn (?*PDSynthLFO) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO) callconv(.C) void),
    setType: ?*const fn (?*PDSynthLFO, LFOType) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, LFOType) callconv(.C) void),
    setRate: ?*const fn (?*PDSynthLFO, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32) callconv(.C) void),
    setPhase: ?*const fn (?*PDSynthLFO, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32) callconv(.C) void),
    setCenter: ?*const fn (?*PDSynthLFO, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32) callconv(.C) void),
    setDepth: ?*const fn (?*PDSynthLFO, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32) callconv(.C) void),
    setArpeggiation: ?*const fn (?*PDSynthLFO, c_int, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, c_int, [*c]f32) callconv(.C) void),
    setFunction: ?*const fn (?*PDSynthLFO, ?*const fn (?*PDSynthLFO, ?*anyopaque) callconv(.C) f32, ?*anyopaque, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, ?*const fn (?*PDSynthLFO, ?*anyopaque) callconv(.C) f32, ?*anyopaque, c_int) callconv(.C) void),
    setDelay: ?*const fn (?*PDSynthLFO, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32, f32) callconv(.C) void),
    setRetrigger: ?*const fn (?*PDSynthLFO, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, c_int) callconv(.C) void),
    getValue: ?*const fn (?*PDSynthLFO) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO) callconv(.C) f32),
    setGlobal: ?*const fn (?*PDSynthLFO, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, c_int) callconv(.C) void),
    setStartPhase: ?*const fn (?*PDSynthLFO, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthLFO, f32) callconv(.C) void),
};
pub const struct_PDSynthEnvelope = opaque {};
pub const PDSynthEnvelope = struct_PDSynthEnvelope;
pub const struct_playdate_sound_envelope = extern struct {
    newEnvelope: ?*const fn (f32, f32, f32, f32) callconv(.C) ?*PDSynthEnvelope = @import("std").mem.zeroes(?*const fn (f32, f32, f32, f32) callconv(.C) ?*PDSynthEnvelope),
    freeEnvelope: ?*const fn (?*PDSynthEnvelope) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope) callconv(.C) void),
    setAttack: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setDecay: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setSustain: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setRelease: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setLegato: ?*const fn (?*PDSynthEnvelope, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, c_int) callconv(.C) void),
    setRetrigger: ?*const fn (?*PDSynthEnvelope, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, c_int) callconv(.C) void),
    getValue: ?*const fn (?*PDSynthEnvelope) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope) callconv(.C) f32),
    setCurvature: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setVelocitySensitivity: ?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32) callconv(.C) void),
    setRateScaling: ?*const fn (?*PDSynthEnvelope, f32, MIDINote, MIDINote) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthEnvelope, f32, MIDINote, MIDINote) callconv(.C) void),
};
pub const kWaveformSquare: c_int = 0;
pub const kWaveformTriangle: c_int = 1;
pub const kWaveformSine: c_int = 2;
pub const kWaveformNoise: c_int = 3;
pub const kWaveformSawtooth: c_int = 4;
pub const kWaveformPOPhase: c_int = 5;
pub const kWaveformPODigital: c_int = 6;
pub const kWaveformPOVosim: c_int = 7;
pub const SoundWaveform = c_uint;
pub const synthRenderFunc = ?*const fn (?*anyopaque, [*c]i32, [*c]i32, c_int, u32, i32) callconv(.C) c_int;
pub const synthNoteOnFunc = ?*const fn (?*anyopaque, MIDINote, f32, f32) callconv(.C) void;
pub const synthReleaseFunc = ?*const fn (?*anyopaque, c_int) callconv(.C) void;
pub const synthSetParameterFunc = ?*const fn (?*anyopaque, c_int, f32) callconv(.C) c_int;
pub const synthDeallocFunc = ?*const fn (?*anyopaque) callconv(.C) void;
pub const synthCopyUserdata = ?*const fn (?*anyopaque) callconv(.C) ?*anyopaque;
pub const struct_PDSynth = opaque {};
pub const PDSynth = struct_PDSynth;
pub const struct_playdate_sound_synth = extern struct {
    newSynth: ?*const fn () callconv(.C) ?*PDSynth = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*PDSynth),
    freeSynth: ?*const fn (?*PDSynth) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) void),
    setWaveform: ?*const fn (?*PDSynth, SoundWaveform) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, SoundWaveform) callconv(.C) void),
    setGenerator_deprecated: ?*const fn (?*PDSynth, c_int, synthRenderFunc, synthNoteOnFunc, synthReleaseFunc, synthSetParameterFunc, synthDeallocFunc, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, c_int, synthRenderFunc, synthNoteOnFunc, synthReleaseFunc, synthSetParameterFunc, synthDeallocFunc, ?*anyopaque) callconv(.C) void),
    setSample: ?*const fn (?*PDSynth, ?*AudioSample, u32, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, ?*AudioSample, u32, u32) callconv(.C) void),
    setAttackTime: ?*const fn (?*PDSynth, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32) callconv(.C) void),
    setDecayTime: ?*const fn (?*PDSynth, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32) callconv(.C) void),
    setSustainLevel: ?*const fn (?*PDSynth, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32) callconv(.C) void),
    setReleaseTime: ?*const fn (?*PDSynth, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32) callconv(.C) void),
    setTranspose: ?*const fn (?*PDSynth, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32) callconv(.C) void),
    setFrequencyModulator: ?*const fn (?*PDSynth, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, ?*PDSynthSignalValue) callconv(.C) void),
    getFrequencyModulator: ?*const fn (?*PDSynth) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) ?*PDSynthSignalValue),
    setAmplitudeModulator: ?*const fn (?*PDSynth, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, ?*PDSynthSignalValue) callconv(.C) void),
    getAmplitudeModulator: ?*const fn (?*PDSynth) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) ?*PDSynthSignalValue),
    getParameterCount: ?*const fn (?*PDSynth) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) c_int),
    setParameter: ?*const fn (?*PDSynth, c_int, f32) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynth, c_int, f32) callconv(.C) c_int),
    setParameterModulator: ?*const fn (?*PDSynth, c_int, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, c_int, ?*PDSynthSignalValue) callconv(.C) void),
    getParameterModulator: ?*const fn (?*PDSynth, c_int) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*PDSynth, c_int) callconv(.C) ?*PDSynthSignalValue),
    playNote: ?*const fn (?*PDSynth, f32, f32, f32, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32, f32, f32, u32) callconv(.C) void),
    playMIDINote: ?*const fn (?*PDSynth, MIDINote, f32, f32, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, MIDINote, f32, f32, u32) callconv(.C) void),
    noteOff: ?*const fn (?*PDSynth, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, u32) callconv(.C) void),
    stop: ?*const fn (?*PDSynth) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) void),
    setVolume: ?*const fn (?*PDSynth, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, f32, f32) callconv(.C) void),
    getVolume: ?*const fn (?*PDSynth, [*c]f32, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, [*c]f32, [*c]f32) callconv(.C) void),
    isPlaying: ?*const fn (?*PDSynth) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) c_int),
    getEnvelope: ?*const fn (?*PDSynth) callconv(.C) ?*PDSynthEnvelope = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) ?*PDSynthEnvelope),
    setWavetable: ?*const fn (?*PDSynth, ?*AudioSample, c_int, c_int, c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynth, ?*AudioSample, c_int, c_int, c_int) callconv(.C) c_int),
    setGenerator: ?*const fn (?*PDSynth, c_int, synthRenderFunc, synthNoteOnFunc, synthReleaseFunc, synthSetParameterFunc, synthDeallocFunc, synthCopyUserdata, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynth, c_int, synthRenderFunc, synthNoteOnFunc, synthReleaseFunc, synthSetParameterFunc, synthDeallocFunc, synthCopyUserdata, ?*anyopaque) callconv(.C) void),
    copy: ?*const fn (?*PDSynth) callconv(.C) ?*PDSynth = @import("std").mem.zeroes(?*const fn (?*PDSynth) callconv(.C) ?*PDSynth),
};
pub const struct_ControlSignal = opaque {};
pub const ControlSignal = struct_ControlSignal;
pub const struct_playdate_control_signal = extern struct {
    newSignal: ?*const fn () callconv(.C) ?*ControlSignal = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*ControlSignal),
    freeSignal: ?*const fn (?*ControlSignal) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*ControlSignal) callconv(.C) void),
    clearEvents: ?*const fn (?*ControlSignal) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*ControlSignal) callconv(.C) void),
    addEvent: ?*const fn (?*ControlSignal, c_int, f32, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*ControlSignal, c_int, f32, c_int) callconv(.C) void),
    removeEvent: ?*const fn (?*ControlSignal, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*ControlSignal, c_int) callconv(.C) void),
    getMIDIControllerNumber: ?*const fn (?*ControlSignal) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*ControlSignal) callconv(.C) c_int),
};
pub const struct_PDSynthInstrument = opaque {};
pub const PDSynthInstrument = struct_PDSynthInstrument;
pub const struct_playdate_sound_instrument = extern struct {
    newInstrument: ?*const fn () callconv(.C) ?*PDSynthInstrument = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*PDSynthInstrument),
    freeInstrument: ?*const fn (?*PDSynthInstrument) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument) callconv(.C) void),
    addVoice: ?*const fn (?*PDSynthInstrument, ?*PDSynth, MIDINote, MIDINote, f32) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, ?*PDSynth, MIDINote, MIDINote, f32) callconv(.C) c_int),
    playNote: ?*const fn (?*PDSynthInstrument, f32, f32, f32, u32) callconv(.C) ?*PDSynth = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, f32, f32, f32, u32) callconv(.C) ?*PDSynth),
    playMIDINote: ?*const fn (?*PDSynthInstrument, MIDINote, f32, f32, u32) callconv(.C) ?*PDSynth = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, MIDINote, f32, f32, u32) callconv(.C) ?*PDSynth),
    setPitchBend: ?*const fn (?*PDSynthInstrument, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, f32) callconv(.C) void),
    setPitchBendRange: ?*const fn (?*PDSynthInstrument, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, f32) callconv(.C) void),
    setTranspose: ?*const fn (?*PDSynthInstrument, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, f32) callconv(.C) void),
    noteOff: ?*const fn (?*PDSynthInstrument, MIDINote, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, MIDINote, u32) callconv(.C) void),
    allNotesOff: ?*const fn (?*PDSynthInstrument, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, u32) callconv(.C) void),
    setVolume: ?*const fn (?*PDSynthInstrument, f32, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, f32, f32) callconv(.C) void),
    getVolume: ?*const fn (?*PDSynthInstrument, [*c]f32, [*c]f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument, [*c]f32, [*c]f32) callconv(.C) void),
    activeVoiceCount: ?*const fn (?*PDSynthInstrument) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*PDSynthInstrument) callconv(.C) c_int),
};
pub const struct_SequenceTrack = opaque {};
pub const SequenceTrack = struct_SequenceTrack;
pub const struct_playdate_sound_track = extern struct {
    newTrack: ?*const fn () callconv(.C) ?*SequenceTrack = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*SequenceTrack),
    freeTrack: ?*const fn (?*SequenceTrack) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) void),
    setInstrument: ?*const fn (?*SequenceTrack, ?*PDSynthInstrument) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, ?*PDSynthInstrument) callconv(.C) void),
    getInstrument: ?*const fn (?*SequenceTrack) callconv(.C) ?*PDSynthInstrument = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) ?*PDSynthInstrument),
    addNoteEvent: ?*const fn (?*SequenceTrack, u32, u32, MIDINote, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, u32, u32, MIDINote, f32) callconv(.C) void),
    removeNoteEvent: ?*const fn (?*SequenceTrack, u32, MIDINote) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, u32, MIDINote) callconv(.C) void),
    clearNotes: ?*const fn (?*SequenceTrack) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) void),
    getControlSignalCount: ?*const fn (?*SequenceTrack) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) c_int),
    getControlSignal: ?*const fn (?*SequenceTrack, c_int) callconv(.C) ?*ControlSignal = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, c_int) callconv(.C) ?*ControlSignal),
    clearControlEvents: ?*const fn (?*SequenceTrack) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) void),
    getPolyphony: ?*const fn (?*SequenceTrack) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) c_int),
    activeVoiceCount: ?*const fn (?*SequenceTrack) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) c_int),
    setMuted: ?*const fn (?*SequenceTrack, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, c_int) callconv(.C) void),
    getLength: ?*const fn (?*SequenceTrack) callconv(.C) u32 = @import("std").mem.zeroes(?*const fn (?*SequenceTrack) callconv(.C) u32),
    getIndexForStep: ?*const fn (?*SequenceTrack, u32) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, u32) callconv(.C) c_int),
    getNoteAtIndex: ?*const fn (?*SequenceTrack, c_int, [*c]u32, [*c]u32, [*c]MIDINote, [*c]f32) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, c_int, [*c]u32, [*c]u32, [*c]MIDINote, [*c]f32) callconv(.C) c_int),
    getSignalForController: ?*const fn (?*SequenceTrack, c_int, c_int) callconv(.C) ?*ControlSignal = @import("std").mem.zeroes(?*const fn (?*SequenceTrack, c_int, c_int) callconv(.C) ?*ControlSignal),
};
pub const struct_SoundSequence = opaque {};
pub const SoundSequence = struct_SoundSequence;
pub const SequenceFinishedCallback = ?*const fn (?*SoundSequence, ?*anyopaque) callconv(.C) void;
pub const struct_playdate_sound_sequence = extern struct {
    newSequence: ?*const fn () callconv(.C) ?*SoundSequence = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*SoundSequence),
    freeSequence: ?*const fn (?*SoundSequence) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) void),
    loadMIDIFile: ?*const fn (?*SoundSequence, [*c]const u8) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSequence, [*c]const u8) callconv(.C) c_int),
    getTime: ?*const fn (?*SoundSequence) callconv(.C) u32 = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) u32),
    setTime: ?*const fn (?*SoundSequence, u32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, u32) callconv(.C) void),
    setLoops: ?*const fn (?*SoundSequence, c_int, c_int, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, c_int, c_int, c_int) callconv(.C) void),
    getTempo_deprecated: ?*const fn (?*SoundSequence) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) c_int),
    setTempo: ?*const fn (?*SoundSequence, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, f32) callconv(.C) void),
    getTrackCount: ?*const fn (?*SoundSequence) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) c_int),
    addTrack: ?*const fn (?*SoundSequence) callconv(.C) ?*SequenceTrack = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) ?*SequenceTrack),
    getTrackAtIndex: ?*const fn (?*SoundSequence, c_uint) callconv(.C) ?*SequenceTrack = @import("std").mem.zeroes(?*const fn (?*SoundSequence, c_uint) callconv(.C) ?*SequenceTrack),
    setTrackAtIndex: ?*const fn (?*SoundSequence, ?*SequenceTrack, c_uint) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, ?*SequenceTrack, c_uint) callconv(.C) void),
    allNotesOff: ?*const fn (?*SoundSequence) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) void),
    isPlaying: ?*const fn (?*SoundSequence) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) c_int),
    getLength: ?*const fn (?*SoundSequence) callconv(.C) u32 = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) u32),
    play: ?*const fn (?*SoundSequence, SequenceFinishedCallback, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, SequenceFinishedCallback, ?*anyopaque) callconv(.C) void),
    stop: ?*const fn (?*SoundSequence) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) void),
    getCurrentStep: ?*const fn (?*SoundSequence, [*c]c_int) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSequence, [*c]c_int) callconv(.C) c_int),
    setCurrentStep: ?*const fn (?*SoundSequence, c_int, c_int, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundSequence, c_int, c_int, c_int) callconv(.C) void),
    getTempo: ?*const fn (?*SoundSequence) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*SoundSequence) callconv(.C) f32),
};
pub const struct_TwoPoleFilter = opaque {};
pub const TwoPoleFilter = struct_TwoPoleFilter;
pub const kFilterTypeLowPass: c_int = 0;
pub const kFilterTypeHighPass: c_int = 1;
pub const kFilterTypeBandPass: c_int = 2;
pub const kFilterTypeNotch: c_int = 3;
pub const kFilterTypePEQ: c_int = 4;
pub const kFilterTypeLowShelf: c_int = 5;
pub const kFilterTypeHighShelf: c_int = 6;
pub const TwoPoleFilterType = c_uint;
pub const struct_playdate_sound_effect_twopolefilter = extern struct {
    newFilter: ?*const fn () callconv(.C) ?*TwoPoleFilter = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*TwoPoleFilter),
    freeFilter: ?*const fn (?*TwoPoleFilter) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter) callconv(.C) void),
    setType: ?*const fn (?*TwoPoleFilter, TwoPoleFilterType) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, TwoPoleFilterType) callconv(.C) void),
    setFrequency: ?*const fn (?*TwoPoleFilter, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, f32) callconv(.C) void),
    setFrequencyModulator: ?*const fn (?*TwoPoleFilter, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, ?*PDSynthSignalValue) callconv(.C) void),
    getFrequencyModulator: ?*const fn (?*TwoPoleFilter) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter) callconv(.C) ?*PDSynthSignalValue),
    setGain: ?*const fn (?*TwoPoleFilter, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, f32) callconv(.C) void),
    setResonance: ?*const fn (?*TwoPoleFilter, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, f32) callconv(.C) void),
    setResonanceModulator: ?*const fn (?*TwoPoleFilter, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter, ?*PDSynthSignalValue) callconv(.C) void),
    getResonanceModulator: ?*const fn (?*TwoPoleFilter) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*TwoPoleFilter) callconv(.C) ?*PDSynthSignalValue),
};
pub const struct_OnePoleFilter = opaque {};
pub const OnePoleFilter = struct_OnePoleFilter;
pub const struct_playdate_sound_effect_onepolefilter = extern struct {
    newFilter: ?*const fn () callconv(.C) ?*OnePoleFilter = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*OnePoleFilter),
    freeFilter: ?*const fn (?*OnePoleFilter) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*OnePoleFilter) callconv(.C) void),
    setParameter: ?*const fn (?*OnePoleFilter, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*OnePoleFilter, f32) callconv(.C) void),
    setParameterModulator: ?*const fn (?*OnePoleFilter, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*OnePoleFilter, ?*PDSynthSignalValue) callconv(.C) void),
    getParameterModulator: ?*const fn (?*OnePoleFilter) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*OnePoleFilter) callconv(.C) ?*PDSynthSignalValue),
};
pub const struct_BitCrusher = opaque {};
pub const BitCrusher = struct_BitCrusher;
pub const struct_playdate_sound_effect_bitcrusher = extern struct {
    newBitCrusher: ?*const fn () callconv(.C) ?*BitCrusher = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*BitCrusher),
    freeBitCrusher: ?*const fn (?*BitCrusher) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*BitCrusher) callconv(.C) void),
    setAmount: ?*const fn (?*BitCrusher, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*BitCrusher, f32) callconv(.C) void),
    setAmountModulator: ?*const fn (?*BitCrusher, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*BitCrusher, ?*PDSynthSignalValue) callconv(.C) void),
    getAmountModulator: ?*const fn (?*BitCrusher) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*BitCrusher) callconv(.C) ?*PDSynthSignalValue),
    setUndersampling: ?*const fn (?*BitCrusher, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*BitCrusher, f32) callconv(.C) void),
    setUndersampleModulator: ?*const fn (?*BitCrusher, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*BitCrusher, ?*PDSynthSignalValue) callconv(.C) void),
    getUndersampleModulator: ?*const fn (?*BitCrusher) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*BitCrusher) callconv(.C) ?*PDSynthSignalValue),
};
pub const struct_RingModulator = opaque {};
pub const RingModulator = struct_RingModulator;
pub const struct_playdate_sound_effect_ringmodulator = extern struct {
    newRingmod: ?*const fn () callconv(.C) ?*RingModulator = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*RingModulator),
    freeRingmod: ?*const fn (?*RingModulator) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*RingModulator) callconv(.C) void),
    setFrequency: ?*const fn (?*RingModulator, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*RingModulator, f32) callconv(.C) void),
    setFrequencyModulator: ?*const fn (?*RingModulator, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*RingModulator, ?*PDSynthSignalValue) callconv(.C) void),
    getFrequencyModulator: ?*const fn (?*RingModulator) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*RingModulator) callconv(.C) ?*PDSynthSignalValue),
};
pub const struct_DelayLine = opaque {};
pub const DelayLine = struct_DelayLine;
pub const struct_DelayLineTap = opaque {};
pub const DelayLineTap = struct_DelayLineTap;
pub const struct_playdate_sound_effect_delayline = extern struct {
    newDelayLine: ?*const fn (c_int, c_int) callconv(.C) ?*DelayLine = @import("std").mem.zeroes(?*const fn (c_int, c_int) callconv(.C) ?*DelayLine),
    freeDelayLine: ?*const fn (?*DelayLine) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLine) callconv(.C) void),
    setLength: ?*const fn (?*DelayLine, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLine, c_int) callconv(.C) void),
    setFeedback: ?*const fn (?*DelayLine, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLine, f32) callconv(.C) void),
    addTap: ?*const fn (?*DelayLine, c_int) callconv(.C) ?*DelayLineTap = @import("std").mem.zeroes(?*const fn (?*DelayLine, c_int) callconv(.C) ?*DelayLineTap),
    freeTap: ?*const fn (?*DelayLineTap) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLineTap) callconv(.C) void),
    setTapDelay: ?*const fn (?*DelayLineTap, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLineTap, c_int) callconv(.C) void),
    setTapDelayModulator: ?*const fn (?*DelayLineTap, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLineTap, ?*PDSynthSignalValue) callconv(.C) void),
    getTapDelayModulator: ?*const fn (?*DelayLineTap) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*DelayLineTap) callconv(.C) ?*PDSynthSignalValue),
    setTapChannelsFlipped: ?*const fn (?*DelayLineTap, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*DelayLineTap, c_int) callconv(.C) void),
};
pub const struct_Overdrive = opaque {};
pub const Overdrive = struct_Overdrive;
pub const struct_playdate_sound_effect_overdrive = extern struct {
    newOverdrive: ?*const fn () callconv(.C) ?*Overdrive = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*Overdrive),
    freeOverdrive: ?*const fn (?*Overdrive) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive) callconv(.C) void),
    setGain: ?*const fn (?*Overdrive, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive, f32) callconv(.C) void),
    setLimit: ?*const fn (?*Overdrive, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive, f32) callconv(.C) void),
    setLimitModulator: ?*const fn (?*Overdrive, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive, ?*PDSynthSignalValue) callconv(.C) void),
    getLimitModulator: ?*const fn (?*Overdrive) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*Overdrive) callconv(.C) ?*PDSynthSignalValue),
    setOffset: ?*const fn (?*Overdrive, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive, f32) callconv(.C) void),
    setOffsetModulator: ?*const fn (?*Overdrive, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*Overdrive, ?*PDSynthSignalValue) callconv(.C) void),
    getOffsetModulator: ?*const fn (?*Overdrive) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*Overdrive) callconv(.C) ?*PDSynthSignalValue),
};
pub const struct_SoundEffect = opaque {};
pub const SoundEffect = struct_SoundEffect;
pub const effectProc = fn (?*SoundEffect, [*c]i32, [*c]i32, c_int, c_int) callconv(.C) c_int;
pub const struct_playdate_sound_effect = extern struct {
    newEffect: ?*const fn (?*const effectProc, ?*anyopaque) callconv(.C) ?*SoundEffect = @import("std").mem.zeroes(?*const fn (?*const effectProc, ?*anyopaque) callconv(.C) ?*SoundEffect),
    freeEffect: ?*const fn (?*SoundEffect) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundEffect) callconv(.C) void),
    setMix: ?*const fn (?*SoundEffect, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundEffect, f32) callconv(.C) void),
    setMixModulator: ?*const fn (?*SoundEffect, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundEffect, ?*PDSynthSignalValue) callconv(.C) void),
    getMixModulator: ?*const fn (?*SoundEffect) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*SoundEffect) callconv(.C) ?*PDSynthSignalValue),
    setUserdata: ?*const fn (?*SoundEffect, ?*anyopaque) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundEffect, ?*anyopaque) callconv(.C) void),
    getUserdata: ?*const fn (?*SoundEffect) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn (?*SoundEffect) callconv(.C) ?*anyopaque),
    twopolefilter: [*c]const struct_playdate_sound_effect_twopolefilter = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_twopolefilter),
    onepolefilter: [*c]const struct_playdate_sound_effect_onepolefilter = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_onepolefilter),
    bitcrusher: [*c]const struct_playdate_sound_effect_bitcrusher = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_bitcrusher),
    ringmodulator: [*c]const struct_playdate_sound_effect_ringmodulator = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_ringmodulator),
    delayline: [*c]const struct_playdate_sound_effect_delayline = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_delayline),
    overdrive: [*c]const struct_playdate_sound_effect_overdrive = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect_overdrive),
};
pub const struct_SoundChannel = opaque {};
pub const SoundChannel = struct_SoundChannel;
pub const AudioSourceFunction = fn (?*anyopaque, [*c]i16, [*c]i16, c_int) callconv(.C) c_int;
pub const struct_playdate_sound_channel = extern struct {
    newChannel: ?*const fn () callconv(.C) ?*SoundChannel = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*SoundChannel),
    freeChannel: ?*const fn (?*SoundChannel) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) void),
    addSource: ?*const fn (?*SoundChannel, ?*SoundSource) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*SoundSource) callconv(.C) c_int),
    removeSource: ?*const fn (?*SoundChannel, ?*SoundSource) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*SoundSource) callconv(.C) c_int),
    addCallbackSource: ?*const fn (?*SoundChannel, ?*const AudioSourceFunction, ?*anyopaque, c_int) callconv(.C) ?*SoundSource = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*const AudioSourceFunction, ?*anyopaque, c_int) callconv(.C) ?*SoundSource),
    addEffect: ?*const fn (?*SoundChannel, ?*SoundEffect) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*SoundEffect) callconv(.C) void),
    removeEffect: ?*const fn (?*SoundChannel, ?*SoundEffect) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*SoundEffect) callconv(.C) void),
    setVolume: ?*const fn (?*SoundChannel, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, f32) callconv(.C) void),
    getVolume: ?*const fn (?*SoundChannel) callconv(.C) f32 = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) f32),
    setVolumeModulator: ?*const fn (?*SoundChannel, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*PDSynthSignalValue) callconv(.C) void),
    getVolumeModulator: ?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue),
    setPan: ?*const fn (?*SoundChannel, f32) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, f32) callconv(.C) void),
    setPanModulator: ?*const fn (?*SoundChannel, ?*PDSynthSignalValue) callconv(.C) void = @import("std").mem.zeroes(?*const fn (?*SoundChannel, ?*PDSynthSignalValue) callconv(.C) void),
    getPanModulator: ?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue),
    getDryLevelSignal: ?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue),
    getWetLevelSignal: ?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) ?*PDSynthSignalValue),
};
pub const RecordCallback = fn (?*anyopaque, [*c]i16, c_int) callconv(.C) c_int;
pub const kMicInputAutodetect: c_int = 0;
pub const kMicInputInternal: c_int = 1;
pub const kMicInputHeadset: c_int = 2;
pub const enum_MicSource = c_uint;
pub const struct_playdate_sound = extern struct {
    channel: [*c]const struct_playdate_sound_channel = @import("std").mem.zeroes([*c]const struct_playdate_sound_channel),
    fileplayer: [*c]const struct_playdate_sound_fileplayer = @import("std").mem.zeroes([*c]const struct_playdate_sound_fileplayer),
    sample: [*c]const struct_playdate_sound_sample = @import("std").mem.zeroes([*c]const struct_playdate_sound_sample),
    sampleplayer: [*c]const struct_playdate_sound_sampleplayer = @import("std").mem.zeroes([*c]const struct_playdate_sound_sampleplayer),
    synth: [*c]const struct_playdate_sound_synth = @import("std").mem.zeroes([*c]const struct_playdate_sound_synth),
    sequence: [*c]const struct_playdate_sound_sequence = @import("std").mem.zeroes([*c]const struct_playdate_sound_sequence),
    effect: [*c]const struct_playdate_sound_effect = @import("std").mem.zeroes([*c]const struct_playdate_sound_effect),
    lfo: [*c]const struct_playdate_sound_lfo = @import("std").mem.zeroes([*c]const struct_playdate_sound_lfo),
    envelope: [*c]const struct_playdate_sound_envelope = @import("std").mem.zeroes([*c]const struct_playdate_sound_envelope),
    source: [*c]const struct_playdate_sound_source = @import("std").mem.zeroes([*c]const struct_playdate_sound_source),
    controlsignal: [*c]const struct_playdate_control_signal = @import("std").mem.zeroes([*c]const struct_playdate_control_signal),
    track: [*c]const struct_playdate_sound_track = @import("std").mem.zeroes([*c]const struct_playdate_sound_track),
    instrument: [*c]const struct_playdate_sound_instrument = @import("std").mem.zeroes([*c]const struct_playdate_sound_instrument),
    getCurrentTime: ?*const fn () callconv(.C) u32 = @import("std").mem.zeroes(?*const fn () callconv(.C) u32),
    addSource: ?*const fn (?*const AudioSourceFunction, ?*anyopaque, c_int) callconv(.C) ?*SoundSource = @import("std").mem.zeroes(?*const fn (?*const AudioSourceFunction, ?*anyopaque, c_int) callconv(.C) ?*SoundSource),
    getDefaultChannel: ?*const fn () callconv(.C) ?*SoundChannel = @import("std").mem.zeroes(?*const fn () callconv(.C) ?*SoundChannel),
    addChannel: ?*const fn (?*SoundChannel) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) c_int),
    removeChannel: ?*const fn (?*SoundChannel) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundChannel) callconv(.C) c_int),
    setMicCallback: ?*const fn (?*const RecordCallback, ?*anyopaque, enum_MicSource) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*const RecordCallback, ?*anyopaque, enum_MicSource) callconv(.C) c_int),
    getHeadphoneState: ?*const fn ([*c]c_int, [*c]c_int, ?*const fn (c_int, c_int) callconv(.C) void) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]c_int, [*c]c_int, ?*const fn (c_int, c_int) callconv(.C) void) callconv(.C) void),
    setOutputsActive: ?*const fn (c_int, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn (c_int, c_int) callconv(.C) void),
    removeSource: ?*const fn (?*SoundSource) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (?*SoundSource) callconv(.C) c_int),
    signal: [*c]const struct_playdate_sound_signal = @import("std").mem.zeroes([*c]const struct_playdate_sound_signal),
    getError: ?*const fn () callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn () callconv(.C) [*c]const u8),
};
pub const struct_playdate_display = extern struct {
    getWidth: *const fn () callconv(.C) c_int,
    getHeight: *const fn () callconv(.C) c_int,
    setRefreshRate: *const fn (f32) callconv(.C) void,
    setInverted: *const fn (c_int) callconv(.C) void,
    setScale: *const fn (c_uint) callconv(.C) void,
    setMosaic: *const fn (c_uint, c_uint) callconv(.C) void,
    setFlipped: *const fn (c_int, c_int) callconv(.C) void,
    setOffset: *const fn (c_int, c_int) callconv(.C) void,
};
pub const PDScore = extern struct {
    rank: u32 = @import("std").mem.zeroes(u32),
    value: u32 = @import("std").mem.zeroes(u32),
    player: [*c]u8 = @import("std").mem.zeroes([*c]u8),
};
pub const PDScoresList = extern struct {
    boardID: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    count: c_uint = @import("std").mem.zeroes(c_uint),
    lastUpdated: u32 = @import("std").mem.zeroes(u32),
    playerIncluded: c_int = @import("std").mem.zeroes(c_int),
    limit: c_uint = @import("std").mem.zeroes(c_uint),
    scores: [*c]PDScore = @import("std").mem.zeroes([*c]PDScore),
};
pub const PDBoard = extern struct {
    boardID: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    name: [*c]u8 = @import("std").mem.zeroes([*c]u8),
};
pub const PDBoardsList = extern struct {
    count: c_uint = @import("std").mem.zeroes(c_uint),
    lastUpdated: u32 = @import("std").mem.zeroes(u32),
    boards: [*c]PDBoard = @import("std").mem.zeroes([*c]PDBoard),
};
pub const AddScoreCallback = ?*const fn ([*c]PDScore, [*c]const u8) callconv(.C) void;
pub const PersonalBestCallback = ?*const fn ([*c]PDScore, [*c]const u8) callconv(.C) void;
pub const BoardsListCallback = ?*const fn ([*c]PDBoardsList, [*c]const u8) callconv(.C) void;
pub const ScoresCallback = ?*const fn ([*c]PDScoresList, [*c]const u8) callconv(.C) void;
pub const struct_playdate_scoreboards = extern struct {
    addScore: ?*const fn ([*c]const u8, u32, AddScoreCallback) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, u32, AddScoreCallback) callconv(.C) c_int),
    getPersonalBest: ?*const fn ([*c]const u8, PersonalBestCallback) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, PersonalBestCallback) callconv(.C) c_int),
    freeScore: ?*const fn ([*c]PDScore) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]PDScore) callconv(.C) void),
    getScoreboards: ?*const fn (BoardsListCallback) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn (BoardsListCallback) callconv(.C) c_int),
    freeBoardsList: ?*const fn ([*c]PDBoardsList) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]PDBoardsList) callconv(.C) void),
    getScores: ?*const fn ([*c]const u8, ScoresCallback) callconv(.C) c_int = @import("std").mem.zeroes(?*const fn ([*c]const u8, ScoresCallback) callconv(.C) c_int),
    freeScoresList: ?*const fn ([*c]PDScoresList) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]PDScoresList) callconv(.C) void),
};
pub const struct_PlaydateAPI = extern struct {
    system: *const playdate_sys,
    file: *const struct_playdate_file,
    graphics: *const playdate_graphics,
    sprite: *const struct_playdate_sprite,
    display: *const struct_playdate_display,
    sound: *const struct_playdate_sound,
    lua: *const struct_playdate_lua,
    json: *const struct_playdate_json,
    scoreboards: *const struct_playdate_scoreboards,
};
pub const PlaydateAPI = struct_PlaydateAPI;

pub const PDSystemEvent = enum(c_uint) {
    Init = 0,
    InitLua = 1,
    Lock = 2,
    Unlock = 3,
    Pause = 4,
    Resume = 5,
    Terminate = 6,
    KeyPressed = 7,
    KeyReleased = 8,
    LowPower = 9,
};

pub extern fn eventHandler(playdate: [*c]PlaydateAPI, event: PDSystemEvent, arg: u32) c_int;
pub const pdext_display_h = "";
pub const pdext_scoreboards_h = "";
pub const playdate_video = struct_playdate_video;
pub const playdate_graphics = struct_playdate_graphics;
pub const PDDateTime = struct_PDDateTime;
pub const playdate_sys = struct_playdate_sys;
pub const LuaType = enum_LuaType;
pub const playdate_lua = struct_playdate_lua;
pub const playdate_json = struct_playdate_json;
pub const playdate_file = struct_playdate_file;
pub const playdate_sprite = struct_playdate_sprite;
pub const playdate_sound_source = struct_playdate_sound_source;
pub const playdate_sound_fileplayer = struct_playdate_sound_fileplayer;
pub const playdate_sound_sample = struct_playdate_sound_sample;
pub const playdate_sound_sampleplayer = struct_playdate_sound_sampleplayer;
pub const playdate_sound_signal = struct_playdate_sound_signal;
pub const playdate_sound_lfo = struct_playdate_sound_lfo;
pub const playdate_sound_envelope = struct_playdate_sound_envelope;
pub const playdate_sound_synth = struct_playdate_sound_synth;
pub const playdate_control_signal = struct_playdate_control_signal;
pub const playdate_sound_instrument = struct_playdate_sound_instrument;
pub const playdate_sound_track = struct_playdate_sound_track;
pub const playdate_sound_sequence = struct_playdate_sound_sequence;
pub const playdate_sound_effect_twopolefilter = struct_playdate_sound_effect_twopolefilter;
pub const playdate_sound_effect_onepolefilter = struct_playdate_sound_effect_onepolefilter;
pub const playdate_sound_effect_bitcrusher = struct_playdate_sound_effect_bitcrusher;
pub const playdate_sound_effect_ringmodulator = struct_playdate_sound_effect_ringmodulator;
pub const playdate_sound_effect_delayline = struct_playdate_sound_effect_delayline;
pub const playdate_sound_effect_overdrive = struct_playdate_sound_effect_overdrive;
pub const playdate_sound_effect = struct_playdate_sound_effect;
pub const playdate_sound_channel = struct_playdate_sound_channel;
pub const MicSource = enum_MicSource;
pub const playdate_sound = struct_playdate_sound;
pub const playdate_display = struct_playdate_display;
pub const playdate_scoreboards = struct_playdate_scoreboards;
