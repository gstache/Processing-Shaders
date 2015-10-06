// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
  vec4 color = texture2D(texture, vertTexCoord.xy);
  vec4 diffuse = color * max(0.0, dot(vertNormal, vertLightDir));

  gl_FragColor = vec4(diffuse.rgb, 1);
	  
}