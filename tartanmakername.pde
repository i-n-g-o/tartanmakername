/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/25876*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
// random tartan maker
// steven kay, 2011
// modified for name encoded woolpunk tartans by ingo randolf @ etextile-summercamp, 2016 

// use an array to "scrable" the name
int[] gaelicNumber=new int[]{18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1};

color[] palette=new color[]{  
  color(0,120,255),
  color(127,127,127),
  color(236,160,72),
  color(45,155,25),
  color(160,136,90),
  color(92,146,190),
  color(218,165,32),
  color(250,90,50),
  color(0,105,25),
  color(125,0,125)
};

Tartan t;
int zoom=1;

int tartanWidth = 0;
int tartanHeight = 0;

// set the name to encode
String name1 = "balfor";
String name2 = "clobair";


void setup() {   
  background(0);
  size(10,10);
  surface.setResizable(true);  
  
  t = createTartan();
}


 void draw() {  
   
  surface.setSize(tartanWidth*zoom, tartanHeight*zoom);
   
  noStroke();
  
  for (int y=0;y<tartanHeight;y++) {
    for (int x=0;x<tartanWidth;x++) {
      fill(t.getColorAt(x,y));
      rect(x*zoom,y*zoom,zoom,zoom);
    }
  }
}

Tartan createTartan() {
  // tartans use gaelic alphabet by default
  // use Tartan.setGaelic(false) or new Tartan(false)
  // to use latin alphabet
  Tartan nt = new Tartan();
  
  // use a table to scramble the name
  nt.setGaelicEncoding(gaelicNumber);
  
  // set a more coloreful palette
  //nt.setPalette(palette);  
    
  // create pattern with 2 names
  // name1 horizontally
  // name2 vertically 
  nt.createPattern(name1, name2);

  // get the size of the pattern
  tartanWidth = nt.getPatternSize()*2;
  tartanHeight = nt.getPatternSizeV()*2;
  
  return nt;
}


void keyPressed() {
  
  if (key=='s') {
    // save a file
    save("../" + year() + "_" + month() + "_" + day() + "-" + 
          hour( ) +"_" + minute() + "_" + second() + "-tartan.png");
  } else if (key==' ') {
    // create a new tartan (with new color)
    t=createTartan();
  } 
  
  redraw();
}