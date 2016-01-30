

Parser parser;

void setup(){
  size(800,450);

  textFont(createFont("Semplice Regular",8,false));

  parser = new Parser("xnee.xns");

}

void draw(){
  background(255);

  parser.hid();
}

class Parser{
  String raw[];
  String filename;
  ArrayList actions;
  int w=1600,h=900;
  String machine,version,display;
  String date,time;

  int dataOffset,dataLength;

  Parser(String _filename){
    filename = _filename;
    raw = loadStrings(filename);
    parse();
  }

  void hid(){
    String messag[] = {"Date:","Time:","Version:","Machine:","Display:","Width:","Height:"};
    String info[] = {date,time,version,machine,display,w+"",h+""};
    fill(0);
    for(int i = 0 ; i < info.length;i++)
      text(messag[i]+" "+info[i],10,i*9+10);
  }

  void parse(){

    date = getInfo(3);
    time = getInfo(4);
    version = getInfo(6);
    machine = getInfo(18);
    display = getInfo(21);

    w = parseInt(splitTokens(getInfo(22),"x")[0]);
    h = parseInt(splitTokens(getInfo(22),"x")[1]);

    dataOffset = getDataOffset();
    println("dataOffset: "+dataOffset);

    parseData();

    println("dataLength: "+dataLength);

  }

  void parseData(){
    actions = new ArrayList();

    for(int i = dataOffset ; i < raw.length;i++ ){
      //detect mouse move
      if(raw[i].charAt(0)=='7' && raw[i].charAt(2)=='6'){
        int time = parseInt(splitTokens(raw[i],",")[7]);
        int posx = parseInt(splitTokens(raw[i],",")[2]);
        int posy = parseInt(splitTokens(raw[i],",")[3]);
        PVector tmp = new PVector(posx,posy);
        actions.add(new Action(time,tmp));

      }
    }

    dataLength = actions.size();

  }


  String getInfo(int ln){
    String result = "";
    int n = raw[ln].length() - raw[ln].replace(":","").length()+1;
    String tmp[] = splitTokens(raw[ln],":");

    String prep = "";
    println(ln+" "+ raw[ln] +" "+n);
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

// type 0=mouse,1=key

class Action{
  int time;
  int type;
  PVector pos;
  char key;

  Action(int _time,PVector _pos){
    time = _time;
    pos = new PVector(_pos.x,_pos.y);
    type = 0;
  }

  Action(int _time,char _key){
    time = _time;
    key = _key;
    type = 1;
  }


}
