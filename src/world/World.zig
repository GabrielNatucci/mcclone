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
    chunckPos: ChunkPos,

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
            .chunckPos = .{ .x = 0, .z = 0 },
        };
    }

    pub fn update(self: *World, position: rl.Vector3) !void {
        const lastChunck = self.getChunck(self.chunckPos.x, self.chunckPos.z);
        const pos_x: i32 = @intFromFloat(position.x);
        const pos_z: i32 = @intFromFloat(position.z);

        if (lastChunck) |chun| {
            if (!(pos_x < chun.xmax and pos_x > chun.xmin) or !(pos_z < chun.zmax and pos_z > chun.zmin)) {
                var chuncklist: std.ArrayList(*Chunck) = .empty;
                defer chuncklist.deinit(self.allocator);

                var it = self.chunckMap.iterator();

                while (it.next()) |entry| {
                    const chunck = entry.value_ptr;

                    if (chunck.xmax > pos_x and chunck.xmin < pos_x and chunck.zmax > pos_z and chunck.zmin < pos_z) {
                        self.chunckPos = .{ .x = chunck.x, .z = chunck.z };
                        std.debug.print("CHUNKPOS ATT:\nX:{}\nZ:{}\n ", .{ self.chunckPos.x, self.chunckPos.z });
                    }

                    try chuncklist.append(self.allocator, chunck);
                }
            }
        }
    }

    pub fn hasChunck(self: World, x: i32, z: i32) bool {
        return self.chunckMap.contains(.{ .x = x, .z = z });
    }

    pub fn getChunck(self: World, x: i32, z: i32) ?Chunck {
        return self.chunckMap.get(.{ .x = x, .z = z });
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
