
#define PROCESSING_TEXLIGHT_SHADER
// bump map py position
// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;

uniform float time;
//position based bump
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
  float y = texCoord.y*80;
  float x = texCoord.x*80;
  mat3 rotMatX =mat3(1, 0, 0, 0, max(.5,cos(x)), -max(.5,sin(x)),0, max(.5,sin(x)), max(.5,cos(x)));
  mat3 rotMatY = mat3(max(.5,cos(y)), 0, max(.5,sin(y)), 0, 1, 0, -max(.5,sin(y)), 0, max(.5,cos(y)));
  vertNormal = normalize(rotMatX * rotMatY * normalMatrix * normal);
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  
  vec4 vert = vertex;

  gl_Position = transform *vert; 
  vertLightDir = normalize(-lightNormal);
}
