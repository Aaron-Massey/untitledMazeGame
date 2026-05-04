shader_type spatial;

// --- Attributes from ReflectiveShape.js ---
uniform vec4 ambientMat : source_color = vec4(1.0);
uniform vec4 diffuseMat : source_color = vec4(1.0);
uniform vec4 specularMat : source_color = vec4(1.0);
uniform float shininess : hint_range(1.0, 512.0) = 200.0;
uniform float uBumpStrength : hint_range(0.0, 5.0) = 2.0;
uniform vec4 emission_color : source_color = vec4(1.0, 0.5, 0.2, 1.0); // Warm orange
uniform float emission_amount : hint_range(0.0, 16.0) = 0.0;


// --- Texture Samplers ---
uniform sampler2D uTexture : source_color;
uniform sampler2D uNormalMap : hint_normal;

// --- Tiling ---
uniform vec2 uv_scale = vec2(1.0, 1.0);



void fragment() {
    // 1. Scale the UVs
    vec2 scaled_uv = UV * uv_scale;

    // 2. Sample the textures using the new scaled_uv
    vec4 tex_color = texture(uTexture, scaled_uv);
    
    // 3. Apply the diffuse color multiplier
    ALBEDO = tex_color.rgb * diffuseMat.rgb;
    
    // 4. Normal mapping 
    NORMAL_MAP = texture(uNormalMap, scaled_uv).rgb;
    NORMAL_MAP_DEPTH = uBumpStrength; 
    
    // 5. Emission
    EMISSION = emission_color.rgb * emission_amount;
}

void light() {
    // 1. Diffuse: Standard Lambertian reflection
    float dot_nl = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
    vec3 diffuse = LIGHT_COLOR * dot_nl * ALBEDO;

    // 2. Specular: True Phong reflection vector math
    vec3 R = reflect(-LIGHT, NORMAL);
    // VIEW is natively passed to light() as normalized, so we don't need normalize(VIEW)
    float dot_rv = clamp(dot(R, VIEW), 0.0, 1.0);
    float spec_factor = pow(dot_rv, shininess);
    vec3 specular = LIGHT_COLOR * specularMat.rgb * spec_factor;

    // 3. Summation
    // We remove the clamp() to allow for HDR and Bloom processing later.
    DIFFUSE_LIGHT += diffuse * ATTENUATION;
    SPECULAR_LIGHT += specular * ATTENUATION;
}