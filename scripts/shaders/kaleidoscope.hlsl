Texture2D src : register(t0);
SamplerState smp : register(s0);
cbuffer params : register(b0) {
    column_major float2x2 rm;
    float2 offset;
    float2 pivot;
    float aspect;
    float size;
    float scale;
    float mirroring;
};

static const float rsqrt2 =  rsqrt(2.0);

struct PS_Input {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD;
};

struct Tile {
    int2 odd;
    float2 pos;
};

inline float2 r45(float2 pos) {
    return float2(pos.x - pos.y, pos.x + pos.y) * rsqrt2;
}

inline float2 pingpong(float2 pos) {
    return 1.0 - abs(mad(frac(pos * 0.5), 2.0, -1.0));
}

inline Tile wrap(float2 pos) {
    Tile tile;
    float2 idx = floor(pos);
    tile.odd = int2(idx) & 1;
    tile.pos = pos - idx;
    return tile;
}

inline Tile mirror(float2 pos) {
    Tile tile;
    float2 idx = floor(pos);
    tile.odd = int2(idx) & 1;
    tile.pos = abs(tile.odd + idx - pos);
    return tile;
}

inline float2 unfold(float2 pos) {
    return pingpong(pos);
}

inline float2 wheel(float2 pos) {
    Tile tile = mirror(pos);
    int flag = tile.odd.x ^ tile.odd.y;
    return lerp(tile.pos, tile.pos.yx, flag);
}

inline float2 fish_head(float2 pos) {
    Tile tile = mirror(pos);
    return lerp(tile.pos.yx, tile.pos, tile.odd.x);
}

inline float2 can_meas(float2 pos) {
    Tile tile = mirror(pos);
    return lerp(tile.pos.yx, tile.pos, tile.odd.y);
}

inline float2 flip_flop(float2 pos) {
    Tile tile = wrap(pos);
    return abs(float2(tile.odd.x, 1.0) - tile.pos);
}

inline float2 flower(float2 pos) {
    pos = pingpong(pos);
    return lerp(pos, pos.yx, step(pos.y, pos.x));
}

inline float2 dia_cross(float2 pos) {
    pos = mad(frac(mad(pos, 0.5, 0.5)), 2.0, -1.0);
    return r45(abs(r45(pos)).yx);
}

inline float2 flipper(float2 pos) {
    Tile tile = wrap(pos);
    return abs(tile.odd.y - tile.pos);
}

inline float2 starlish(float2 pos) {
    float2 p0 = flower(pos);
    float2 p1 = r45(p0.yx);
    return lerp(p0, p1, step(p1.x, p0.x));
}

float4 kaleidoscope(PS_Input input) : SV_Target {
    float2 pos = (input.uv - offset) * 2.0 * rcp(size) * rcp(scale);
    pos.y *= aspect;
    pos = -pos;

    switch (int(mirroring)) {
        case 0:
            pos = unfold(pos);
            break;
        case 1:
            pos = wheel(pos);
            break;
        case 2:
            pos = fish_head(pos);
            break;
        case 3:
            pos = can_meas(pos);
            break;
        case 4:
            pos = flip_flop(pos);
            break;
        case 5:
            pos = flower(pos);
            break;
        case 6:
            pos = dia_cross(pos);
            break;
        case 7:
            pos = flipper(pos);
            break;
        case 8:
            pos = starlish(pos);
            break;
        default:
            break;
    }

    pos = mul(rm, -pos);
    pos.y *= rcp(aspect);
    float2 coord = mad(pos, 0.5 * size, pivot);
    return src.Sample(smp, coord);
}
