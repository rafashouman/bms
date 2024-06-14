shader_type spatial;

#define USE_ALPHA 0
#define USE_ALPHA_CUTOFF 0
#define USE_EMISSION 0
#define USE_REFLECTIONS 0
#define USE_NORMAL_MAP 0
#define USE_OCCLUSION 0
#define USE_ANISOTROPY 0
#define USE_BACKLIGHT 0
#define USE_REFRACTION 0
#define USE_TRIPLANAR 1

#if USE_ALPHA
render_mode depth_draw_always;
#endif

#if USE_EMISSION
#include "includes/emission.gdshaderinc"
#endif

#if USE_REFLECTIONS
#include "includes/reflections.gdshaderinc"
#endif

#if USE_NORMAL_MAP
#include "includes/normal-map.gdshaderinc"
#endif

#if USE_OCCLUSION
#include "includes/occlusion.gdshaderinc"
#endif

#if USE_ANISOTROPY
#include "includes/anisotropy.gdshaderinc"
#endif

#if USE_BACKLIGHT
#include "includes/backlight.gdshaderinc"
#endif

#if USE_REFRACTION
#include "includes/refraction.gdshaderinc"
#elif !USE_REFRACTION && USE_ALPHA
#include "includes/transparency.gdshaderinc"
#endif

group_uniforms BaseProperties;
#if USE_ALPHA_CUTOFF
uniform float alpha_cutoff: hint_range(0.0, 1.0) = 0.5;
#endif
uniform vec4 color: source_color = vec4(0.7, 0.12, 0.86, 1.0);
uniform sampler2D base_texture;
uniform vec4 specular: source_color = vec4(0.3, 0.3, 0.3, 0.5);
uniform sampler2D specular_texture;
uniform vec4 fresnel: source_color = vec4(0.2, 0.2, 0.2, 0.3);
uniform sampler2D fresnel_texture;
group_uniforms;

varying vec3 SPECULAR_COLOR;
varying float SPECULAR_STRENGTH;
varying vec3 FRESNEL_COLOR;
varying float FRESNEL_STRENGTH;

group_uniforms Tiling;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_offset = vec2(0,0);
group_uniforms;

#if USE_TRIPLANAR
uniform float triplanar_scale = 1.0;
uniform float triplanar_sharpness = 1.0;
#endif

void vertex() {
    UV = UV * uv_scale.xy + uv_offset.xy;
}

void fragment() {
#if USE_TRIPLANAR
    vec3 triplanar_weights = abs(NORMAL);
    triplanar_weights = triplanar_weights / dot(triplanar_weights, vec3(1.0));
    vec3 triplanar_uv = vec3(UV, 0.0) * triplanar_scale;
    vec4 color_x = texture(base_texture, triplanar_uv.yz);
    vec4 color_y = texture(base_texture, triplanar_uv.zx);
    vec4 color_z = texture(base_texture, triplanar_uv.xy);
    vec4 triplanar_color = color_x * triplanar_weights.x + color_y * triplanar_weights.y + color_z * triplanar_weights.z;
    ALBEDO = triplanar_color.rgb;
#else
    ALBEDO = color.rgb * texture(base_texture, UV).rgb;
#endif

#if USE_ALPHA
    float alpha = color.a * texture(base_texture, UV).a;
    ALBEDO *= alpha;
#elif USE_ALPHA_CUTOFF
    ALPHA = color.a * texture(base_texture, UV).a;
    ALPHA_SCISSOR_THRESHOLD = color.a * texture(base_texture, UV).a;
#endif
}