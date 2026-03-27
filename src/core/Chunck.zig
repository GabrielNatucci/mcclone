const std = @import("std");
const rl = @import("raylib");
const Block = @import("Block.zig").Block;

pub const Chunck = struct {
    blockList: std.ArrayList(Block),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Chunck {
        const block1: Block = try Block.init(0.0, 0.0, 0.0);
        const block2: Block = try Block.init(2.0, 0.0, 0.0);

        var blockListtemp: std.ArrayList(Block) = .empty;

        try blockListtemp.append(allocator, block1);
        try blockListtemp.append(allocator, block2);

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
