const std = @import("std");
const rl = @import("raylib");
const Block = @import("Block.zig");

pub const Chunck = struct {
    blockList: std.ArrayList(Block.Block),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, varx: c_int, varz: c_int) !Chunck {
        var blockListtemp: std.ArrayList(Block.Block) = .empty;

        var x: i32 = -4;
        while (x < 4) : (x += 1) {
            var z: i32 = -4;
            while (z < 4) : (z += 1) {
                var y: i32 = 0;
                while (y < 3) : (y += 1) {
                    var typevalue = Block.BlockType.dirt;
                    if (y == 2) {
                        typevalue = Block.BlockType.grass;
                    }

                    const block: Block.Block = try Block.Block.init(@floatFromInt(x + varx*8), @floatFromInt(y), @floatFromInt(z + varz*8), typevalue);
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
