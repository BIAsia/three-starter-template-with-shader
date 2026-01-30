varying vec3 vPosition;
varying vec2 vUV;
varying vec3 vNormal;

uniform float uProgress;
uniform float uTime;
uniform vec3 uResolution;

#define PI 3.1415927

vec3 rgb2vec3(float r, float g, float b){
    return vec3(r/255., g/255., b/255.);
}

mat2 rotate2d(float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

// float rectangle(vec2 uv, vec2 pos, float width, float height) {
//  float t = 0.0;
//  if ((uv.x > pos.x - width / 2.0) && (uv.x < pos.x + width / 2.0)
//      && (uv.y > pos.y - height / 2.0) && (uv.y < pos.y + height / 2.0)) {
//      t = 1.0;
//  }
//  return t;
// }

float sdRoundRect( in vec2 p, in vec2 b, in float r ) {
    vec2 q = abs(p)-b+r;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r;
}

vec4 normalBlend(vec4 src, vec4 dst) {
    float finalAlpha = src.a + dst.a * (1.0 - src.a);
    return vec4(
        (src.rgb * src.a + dst.rgb * dst.a * (1.0 - src.a)) / finalAlpha,
        finalAlpha
    );
}

float sigmoid(float t) {
    return 1.0 / (1.0 + exp(-t));
}

float drawSquare(vec2 pos, vec2 size, float radius, float blur){
    float rec = sdRoundRect(pos, size, radius+blur);
    rec = sigmoid(rec/blur);
    rec = clamp(rec, 0., 1.);
    return rec;
}

void main() {
    vec2 uv = vUV;
    vec2 coord = vec2(vUV.x*uResolution.y/uResolution.x,vUV.y);

    vec3 colors[5];
    colors[0] = rgb2vec3(0., 195., 125.);
    colors[1] = rgb2vec3(0., 165., 155.);
    colors[2] = rgb2vec3(0., 0., 0.);
    colors[3] = rgb2vec3(125., 170., 31.);
    colors[4] = rgb2vec3(167., 170., 31.);

    // Affection
    float time_a = 0.05;
    float size_a = 0.1;
    // Parameters
    float uSpeed = 1.;

    float k = 844./390.;
    uv.y = uv.y*(k);
    float x = uv.x;
    float y = uv.y;
    //vec2 uv = vec2(x, y);

    vec2 center = vec2(0.5, 0.5*k);
    float speed = uSpeed * uTime * time_a;

    vec2 low = vec2(0.1, 0.1);
    vec2 high = vec2(0.52, 0.72);

    uv *= rotate2d(PI/4.);
    center *= rotate2d(PI/4.);
    low *= rotate2d(PI/4.);
    high *= rotate2d(PI/4.);

    // Calculates
    vec3 fragColor = vec3(0.);

    float timeIncrease = 0.5*(speed*0.02);
    float opacityIncrease = 0.;

    float rec0 = drawSquare(uv-center, vec2(fract(0.85+timeIncrease)), 0., 0.0);
    fragColor = mix(colors[0],fragColor,clamp(rec0+0.8+opacityIncrease, 0., 1.));

    //vec4 Rectangle = rectangle(uv, center, 0.6, 0.6, colors[1]);
    float rec1 = drawSquare(uv-center, vec2(fract(0.6+timeIncrease)), 0., 0.05);
    fragColor = mix(colors[0],fragColor,clamp(rec1+opacityIncrease, 0., 1.));

    float rec2 = drawSquare(uv-center, vec2(fract(0.65+timeIncrease)), 0., 0.);
    fragColor = mix(colors[1],fragColor,clamp(rec2+0.7+opacityIncrease, 0., 1.));

    float rec3 = drawSquare(uv-center, vec2(fract(0.45+timeIncrease)), 0., 0.07);
    fragColor = mix(colors[2],fragColor,clamp(rec3+0.4+opacityIncrease, 0., 1.));

    float rec4 = drawSquare(uv-center, vec2(fract(0.45+timeIncrease)), 0., 0.0);
    fragColor = mix(colors[2],fragColor,clamp(rec4+0.8+opacityIncrease, 0., 1.));

    float rec5 = drawSquare(uv-center, vec2(fract(0.3+timeIncrease)), 0., .05);
    fragColor = mix(colors[3],fragColor,clamp(rec5+0.6+opacityIncrease, 0., 1.));

    float rec6 = drawSquare(uv-center, vec2(fract(0.15+timeIncrease)), .0, 0.);
    fragColor = mix(colors[4],fragColor,clamp(rec6+0.92+opacityIncrease, 0., 1.));

    float rec7 = drawSquare(uv-center, vec2(fract(0.1+timeIncrease)), 0., .07);
    fragColor = mix(colors[2],fragColor,clamp(rec7+0.5+opacityIncrease, 0., 1.));

    fragColor = mix(vec3(0.), fragColor, 0.5);
    gl_FragColor = vec4(vec3(fragColor), 1.);

}
