/*
   Optosonic transoder
   Copyright (C) 2015 Krystof Pesek

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, see <http://www.gnu.org/licenses/>.

 */


////////////////////////
float UROVNE[] = {0.001 ,0.1 };
boolean printing = false;
int width = 1181;
int height = 1535;
////////////////////////

void setup()
{
  size(1181,1535,P2D);
  frameRate(60);
}

void draw(){
  fill(255,35);
  noStroke();
  rect(0,0,width,height);

  if(printing){
    printFrame(true);
    printing = false;
  }
}

void keyPressed(){
  if(key==' '){
    println("printing..");
    printing = true;
  }
}

