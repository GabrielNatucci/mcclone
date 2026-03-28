const std = @import("std");
const rl = @import("raylib");
const TILE_SIZE = 32.0;
const ATLAS_SIZE: f32 = 1024.0;

pub const BlockType = enum {
    grass,
    dirt,
    stone,
};

pub const Block = struct {
    x: f32,
    y: f32,
    z: f32,
    renderXplus: bool = true,
    renderXminus: bool = true,
    renderZplus: bool = true,
    renderZminus: bool = true,
    renderTop: bool = true,
    renderBottom: bool = true,
    block_type: BlockType,

    pub fn init(
        x: f32,
        y: f32,
        z: f32,
        block_type: BlockType,
    ) !Block {
        return .{
            .x = x,
            .y = y,
            .z = z,
            .block_type = block_type,
        };
    }

    pub fn render(self: Block, atlas_texture: rl.Texture2D) !void {
        const uvs = getBlockUVs(self.block_type);
        const half: f32 = 0.5;
        _ = atlas_texture;

        rl.gl.rlColor4ub(255, 255, 255, 255);

        // face frontal (z+)
        if (self.renderZplus) {
            rl.gl.rlNormal3f(0.0, 0.0, 1.0);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v1);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v1);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v0);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v0);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z + half);
        }

        // face traseira (z-)
        if (self.renderZminus) {
            rl.gl.rlNormal3f(0.0, 0.0, -1.0);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v1);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v0);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v0);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v1);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z - half);
        }

        // face superior (y+)
        if (self.renderTop) {
            rl.gl.rlNormal3f(0.0, 1.0, 0.0);
            rl.gl.rlTexCoord2f(uvs.top.u0, uvs.top.v0);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.top.u0, uvs.top.v1);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.top.u1, uvs.top.v1);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.top.u1, uvs.top.v0);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z - half);
        }

        // face inferior (y-)
        if (self.renderBottom) {
            rl.gl.rlNormal3f(0.0, -1.0, 0.0);
            rl.gl.rlTexCoord2f(uvs.bottom.u1, uvs.bottom.v0);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.bottom.u0, uvs.bottom.v0);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.bottom.u0, uvs.bottom.v1);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.bottom.u1, uvs.bottom.v1);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z + half);
        }

        // face direita (x+)
        if (self.renderXplus) {
            rl.gl.rlNormal3f(1.0, 0.0, 0.0);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v0);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v0);
            rl.gl.rlVertex3f(self.x + half, self.y + half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v1);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v1);
            rl.gl.rlVertex3f(self.x + half, self.y - half, self.z - half);
        }

        // face esquerda (x-)
        if (self.renderXminus) {
            rl.gl.rlNormal3f(-1.0, 0.0, 0.0);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v0);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u0, uvs.side.v1);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z - half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v1);
            rl.gl.rlVertex3f(self.x - half, self.y - half, self.z + half);
            rl.gl.rlTexCoord2f(uvs.side.u1, uvs.side.v0);
            rl.gl.rlVertex3f(self.x - half, self.y + half, self.z + half);
        }
    }

    pub fn deinit(self: *Block) !void {
        _ = self;
    }
};

const UV = struct { u0: f32, v0: f32, u1: f32, v1: f32 };

const BlockUV = struct {
    side: UV,
    top: UV,
    bottom: UV,
};

fn getBlockUVs(block_type: BlockType) BlockUV {
    return switch (block_type) {
        .grass => .{
            .side = uv(0, 0),
            .top = uv(1, 0),
            .bottom = uv(2, 0),
        },
        .dirt => .{
            .side = uv(3, 0),
            .top = uv(4, 0),
            .bottom = uv(5, 0),
        },
        .stone => .{
            .side = uv(6, 0),
            .top = uv(7, 0),
            .bottom = uv(8, 0),
        },
    };
}

fn uv(tile_x: f32, tile_y: f32) UV {
    const u_0 = (tile_x * TILE_SIZE) / ATLAS_SIZE;
    const u_1 = ((tile_x + 1) * TILE_SIZE) / ATLAS_SIZE;
    const v_0 = (tile_y * TILE_SIZE) / ATLAS_SIZE;
    const v_1 = ((tile_y + 1) * TILE_SIZE) / ATLAS_SIZE;

    return .{ .u0 = u_0, .v0 = v_0, .u1 = u_1, .v1 = v_1 };
}
