import processing.pdf.*;

Parser parser;

void setup(){
  size(800,450);

  textFont(createFont("Semplice Regular",8,false));

  parser = new Parser("xnee.xns");

}

boolean rec = false;

void mousePressed(){
  rec = true;
}

void draw(){
  background(255);
  
  if(rec)
  beginRecord(PDF, "out.pdf");

  parser.hid();
  parser.draw();

  if(rec){
  endRecord();
    rec = false;
  }
}

class Parser{
  int carret = 0;
  String raw[];
  String filename;
  ArrayList actions;
  int w=1600,h=900;
  String machine,version,display;
  String date,time;
  ArrayList types;

  int replayTime = 0;

  int minTime=999999999,maxTime=-1,relTime=0,runTime;

  int dataOffset,dataLength;

  Parser(String _filename){
    filename = _filename;
    raw = loadStrings(filename);
    println("\n#################################################\n# xnee 3.19 parser, opening file "+filename+"\n#################################################\n");

    parse();
  }

  void hid(){
    String messag[] = {"Date:","Time:","Version:","Machine:","Display:","Width:","Height:","Time:"};
    String info[] = {date,time,version,machine,display,w+"",h+"",replayTime+""};
    fill(0);
    for(int i = 0 ; i < info.length;i++)
      text(messag[i]+" "+info[i],10,i*9+10);
  }

  void draw(){
    replayTime=millis()-runTime;

    if(replayTime>relTime)
      runTime = millis();

    PVector lastpos = new PVector(width/2,height/2);
    carret = 0;

    noFill();
    stroke(0,100);

    //draw mousemoves
    beginShape();
    for(int i = 0 ; i < actions.size();i++){
      Action tmp = (Action)actions.get(i);
      if(replayTime>tmp.time){
        if(tmp.type==0){
          vertex(tmp.pos.x,tmp.pos.y);
          lastpos = new PVector(tmp.pos.x,tmp.pos.y);
        }


      }
    }
    endShape();

    types = new ArrayList();
    types.add(new TypeText("",new PVector(width/2,10),minTime,0));

    //draw mousepresses
    fill(0,90);
    noStroke(); 
    for(int i = 0 ; i < actions.size();i++){
      Action tmp = (Action)actions.get(i);
      if(replayTime>tmp.time){

        if(tmp.type==1){
          ellipse(tmp.pos.x,tmp.pos.y,50,50);
          lastpos = new PVector(tmp.pos.x,tmp.pos.y);
          types.add(new TypeText("",lastpos,tmp.time,types.size()-1));
        }

        if(tmp.type==2){
          TypeText tt = (TypeText)types.get(types.size()-1);
          tt.addString(tmp.key+"");
        }
      }
    }

    fill(0);
    for(int i = 0; i < types.size();i++){
      TypeText tt = (TypeText)types.get(i);
      if(replayTime>tt.time){
        text(tt.text,tt.pos.x,tt.pos.y);
      }

    }

    /*
       for(int i = 0; i < types.size();i++){
       String s = (String)types.get(i);
       text(s,width-400,i*9+10);
       }
     */

  }

  void parse(){

    date = getInfo(3);
    time = getInfo(4);
    version = getInfo(6);
    machine = getInfo(18);
    display = getInfo(21);

    // WTF?
    // w = parseInt(splitTokens(getInfo(22),"x")[0]);
    // h = parseInt(splitTokens(getInfo(22),"x")[1]);

    dataOffset = getDataOffset();
    println("dataOffset: "+dataOffset);

    parseData();

    relTime = (maxTime-minTime);

    println("dataLength: "+dataLength);
    println("minTime: "+minTime);
    println("maxTime: "+maxTime);
    println("duratin: "+relTime);
  }

  void parseData(){
    actions = new ArrayList();

    PVector last = new PVector(0,0);
    PVector lastClick = new PVector(0,0);
    for(int i = dataOffset ; i < raw.length;i++ ){
      //detect mouse move
      if(raw[i].charAt(0)=='7' && raw[i].charAt(2)=='6'){
        int time = parseInt(splitTokens(raw[i],",")[7]);
        int posx = parseInt(splitTokens(raw[i],",")[2]);
        int posy = parseInt(splitTokens(raw[i],",")[3]);
        PVector tmp = new PVector(posx,posy);
        last = new PVector(posx,posy);
        actions.add(new Action(time,tmp,this));

      }

      // detect mousepresses
      if(raw[i].charAt(0)=='7' && raw[i].charAt(2)=='4'){
        int time = parseInt(splitTokens(raw[i],",")[7]);
        float posx = last.x;
        float posy = last.y;
        PVector tmp = new PVector(posx,posy);
        lastClick = new PVector(posx,posy);
        actions.add(new Action(time,tmp,true,this));

      }

      //detect keydown
      if(raw[i].charAt(0)=='7' && raw[i].charAt(2)=='3'){
        int time = parseInt(splitTokens(raw[i],",")[7]);
        int cc = parseInt(splitTokens(raw[i],",")[5]);
        String ch = charMap(cc);

        actions.add(new Action(time,ch,lastClick,this));

      }



    }


    dataLength = actions.size();
    for(int i = 0 ;i <dataLength;i++){
      Action tmp = (Action)actions.get(i);
      tmp.timeOffset();
    }

  }


