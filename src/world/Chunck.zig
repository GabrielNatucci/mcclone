const std = @import("std");
const rl = @import("raylib");
const Block = @import("Block.zig");

pub const Chunck = struct {
    blockMap: std.AutoHashMap([3]i32, Block.Block),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, varx: c_int, varz: c_int) !Chunck {
        var blockMap = std.AutoHashMap([3]i32, Block.Block).init(allocator);

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

                    const pos_x: i32 = x + @as(i32, @intCast(varx)) * 8;
                    const pos_y: i32 = y;
                    const pos_z: i32 = z + @as(i32, @intCast(varz)) * 8;

                    const block: Block.Block = try Block.Block.init(@floatFromInt(pos_x), @floatFromInt(pos_y), @floatFromInt(pos_z), typevalue);
                    try blockMap.put([3]i32{ pos_x, pos_y, pos_z }, block);
                }
            }
        }

        return .{
            .blockMap = blockMap,
            .allocator = allocator,
        };
    }

    pub fn hasBlock(self: Chunck, x: i32, y: i32, z: i32) bool {
        return self.blockMap.contains([3]i32{ x, y, z });
    }

    pub fn getBlock(self: Chunck, x: i32, y: i32, z: i32) ?Block.Block {
        return self.blockMap.get([3]i32{ x, y, z });
    }

    pub fn update(self: *Chunck) !void {
        var it = self.blockMap.valueIterator();
        while (it.next()) |block| {
            const xPos: i32 = @intFromFloat(block.x);
            const yPos: i32 = @intFromFloat(block.y);
            const zPos: i32 = @intFromFloat(block.z);

            if (self.hasBlock(xPos + 1, yPos, zPos)) {
                block.renderXplus = false;
            }

            if (self.hasBlock(xPos - 1, yPos, zPos)) {
                block.renderXminus = false;
            }

            if (self.hasBlock(xPos, yPos, zPos - 1)) {
                block.renderZminus = false;
            }

            if (self.hasBlock(xPos, yPos, zPos + 1)) {
                block.renderZplus = false;
            }

            if (self.hasBlock(xPos, yPos + 1, zPos)) {
                block.renderTop = false;
            }

            if (self.hasBlock(xPos, yPos + 1, zPos)) {
                block.renderBottom = false;
            }
        }
    }

    pub fn render(self: Chunck, atlas_texture: rl.Texture2D) !void {
        var it = self.blockMap.valueIterator();
        while (it.next()) |block| {
            try block.*.render(atlas_texture);
        }
    }

    pub fn deinit(self: *Chunck) !void {
        self.blockMap.deinit();
    }
};
