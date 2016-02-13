
String filename = "160206_berlin_recover.scd.scd";

float time = 0;
ArrayList players;

String plnames[] = {"kof,joach,alex"};

String [] raw;

void setup(){
  size(1280,720);

  createFont("Semplice Regular",8);

  raw = loadStrings(filename);
  players = new ArrayList();
  for(int i = 0 ; i < plnames.length;i++)
    players.add(new Player(filename,plnames[i],i));
}





void draw(){

  background(0);
  /*
     for(int i = 0 ; i < players.size();i++){
     Player p = (Player)players.get(i);
     p.draw();
     }
   */




}

class Parser{

  String raw;
  int level = 0;
  Player parent;

  Parser(Player _parent,String [] _raw){
    parent = _parent;
    raw = "";
    for(int i = 0 ; i < _raw.length;i++){
      raw += _raw[i];
    }
    parse();
  }

  void parse(){
    int lastlevel = level;
    int offset = 0;
    for(int i = 0 ; i < raw.length();i++){
      lastlevel = level;

      if(raw.charAt(i)=='['){
        level++;
        offset = i;
      }

      if(raw.charAt(i)==']'){
        level--;
        if(level==1){
          String tmp = raw.substring(offset,i);
          println(raw.substring(offset+1,i));
          String split[] = splitTokens(tmp," ,\t");
         try{ 
          float timecode = parseFloat(split[0]);
          String name = split[1];
          String code = "";
          println(timecode+" "+name);

         try{ 
          for(int ii = 2 ;ii < split.length;ii++){
            code+=split[i];
          }



          if(name.equals(parent.name))
            parent.execs.add(new Exec(time,code));
         
          level = 1;
          }catch(Exception e){
          println("weird error");
          }
          }catch(Exception e){
          println("weird error2");
          }
        }
      }


    }
  }
}

class Player{
  Parser parser;
  int id;
  String name;
  String filename;
  ArrayList execs;

  Player(String _filename,String _name,int _id){
    filename = _filename;
    name = _name;
    id = _id;

    execs = new ArrayList();

    parser = new Parser(this,raw);
  }
}

class Exec{
  float time;
  String raw;
  Player parent;

  Exec(float _time, String _raw){
    time=time;
    raw=_raw+"";
  }

}
