// Custom sphere drawing with texture coordinates

// detail must be at least 1.
void texturedSphere(int detail, PImage texture) {
  half_sphere(detail, +1, texture);
  half_sphere(detail, -1, texture);
}

void half_sphere(int d, float vmult, PImage texture){
  if(d<1)
    println("Nope, half_sphere(>=1) required");
    
  float s = PI/(d*2);
  float[][] v = new float[(int)(d*d*4)][5];
  int vn = 0;
 
  for(int z=1; z<=d; z++){
    float phi = (PI/2) + s *(z-1);
    for(int c=0; c<d*4; c++){
       float theta = c*s;
       v[vn][0] = cos(theta)*sin(phi);
       v[vn][1] = sin(theta)*sin(phi);
       v[vn][2] = cos(phi)*vmult;
       
       v[vn][3] = v[vn][0]*0.5 + 0.5;
       v[vn][4] = v[vn][1]*0.5 + 0.5;
       vn++;
    }
  }
  
  //draw top cap
  beginShape(TRIANGLE_FAN); 
  texture(texture);
  normal(0,0,-1*vmult);
  vertex(0,0,-1*vmult, 0.5,0.5);
  for(int p=0; p<d*4; p++) {
    float[] V = v[vn-p-1];
    normal(V[0],V[1],V[2]);
    vertex(V[0],V[1],V[2], V[3],V[4]);
  }
  vertex(v[vn-1][0],v[vn-1][1],v[vn-1][2], v[vn-1][3], v[vn-1][4]);
  endShape();
  
  //draw body quads
  
  float[] A;
  float[] B;
  for(int c = 0; c<d-1; c++){
    int nc = (c+1)*d*4;
    int cc = (c)*d*4;
    beginShape(QUAD_STRIP);
    texture(texture);
    for(int p=0; p<d*4; p++){
      A = v[nc+p];
      B = v[cc+p];
      normal(A[0],A[1],A[2]);
      vertex(A[0],A[1],A[2], A[3], A[4]);
      normal(B[0],B[1],B[2]);
      vertex(B[0],B[1],B[2], B[3], B[4]);
    }
    A = v[nc];
    B = v[cc];
    normal(A[0],A[1],A[2]);
    vertex(A[0],A[1],A[2], A[3], A[4]);
    normal(B[0],B[1],B[2]);
    vertex(B[0],B[1],B[2], B[3], B[4]);
    endShape();
  }
  
  
}
