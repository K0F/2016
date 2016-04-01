/*
Coded by Kof @ 
Thu Jan 23 05:11:48 CET 2014



   ,dPYb,                  ,dPYb,
   IP'`Yb                  IP'`Yb
   I8  8I                  I8  8I
   I8  8bgg,               I8  8'
   I8 dP" "8    ,ggggg,    I8 dP
   I8d8bggP"   dP"  "Y8ggg I8dP
   I8P' "Yb,  i8'    ,8I   I8P
  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
  88P      Y8P"Y8888P"    PI8"8888
                           I8 `8,
                           I8  `8,
                           I8   8I
                           I8   8I
                           I8, ,8'
                            "Y8P'

                            
*/

import java.io.*;

String FILENAME = "text.txt";
String SPLIT_TOKENS = " []<>()\"";
boolean DEBUG = false;
boolean done = true;
float VOICE_WPM = 140.0; 

String text[];
String raw;
ArrayList words;
ArrayList nodes;

Node walker;
String result = "";
ArrayList output;

int pause = 100;
int speed = 2;

int first = 0;

void setup(){

  size(480,320);

  nodes = new ArrayList();

  initialize();

  textFont(loadFont("SempliceRegular-8.vlw"));

  while(nodes.size()<100){
    delay(100);
  }

  walker = (Node)nodes.get((int)random(nodes.size()));
  output = new ArrayList();
  output.add(walker.word);
}

void initialize(){
  getWords();
  castNodes();
  makeConnections();
}


void draw(){


  if(first>1){
    delay(200);
    String tmp = "";
    for(int i = 0;i<=first;i++){
      tmp+=(String)output.get(i)+" ";
    }

    //  verlaine.mluv(tmp);

    if(done)
    execute("echo '"+tmp+"' | festival --tts");

    for(int i = first ; i >= 0;i--){
      output.remove(i);
    }
  } 


  walker = walker.pickNext();
  result += walker.word+" ";
  output.add(walker.word);

  background(0);

  int x = 10, y = height/2-20;
  int c = 0;


  first = 0;
  for(Object a: output){
    String curr = (String)a;
    text(curr,x,y);

    float off = textWidth(curr+" ");
    x += (int)off;

    if(curr.indexOf(".")>-1||
        curr.indexOf("!")>-1||curr.indexOf("?")>-1)
      first = c;

    if(x>=width-20-off){

      x=10;
      y+=10;

    }
    c++;

  }
}

class Node{
  ArrayList next;
  ArrayList positions;
  ArrayList choices;
  int id;
  float weights[];
  String word;

  Node(String _word){
    choices = new ArrayList();
    next = new ArrayList();
    word = _word;
  }

  Node pickNext(){
    try{
      Node tmp = (Node)next.get((int)random(next.size()));

      while(tmp==null||tmp==this){
        tmp = (Node)next.get((int)random(next.size()));
      }

      return tmp;
    }catch(Exception e){

      Node tmp = (Node)next.get((int)random(next.size()));
      while(tmp==null||tmp==this){
        tmp = (Node)next.get((int)random(next.size()));
      }
      return tmp;
    }
  }

  void addConnection(Node _n){
    if(DEBUG)
      println(word+ " is searching for: "+_n.word);
    next.add(_n);
  }




  void addConnection(String _in){
    if(DEBUG)
      println(word+ " is searching for: "+_in);
    int test = 0;
search:
    for(Object tmp: nodes){
      Node n = (Node)tmp; 
      if(n.word.equals(_in)){
        test = nodes.indexOf(n);
        Node newNode = (Node)nodes.get(test);
        next.add(newNode);
        break search;
      }
    }
  }

  void printConnections(){
    if(DEBUG)
      print(word+" -> ");
    for(Object tmp: next){
      Node n = (Node)tmp;
      if(DEBUG)
        print(n.word+", ");

    }
    if(DEBUG)
      println(next.size());
  }
}

void printAllConnections(){

  for(Object tmp: nodes){
    Node n = (Node)tmp;
    n.printConnections();
  }
}


void castNodes(){
  nodes = new ArrayList();
  for(Object w: words){
    String wtmp = (String)w;
    boolean has = false;

check:
    for(Object n: nodes){
      Node ntmp = (Node)n;
      if(wtmp.equals(ntmp.word)){
        has=true;
        break check;
      }
    }

    if(!has)
      nodes.add(new Node(wtmp));
  }

}

void makeConnections(){
  for(int i = 0 ; i < words.size()-1;i++){
    String current = (String)words.get(i);
    String next = (String)words.get(i+1);

    Node curr = getNode(current);
    Node nxt = getNode(next);

    curr.addConnection(nxt);

  }
}

Node getNode(String _in){
  Node out = null;
  for(Object n: nodes){
    Node tmp = (Node)n;  
    if(tmp.word.equals(_in)){
      out = tmp;
    }
  }
  return out;

}

void getWords(){


  text = loadStrings(FILENAME);
  words = new ArrayList();
  raw = "";

  for(int i = 0 ;i < text.length;i++){
    String tmp[] = splitTokens(text[i],SPLIT_TOKENS);
    for(int ii = 0 ; ii < tmp.length;ii++){
      raw += tmp[ii]+" ";
      words.add(tmp[ii]+"");

    }
  }
}


////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

void execute(String _in){
  done = false;
  Runnable runnable = new Executer(_in);
  Thread thread = new Thread(runnable);
  thread.start();
}

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

class Executer implements Runnable{
  String command;

  Executer(String _command){
    command = _command;
  }

  void run(){

    String s = null;

    try{

      Runtime runtime = Runtime.getRuntime();

      String cmd[] = {"/bin/sh","-c",command};
      String env[] = {"PATH=/bin/:/usr/bin/:/usr/local/bin/","DISPLAY=:0.0","SHELL=/bin/bash","USER=kof"};

      Process p = runtime.exec(cmd);

      BufferedReader stdInput = new BufferedReader(new
          InputStreamReader(p.getInputStream()));

      BufferedReader stdError = new BufferedReader(new
          InputStreamReader(p.getErrorStream()));

      // read the output from the command
      //System.out.println("Here is the standard output of the command:\n");
      while ((s = stdInput.readLine()) != null) {
        System.out.println(s);
      }

      // read any errors from the attempted command
      //System.out.println("Here is the standard error of the command (if any):\n");
      while ((s = stdError.readLine()) != null) {
        System.out.println(s);
      }

      done = true;

    }
    catch (IOException e) {
      System.out.println("exception happened - here's what I know: ");
      e.printStackTrace();
    }
  }
}


