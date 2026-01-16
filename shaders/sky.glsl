extern number screen_height;
extern number sky_height;
extern number camera_height;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 blue = vec4(0.53, 0.80, 0.92, 1.0);
    vec4 transparent = vec4(0.0, 0.0, 0.0, 0.0);

    number height_from_ground = screen_height - screen_coords.y + (camera_height - screen_height / 2);
    
    if (height_from_ground - sky_height < 0)
        return blue;

    if (height_from_ground - sky_height > screen_height)
        return transparent;
    
    float factor = mod(height_from_ground - sky_height, screen_height) / screen_height;
    
    return mix(blue, transparent, factor);
}