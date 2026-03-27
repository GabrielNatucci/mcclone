const std = @import("std");
const rl = @import("raylib");

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

    while (!rl.windowShouldClose()) {
        rl.updateCamera(&camera, rl.CameraMode.first_person);

        rl.beginDrawing();
        rl.clearBackground(.white);

        rl.beginMode3D(camera);

        rl.drawCube(rl.Vector3{ .x = 10.0, .y = 0.0, .z = 5.0 }, 10.0, 10.0, 10.0, .lime);
        rl.endMode3D();

        rl.endDrawing();

        std.debug.print("FPS: {}\n", .{rl.getFPS()});
    }
}
