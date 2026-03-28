const std = @import("std");
const rl = @import("raylib");
const World = @import("world/World.zig").World;
const Player = @import("entity/Player.zig").Player;

pub fn main() !void {
    rl.initWindow(1920, 1080, "MINECLONE");

    rl.hideCursor();
    rl.disableCursor();

    const atlas = try rl.loadTexture("assets/blocks/blockatlas.png");
    defer rl.unloadTexture(atlas);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var world: World = try World.init(allocator);
    var player = try Player.init(allocator);

    var wireframe = false;

    // rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(rl.KeyboardKey.f10)) {
            wireframe = !wireframe;
        }

        try player.update(rl.getFrameTime());
        try world.update(player.camera.position);

        rl.updateCamera(&player.camera, rl.CameraMode.first_person);

        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginMode3D(player.camera);

        if (wireframe) {
            rl.gl.rlEnableWireMode();
        }

        try world.render(atlas);
        try player.render(atlas);

        if (wireframe) {
            rl.gl.rlDisableWireMode();
        }

        rl.endMode3D();

        try player.renderPos();
        rl.drawFPS(10, 10);
        rl.endDrawing();
    }

    try world.deinit();
}
