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

void fragment() {
    // 1. Sample the texture
    vec4 tex_color = texture(uTexture, UV);
    
    // 2. Apply the diffuse color multiplier here
    // This ensures the light pass has the 'cat fur' color to work with
    ALBEDO = tex_color.rgb * diffuseMat.rgb;
    
    // 3. Normal mapping logic
    vec3 n_map = texture(uNormalMap, UV).rgb * 2.0 - 1.0;
    
    // Using TBN components for correct vector math
    vec3 local_n = TANGENT * n_map.x + BINORMAL * n_map.y + NORMAL * n_map.z;
    NORMAL = mix(NORMAL, local_n, uBumpStrength);
    
    // Disable default PBR specular to let our light() function take over entirely
    SPECULAR = 0.0;
	EMISSION = emission_color.rgb * emission_amount;
}

void light() {
    // 1. Ambient: Calculated based on the light color and albedo
    vec3 ambient = LIGHT_COLOR * (ambientMat.rgb * 0.03) * ALBEDO;

    // 2. Diffuse: Standard Lambertian reflection
    float dot_nl = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
    vec3 diffuse = LIGHT_COLOR * dot_nl * ALBEDO;

    // 3. Specular: True Phong reflection vector math
    vec3 R = reflect(-LIGHT, NORMAL);
    vec3 V = normalize(VIEW);
    float dot_rv = clamp(dot(R, V), 0.0, 1.0);
    float spec_factor = pow(dot_rv, shininess);
    vec3 specular = LIGHT_COLOR * specularMat.rgb * spec_factor;

    // 4. Summation: Clamped to [0,1] to prevent white-out saturation
    // We multiply by ATTENUATION for light falloff (important for Omni/Spot lights)
    DIFFUSE_LIGHT += clamp((diffuse + ambient) * ATTENUATION, vec3(0.0), vec3(1.0));
    SPECULAR_LIGHT += clamp(specular * ATTENUATION, vec3(0.0), vec3(1.0));
}