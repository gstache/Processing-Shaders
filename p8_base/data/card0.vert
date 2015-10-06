
#define PROCESSING_TEXLIGHT_SHADER

//Mountain Vertex
// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;

// Set in Processing
uniform sampler2D texture;

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
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
  vec4 texel = texture2D(texture, vertTexCoord.xy);
  float alt = 0.3*texel.r + 0.59*texel.g + 0.1*texel.b;
  vec3 newNorm = vertNormal * alt * 100;
  vec3 newVert = vertex+newNorm;
  vec4 vert = vec4(newVert, 1);

  gl_Position = transform * vert; 
  vertLightDir = normalize(-lightNormal);

}
