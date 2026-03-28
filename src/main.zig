const std = @import("std");
const rl = @import("raylib");
const World = @import("core/World.zig").World;

pub fn main() !void {
    rl.initWindow(1920, 1080, "MINECLONE");

    var camera = std.mem.zeroes(rl.Camera);
    camera.position = rl.Vector3{ .x = 0.0, .y = 10.0, .z = 10.0 };
    camera.target = rl.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };
    camera.up = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    camera.fovy = 75.0;
    camera.projection = rl.CameraProjection.perspective;

    rl.hideCursor();
    rl.disableCursor();

    const atlas = try rl.loadTexture("assets/blocks/blockatlas.png");
    defer rl.unloadTexture(atlas);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var world: World = try World.init(allocator);

    while (!rl.windowShouldClose()) {
        rl.updateCamera(&camera, rl.CameraMode.first_person);

        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginMode3D(camera);

        try world.render(atlas);

        rl.endMode3D();

        rl.drawFPS(10, 10);
        rl.endDrawing();
    }

    try world.deinit();
}
