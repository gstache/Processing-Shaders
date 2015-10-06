// Fragment shader
// The fragment shader is run once for every pixel
// It can change the color and transparency of the fragment.

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D texture;
uniform float seg; 
// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;


void main() { 
    vec4 color = texture2D(texture, vertTexCoord.xy);
    float intense = 0.3*color.r+.59*color.g+.1*color.b;
    if(vertTexCoord.x >= (1.0-seg) || vertTexCoord.x <= (seg) ||  vertTexCoord.y >= (1.0-seg) || vertTexCoord.y <= (seg)) {
    	gl_FragColor = vec4(0,0,0,1);
    } else {
    	vec4 color1 =  texture2D(texture, vec2(vertTexCoord.x - seg, vertTexCoord.y));
    	vec4 color2 =  texture2D(texture, vec2(vertTexCoord.x, vertTexCoord.y - seg));
    	vec4 color3 =  texture2D(texture, vec2(vertTexCoord.x + seg, vertTexCoord.y));
    	vec4 color4 =  texture2D(texture, vec2(vertTexCoord.x, vertTexCoord.y + seg));
    	float intense1 = 0.3*color1.r+.59*color1.g+.1*color1.b;
    	float intense2 = 0.3*color2.r+.59*color2.g+.1*color2.b;
    	float intense3 = 0.3*color3.r+.59*color3.g+.1*color3.b;
    	float intense4 = 0.3*color4.r+.59*color4.g+.1*color4.b;
    	float sum = intense1+intense2+intense3+intense4;
    	float weight = sum - 4.0*intense;
    	gl_FragColor = vec4(weight, weight, weight, 1);
    }

}
