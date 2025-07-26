Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);
cbuffer constant0 : register(b0) {
    column_major float2x2 rm;
    column_major float2x2 rm_45;
    float2 res;
    float2 pivot;
    float2 offset;
    float2 tile_size;
    float scale;
    float mirroring;
};

#define PI 3.1415927

static const float2 up = float2(0.0, -1.0);
static const float2 diag = float2(1.0, 1.0) * rcp(sqrt(2.0));
static const float arg_8 = rcp(sqrt(2.0));
static const float arg_16 = cos(PI * rcp(8.0));

struct PS_INPUT {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};

struct TileInfo {
    float2 parity;
    float2 pos;
};

TileInfo tiler(float2 pos, float2 range) {
    TileInfo tile;
    int2 idx = (int2)floor(pos * rcp(range));
    tile.parity = float2(idx & 1);
    tile.pos = pos - idx * range;
    return tile;
}

TileInfo mirror(float2 pos, float2 range) {
    TileInfo tile;
    int2 idx = (int2)floor(pos * rcp(range));
    tile.parity = float2(idx & 1);
    float2 tile_pos = pos - idx * range;
    tile.pos = lerp(tile_pos, range - tile_pos, tile.parity);
    return tile;
}

float2 unfold(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    return tile.pos;
}

float2 wheel(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    float flag = step(1.0, abs(tile.parity.x - tile.parity.y));
    return lerp(tile.pos, tile.pos.yx, flag);
}

float2 fish_head(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    return lerp(tile.pos.yx, tile.pos, tile.parity.x);
}

float2 can_meas(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    return lerp(tile.pos.yx, tile.pos, tile.parity.y);
}

float2 flip_flop(float2 pos) {
    TileInfo tile = tiler(pos, tile_size);
    float2 flag = float2(tile.parity.x, 1.0);
    return lerp(tile.pos, tile_size - tile.pos, flag);
}

float2 flower(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    float flag = step(tile.pos.x, tile.pos.y);
    return lerp(tile.pos, tile.pos.yx, flag);
}

float2 dia_cross(float2 pos) {
    float2 st = float2(tile_size.x, 0.0);
    float2 range = float2(tile_size.x * 2.0, tile_size.y);
    TileInfo t_1 = tiler(pos + st, range);
    TileInfo t_2 = tiler(pos.yx + st, range);
    float2 pos_1 = lerp(t_1.pos - st, tile_size - t_1.pos, t_1.parity.y);
    float2 pos_2 = lerp(t_2.pos - st, tile_size - t_2.pos, t_2.parity.y);
    float2 dir = normalize(pos_1);
    float flag = step(arg_8, dot(up, dir));
    return lerp(pos_2, pos_1, flag);
}

float2 flipper(float2 pos) {
    TileInfo tile = tiler(pos, tile_size);
    return lerp(tile.pos, tile_size - tile.pos, tile.parity.y);
}

float2 starlish(float2 pos) {
    TileInfo tile = mirror(pos, tile_size);
    float base_flag = step(tile.pos.x, tile.pos.y);
    float2 base_tile = lerp(tile.pos, tile.pos.yx, base_flag);
    float2 dir = normalize(abs(tile.pos));
    float flag = step(arg_16, dot(diag, dir));
    return lerp(base_tile, mul(rm_45, base_tile.yx), flag);
}

float4 kaleidoscope(PS_INPUT input) : SV_Target {
    float2 rel_pos = (input.uv * res - pivot + offset) * scale;

    float2 tile_pos = rel_pos;
    switch (int(mirroring)) {
        case 0:
            tile_pos = unfold(rel_pos);
            break;
        case 1:
            tile_pos = wheel(rel_pos);
            break;
        case 2:
            tile_pos = fish_head(rel_pos);
            break;
        case 3:
            tile_pos = can_meas(rel_pos);
            break;
        case 4:
            tile_pos = flip_flop(rel_pos);
            break;
        case 5:
            tile_pos = flower(rel_pos);
            break;
        case 6:
            tile_pos = dia_cross(rel_pos);
            break;
        case 7:
            tile_pos = flipper(rel_pos);
            break;
        case 8:
            tile_pos = starlish(rel_pos);
            break;
        case 9:
            break;
    }

    tile_pos = mul(rm, tile_pos);

    TileInfo coord = mirror(tile_pos + pivot, res);
    float2 inv_res = rcp(res);
    float2 e = 0.5 * inv_res;
    return texture0.Sample(sampler0, clamp(coord.pos * inv_res, e, 1.0 - e));
}
