import processing.pdf.*;

int h = 428*2+200;
int w = 287*2;

int res = 4;

int rs[] = {255,255,0,0,73,40};
int gs[] = {255,72,176,57,64,52,40};
int bs[] = {0,176,57,191,115,40};

color col[];


void setup(){
  size(w,h,OPENGL);
  noiseSeed(2016);
  col = new color[rs.length];
  for(int i = 0 ; i < rs.length;i++){
    col[i] = color(rs[i],gs[i],bs[i]);

  }


  ortho();

}

ArrayList lines;
int pcnt = 1;

int b = 100;
float f = 0;
void draw(){
  background(255);
  lines = new ArrayList(); 

  noFill();
  stroke(col[2],55);
  int lin = 0;
  float cnt = 0;

  pushMatrix();
  translate(width/2,height/2,0);

  rotateX(PI/4+(frameCount/1000.0));
  rotateZ(PI/5+(frameCount/1001.0));

  for(int z = -b*4;z<b*4;z+=res*16){
    for(int y = -b ; y < b; y+=res){

      lines.add(new Line());
      Line current = (Line)(lines.get(lines.size()-1));
      beginShape();
      int x= -b;
      float d = pow(noise((x+b)/80.0,(y+b)/80.0,(z+b*4)/400.0+f)+1,8.35)*(-1.0);
      //if(y==-b)
      //current.addPoint(screenX(x+10000,y,z+d),screenY(x+10000,y,z+d));
      for(x = -b ; x < b ; x+=res){
        d = pow(noise((x+b)/80.0,(y+b)/80.0,(z+b*4)/400.0+f)+1,8.35)*(-1.0);
        strokeWeight(map(y,-b,b,1,4));
        vertex(x,y,z+d);
        current.addPoint(screenX(x,y,z+d),screenY(x,y,z+d));

        lin++;
      }

      if(y==-b)
      current.addPoint(screenX(x-10000,y,z+d),screenY(x-10000,y,z+d));
      endShape();
    }
  }

  popMatrix();
  f+=0.01;

  if(frameCount%100==0)
    render();

}


void render(){
  beginRecord(PDF,"out_u"+nf(pcnt,2)+".pdf");
  pcnt++;
  noFill();
  int cnt =0;
  for(int i = 0; i< lines.size();i++){
    Line ln = (Line)lines.get(i);
    beginShape();
    for(int ii = 0 ; ii < ln.points.size();ii++){
      PVector tmp = ln.getPoint(ii);
      strokeWeight(map(i,0,lines.size(),4,1));
      stroke(col[4],map(i,0,lines.size(),127,12));
      curveVertex(tmp.x,tmp.y);
    }
    endShape();
    cnt++;
  }
  endRecord();
}

class Line{
  ArrayList points;
  Line(){
    points = new ArrayList();
  }

  void addPoint(float _x,float _y){
    points.add(new PVector(_x,_y));
  }

  PVector getPoint(int i){
    return (PVector)points.get(i);
  }

  int size(){
    return points.size();
  }
}
