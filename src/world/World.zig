
const std = @import("std");
const rl = @import("raylib");
const Chunck = @import("Chunck.zig").Chunck;

pub const ChunkPos = struct {
    x: c_int,
    z: c_int,
};

pub const World = struct {
    chunckMap: std.AutoHashMap(ChunkPos, Chunck),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !World {
        var chunkMap = std.AutoHashMap(ChunkPos, Chunck).init(allocator);

        var z: c_int = -8;
        while (z < 8) : (z += 1) {
            var x: c_int = -8;
            while (x < 8) : (x += 1) {
                var chunk = try Chunck.init(allocator, x, z);
                try chunk.update();
                try chunkMap.put(.{ .x = x, .z = z }, chunk);
            }
        }

        return .{
            .chunckMap = chunkMap,
            .allocator = allocator,
        };
    }

    pub fn update(self: *World, position: rl.Vector3) !void {
        _ = self;
        _ = position;
    }

    pub fn render(self: World, atlas_texture: rl.Texture2D) !void {
        rl.gl.rlBegin(rl.gl.rl_quads);
        rl.gl.rlSetTexture(atlas_texture.id);
        var it = self.chunckMap.iterator();
        while (it.next()) |entry| {
            try entry.value_ptr.render();
        }
        rl.gl.rlEnd();
        rl.gl.rlSetTexture(0);
    }

    pub fn deinit(self: *World) !void {
        var it = self.chunckMap.iterator();
        while (it.next()) |entry| {
            try entry.value_ptr.deinit();
        }
        self.chunckMap.deinit();
    }
};
