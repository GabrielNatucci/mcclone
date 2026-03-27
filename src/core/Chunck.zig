const std = @import("std");
const rl = @import("raylib");
const Block = @import("Block.zig").Block;

pub const Chunck = struct {
    blockList: std.ArrayList(Block),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Chunck {
        var blockListtemp: std.ArrayList(Block) = .empty;

        for (0..8) |x| {
            for (0..8) |y| {
                for (0..3) |z| {
                    const block: Block = try Block.init(@floatFromInt(x), @floatFromInt(y), @floatFromInt(z));
                    try blockListtemp.append(allocator, block);
                }
            }
        }

        return .{
            .blockList = blockListtemp,
            .allocator = allocator,
        };
    }

    pub fn render(self: Chunck) !void {
        for (self.blockList.items) |value| {
            try value.render();
        }
    }

    pub fn deinit(self: *Chunck) !void {
        self.blockList.deinit(self.allocator);
    }
};
