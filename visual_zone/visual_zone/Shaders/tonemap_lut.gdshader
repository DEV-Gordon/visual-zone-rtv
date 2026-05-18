shader_type spatial;
render_mode unshaded, depth_test_disabled, depth_draw_never, cull_disabled, blend_mul;

uniform sampler2D screen_tex  : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D lut_tex     : filter_linear;

uniform float exposure    : hint_range(0.0, 3.0) = 0.8;
uniform float contrast    : hint_range(0.5, 2.0) = 1.0;
uniform float saturation  : hint_range(0.0, 2.0) = 1.25;
uniform float lut_intensity: hint_range(0.0, 1.0) = 0.85;
uniform float black_lift  : hint_range(0.0, 0.5) = 0.0;

const float LUT_SIZE = 64.0;

vec3 sample_lut(vec3 col) {
    col = clamp(col, 0.0, 1.0);
    float slice      = col.b * (LUT_SIZE - 1.0);
    float slice_idx  = floor(slice);
    float slice_frac = fract(slice);
    float u1 = (slice_idx         * LUT_SIZE + col.r * (LUT_SIZE - 1.0) + 0.5) / (LUT_SIZE * LUT_SIZE);
    float u2 = ((slice_idx + 1.0) * LUT_SIZE + col.r * (LUT_SIZE - 1.0) + 0.5) / (LUT_SIZE * LUT_SIZE);
    float v  = (col.g * (LUT_SIZE - 1.0) + 0.5) / LUT_SIZE;
    return mix(texture(lut_tex, vec2(u1, v)).rgb, texture(lut_tex, vec2(u2, v)).rgb, slice_frac);
}

vec3 SoftFilmic(vec3 x) {
    vec3 X = max(vec3(0.0), x - 0.004);
    return (X * (6.2 * X + 0.5)) / (X * (6.2 * X + 1.7) + 0.06);
}

void vertex() {
    POSITION = vec4(VERTEX.xy, 0.0, 1.0);
}

void fragment() {
    vec2 uv   = SCREEN_UV;
    vec3 col  = texture(screen_tex, uv).rgb;
    vec3 orig = col;

    col *= exposure;
    col = pow(col / 0.18, vec3(contrast)) * 0.18;
    col = max(col, 0.0);

    float luma_raw = dot(col, vec3(0.299, 0.587, 0.114));
    vec3 pastel_shadows    = vec3(0.5,  0.52, 0.56);
    vec3 pastel_highlights = vec3(1.0,  0.98, 0.95);
    vec3 graded = mix(col * pastel_shadows, col * pastel_highlights, smoothstep(0.1, 0.9, luma_raw));

    vec3 mapped = SoftFilmic(graded);

    vec3 lut_col = sample_lut(mapped);
    vec3 final   = mix(mapped, lut_col, lut_intensity);

    float luma_mapped = dot(final, vec3(0.299, 0.587, 0.114));
    final = mix(vec3(luma_mapped), final, saturation);

    vec3 factor = final / max(orig, vec3(0.005));
    ALBEDO = clamp(factor, 0.0, 8.0);
}