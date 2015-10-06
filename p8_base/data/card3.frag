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

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;


void main() { 
  vec4 color = texture2D(texture, vertTexCoord.xy);
  float intensity = 0.3*color.r + 0.59*color.g+0.1*color.b;
  float mult = 0.0;
  if(intensity < 0.2) {
  	mult = 0;
  } else if (intensity >= 0.2 && intensity < 0.4) {
  	mult = 0.2;
  } else if (intensity >= 0.4 && intensity < 0.6) {
  	mult = 0.4;
  } else if (intensity >= 0.6 && intensity < 0.8) {
  	mult = 0.6;
  } else if (intensity >= 0.8) {
  	mult = 0.8;
  }
  
  vec4 average = vec4(color.rgb*mult, color.a);
  gl_FragColor = average;
  
}
