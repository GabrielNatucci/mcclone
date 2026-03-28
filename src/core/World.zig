const std = @import("std");
const rl = @import("raylib");
const Chunck = @import("Chunck.zig").Chunck;

pub const World = struct {
    chunckList: std.ArrayList(Chunck),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !World {
        var chunkListtemp: std.ArrayList(Chunck) = .empty;

        var z: c_int = -4;
        while (z < 4) : (z += 1) {
            var x: c_int = -4;
            while (x < 4) : (x += 1) {
                const chunk = try Chunck.init(allocator, x, z);
                try chunkListtemp.append(allocator, chunk);
            }
        }

        return .{
            .chunckList = chunkListtemp,
            .allocator = allocator,
        };
    }

    pub fn update(self: *World, position: rl.Vector3) !void {
        _ = self;
        _ = position;
    }

    pub fn render(self: World, atlas_texture: rl.Texture2D) !void {
        for (self.chunckList.items) |value| {
            try value.render(atlas_texture);
        }
    }

    pub fn deinit(self: *World) !void {
        for (self.chunckList.items) |*chunk| {
            try chunk.deinit();
        }
        self.chunckList.deinit(self.allocator);
    }
};
