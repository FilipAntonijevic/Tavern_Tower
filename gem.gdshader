shader_type canvas_item;

uniform float shine_width = 0.2;
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);

const float cycle_duration = 2.5;
const float shine_duration = 0.6;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float t = mod(TIME, cycle_duration);

    float shine_pos = 0.0;
    if (t < shine_duration) {
        shine_pos = t / shine_duration;
    } else {
        shine_pos = -1.0; 
    }

    float dist = abs(UV.x - shine_pos);
    float shine = smoothstep(shine_width, 0.0, dist);

    float alpha_mask = step(0.1, tex_color.a);

    COLOR = tex_color + shine * shine_color * alpha_mask;
}
