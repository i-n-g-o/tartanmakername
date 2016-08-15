class Tartan {

  // our alphabets  
  String[] gaelicAL=new String[]{"a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "r", "s", "t", "u"};
  String[] latinAL=new String[]{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};

  int[] gaelicEncTable = null;
  int[] latinEncTable = null;
     
  HashMap<String, Integer> gaelicLut=new HashMap<String, Integer>();
  HashMap<String, Integer> latinLut=new HashMap<String, Integer>();

  // default palette
  color[] palette=new color[]{
    color(0), // black
    color(255), // white
  };

  String firstName = "";
  String secondName = "";
  int[] warp;
  int[] weft;
  int totalwidth = 0;
  int rowtotalwidth = 0;
  boolean useGaelic = true;
  boolean enforceNewColor = true;


  Tartan() {
    this(true);
  }

  Tartan(boolean gaelic) {    
    useGaelic = gaelic;
    
    // create our lookup-tables
    createGaelicLut();
    createLatinLut();    
  }


  void createGaelicLut() {
    gaelicLut.clear();
    
    // space always has index 1
    gaelicLut.put(" ", 1);
    if (gaelicEncTable != null && gaelicEncTable.length >= 18) {
      // use the encoding table
      for (int i=0; i<gaelicEncTable.length; i++) {
        if (i >= gaelicAL.length) {
          break;
        }
        gaelicLut.put(gaelicAL[i], gaelicEncTable[i]+1);
      }
    } else {
      // number it from 1 .. length
      for (int i=0; i<gaelicAL.length; i++) {      
        gaelicLut.put(gaelicAL[i], i+2);
      }
    }
  }
  
  void createLatinLut() {
    latinLut.clear();
    
    // space always has index 1
    latinLut.put(" ", 1);
    if (latinEncTable != null && latinEncTable.length >= 26) {
      // use the encoding table
      for (int i=0; i<latinEncTable.length; i++) {
        if (i >= latinAL.length) {
          break;
        }
        latinLut.put(latinAL[i], latinEncTable[i]+1);
      }
    } else {
      // number it from 1 .. length
      for (int i=0; i<gaelicAL.length; i++) {      
        latinLut.put(latinAL[i], i+2);
      }
    }
  }
  
  void setGaelicEncoding(int[] table) {
    
    if (table != null) {
      for (int i=0; i<table.length; i++) {      
        if (table[i] <= 0) {
          //
          println("discarding table with index of <= 0");
          return;
        }
      }
    }
    
    if (table != null && table.length < 18) {
      println("discarding table with less than 18 entries");
      return;
    }
    
    gaelicEncTable = table;
    
    createGaelicLut();
  }
  
  void setLatinEncoding(int[] table) {
    
    if (table != null) {
      for (int i=0; i<table.length; i++) {      
        if (table[i] <= 0) {
          //
          println("discarding table with index of <= 0");
          return;
        }
      }
    }
    
    if (table != null && table.length < 26) {
      println("discarding table with less than 26 entries");
      return;
    }
    
    latinEncTable = table;
    
    createLatinLut();
  }

  void setPalette(color[] c) {
    palette = c;
  }

  // create the pattern with 2 names
  void createPattern(String name, String name2) {    
    
    // chace names
    firstName = name;
    secondName = name2;
    
    //--------------------------------------------
    // calculate columns
    int stripes=name.length();
    int lastcolor=0;
    
    for (int i=0; i<stripes; i++) {
      int w=getNum(name.toLowerCase().charAt(i));
      totalwidth+=w;
    }
    
    // make sure the pattern is horizontally repeatable
    // append as much spaces as it needs
    while ((totalwidth % 2)>0) {      
      totalwidth += getNum(' ');
      name += " ";
    }
    
    stripes=name.length();
    totalwidth=0;
    int[] stripewidths=new int[stripes];
    int[] stripecolors=new int[stripes];

    for (int i=0; i<stripes; i++) {
      int w=getNum(name.toLowerCase().charAt(i));
      
      print(w + " ");
      
      // select color (different from last color)
      int c=int(random(0, palette.length));
      if (enforceNewColor) {
        while (c==lastcolor) {
          c =int(random(0, palette.length));
        }
        lastcolor=c;
      }

      stripewidths[i] = w;
      stripecolors[i]=c;
      totalwidth+=w;      
    }
    println();
    

    //--------------------------------------------
    // calculate rows
    int rows=name2.length();    
    lastcolor=0;
    
    for (int i=0; i<rows; i++) {
      int w=getNum(name2.toLowerCase().charAt(i));
      rowtotalwidth+=w;
    }
    
    // make sure the pattern is repeatable vertically
    // append as much spaces as it needs
    while ((rowtotalwidth % 2)>0) {
      rowtotalwidth += getNum(' ');
      name2 += " ";
    }
    
    rows=name2.length();
    rowtotalwidth = 0;
    int[] rowwidths=new int[rows];
    int[] rowcolors=new int[rows];
    
    for (int i=0; i<rows; i++) {
      int w=getNum(name2.toLowerCase().charAt(i));
      
      print(w + " ");
      
      // select color (different from last color)
      int c=int(random(0, palette.length));
      if (enforceNewColor) {
        while (c==lastcolor) {
          c =int(random(0, palette.length));
        }
        lastcolor=c;
      }

      rowwidths[i] = w;
      rowcolors[i]=c;
      rowtotalwidth+=w;      
    }
    println();


    //--------------------------------------------
    // create warp
    warp=new int[totalwidth*2]; // warp threads run vertically   
    int pos=0;   
    for (int i=0; i<stripes; i++) {
      for (int j=0; j<stripewidths[i]; j++) {        
        warp[pos]=stripecolors[i];        
        warp[(totalwidth*2)-pos-1]=stripecolors[i]; // mirrored
        pos++;
      }
    }

    //--------------------------------------------
    // create weft
    weft=new int[rowtotalwidth*2]; // weft threads run horizontally
    pos=0;
    for (int i=0; i<rows; i++) {
      for (int j=0; j<rowwidths[i]; j++) {
        weft[pos]=rowcolors[i];
        weft[(rowtotalwidth*2)-pos-1]=rowcolors[i];        
        pos++;
      }
    }   
  }

  String getLatinName(String name) {
    String result = "";      
    for (int i=0; i<name.length(); i++) {
      int w=getNum(name2.toLowerCase().charAt(i)); 
      // decode using latin alphabet
      if(w>0){
        result+=latinAL[w-1];
      } else {
        result+="?";
      }
    }
    return result;
  }

  void setGaelic(boolean _val) {
    useGaelic = _val;
  }
  
  boolean isGaelic() {
    return useGaelic;
  }

  // get the number for a character
  int getNum(char c) {
    
    Integer w = null;
    if (useGaelic) {
      w = gaelicLut.get(""+c);
    } else {
      w = latinLut.get(""+c);
    }
    
    if (w == null) {
      println("could not find character. skipping: " + c);
      w = 0;
    }
    return w;
  }

  int getPatternSize() {
    return totalwidth;
  }

  int getPatternSizeV() {
    return rowtotalwidth;
  }
  
  boolean isEnforceNewColor() {
    return enforceNewColor;
  }
  
  void setEnforceNewColor(boolean _val) {
    enforceNewColor = _val;    
  }

  color getColorAt(int x, int y) {
    if (((x+y)%4)>=2) {
      return palette[warp[x%(totalwidth*2)]];
    } else {
      return palette[weft[y%(rowtotalwidth*2)]];
    }
  }
}