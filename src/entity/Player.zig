const std = @import("std");
const rl = @import("raylib");

pub const Player = struct {
    camera: rl.Camera,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Player {
        var camera = std.mem.zeroes(rl.Camera);
        camera.position = rl.Vector3{ .x = 0.0, .y = 50.0, .z = 10.0 };
        camera.up = rl.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
        camera.fovy = 75.0;
        camera.projection = rl.CameraProjection.perspective;

        return .{
            .allocator = allocator,
            .camera = camera,
        };
    }

    pub fn update(self: *Player, frameTime: f32) !void {
        if (self.camera.position.y > 5) {
            self.camera.position.y -= 10 * frameTime;
        }
    }

    pub fn render(self: Player, atlas_texture: rl.Texture2D) !void {
        _ = atlas_texture;
        _ = self;
    }

    pub fn renderPos(self: Player) !void {
        var text_buf: [128]u8 = undefined;
        const post_text = try std.fmt.bufPrintZ(&text_buf, "PLAYER POSITION\n X:{d:.2}\n Y:{d:.2}\n Z:{d:.2}\n", .{ self.camera.position.x, self.camera.position.y, self.camera.position.z });
        rl.drawText(post_text, 10, 30, 20, .black);
    }

    pub fn deinit(self: *Player) !void {
        _ = self;
    }
};
