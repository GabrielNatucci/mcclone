const std = @import("std");
const rl = @import("raylib");
const Chunck = @import("Chunck.zig").Chunck;

const SortContext = struct {
    px: i32,
    pz: i32,
};

pub const ChunkPos = struct {
    x: c_int,
    z: c_int,
};

pub const World = struct {
    chunckMap: std.AutoHashMap(ChunkPos, Chunck),
    allocator: std.mem.Allocator,
    currentChunckPos: ChunkPos,

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
            .currentChunckPos = .{ .x = 0, .z = 0 },
        };
    }

    pub fn update(self: *World, position: rl.Vector3) !void {
        const lastChunck = self.getChunck(self.currentChunckPos.x, self.currentChunckPos.z);
        const pos_x: i32 = @intFromFloat(position.x);
        const pos_z: i32 = @intFromFloat(position.z);
        var hasUpdated: bool = false;

        if (lastChunck) |chun| {
            if (!(pos_x < chun.xmax and pos_x > chun.xmin) or !(pos_z < chun.zmax and pos_z > chun.zmin)) {
                var chuncklist: std.ArrayList(*Chunck) = .empty;
                defer chuncklist.deinit(self.allocator);
                var it = self.chunckMap.iterator();

                while (it.next()) |entry| {
                    const chunck = entry.value_ptr;

                    if (chunck.xmax > pos_x and chunck.xmin < pos_x and chunck.zmax > pos_z and chunck.zmin < pos_z) {
                        self.currentChunckPos = .{ .x = chunck.x, .z = chunck.z };
                        hasUpdated = true;
                        std.debug.print("CHUNKPOS ATT:\nX:{}\nZ:{}\n ", .{ self.currentChunckPos.x, self.currentChunckPos.z });
                    }

                    try chuncklist.append(self.allocator, chunck);
                }

                if (hasUpdated) {
                    const px: i32 = @as(c_int, self.currentChunckPos.x);
                    const pz: i32 = @as(c_int, self.currentChunckPos.z);

                    std.sort.block(*Chunck, chuncklist.items, SortContext{
                        .px = px,
                        .pz = pz,
                    }, lessThan);
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

fn lessThan(ctx: SortContext, a: *Chunck, b: *Chunck) bool {
    const dx_a = a.x - ctx.px;
    const dz_a = a.z - ctx.pz;
    const da = dx_a * dx_a + dz_a * dz_a;

    const dx_b = b.x - ctx.px;
    const dz_b = b.z - ctx.pz;
    const db = dx_b * dx_b + dz_b * dz_b;

    return da < db;
}

fn dist2(chunk: *Chunck, px: i32, pz: i32) i32 {
    const dx = chunk.x - px;
    const dz = chunk.z - pz;
    return dx * dx + dz * dz;
}
