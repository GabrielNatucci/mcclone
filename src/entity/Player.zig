const std = @import("std");
const rl = @import("raylib");

pub const Player = struct {
    camera: rl.Camera,
    allocator: std.mem.Allocator,
    speedy: f32,

    pub fn init(allocator: std.mem.Allocator) !Player {
        var camera = std.mem.zeroes(rl.Camera);
        camera.position = rl.Vector3{ .x = 0.0, .y = 50.0, .z = 10.0 };
        camera.up = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
        camera.fovy = 75.0;
        camera.projection = rl.CameraProjection.perspective;

        return .{
            .allocator = allocator,
            .camera = camera,
            .speedy = -1,
        };
    }

    pub fn update(self: *Player, frameTime: f32) !void {
        if (self.camera.position.y > 5) {
            self.speedy -= 20 * frameTime;
        } else {
            self.speedy = 0;
            self.camera.position.y = 5;

            if (rl.isKeyPressed(rl.KeyboardKey.space)) {
                self.speedy = 10;
            }
        }

        if (self.speedy != 0) {
            self.camera.position.y += self.speedy * frameTime;
        }
    }

    pub fn render(self: Player, atlas_texture: rl.Texture2D) !void {
        _ = atlas_texture;
        _ = self;
    }

    pub fn renderPos(self: Player) !void {
        var text_buf: [128]u8 = undefined;
        const post_text = try std.fmt.bufPrintZ(&text_buf, "PLAYER POSITION\n X:{d:.2}\n Y:{d:.2}\n Z:{d:.2}\n SPEEDY:{d:.2}", .{ self.camera.position.x, self.camera.position.y, self.camera.position.z, self.speedy });
        rl.drawText(post_text, 10, 30, 20, .black);
    }

    pub fn deinit(self: *Player) !void {
        _ = self;
    }
};
