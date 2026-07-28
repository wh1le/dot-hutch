#version 300 es
precision highp float;


in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 rgb = pixColor.rgb;

    float luma = dot(rgb, vec3(0.2126, 0.7152, 0.0722));
    rgb = mix(vec3(luma), rgb, 0.60);

    rgb = rgb * 0.82 + 0.05;

    float luma2 = dot(rgb, vec3(0.2126, 0.7152, 0.0722));
    float whitemask = smoothstep(0.75, 1.0, luma2);
    rgb *= 1.0 - whitemask * 0.25;

    fragColor = vec4(rgb, pixColor.a);
}
