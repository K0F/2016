
int NUM = 5000;
float DIA = 200;
int SEG = 128;

ArrayList circles;

void setup(){
  size(1280,720,OPENGL);

  circles = new ArrayList();
  for(int i = 0 ; i < NUM; i++){
    Circle tmp = new Circle(sin(i/10.0),sin(i/10.01),sin(i/10.021),DIA,SEG,i);
    circles.add(tmp);  

  }
}



void draw(){

  background(5,9,13);

pushMatrix();
translate(width/2,height/2);
 for(int i = 0 ; i < NUM; i++){
    Circle tmp = (Circle)circles.get(i);
    tmp.draw();

  }
  popMatrix();

}





class Circle{
  PVector rot;
  float dia;
  int seg;
  int id;
  int sel = 0;

  Circle(float x, float y, float z,float _dia,int _seg,int _id){
    rot = new PVector(x,y,z);
    dia = _dia;
    seg = _seg;
    id = _id;
  }

  void draw(){

    pushMatrix();
    rotateX(rot.x*frameCount/1000.0);
    rotateY(rot.y*frameCount/1000.0);
    rotateZ(rot.z*frameCount/1000.0);
    float lf = -PI-(TWO_PI/(seg+0.0));
    int cnt = 0;
    for(float f = -PI ; f < PI ; f+=(TWO_PI/(seg+0.0))){
    
    if(cnt==sel){
    stroke(255,90);
      line(cos(f)*dia,sin(f)*dia,cos(lf)*dia,sin(lf)*dia);
   } else{
   // stroke(#ffcc00,constrain(abs(tan(f)+1.0)*12,0,24));
      
      }
      lf=f;
      cnt++;
    }
    popMatrix();

    sel+=1;
    if(sel>seg)
    sel=0;
  }



}
