#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 rgb = pixColor.rgb;

    float cap = 0.7;
    rgb = min(rgb, vec3(cap));

    fragColor = vec4(rgb, pixColor.a);
}
