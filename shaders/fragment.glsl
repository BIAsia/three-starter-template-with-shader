varying vec3 vPosition;
varying vec2 vUV;
varying vec3 vNormal;

uniform float uProgress;
uniform float uTime;
uniform vec3 uResolution;

#define PI 3.1415927
const float dots = 50.; //number of lights

vec3 RAMP(vec3 cols[4], float x) {
    x *= float(cols.length() - 1);
    return mix(cols[int(x)], cols[int(x) + 1], smoothstep(0.0, 1.0, fract(x)));
}

mat2 rotate2d(float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

vec3 RGBColor(vec3 rgb){
    return vec3(rgb.r/255., rgb.g/255., rgb.b/255.);
}

float rand(vec2 co, float time){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233+time/10000.))) * 43758.5453);
}

void main() {
    vec3 rgb = vec3(0., 1., uProgress);
    vec2 uv = vUV;
    vec2 coord = vec2(vUV.x*uResolution.y/uResolution.x,vUV.y);

     float time = uTime*0.005;

    vec3 mainColor = RGBColor(vec3(0., 0., 0.));
    vec3 assistColor = RGBColor(vec3(26., 42., 108.));
    vec3 assistColor2 = RGBColor(vec3(178., 31., 31.));
    vec3 assistColor3 = RGBColor(vec3(223., 167., 25.));

    vec3[4] colors;
    colors[0] = assistColor3;
    colors[1] = assistColor2;
    colors[2] = assistColor;
    colors[3] = mainColor;
    vec3 color = RAMP(colors, uv.y*0.5*abs(cos(time)-0.8));

    vec2 pos = vec2(0.5) - uv;
    float r = length(pos) * .6;
    float a = atan(pos.y, pos.x);
    float count = 2.;
    float shape =
        abs(0.7*sin(a * (count * .5) + (time  * 0.8+0.4))) *
        sin(a * count - (time  * 0.8+0.2))
    ;

    float shape2 =
        abs(0.2*sin(a * (count * .5) + (time  * 0.8 + 0.5))) *
        cos(a * count*2. - (time  * 0.8+0.5))
    ;
    shape+=shape2;

    shape = pow(shape,1.);
    //r += 0.05*rand(uv,time*0.01);
    color = mix(
        color,
        vec3(0.),
        r
    );

    color *= 1. +  0.5;

    float alpha = (1. - smoothstep(shape, shape + 0.8, r)) + (1. - smoothstep(shape, shape + 1.5, r)) * 0.2;
    alpha = clamp(alpha, 0., 1.0);
    alpha -= 0.1;
    color *= alpha;

    color.rgb += vec3(-0.1, 0.1, 0.05);

    color += assistColor;
    gl_FragColor = vec4(vec3(color), 1.);
    

    //gl_FragColor = vec4(vec3(fragColor.rgb), 1.);

}