

String words[] = {
  "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
};

ArrayList keywords;


void setup(){
  size(320,320);

  keywords = new ArrayList();

  for(int i = 0 ; i < words.length;i++){
    for(int ii = 0 ; ii < words.length;ii++){
      for(int iii = 0 ; iii < words.length;iii++){
        for(int iiii = 0 ; iiii < words.length;iiii++){
          for(int iiiii = 0 ; iiiii < words.length;iiiii++){
            for(int iiiiii = 0 ; iiiiii < words.length;iiiiii++){
              for(int iiiiiii = 0 ; iiiiiii < words.length;iiiiiii ++){
                for(int iiiiiiii = 0 ; iiiiiiii  < words.length;iiiiiiii ++){
                  //keywords.add(words[i]+words[ii]+words[iii]+words[iiii]+words[iiiii]+words[iiiiii]+words[iiiiiii]+words[iiiiiiii]);
                  println(words[i]+words[ii]+words[iii]+words[iiii]+words[iiiii]+words[iiiiii]+words[iiiiiii]+words[iiiiiiii]+"");
                }
              }
            }
          }
        }
      }
    }
  }
/*
println(keywords.size());
String [] tmp = new String[keywords.size()];
for(int i = 0 ; i < tmp.length;i++){
  tmp[i] = (String)keywords.get(i);
}
saveStrings("/tmp/generated.txt",tmp);
//exit();
*/
}
