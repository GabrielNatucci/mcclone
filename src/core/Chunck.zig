const std = @import("std");
const rl = @import("raylib");
const Block = @import("Block.zig").Block;

pub const Chunck = struct {
    blockList: std.ArrayList(Block),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Chunck {
        var blockListtemp: std.ArrayList(Block) = .empty;

        for (0..8) |x| {
            for (0..8) |z| {
                for (0..3) |y| {
                    const block: Block = try Block.init(@floatFromInt(x), @floatFromInt(y), @floatFromInt(z), .dirt);
                    try blockListtemp.append(allocator, block);
                }
            }
        }

        return .{
            .blockList = blockListtemp,
            .allocator = allocator,
        };
    }

    pub fn render(self: Chunck, atlas_texture: rl.Texture2D) !void {
        for (self.blockList.items) |value| {
            try value.render(atlas_texture);
        }
    }

    pub fn deinit(self: *Chunck) !void {
        self.blockList.deinit(self.allocator);
    }
};
