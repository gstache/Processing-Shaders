// Fragment shader
//wiggle
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
	vec4 color = texture2D(texture, vertTexCoord.xy);
	if (color.g < .1 || color.r >= .3 || color.b >= .3)  {
		float intense = .3*color.r + .59*color.g +.1*color.b;
		color = vec4(vec3(intense), 1);
	}
    gl_FragColor = vec4(color.rgb, 1);
	  
}
