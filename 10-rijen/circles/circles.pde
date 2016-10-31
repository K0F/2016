
int NUM = 5000;
float DIA = 200;
int SEG = 256;
float SYMM = 2;
float ALPHA = 35.0;

ArrayList circles;

void setup(){
  size(1280,720,OPENGL);
  
  noiseSeed(2016);

  circles = new ArrayList();
  for(int i = 0 ; i < NUM; i++){
    Circle tmp = new Circle(sin(i/5000.0)*10.0,sin(i/5000.1)*10.0,sin(i/5000.21)*10.0,DIA,SEG,i);
    circles.add(tmp);  

  }
}



void draw(){

  background(5,9,13,120);

  pushMatrix();
  translate(width/2,height/2);
  //rotateX(frameCount/1000.0);
  rotateY(frameCount/101.0);
  for(int i = 0 ; i < NUM; i++){
    Circle tmp = (Circle)circles.get(i);
    tmp.draw();

  }
  popMatrix();

  for(int i = 0 ; i < NUM; i++){
    Circle tmp = (Circle)circles.get(i);

    tmp.seg = (int)(pow((sin(frameCount/201.0)+1.3)/2.0 ,1.15) * SEG)+1;
    tmp.setRot(
        sin((i+frameCount) / 501.0),
        sin((i+frameCount) / 100.0),
        sin((i+frameCount) / 200.1),
        pow(noise((i/100.0+frameCount) / 3000.0,0),0.71)*1.0);
    tmp.dia = pow(noise(0,(i+frameCount)/1000.0+(i/10001.0)),0.85)*250.0;
  }

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

  void setRot(float x,float y,float z,float scalar){
    rot = new PVector(x,y,z);
    rot.mult(scalar);
  }

  void draw(){

    pushMatrix();
    rotateX(rot.x*frameCount/1000.0);
    rotateY(rot.y*frameCount/1000.0);
    rotateZ(rot.z*frameCount/1000.0);
    float lf = -PI-(TWO_PI/(seg+0.0));
    int cnt = 0;
    int div = (int)(seg/SYMM);
    for(float f = -PI ; f < PI ; f+=(TWO_PI/(seg+0.0))){
      if(((cnt+sel)%seg)%div==0  ){
        stroke(#ffeeaa,ALPHA);
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
