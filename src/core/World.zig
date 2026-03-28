const std = @import("std");
const rl = @import("raylib");
const Chunck = @import("Chunck.zig").Chunck;

pub const World = struct {
    chunckList: std.ArrayList(Chunck),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !World {
        const chunck1: Chunck = try Chunck.init(allocator);

        var chunkListtemp: std.ArrayList(Chunck) = .empty;
        try chunkListtemp.append(allocator, chunck1);

        return .{
            .chunckList = chunkListtemp,
            .allocator = allocator,
        };
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
