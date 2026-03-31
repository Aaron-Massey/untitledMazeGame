shader_type spatial;

// These uniform variables will show up in the Godot Inspector!
uniform vec3 color_light : source_color = vec3(0.7, 0.7, 0.7); // Light Gray
uniform vec3 color_dark : source_color = vec3(0.5, 0.5, 0.5);  // Dark Gray
uniform vec3 line_color : source_color = vec3(0.0, 0.0, 0.0);  // Black
uniform float line_thickness = 0.05;
uniform float square_size = 1.0; // 1 square = 1 meter

varying vec3 world_pos;

void vertex() {
    // Grab the actual world position of the vertices so the grid never stretches
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // FIX: Convert the View Space NORMAL into a World Space NORMAL
    vec3 world_normal = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
    
    // 1. Figure out which side of the box we are looking at using the WORLD normal
    vec2 grid_pos;
    vec3 n = abs(world_normal); // Use our new world_normal here!
    
    if (n.x > n.y && n.x > n.z) {
        grid_pos = world_pos.zy;
    } else if (n.y > n.x && n.y > n.z) {
        grid_pos = world_pos.xz;
    } else {
        grid_pos = world_pos.xy;
    }
    
    // Scale the grid by our chosen size
    grid_pos /= square_size;

    // 2. Create the Alternating Checkerboard
    vec2 cell = floor(grid_pos);
    float checker = mod(cell.x + cell.y, 2.0);
    vec3 final_color = mix(color_light, color_dark, checker);

    // 3. Create the Black Outline Every 5 Squares
    vec2 grid_5 = mod(grid_pos, 5.0);
    float half_thick = line_thickness / 2.0;
    
    // If we are close to the edge of a 5-square boundary, paint it black
    if (grid_5.x < half_thick || grid_5.x > 5.0 - half_thick || 
        grid_5.y < half_thick || grid_5.y > 5.0 - half_thick) {
        final_color = line_color;
    }

    // Apply the color!
    ALBEDO = final_color;
}