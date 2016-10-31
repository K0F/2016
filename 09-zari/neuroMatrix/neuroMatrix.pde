
int NUM = 100;
int MAT_DIM = 16;
ArrayList en;


void setup(){
  size(512,512);
  en = new ArrayList();
  for(int i = 0 ; i < NUM;i++)
    en.add(new Engine(i));
}

void draw(){

  background(0);

  for(int i = 0 ; i < NUM;i++)
  {
    Engine tmp= (Engine)en.get(i);
    tmp.draw();
  }


}


class Engine{
  int id;
  float mat[];
  PVector pos;
  PGraphics img;
  int sel = 0;

  Engine(int _id){
    id = _id;
    mat = new float[MAT_DIM*MAT_DIM];
    for(int y = 0 ; y < mat.length;y++){
      mat[y] = random(0,100)/100.0;
    }

    img = createGraphics(MAT_DIM,MAT_DIM);
    pos = new PVector(random(100)/100.0,random(100)/100.0);
  }

  void viz(){
    img.beginDraw();
    for(int i = 0 ; i < mat.length;i++){
      img.stroke(mat[i]*255);
      img.point(i%MAT_DIM,(int)(i/(MAT_DIM+0.0)));
    }
    img.endDraw();
  }

  void move(){
    for(int i = 0 ; i < en.size();i++){
      if(i!=id){
        Engine beta = (Engine)en.get(i);
        float d = dist(beta.pos.x,beta.pos.y,pos.x,pos.y);
        for(int ii = 0 ; ii < mat.length;ii++){
          
          if(d>0.5){
          mat[ii] += (beta.mat[ii]-mat[ii])/((d+1.0)*1000.0);
   shift(); 
          }else{
          mat[ii] -= (beta.mat[ii]-mat[ii])/((d+1.0)*1000.0);
         }
        } 
      }
    }
    pos.x += (mat[0]-pos.x)/10.0;
    pos.y += (mat[1]-pos.y)/10.0;
    
    pos.x = constrain(pos.x,0,1);
    pos.y = constrain(pos.y,0,1);
  }

  void shift(){
      mat[mat.length-1] = mat[0];

        for(int ii = 1 ; ii < mat.length;ii++){
          mat[ii-1] = mat[ii];
      }
  }


  void draw(){

    move(); 
    viz();
    image(img,pos.x*width,pos.y*height);
  }
}
