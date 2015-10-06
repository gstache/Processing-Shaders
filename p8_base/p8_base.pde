/**
* Vertex manipulations:
* Mountain Shader: card0.vert,
* wiggle: card1.vert, 
* position bump: card2.vert, 
*fragment shaders
* color threshold: card3.frag
* edge detection: card4.frag
* no-green desaturation: card1.frag
*/
//Declare global variables
PImage texture;
PShader floorShader;
ArrayList<PShader> shaders;
int activeShader = 0;

float offsetY;
float offsetX;
float zoom;
boolean locked = false;
float dirY = 0;
float dirX = 0;
int frame = 0;
boolean first = true;
float time = 0;

boolean output = false;

//initialize variables and load shaders
void setup() {
  size(640, 640, P3D);
  offsetX = width/2;
  offsetY = height/2;
  noStroke();
  fill(204);
  
  shaders = new ArrayList<PShader>();
  shaders.add(loadShader("data/card0.frag", "data/card0.vert")); //diffuse
  shaders.add(loadShader("data/card1.frag", "data/card1.vert")); //checkerboard
  shaders.add(loadShader("data/card2.frag", "data/card2.vert")); //jiggle
  shaders.add(loadShader("data/card3.frag", "data/card3.vert")); //blur
  shaders.add(loadShader("data/card4.frag", "data/card4.vert")); //thresholding
  floorShader = loadShader("data/floor.frag", "data/floor.vert");
  
  texture = loadImage("data/alex.jpg");
}

void draw() {
  
  background(0); 
  
  //create a single directional light
  directionalLight(204, 204, 204, 0, 0, -1);
  
  //translate and rotate all objects to simulate a camera
  //NOTE: processing +y points DOWN
  translate(offsetX, offsetY, zoom);
  rotateY(-dirX);
  rotateX(dirY);
  
  //Render a floor plane with the default shader
  shader(floorShader);
  fill(204);
  beginShape();
    vertex(-300, 300, -400);
    vertex( 300, 300, -400);
    vertex( 300, 300,  200);
    vertex(-300, 300,  200);
  endShape();
  
  //Render the "Swiss Cheese" shader (card1)
  shader(shaders.get(activeShader));
  shaders.get(activeShader).set("time", time);
  float seg = 1.0/50.0;
  shaders.get(activeShader).set("seg", seg);
  textureMode(NORMAL);
  //fill(color(256,10,10));
  PVector v1 = new PVector(-200,  -100,  -100);
  PVector tx1 = new PVector(0,0);
  PVector v2 = new PVector(200,  -100,  -100);
  PVector tx2 = new PVector(1,0);
  PVector v3 = new PVector(200,  300,  -100);
  PVector tx3 = new PVector(1,1);
  PVector v4 = new PVector(-200,  300,  -100);
  PVector tx4 = new PVector(0,1);
  println(mouseX+", "+mouseY);
  
  beginShape(QUADS);
    texture(texture);
    for (int i = 0; i < (int)(1/seg); i++){
       
      float t = float(i)*(seg);
      PVector v5 = PVector.lerp(v1, v4, t);
      PVector v6 = PVector.lerp(v2, v3, t);
      PVector v7 = PVector.lerp(v1, v4, t+(seg));
      PVector v8 = PVector.lerp(v2, v3, t+(seg));
      for (int j = 0; j < (int)(1/seg); j++) {
        float t2 = float(j)*(seg);
        PVector vt = PVector.lerp(v5,v6, t2);
        PVector vt2 = PVector.lerp(v5,v6, t2 + (seg));
        PVector vt3 = PVector.lerp(v7,v8, t2);
        PVector vt4 = PVector.lerp(v7,v8, t2 + (seg));     
        vertex(vt.x, vt.y,vt.z,t2, t);
        vertex(vt2.x , vt2.y, vt.z, t2 + (seg), t);
        vertex(vt4.x , vt4.y ,vt.z,t2 + (seg), t + (seg));
        vertex(vt3.x, vt3.y ,vt.z,t2, t + (seg));
      }
    }
   first = false;
  endShape();

  if(output){
    save("saves/cardScene"+frame+".png");
    frame++; 
  }
  
  time += 1.0 / frameRate;
}

void mouseDragged(){ 
  //control the scene rotation via the current mouse location
  if(mouseButton == LEFT){
    dirY -= ((mouseY-pmouseY) / float(height) );
    dirX -= ((mouseX-pmouseX) / float(width) ) ;
  }else if(mouseButton == RIGHT){
    //if the mouse is pressed, update the x and z camera locations
    offsetY += (mouseY - pmouseY);
    offsetX += (mouseX - pmouseX);
  } 
}

void keyPressed(){
  if(key == ' '){
    locked = !locked;
  }else if(key == '1'){
    texture = loadImage("data/alex.jpg");
  }else if(key == '2'){
    texture = loadImage("data/gradient.jpg");
  }else if(key == '3'){
    texture = loadImage("data/duck.bmp");
  }else if(key == 'v'){
    output = true;
  }else if(key == ']'){ //next
    activeShader = (activeShader+1)%shaders.size();
  }else if(key == '['){ //previous
    activeShader = (activeShader-1+shaders.size())%shaders.size();
  }
}

void keyReleased(){
  if(key == 'v'){
    output = false;
  }
}

void mouseWheel(MouseEvent event) {
  zoom += event.getAmount()*12.0;
}
