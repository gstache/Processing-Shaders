
#define PROCESSING_TEXLIGHT_SHADER
//wiggle
// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;
uniform float time;


// Come from the geometry/material of the object
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

// These values will be sent to the fragment shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  vertColor = color;
  
  vertNormal = normalize(normalMatrix * normal);
  
  vec4 vert = vertex;
  vert = vec4(vert.x,vert.y +30*(2*sin(time - texCoord.x) - 1) - 40, vert.zw);
  gl_Position = transform * vert; 
  vertLightDir = normalize(-lightNormal);

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
