const std = @import("std");
const rl = @import("raylib");
const Chunck = @import("core/Chunck.zig").Chunck;

pub fn main() !void {
    rl.initWindow(1280, 720, "MINECLONE");

    var camera = std.mem.zeroes(rl.Camera);
    camera.position = rl.Vector3{ .x = 0.0, .y = 10.0, .z = 10.0 };
    camera.target = rl.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };
    camera.up = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    camera.fovy = 45.0;
    camera.projection = rl.CameraProjection.perspective;

    rl.hideCursor();
    rl.disableCursor();
    rl.setTargetFPS(rl.getMonitorRefreshRate(rl.getCurrentMonitor()));
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var chunck: Chunck = try Chunck.init(allocator);

    // var block1: Block = try Block.init(0.0, 0.0, 0.0);
    // var block2: Block = try Block.init(2.0, 0.0, 0.0);

    while (!rl.windowShouldClose()) {
        rl.updateCamera(&camera, rl.CameraMode.first_person);

        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginMode3D(camera);

        try chunck.render();

        rl.endMode3D();
        rl.endDrawing();

        std.debug.print("FPS: {}\n", .{rl.getFPS()});
    }

    try chunck.deinit();
}