  String getInfo(int ln){
    String result = "";
    int n = raw[ln].length() - raw[ln].replace(":","").length()+1;
    String tmp[] = splitTokens(raw[ln],":");

    String prep = "";
    for(int i = 1 ; i < n;i++){
      if(i<n-1)
        prep+=tmp[i]+":";
      else
        prep+=tmp[i];


    }

    tmp = splitTokens(prep," ");

    for(int i = 0;i<tmp.length;i++){
      result += tmp[i]+" ";
    }

    return result;

  }

  int getDataOffset(){
    int result = -1;
    int occ = 0;

search:
    for(int i = 0 ; i < raw.length;i++){
      if(occ==1){
        result = i+1;
        break search;
      }      
      if(raw[i].indexOf("error-range")>-1){
        occ++;
      }
    }
    return result;
  }

}

// type 0=mouse,1=click,2=key

class Action{
  Parser parent;
  int time;
  int type;
  PVector pos;
  String key;
  boolean click;
  int typeId=0;

  //mousemove
  Action(int _time,PVector _pos,Parser _parent){
    parent = _parent;
    time = _time;
    pos = new PVector(map(_pos.x,0,parent.w,0,width),map(_pos.y,0,parent.h,0,height));
    type = 0;

    parent.minTime = min(parent.minTime,time);
    parent.maxTime = max(parent.maxTime,time);
  }

  //mousepress
  Action(int _time,PVector _pos,boolean _click,Parser _parent){
    parent = _parent;
    time = _time;
    pos = new PVector(map(_pos.x,0,parent.w,0,width),map(_pos.y,0,parent.h,0,height));
    click = true;
    type = 1;

    parent.minTime = min(parent.minTime,time);
    parent.maxTime = max(parent.maxTime,time);
  }

  //keydown
  Action(int _time,String _key,PVector _pos,Parser _parent){
    parent = _parent;
    time = _time;
    key = _key;
    type = 2;

    pos = new PVector(map(_pos.x,0,parent.w,0,width),map(_pos.y,0,parent.h,0,height));

    parent.minTime = min(parent.minTime,time);
    parent.maxTime = max(parent.maxTime,time);
  }

  void timeOffset(){
    time = time-parent.minTime;
  }
}


class TypeText{
  String text;
  PVector pos;
  int time;
  int id;

  TypeText(String _in,PVector _pos,int _time,int _id){
    text = "";

    pos = new PVector(_pos.x,_pos.y);

    id = _id;
    time = _time;
  }

  void addString(String _in){
    text += _in;
  }
}

//////////////////////////////////////////////////////
String charMap(int key){
  String result = "~";
  
  switch(key){
    case 38:
      result= "a";
      break;
    case 56:
      result= "b";
      break;
    case 54:
      result= "c";
      break;
    case 40:
      result= "d";
      break;
    case 26:
      result= "e";
      break;
    case 41:
      result= "f";
      break;
    case 42:
      result= "g";
      break;
    case 43:
      result= "h";
      break;
    case 31:
      result= "i";
      break;
    case 44:
      result= "j";
      break;
    case 45:
      result= "k";
      break;
    case 46:
      result= "l";
      break;
    case 58:
      result= "m";
      break;
    case 57:
      result= "n";
      break;
    case 32:
      result= "o";
      break;
    case 33:
      result= "p";
      break;
    case 24:
      result= "q";
      break;
    case 27:
      result= "r";
      break;
    case 39:
      result= "s";
      break;
    case 28:
      result= "t";
      break;
    case 30:
      result= "u";
      break;
    case 55:
      result= "v";
      break;
    case 25:
      result= "w";
      break;
    case 53:
      result= "x";
      break;
    case 29:
      result= "y";
      break;
    case 52:
      result= "z";
      break;

    case 10:
      result= "1";
      break;

    case 11:
      result= "2";
      break;

    case 12:
      result= "3";
      break;

    case 13:
      result= "4";
      break;

    case 14:
      result= "5";
      break;

    case 15:
      result= "6";
      break;

    case 16:
      result= "7";
      break;

    case 17:
      result= "8";
      break;

    case 18:
      result= "9";
      break;

    case 19:
      result= "0";
      break;

    case 20:
      result= "-";
      break;

    case 21:
      result= "=";
      break;
      /////////////////////////// FUN KEYS
    case 67:
      result= "<F1>";
      break;
    case 68:
      result= "<F2>";
      break;
    case 69:
      result= "<F3>";
      break;
    case 70:
      result= "<F4>";
      break;
    case 71:
      result= "<F5>";
      break;
    case 72:
      result= "<F6>";
      break;
    case 73:
      result= "<F7>";
      break;
    case 74:
      result= "<F8>";
      break;
    case 75:
      result= "<F9>";
      break;
    case 76:
      result= "<F10>";
      break;
    case 95:
      result= "<F11>";
      break;
    case 96:
      result= "<F12>";
      break;
///////////////////////////// specials
  case 65:
      result= " ";
      break;
    case 113:
      result= "<L-ARROW>";
      break;
    case 114:
      result= "<R-ARROW>";
      break;
    case 111:
      result= "<UP-ARROW>";
      break;
    case 116:
      result= "<DOWN-ARROW>";
      break;

      case 36:
      result="\n";
      break;
      
      case 23:
      result="<TAB>";
      break;
  }
  
  println("key: "+key+" mapped to "+result);

  return result;
}

