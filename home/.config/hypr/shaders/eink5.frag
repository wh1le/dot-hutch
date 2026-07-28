precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec3 rgb = texture2D(tex, v_texcoord).rgb;
    float l = dot(rgb, vec3(0.2126, 0.7152, 0.0722)); // luminance
    float q = floor(l * 4.0 + 0.5) / 4.0;

    if (l > 0.90) q = 1.0;

    gl_FragColor = vec4(vec3(q), 1.0);
}
