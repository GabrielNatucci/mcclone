const std = @import("std");
const rl = @import("raylib");

pub const Block = struct {
    x: f32,
    y: f32,
    z: f32,
    pub fn init(
        x: f32,
        y: f32,
        z: f32,
    ) !Block {
        return .{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn render(self: Block) !void {
        rl.drawCube(rl.Vector3{ .x = self.x, .y = self.y, .z = self.z }, 1.0, 1.0, 1.0, .lime);
    }

    pub fn deinit(self: *Block) !void {
        _ = self;
    }
};
