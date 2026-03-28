const std = @import("std");
const rl = @import("raylib");
const World = @import("core/World.zig").World;

pub fn main() !void {
    rl.initWindow(1920, 1080, "MINECLONE");

    var camera = std.mem.zeroes(rl.Camera);
    camera.position = rl.Vector3{ .x = 0.0, .y = 100.0, .z = 10.0 };
    // camera.target = rl.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };
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

    var wireframe = false;

    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(rl.KeyboardKey.f10)) {
            wireframe = !wireframe; // toggle
        }

        if (camera.position.y > 5) {
            camera.position.y -= 1;
        }

        rl.updateCamera(&camera, rl.CameraMode.first_person);

        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginMode3D(camera);

        if (wireframe) {
            rl.gl.rlEnableWireMode();
        }

        try world.render(atlas);

        if (wireframe) {
            rl.gl.rlDisableWireMode();
        }

        rl.endMode3D();

        var text_buf: [128]u8 = undefined;
        const post_text = try std.fmt.bufPrintZ(&text_buf, "PLAYER POSITION\n X:{d:.2}\n Y:{d:.2}\n Z:{d:.2}\n", .{ camera.position.x, camera.position.y, camera.position.z });
        rl.drawText(post_text, 10, 30, 20, .black);

        rl.drawFPS(10, 10);
        rl.endDrawing();
    }

    try world.deinit();
}
