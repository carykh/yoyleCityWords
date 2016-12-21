import processing.opengl.*;
import saito.objloader.*;
//import com.sun.opengl.util.texture.*;
OBJModel van;
//good seeds = 63558, 85052, 87279, 5598, 60908, 81404, 22703, 28671, 19003 (water), 82839, 89424
//Good seed = 43762
int seed = 23589;//int(random(0,100000));
int cityLoc = 84;

int full = 0; // <---CHANGED!
int camMode = 1; // <---CHANGED! //0 = move around, 1 = follow track
float slope = 1;

PImage bb;
float xoff = 0.0;
int w = 300;
int h = 300;
float[][] elev = new float[h][w];
float[][] water = new float[h][w];
float[][] city = new float[h][w];
int[][][] vansInSpot = new int[h][w][0];
int[][] bridges = new int[h][w];
boolean[][] tri = new boolean[h][w];
int treeRes = 2;
float[][] trees = new float[h*treeRes][w*treeRes];
int buildingCount = 80;
int buildingCount2 = 20;
int buildingCount3 = 3;
Building [][][] city2 = new Building[h][w][buildingCount];
float[][][] ripple = new float[h][w][10];
int[][][] tileColors = new int[h][w][3];
float[][] treeTileColors = new float[h*2][w*2];
float minH = 1000;
float maxH = -1000;
float minH2 = 1000;
float maxH2 = -1000;
float inf = 0.01;
float[] cam = {w/2,200,20,w/2,-20000,-1190,0,0,-1,PI/3,36,188};
float[] prevCam = new float[8];
float speed = 0.5;
float dg = 0;
int[][] colors = {{129,123,91},{400,283,243},{0,0,0},{16,70,12},{42,100,30},{70,70,70},{100,100,100},{230,230,230},{255,255,255}};//{{50,20,40},{94,30,96},{94,30,96},{131,46,141},{43,102,48},{70,70,70},{100,100,100},{230,230,230},{255,255,255}};
int fog = 400;
int[] bg = {153,207,243};//{250,230,100};
int[] wc = {23,56,125};
PImage sun, flag, roadImage, roadImage2, roadImage3, roadImage4, window,robotBack,robotSide,robotTop,wheel;
PImage[][] beginSign = new PImage[3][40];
PImage[][] endSign = new PImage[3][40];
PImage[] robotFace = new PImage[40];
float sunHeight = 100;
float riverDepth = 0.6;
float bankDepth = 0.002;
int timer = 0;
float citySize = 0.02;
float roadWidth = 0.15;
float roadHeightBase = 0.001;
float roadHeight = 0.001;
float edgeMargin = 0.01;
color[] flowerColors = {color(255,0,0),color(255,255,0),color(255,0,255),color(255,120,0),color(0,0,255),
color(0,120,255),color(120,0,255)};
float[] len = {120,200,300};
int leafCount = 40;
int[] tree = {7,10,13};
float wireWidth = 0.0025;
float oceanDepth = 0.07;
float cityMax = 0;
float stadDist = 10000;
int YNX = 0;
int YNY = 0;
int YSX = 0;
int YSY = 0;
boolean cPress = false;
float[][][][][]YNCoords = new float[2][2][91][33][4];
float brh = 1.5;
float brrh = 0.1;
float roadRes = 0.1;
int[] sunColor = {255, 255, 255};
float haloSize = 500;
int cloudCount = 300;
Cloud[] clouds = new Cloud[cloudCount];
float cityTree = -0.13;
int[] treeColor = {15,45,10};
float sludgeProg = cityLoc+73;
float sludgeSpeed = 0.0003;
float driveSpeed = 0.006;
float totSec = 0;
int sumill = 0;
float turnSpeed = 0.002;
int vanCount = 6000;
Van[] vans = new Van[vanCount];
float[][] camCoor = {
  
{108.352844,158.98863,18.5,-6020.0425,-14336.016,-12703.196,0.0,0.0,-1.0,1.0471976,36.0,157.0}, //1.5 seconds

{135.98465,147.30614,18.5,15565.752,-15426.508,-12703.196,0.0,0.0,-1.0,1.0471976,36.0,156.9892}, //3.0 seconds

{156.8387,134.36107,8.5,16956.193,-6481.5156,-27779.227,0.0,0.0,-1.0,1.0471976,36.0,156.9784}, //4.5 seconds

{174.17368,124.96791,-6.5,40532.45,-9167.373,-16878.16,0.0,0.0,-1.0,1.0471976,36.0,156.96759}, //6.0 seconds

{172.01854,120.06224,28.5,60270.79,-9539.59,1976.457,0.0,0.0,-1.0,1.0471976,36.0,156.95679}, //7.5 seconds

{224.03827,105.77171,41.0,61042.973,-6692.9033,70132.98,0.0,0.0,-1.0,1.0471976,36.0,156.94598}, //9.0 seconds

{301.60907,94.68274,53.5,-199647.81,18769.469,-143011.31,0.0,0.0,-1.0,1.0471976,36.0,156.93518} //10.5 seconds


/*{155.06111,180.9793,28.902405,11737.273,12825.111,-10717.372,0.0,0.0,-1.0,1.0471976,36.0,181.0}, //1.5 seconds

{155.06252,180.9608,28.902405,12730.004,11878.525,-10717.372,0.0,0.0,-1.0,1.0471976,36.0,180.9892}, //3.0 seconds

{155.06322,180.95155,28.902405,13226.369,11405.232,-10717.372,0.0,0.0,-1.0,1.0471976,36.0,180.9784}, //4.5 seconds

{155.04515,180.93495,28.911995,14599.494,9868.543,-10717.36,0.0,0.0,-1.0,1.0471976,36.0,180.96759}, //6.0 seconds

{155.01364,180.90698,28.950356,14797.3,8369.321,-12091.132,0.0,0.0,-1.0,1.0471976,36.0,180.95679}, //7.5 seconds

{154.94582,180.85956,29.045458,15363.509,7117.215,-12777.925,0.0,0.0,-1.0,1.0471976,36.0,180.94598}, //9.0 seconds

{154.7208,180.77829,29.255787,16200.907,5253.992,-13464.614,0.0,0.0,-1.0,1.0471976,36.0,180.93518}, //10.5 seconds

{154.41083,180.66524,29.582108,18856.3,4313.987,-11375.091,0.0,0.0,-1.0,1.0471976,36.0,180.92438}, //12.0 seconds

{153.71985,180.47627,31.084435,20534.44,3065.0464,-10672.469,0.0,0.0,-1.0,1.0471976,36.0,180.91357}, //13.5 seconds

{152.51062,180.23244,33.350792,22212.07,1816.0566,-9969.101,0.0,0.0,-1.0,1.0471976,36.0,180.90277}, //15.0 seconds

{152.63791,180.05513,36.15716,21793.213,-2955.8318,-13581.914,0.0,0.0,-1.0,1.0471976,36.0,180.89197}, //16.5 seconds

{153.16437,179.58897,38.743526,18298.277,-8611.475,-20076.117,0.0,0.0,-1.0,1.0471976,36.0,180.88116}, //18.0 seconds

{153.25119,179.26395,46.32983,17911.443,-14382.3545,-22400.832,0.0,0.0,-1.0,1.0471976,36.0,180.87036}, //19.5 seconds

//{153.33801,178.93892,66.51593,12623.164,-21537.248,-27336.166,0.0,0.0,-1.0,1.0471976,36.0,180.85956}, //21.0 seconds

{153.42484,178.61389,71.90225,10053.233,-24719.29,-33344.805,0.0,0.0,-1.0,1.0471976,36.0,180.84875}, //22.5 seconds

{148.1182,191.85606,80.88852,2465.874,-25210.771,-42439.07,0.0,0.0,-1.0,1.0471976,36.0,180.83795}, //24.0 seconds

{145.59657,197.92148,95.6747,-1729.8494,-27675.414,-49493.098,0.0,0.0,-1.0,1.0471976,36.0,180.82715}, //25.5 seconds

{142.6165,202.18652,100.56092,-2637.0696,-30319.316,-56550.07,0.0,0.0,-1.0,1.0471976,36.0,180.81635}, //27.0 seconds

{143.89403,197.47354,96.24753,438.36365,-33161.0,-63632.637,0.0,0.0,-1.0,1.0471976,36.0,180.80554}, //28.5 seconds

{143.17966,195.14905,85.53394,840.3351,-35871.547,-70702.41,0.0,0.0,-1.0,1.0471976,36.0,180.79474}, //30.0 seconds

{143.9258,190.15254,69.22072,1044.2749,-35168.34,-79486.69,0.0,0.0,-1.0,1.0471976,36.0,180.78394}, //31.5 seconds

{144.03,178.94511,49.027443,1133.7778,-30409.684,-89872.51,0.0,0.0,-1.0,1.0471976,36.0,180.77313}, //33.0 seconds

{144.07,169.83716,16.674103,248.0,3880.376,-106972.195,0.0,0.0,-1.0,1.0471976,36.0,180.76233}, //34.5 seconds

{144.07,161.72868,-5.6792374,-113.454895,21964.137,-120100.25,0.0,0.0,-1.0,1.0471976,36.0,180.75153}, //36.0 seconds*/










};

float frL = 0;
int camModeTime = 36;
int currentKeyFrame = 0;
int innerFrame = 0;
boolean lastWasLong = false;

void setup() {
  van = new OBJModel(this, "supervan.obj", "absolute", TRIANGLES);
  van.scale(20);
  van.translateToCenter();
  sphereDetail(9);
  println("Seed: "+seed);
  noiseSeed(seed);
  randomSeed(seed);
  noiseDetail(6, 0.5);
  sun = loadImage("sun.png");
  roadImage = loadImage("roadNew.png");
  roadImage2 = loadImage("roadNew2.png");
  roadImage3 = loadImage("roadNew3.png");
  roadImage4 = loadImage("roadNew4.png");
  flag = loadImage("flag.png");
  window = loadImage("window.png");
  bb = loadImage("bb.png");
  frL = 0;
  for(int i = 0; i < camCoor.length; i++){
    frL += camCoor[i][10];
  }
  for(int i = 0; i < 8; i++){
    prevCam[i] = -9999;
  }
  for(int j = 0; j < 40; j++){
    String k;
    if(j < 9){
      k = "000"+(j+1);
    }else{
      k = "00"+(j+1);
    }
    robotFace[j] = loadImage("robotFace"+k+".png");
  }
  robotBack = loadImage("robotBack.png");
  robotSide = loadImage("robotSide.png");
  robotTop = loadImage("robotTop.png");
  wheel = loadImage("wheel.png");
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < 40; j++){
      int j2 = (j+10)%40;
      String k;
      if(j2 < 9){
        k = "000"+(j2+1);
      }else{
        k = "00"+(j2+1);
      }
      beginSign[i][j] = loadImage("begin"+(i+1)+"v"+k+".png");
      endSign[i][j] = loadImage("end"+(i+1)+"v"+k+".png");
    }
  }
  textureMode(IMAGE);
  vansInSpot = new int[h][w][0];
  for(int y = 0; y < h; y++){
    for(int x = 0; x < w; x++){
      vansInSpot[y][x] = new int[0];
      bridges[y][x] = 0;
      elev[y][x] = noise(float(x)*0.01, float(y)*0.01);
      float dx = abs(float(x-w/2));
      if(dx < 6){
        float ef = y/10+0.5;
        if(ef > 1) ef = 1;
        dx = 6-(6-dx)*ef;
      }
      elev[y][x] += (-float(y)-10.0*dx/float(y+10))*inf;
      //water[y][x] = -(min(max(abs(noise((float(x)+float(h))*0.01, (float(y)/2+float(h))*0.01)-0.5),-0.013),0.013)-0.013)*riverDepth;
      for(int z = 0; z < 10; z++){
        ripple[y][x][z] = noise(x,y,z)*0.18+0.9;
      }
      //city[y][x] = noise(float(x)*0.1,float(y)*0.1)-dist(x*0.5,y*1.1,(w*0.5)*0.5,h*0.55*1.1)*citySize;
      city[y][x] = -1;
      if(x >= 70 && x < 230 && y >= cityLoc && y < cityLoc+110){
        color c = bb.pixels[x-70+(y-cityLoc)*160];
        if(green(c) > 5){
          city[y][x] = random(0.0015,0.0021)*(green(c)-5);
        }else if(pow(random(0,1),2) > red(c)/255){
          city[y][x] = -0.01;
        }else{
          city[y][x] = -1;
        }
      }
      if(abs(y-h/2) > 145 || abs(x-w/2) > 145){
        city[y][x] = -1;
      }
      if(elev[y][x] > maxH) maxH = elev[y][x];
      if(elev[y][x] < minH) minH = elev[y][x];
    }
  }
  for(int y = 0; y < h; y++){
    for(int x = 0; x < w; x++){
      elev[y][x] = pow((elev[y][x]-minH)/(maxH-minH),2.8);
      elev[y][x] -= water[y][x];
      if(elev[y][x] < oceanDepth){
        water[y][x] = max(water[y][x], oceanDepth-elev[y][x]);
      }
      water[y][x] -= bankDepth;
      float d = dist(x,y,w*0.5,h*0.6);
      float effect = min(max(10*(h-0.6),0),1);
      if(d > h*0.33){
        float d2 = d-h*0.33;
        elev[y][x] -= pow(d2,2)*0.00001*effect;
      }
      if(elev[y][x] > maxH2) maxH2 = elev[y][x];
      if(elev[y][x] < minH2) minH2 = elev[y][x];
    }
  }
  for(int y = 0; y < h; y++){
    for(int x = 0; x < w; x++){
      elev[y][x] = (elev[y][x]-minH2)/(maxH2-minH2);
      tileColors[y][x] = colorify(x,y);
      if(city[y][x] > cityMax && dry(x,y) && dry(x+1,y) && dry(x,y+1) && dry(x+1,y+1) && 
      abs(elev[y][x]-elev[y][x-1]) < 0.0025 && abs(elev[y][x]-elev[y-1][x]) < 0.0025){
        cityMax = city[y][x];
        YNX = x;
        YNY = y;
      }
    }
  }
  for(int y = 0; y < h-1; y++){
    for(int x = 0; x < w-1; x++){
      //if(city[y][x] >= 0){
        float s1 = elev[y][x]+elev[y+1][x+1];
        float s2 = elev[y+1][x]+elev[y][x+1];
        tri[y][x] = (s1 >= s2);
      /*}else{
        float s1 = abs(elev[y][x]-elev[y+1][x+1]);
        float s2 = abs(elev[y+1][x]-elev[y][x+1]);
        tri[y][x] = (s1 >= s2);
      }*/
      if(city[y][x] >= 0 && dry(x,y)){
        for(int z = 0; z < buildingCount; z++){
          setNewBuilding(x,y,z);
          int iter = 0;
          while(iter < 50 && collides(x,y,z)){
            setNewBuilding(x,y,z);
            iter++;
          }
          if(iter >= 49){
            city2[y][x][z].t = 0;
          }
        }
        /*for(int z = 0; z < buildingCount; z++){
          city2[y][x][z].w += random(0,0.07);
          city2[y][x][z].l += random(0,0.07);
          city2[y][x][z].w = min(1-city2[y][x][z].x,city2[y][x][z].w);
          city2[y][x][z].l = min(1-city2[y][x][z].y,city2[y][x][z].l);
        }*/
      }else if(dry(x,y) && city[y][x] >= cityTree){
        for(int z = 0; z < buildingCount3; z++){
          setNewBuilding(x,y,z);
        }
      }else{
        for(int z = 0; z < buildingCount; z++){
          setBlankBuilding(x,y,z);
        }
      }
      if((abs(y-h/2) < 145 && abs(x-w/2) < 145) && city[y][x] < 0 && dry(x,y)
      && (x <= w/2-2 || x >= w/2+4)){
        boolean ok = true;
        for(int x2 = x-1; x2 <= x+2; x2++){
          for(int y2 = y-1; y2 <= y+1; y2++){
            if(city[y2][x2] >= 0 || !dry(x2,y2) || (bridges[y2][x2] != 0 && y2 >= y && x2 >= x)){
              ok = false;
              break;
            }
          }
        }
        if(ok && abs(elev[y][x+1]-elev[y][x-1]) < 0.003 && abs(elev[y+1][x]-elev[y-1][x]) < 0.003){
          float d = dist(x,y,YNX,YNY);
          if(d < stadDist){
            stadDist = d;
            YSX = x;
            YSY = y;
          }
        }
      }
    }
  }
  for(int i = 0; i < vanCount; i++){
    int x = 4;
    int y = 4;
    while(city[y][x] <= 0){
      x = (int)(random(70,230));
      y = (int)(random(cityLoc,cityLoc+110));
    }
    vans[i] = new Van(x+random(0.3,0.999),y+roadWidth*0.3,random(-driveSpeed,0),0.00,0.00,0.00,2,-1,-1);
    addVan(i,x,y);
  }
  for(int y = 0; y < h*treeRes; y++){
    for(int x = 0; x < w*treeRes; x++){
      int x2 = int(x/2);
      int y2 = int(y/2);
      trees[y][x] = random(-0.002,0.01);
      float treePlace = noise(float(x)*0.1, float(y)*0.1)-max(0.5,city[y2][x2]*2+1);
      treePlace = min(max(treePlace,-0.012),0);
      trees[y][x] += treePlace;
      for(int y3 = max(y2-1,0); y3 <= min(y2+1,h-1); y3++){
        for(int x3 = max(x2-1,0); x3 <= min(x2+1,w-1); x3++){
          if(water[y3][x3] > 0){
            trees[y][x] = -0.012;
            break;
          }
        }
      }
      float thisElev = getElev2(x,y);
      if(thisElev > 0.7 || thisElev < 0.17) trees[y][x] = -0.012;
      if(trees[y][x] > 0){
        if(x2 >= 70 && x2 < 230 && y2 >= cityLoc && y2 < cityLoc+110){
          color c = bb.pixels[x2-70+(y2-cityLoc)*160];
          trees[y][x] -= (1-red(c)/255.0)*0.0121;
        }
      }
      if(thisElev < 0.26){
        trees[y][x] -= (0.26-thisElev)/0.06*0.012;
      }
    }
  }
  for(int y = 0; y < h*treeRes; y++){
    for(int x = 0; x < w*treeRes; x++){
      treeTileColors[y][x] = treeColorify(x,y);
    }
  }
  for(int i = 0; i < cloudCount; i++){
    float x = random(-100,400);
    float y = random(-100,400);
    float low = 30.0;
    float high = 160.0;
    if(y > 170){
      low = 50;
    }
    float zmin = elev[int(min(max(y,0),h-1))][int(min(max(x,0),w-1))]*slope;
    clouds[i] = new Cloud(x,y,random(zmin+low,zmin+high),pow(random(1,3),2));
  }
  size(1920,1080,OPENGL);
  noStroke();
  perspective(cam[9],float(width)/height,0.001,1000);
  noLights();
  sumill = millis();
  for(int i = 0; i < 2000; i++){ //move vans around a bit before starting!
    moveVans();
  }
}

void draw() {
  float camHeight = cam[2];
  if(cam[0] >= 0 && cam[0] < w && cam[1] >= 0 && cam[1] < h){
    camHeight = abs(elev[round(cam[1])][round(cam[0])]*slope-cam[2]);
  }
  if(camHeight < 1.0){
    perspective(cam[9],float(width)/height,0.002,1000);
    roadHeight = roadHeightBase;
  }else{
   // println(elev[round(cam[1])][round(cam[0])]+",    "+cam[0]+",   "+cam[1]+",    "+cam[2]);
    perspective(cam[9],float(width)/height,0.1,1000);
    roadHeight = min(50,(camHeight-1.0)*5)*roadHeightBase;
  }
  background(bg[0],bg[1],bg[2]);
  if(keyPressed){
    if (key == CODED) {
      if(camMode == 0){
        float dire = atan2(cam[4]-cam[1],cam[3]-cam[0]);
        if (keyCode == UP) {
          cam[0] += speed*cos(dire);
          cam[3] += speed*cos(dire);
          cam[1] += speed*sin(dire);
          cam[4] += speed*sin(dire);
        }else if (keyCode == DOWN) {
          cam[0] -= speed*cos(dire);
          cam[3] -= speed*cos(dire);
          cam[1] -= speed*sin(dire);
          cam[4] -= speed*sin(dire);
        }else if (keyCode == LEFT) {
          cam[0] -= speed*cos(dire+PI/2);
          cam[3] -= speed*cos(dire+PI/2);
          cam[1] -= speed*sin(dire+PI/2);
          cam[4] -= speed*sin(dire+PI/2);
        }else if (keyCode == RIGHT) {
          cam[0] += speed*cos(dire+PI/2);
          cam[3] += speed*cos(dire+PI/2);
          cam[1] += speed*sin(dire+PI/2);
          cam[4] += speed*sin(dire+PI/2);
        }else if (keyCode == SHIFT){
          cam[2] -= speed;
          cam[5] -= speed;
        }
      }
    }else{
      if (key == ' '){
        if(camMode == 0){
          cam[2] += speed;
          cam[5] += speed;
        }
      }
      if (key == 'c' || key == 'v' || key == 'b'){
        if(!cPress){
          cam[11] = sludgeProg;
          if(key == 'c'){
            sludgeProg -= 1*sludgeSpeed;
            cam[10] = 1;
            totSec += 1/24;
            lastWasLong = false;
          }else{
            sludgeProg -= sludgeSpeed*camModeTime;
            cam[10] = camModeTime;
            totSec += 1.5;
            for(int i = 0; i < 8; i++){
              float current = cam[i];
              if(lastWasLong && key == 'v') cam[i] += cam[i]-prevCam[i];
              prevCam[i] = current;
            }
            lastWasLong = true;
          }
          print("{");
          for(int i = 0; i < 12; i++){
            print(cam[i]);
            if(i < 11) print(",");
          }
          print("},");
          print(" //"+totSec+" seconds");
          println("");
        }
        cPress = true;
      }else{
        cPress = false;
      }
      if(key == 'y'){
        sludgeProg += 0.3;
      }
      if(key == 'u'){
        sludgeProg += 0.03;
      }
      if(key == 'i'){
        sludgeProg -= 0.03;
      }
      if(key == 'o'){
        sludgeProg -= 0.3;
      }
      if (key == 'w'){
        tilt(10);
      }else if (key == 's'){
        tilt(-10);
      }else if (key == 'a'){
        turn(-10);
      }else if (key == 'd'){
        turn(10);
      }else if (key == 'e'){
        full = 0;
      }else if (key == 'r'){
        full = 1;
      }else if (key == 't'){
        full = 2;
      }else if (key == 'f'){
        speed = 0.0008;
      }else if (key == 'g'){
        speed = 0.004;
      }else if (key == 'h'){
        speed = 0.02;
      }else if (key == 'j'){
        speed = 0.1;
      }else if (key == 'k'){
        speed = 0.5;
      }else if (key == 'l'){
        speed = 2.5;
      }else if (key == ','){
        turnSpeed = 0.0004;
      }else if (key == '.'){
        turnSpeed = 0.002;
      }else if (key == '/'){
        turnSpeed = 0.01;
      }else if (key == '='){
        cam[9] *= 0.97;
      }else if (key == '0'){
        cam[9] = PI/3;
      }else if (key == '-'){
        cam[9] *= 1.031;
        if(cam[9] > PI) cam[9] = PI-0.1;
      }
    }
  }else{
    cPress = false;
  }
  if(camMode == 1){
    if(currentKeyFrame < camCoor.length){
      for(int i = 0; i < 12; i++){
        cam[i] = getDim(i,currentKeyFrame,float(innerFrame)/camCoor[currentKeyFrame][10]);
      }
    }
    innerFrame++;
    if(innerFrame >= camCoor[currentKeyFrame][10]){
      innerFrame = 0;
      currentKeyFrame++;
      sludgeProg = camCoor[currentKeyFrame][11];
    }
    if(timer == 0){
      sludgeProg = camCoor[currentKeyFrame][11];
    }
  }
  int x2 = min(max(int(cam[0]),0),w-1);
  int y2 = min(max(int(cam[1]),0),h-1);
  /*if(cam[2] < elev[y2][x2]*slope+1){
    cam[2] = elev[y2][x2]*slope+1;
    dg = cam[2]-elev[y2][x2]*slope;
  }*/
  camera(cam[0],cam[1],cam[2],cam[3],cam[4],cam[5],cam[6],cam[7],cam[8]);
  int xs = 0;
  int xe = w-1;
  int ys = 0;
  int ye = h-1;
  if(full == 0){
    xs = int(max(cam[0]-10,0));
    xe = int(min(cam[0]+10,w-1));
    ys = int(max(cam[1]-10,0));
    ye = int(min(cam[1]+10,h-1));
  }
  int xs2 = 0;
  int xe2 = w-1;
  int ys2 = 0;
  int ye2 = h-1;
  if(full == 0){
    xs2 = int(max(cam[0]-50,0));
    xe2 = int(min(cam[0]+50,w-1));
    ys2 = int(max(cam[1]-50,0));
    ye2 = int(min(cam[1]+50,h-1));
  }
  for(int y = ys2; y < ye2; y++){
    for(int x = xs2; x < xe2; x++){
      noTint();
      noLights();
      ambient(0);
      specular(0);
      drawLand(x,y);
      if(full >= 1 || (y >= ys && y < ye && x >= xs && x < xe)){
        if(water[y][x] > 0 || water[y+1][x] > 0 || water[y][x+1] > 0 || water[y+1][x+1] > 0){
          drawWater(x,y);
        }
        for(int y3 = y*2; y3 < y*2+2; y3++){
          for(int x3 = x*2; x3 < x*2+2; x3++){
            if(treeAboveElev(x3,y3)){
              drawBlobTree(x3,y3);
            }
          }
        }
        fill(20,20,20,255);
        if(x == YSX && y == YSY){
          //drawYS(x,y);
        }
        if(city[y][x] < 0 && dry(x,y) && city[y][x] >= cityTree){
          for(int z = 0; z < buildingCount3; z++){
            drawTree(x,y,z);
          }
        }
        if(city[y][x] >= 0 && dry(x,y)){
          if(full >= 0){
            drawHoriRoad(x,y);
            drawVertRoad(x,y);
            drawRoadPiece(x,y,roadImage2);
          }
          if(x >= YSX-1 && x <= YSX+2 && y >= YSY-1 && y <= YSY+1){ //within stadium 
          }else{
            for(int z = 0; z < buildingCount; z++){
              if(city2[y][x][z].t == 1){
                drawBuilding(x,y,z);
              }
              if(full >= 2){
                if(city2[y][x][z].t == 2){
                  drawPark(x,y,z);
                }else if(city2[y][x][z].t == 3){
                  drawPool(x,y,z);
                }else if(city2[y][x][z].t == 4){
                  drawTree(x,y,z);
                }else if(city2[y][x][z].t == 5){
                  drawFlag(x,y,z);
                }else if(city2[y][x][z].t == 6){
                  drawTL(x,y,z);
                }else if(city2[y][x][z].t == 7){
                  drawSL(x,y,z);
                }else if(city2[y][x][z].t == 8){
                  drawTP(x,y,z);
                }else if(city2[y][x][z].t == 9){
                  drawYN(x,y,z);
                }else if(city2[y][x][z].t == 10){
                  drawHoriBridge(x,y,z);
                }else if(city2[y][x][z].t == 11){
                  drawVertBridge(x,y,z);
                }
              }
            }
          }
        }else if(y > 0 && x > 0 && city[y-1][x] > 0 && city[y][x-1] > 0 && dry(x,y-1) && dry(x-1,y)){
          if(full >= 0){
            drawHoriRoad(x,y);
            drawVertRoad(x,y);
            drawRoadPiece(x,y,roadImage2);
          }
        }else if(y > 0 && city[y-1][x] > 0 && dry(x,y-1)){
          if(full >= 0){
            drawHoriRoad(x,y);
            drawRoadPiece(x,y,roadImage2);
          }
        }else if(x > 0 && city[y][x-1] > 0 && dry(x-1,y)){
          if(full >= 0){
            drawVertRoad(x,y);
            drawRoadPiece(x,y,roadImage2);
          }
        }else if(y > 0 && x > 0 && city[y-1][x-1] > 0 && dry(x-1,y-1)){
          if(full >= 0) drawRoadPiece(x,y,roadImage2);
        }
      }
    }
  }
  moveVans();
  drawVans();
  beginShape();
  texture(sun);
  vertex(-250,-150,2+sunHeight,0,0);
  vertex(-250,-150,150+sunHeight,0,sun.width);
  vertex(-150,-250,150+sunHeight,sun.height,sun.width);
  vertex(-150,-250,2+sunHeight,sun.height,0);
  endShape();
  for(int i = 0; i < 32; i++){
    float a = float(i)*PI/16;
    float a2 = float(i+1)*PI/16;
    beginShape();
    fill(sunColor[0],sunColor[1],sunColor[2],200);
    vertex(-170,-170,75+sunHeight);
    fill(sunColor[0],sunColor[1],sunColor[2],0);
    vertex(-190+cos(a)*0.707*haloSize,-190-cos(a)*0.707*haloSize,75+sunHeight+sin(a)*haloSize);
    fill(sunColor[0],sunColor[1],sunColor[2],0);
    vertex(-190+cos(a2)*0.707*haloSize,-190-cos(a2)*0.707*haloSize,75+sunHeight+sin(a2)*haloSize);
    endShape();
  }
  setShade4(120,w/2,-0.1,150);
 /* beginShape(); //pole - Yoyle Tower
  vertex(w/2-0.3,-0.1,0);
  vertex(w/2-0.3,-0.1,300);
  vertex(w/2+0.3,-0.1,300);
  vertex(w/2+0.3,-0.1,0);
  endShape();*/
  /*fill(255,255,255,100);
  for(int i = 0; i < cloudCount; i++){
    pushMatrix();
    translate(clouds[i].x,clouds[i].y,clouds[i].z);
    scale(clouds[i].r);
    sphere(1);
    popMatrix();
  }*/
  sunHeight+=0.1;
  timer++;
  if(camMode == 1){
    sludgeProg-=sludgeSpeed;
  }
  if(camMode == 1){
    println(timer/36.0);
    //saveFrame("imagesFINAL\\####.png");
    println("Frames: "+timer+"/"+frL+",   that's "+
    ((float(timer)/frL)*100)+"% done in "+(float(millis())/60000)+" minutes.  Est. time left = "+
    ((float(millis()-sumill)/timer)*(frL-timer)/60000)+" minutes");
  }else{
    if(full == 2)saveFrame("stillImages2\\higher.png");
  }
}
void addVan(int i, int x, int y){
  int[] ph = vansInSpot[y][x];
  vansInSpot[y][x] = new int[ph.length+1];
  for(int j = 0; j < ph.length; j++){
    vansInSpot[y][x][j] = ph[j];
  }
  vansInSpot[y][x][ph.length] = i;
}
void removeVan(int i, int x, int y){
  int[] ph = vansInSpot[y][x];
  vansInSpot[y][x] = new int[ph.length-1];
  int j2 = 0;
  for(int j = 0; j < ph.length-1; j++){
    if(j2 < ph.length && ph[j2] == i) j2++; //do it again, skip over van to remove
    vansInSpot[y][x][j] = ph[j2];
    j2++;
  }
}
void drawYS(int x, int y){
  float low = 1;
  float high = 0;
  for(int x2 = x-1; x2 <= x+3; x2++){
    for(int y2 = y-1; y2 <= y+2; y2++){
      float e = elev[y2][x2];
      if(e < low) low = e;
      if(e > high) high = e;
    }
  }
  float d = dist(x,y,high*slope,cam[0],cam[1],cam[2]);
  int[] col = {140,140,140};
  drawBlock(x+1+roadWidth/2,y+0.5+roadWidth/2,2-roadWidth/2,1.5-roadWidth/2,low*slope,high*slope,col,false,false);
  float x2 = x+1+roadWidth/2;
  float y2 = y+0.5+roadWidth/2;
  float z2 = high*slope;
  int[] col5 = {0,120,0};
  setShade3(col5,1,x,y,elev[y][x]*slope+high);
  beginShape();
  vertex(x2-1,y2-0.5,z2+roadHeight/2);
  vertex(x2-1,y2+0.5,z2+roadHeight/2);
  vertex(x2+1,y2+0.5,z2+roadHeight/2);
  vertex(x2+1,y2-0.5,z2+roadHeight/2);
  endShape();
  if(full >= 1){
    setShade4(255,x,y,elev[y][x]*slope+high);
    for(int i = 1; i < 10; i++){
      beginShape();
      vertex(x2-1.01+i*0.2,y2-0.5,z2+roadHeight);
      vertex(x2-1.01+i*0.2,y2+0.5,z2+roadHeight);
      vertex(x2-0.99+i*0.2,y2+0.5,z2+roadHeight);
      vertex(x2-0.99+i*0.2,y2-0.5,z2+roadHeight);
      endShape();
    }
    for(int i = 1; i < 10; i++){
      int[] col2 = {120+(i%2)*15+i*5,80+(i%2)*15+i*5,40+(i%2)*15+i*5};
      drawBlock(x2, y2-1.45+float(i)*0.1, 1,0.05,z2,z2+float(10-i)*0.1,col2,false,false);
      drawBlock(x2, y2+1.45-float(i)*0.1, 1,0.05,z2,z2+float(10-i)*0.1,col2,false,false);
      drawBlock(x2-1.95+float(i)*0.1,y2,0.05,0.5,z2,z2+float(10-i)*0.1,col2,false,false);
      drawBlock(x2+1.95-float(i)*0.1,y2,0.05,0.5,z2,z2+float(10-i)*0.1,col2,false,false);
      for(int a = 0; a < 10; a++){
        float ang = float(a)*PI/20+PI;
        drawSlice(x2-1,y2-0.5,float(10-i)*0.1,float(10-i)*0.1-0.1,ang,ang+PI/20,z2,z2+float(10-i)*0.1,col2,false,false,false);
        ang += PI/2;
        drawSlice(x2+1,y2-0.5,float(10-i)*0.1,float(10-i)*0.1-0.1,ang,ang+PI/20,z2,z2+float(10-i)*0.1,col2,false,false,false);
        ang += PI/2;
        drawSlice(x2+1,y2+0.5,float(10-i)*0.1,float(10-i)*0.1-0.1,ang,ang+PI/20,z2,z2+float(10-i)*0.1,col2,false,false,false);
        ang += PI/2;
        drawSlice(x2-1,y2+0.5,float(10-i)*0.1,float(10-i)*0.1-0.1,ang,ang+PI/20,z2,z2+float(10-i)*0.1,col2,false,false,false);
      }
    }
  }
}
void tilt(int sign){
  float x = cam[3]-cam[0];
  float y = cam[4]-cam[1];
  float z = cam[5]-cam[2];
  float d = dist(0,0,0,x,y,z);
  float ang1 = atan2(y,x); //left and right
  float ang2 = atan2(z,sqrt(x*x+y*y)); //up and down
  ang2 += sign*turnSpeed;
  ang2 = min(max(ang2,-PI/2+sqrt(speed)*0.005),PI/2-speed*0.01);
  z = sin(ang2)*d;
  float xy = cos(ang2);
  x = xy*cos(ang1)*d;
  y = xy*sin(ang1)*d;
  cam[3] = cam[0]+x;
  cam[4] = cam[1]+y;
  cam[5] = cam[2]+z;
}
void turn(int sign){
  float x = cam[3]-cam[0];
  float y = cam[4]-cam[1];
  float d = dist(0,0,x,y);
  float ang1 = atan2(y,x); //left and right
  ang1 += sign*turnSpeed;
  x = cos(ang1)*d;
  y = sin(ang1)*d;
  cam[3] = cam[0]+x;
  cam[4] = cam[1]+y;
}
int[] colorify(int x, int y){
  float n = elev[y][x];
  int n2 = min(int(n*float(colors.length-1)),colors.length-2);
  float tween = (n*float(colors.length-1))%1;
  float shading = 0;
  float tot = 0;
  for(int x2 = max(x-1,0); x2 < min(x+1,w-1); x2++){
    for(int y2 = max(y-1,0); y2 < min(y+1,h-1); y2++){
      shading += (elev[y2][x2]-n)*float(x2-x+y2-y);
      tot++;
    }
  }
  shading = (20+(1000*shading/tot))/20;
  if(shading < 0.3) shading = 0.3;
  int[] c = {int(inter(colors[n2][0],colors[n2+1][0],tween)*shading),
    int(inter(colors[n2][1],colors[n2+1][1],tween)*shading),
    int(inter(colors[n2][2],colors[n2+1][2],tween)*shading)};
  return c;
}
float treeColorify(int x, int y){
  float n = trees[y][x];
  float shading = 0;
  float tot = 0;
  for(int x2 = max(x-1,0); x2 < min(x+1,w*2-1); x2++){
    for(int y2 = max(y-1,0); y2 < min(y+1,h*2-1); y2++){
      shading += (trees[y2][x2]-n)*float(x2-x+y2-y);
      tot++;
    }
  }
  shading = (10+(1000*shading/tot))/17;
  if(shading < 0.2) shading = 0.2;
  return shading;
}
float inter(float a, float b, float c){
  return a+(b-a)*c;
}
color fogged(int x, int y, boolean wat){
  float d = dist(cam[0],cam[1],cam[2],x,y,elev[y][x]*slope);
  float tween = min(max(d/fog,0),1);
  int[] bg2 = setBg2(x,y,elev[y][x]*slope);
  if(wat){
    float br = ripple[y][x][abs(timer%18-9)];
    int[] col = {int(255-(255-wc[0])*br),int(255-(255-wc[1])*br),int(255-(255-wc[2])*br)};
    return fogger(col,bg2,tween);
  }
  int[] col = {tileColors[y][x][0],tileColors[y][x][1],tileColors[y][x][2]};
  return fogger(col,bg2,sqrt(tween));
}
color fogger(int[] col, int[] bg2, float tween){
  return color(inter(col[0],bg2[0],tween),inter(col[1],bg2[1],tween),inter(col[2],bg2[2],tween));
}
int[] foggerArray(int[] col, int[] bg2, float tween){
  int[] c = {(int) inter(col[0],bg2[0],tween),
            (int) inter(col[1],bg2[1],tween),
            (int) inter(col[2],bg2[2],tween)};
  return c;
}
void setNewVanDire(int i){
  boolean[] allowed = {true,true,true,true};
  allowed[opp(vans[i].dire)] = false;
  boolean c00 = (city[(int)(vans[i].y-0.5)][(int)(vans[i].x-0.5)] >= 0);
  boolean c01 = (city[(int)(vans[i].y-0.5)][(int)(vans[i].x+0.5)] >= 0);
  boolean c10 = (city[(int)(vans[i].y+0.5)][(int)(vans[i].x-0.5)] >= 0);
  boolean c11 = (city[(int)(vans[i].y+0.5)][(int)(vans[i].x+0.5)] >= 0);
  if(!c00 && !c01 && bridges[(int)(vans[i].y-0.5)][(int)(vans[i].x+0.5)] < 2) allowed[0] = false;
  if(!c10 && !c11 && bridges[(int)(vans[i].y+0.5)][(int)(vans[i].x+0.5)] < 2) allowed[1] = false;
  if(!c00 && !c10 && bridges[(int)(vans[i].y+0.5)][(int)(vans[i].x-0.5)]%2 == 0) allowed[2] = false;
  if(!c01 && !c11 && bridges[(int)(vans[i].y+0.5)][(int)(vans[i].x+0.5)]%2 == 0) allowed[3] = false;
  if(allowed[0] || allowed[1] || allowed[2] || allowed[3]){
    int choice = -1;
    while(choice == -1 || !allowed[choice]){
      choice = (int)(random(0,4));       
    }
    boolean prevB = vans[i].b;
    vans[i].b = false;
    int x = 0;
    int y = 0;
    if(choice == 0 && !c00 && !c01){ vans[i].b = true;
      x = (int)(vans[i].x+0.5);
      y = (int)(vans[i].y-0.5);
      while(bridges[y][x] >= 2) y--;
      y++;
    }else if(choice == 1 && !c10 && !c11){ vans[i].b = true;
      x = (int)(vans[i].x+0.5);
      y = (int)(vans[i].y-0.5);
      while(bridges[y][x] >= 2)  y++;
    }else if(choice == 2 && !c00 && !c10){ vans[i].b = true;
      x = (int)(vans[i].x-0.5);
      y = (int)(vans[i].y+0.5);
      while(bridges[y][x]%2 == 1) x--;
      x++;
    }else if(choice == 3 && !c01 && !c11){ vans[i].b = true;
      x = (int)(vans[i].x+0.5);
      y = (int)(vans[i].y+0.5);
      while(bridges[y][x]%2 == 1) x++;
    }
    if(vans[i].b && !prevB || choice != vans[i].dire){
      vans[i].bridgeEndX = x;
      vans[i].bridgeEndY = y;
      vans[i].bridgeLength = dist(round(vans[i].x),round(vans[i].y),x,y);
    }
    vans[i].toDire = choice;
    vans[i].toTurnTimer = 1;
    if((vans[i].dire == 0 && choice == 2) || (vans[i].dire == 2 && choice == 1) ||
    (vans[i].dire == 1 && choice == 3) || (vans[i].dire == 3 && choice == 0)){
      vans[i].toTurnTimer = round(roadWidth*0.4/driveSpeed);
    }
  }
}
int opp(int n){
  if(n%2 == 0) return n+1;
  return n-1;
}
void moveVans(){
 // float margin = 0.02*roadWidth;
  float foresight = 0.24*roadWidth;
//  float adjustPower = driveSpeed/35;
  float goal = 0;
  for(int i = 0; i < vanCount; i++){
    vans[i].toTurnTimer--;  
    if(vans[i].toTurnTimer == 0){
      vans[i].dire = vans[i].toDire;
    }
    float sp = driveSpeed;
    /*if(vans[i].b){ //on a bridge, can go FASTER!
      float distLeft = dist(vans[i].x, vans[i].y , vans[i].bridgeEndX, vans[i].bridgeEndY);
      sp = (vans[i].bridgeLength/2-abs(distLeft-vans[i].bridgeLength/2)+0.75)*driveSpeed;
      sp = max(sp,driveSpeed);
    }*/
    
    int prevX = (int)vans[i].x;
    int prevY = (int)vans[i].y;
    
    for(int j2 = 0; j2 < vansInSpot[prevY][prevX].length; j2++){
      int j = vansInSpot[prevY][prevX][j2];
      if(abs(vans[i].x-vans[j].x) < 0.05 && abs(vans[i].y-vans[j].y) < 0.1){
        if((vans[i].dire == 0 && vans[i].y > vans[j].y) ||
        (vans[i].dire == 1 && vans[i].y < vans[j].y) || 
        (vans[i].dire == 2 && vans[i].x > vans[j].x) ||
        (vans[i].dire == 3 && vans[i].x < vans[j].x)){
          sp = driveSpeed/2; //Avoid other cars if you're too close!
        }
      } 
    }
    
    if(vans[i].dire == 0){
      goal = round(vans[i].x)+0.7*roadWidth;
      vans[i].vx += -vans[i].vx/15;
      vans[i].vy += (-sp-vans[i].vy)/15;
      if((int)(vans[i].y+vans[i].vy-roadWidth-foresight) != (int)(vans[i].y-roadWidth-foresight)) setNewVanDire(i);
    }else if(vans[i].dire == 1){
      goal = round(vans[i].x)+0.3*roadWidth;
      vans[i].vx += -vans[i].vx/15;
      vans[i].vy += (sp-vans[i].vy)/15;
      if((int)(vans[i].y+vans[i].vy+foresight) != (int)(vans[i].y+foresight)) setNewVanDire(i);
    }else if(vans[i].dire == 2){
      goal = round(vans[i].y)+0.3*roadWidth;
      vans[i].vx += (-sp-vans[i].vx)/15;
      vans[i].vy += -vans[i].vy/15;
      if((int)(vans[i].x+vans[i].vx-roadWidth-foresight) != (int)(vans[i].x-roadWidth-foresight)) setNewVanDire(i);
    }else if(vans[i].dire == 3){
      goal = round(vans[i].y)+0.7*roadWidth;
      vans[i].vx += (sp-vans[i].vx)/15;
      vans[i].vy += -vans[i].vy/15;
      if((int)(vans[i].x+vans[i].vx+foresight) != (int)(vans[i].x+foresight)) setNewVanDire(i);
    }
    vans[i].x += vans[i].vx;
    vans[i].y += vans[i].vy;
    int currX = (int)vans[i].x;
    int currY = (int)vans[i].y;
    if(prevX != currX || prevY != currY){
      removeVan(i,prevX,prevY);
      addVan(i,currX,currY);
    }
    float x = vans[i].x;
    float y = vans[i].y;
    int ix = (int)(x);
    int iy = (int)(y);
    float e00 = elev[iy][ix]+max(water[iy][ix],0)*brh;
    float e01 = elev[iy][ix+1]+max(water[iy][ix+1],0)*brh;
    float e10 = elev[iy+1][ix]+max(water[iy+1][ix],0)*brh;
    float e11 = elev[iy+1][ix+1]+max(water[iy+1][ix+1],0)*brh;
    vans[i].tiltX += (atan2((e00-e10)*slope,1)-vans[i].tiltX)/5;
    vans[i].tiltY += (-atan2((e00-e01)*slope,1)-vans[i].tiltY)/5;
  }
}
void drawVans(){
  for(int i = 0; i < vanCount; i++){
    float x = vans[i].x;
    float y = vans[i].y;
    int ix = (int)(x);
    int iy = (int)(y);
    float e00 = elev[iy][ix]+max(water[iy][ix],0)*brh;
    float e01 = elev[iy][ix+1]+max(water[iy][ix+1],0)*brh;
    float e10 = elev[iy+1][ix]+max(water[iy+1][ix],0)*brh;
    float e11 = elev[iy+1][ix+1]+max(water[iy+1][ix+1],0)*brh;
    float z = inter(inter(e00,e01,x%1),inter(e10,e11,x%1),y%1)*slope+roadHeight;
    pushMatrix();
    translate(x,y,z);
    rotateX(-vans[i].tiltX);
    rotateY(-vans[i].tiltY);
    float r = atan2(vans[i].vy,vans[i].vx);
    rotateZ(r-PI/2);
    float tireHeight = (25.7+abs(((timer+i)%8)-4)*0.6)*0.0004;
    float d = dist(x,y,z,cam[0],cam[1],cam[2]);
    int[] whe = {0,0,0};
    if(d <= 12 && full >= 2){
      drawBlockRaw(0.0,0.0,0.013,0.024,0.004,0.014,x,y,z,vans[i].c,false,false);
      drawBlockRaw(0.0,0.0,0.013,0.012,0.004,0.020,x,y,z,vans[i].c,false,false);
      if(d <= 6){
        translate(-0.010,-0.016,0.002);
        drawWheel2(0.004,0.0025);
        translate(0.020,0,0);
        drawWheel2(0.004,0.0025);
        translate(0,0.032,0);
        drawWheel2(0.004,0.0025);
        translate(-0.020,0,0);
        drawWheel2(0.004,0.0025);
        translate(0.010,-0.016,-0.002);
      }else{
        drawBlockRaw(0.0,0.016,0.013,0.004,0.000,0.004,x,y,z,whe,false,false);
        drawBlockRaw(0.0,-0.016,0.013,0.004,0.000,0.004,x,y,z,whe,false,false);
      }
  /*  }else if(d <= 10){
      drawBlockRaw(0.0,0.0,0.013,0.024,0.004,0.014,x,y,z,vans[i].c,false,false);*/
    }else{
      drawRect(0.0,0.0,0.013,0.024,0.014,x,y,z,vans[i].c,false,false);
    }
    //van.draw();
    popMatrix();
  }
}
void drawHoriRoad(int x, int y){
  float e00 = elev[y][x]+max(water[y][x],0)*brh;
  float e01 = elev[y][x+1]+max(water[y][x+1],0)*brh;
  float e10 = elev[y+1][x]+max(water[y+1][x],0)*brh;
  float e11 = elev[y+1][x+1]+max(water[y+1][x+1],0)*brh;
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  if(d >= fog*roadRes && false){
    setShade4(45,x,y,elev[y][x]*slope);
    beginShape();
    vertex(x+roadWidth,y,inter(e00,e01,roadWidth)*slope+roadHeight);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight);
    vertex(x+1,y+roadWidth,inter(e01,e11,roadWidth)*slope+roadHeight);
    vertex(x+1,y,e01*slope+roadHeight);
    endShape();
  }else{
    beginShape();
    texture(roadImage);
    vertex(x+roadWidth,y,inter(e00,e01,roadWidth)*slope+roadHeight,0,0);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight,0,roadImage.height);
    vertex(x+1,y+roadWidth,inter(e01,e11,roadWidth)*slope+roadHeight,roadImage.width,roadImage.height);
    vertex(x+1,y,e01*slope+roadHeight,roadImage.width,0);
    endShape();
  }
  if(water[y][x] > 0 || water[y][x+1] > 0){
    setShade4(140,x,y,elev[y][x]*slope);
    beginShape();
    vertex(x+roadWidth,y-roadWidth/4,inter(e00,e01,roadWidth)*slope);
    vertex(x+roadWidth,y+roadWidth*5/4,inter(e00,e11,roadWidth)*slope);
    vertex(x+1,y+roadWidth*5/4,inter(e01,e11,roadWidth)*slope);
    vertex(x+1,y-roadWidth/4,e01*slope);
    endShape();
  }
}
void drawVertRoad(int x, int y){
  float e00 = elev[y][x]+max(water[y][x],0)*brh;
  float e01 = elev[y][x+1]+max(water[y][x+1],0)*brh;
  float e10 = elev[y+1][x]+max(water[y+1][x],0)*brh;
  float e11 = elev[y+1][x+1]+max(water[y+1][x+1],0)*brh;
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  if(d >= fog*roadRes && false){
    setShade4(45,x,y,elev[y][x]*slope);
    beginShape();
    vertex(x,y+roadWidth,inter(e00,e10,roadWidth)*slope+roadHeight);
    vertex(x,y+1,e10*slope+roadHeight);
    vertex(x+roadWidth,y+1,inter(e10,e11,roadWidth)*slope+roadHeight);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight);
    endShape();
  }else{
    beginShape();
    texture(roadImage);
    vertex(x,y+roadWidth,inter(e00,e10,roadWidth)*slope+roadHeight,0,0);
    vertex(x,y+1,e10*slope+roadHeight,roadImage.width,0);
    vertex(x+roadWidth,y+1,inter(e10,e11,roadWidth)*slope+roadHeight,roadImage.width,roadImage.height);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight,0,roadImage.height);
    endShape();
  }
  if(water[y][x] > 0 || water[y+1][x] > 0){
    setShade4(140,x,y,elev[y][x]*slope);
    beginShape();
    vertex(x-roadWidth/4,y+roadWidth,inter(e00,e10,roadWidth)*slope);
    vertex(x-roadWidth/4,y+1,e10*slope);
    vertex(x+roadWidth*5/4,y+1,inter(e10,e11,roadWidth)*slope);
    vertex(x+roadWidth*5/4,y+roadWidth,inter(e00,e11,roadWidth)*slope);
    endShape();
  }
}
void drawRoadPiece(int x, int y, PImage img){
  float e00 = elev[y][x]+max(water[y][x],0)*brh;
  float e01 = elev[y][x+1]+max(water[y][x+1],0)*brh;
  float e10 = elev[y+1][x]+max(water[y+1][x],0)*brh;
  float e11 = elev[y+1][x+1]+max(water[y+1][x+1],0)*brh;
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  if(d >= fog*roadRes && false){
    setShade4(45,x,y,elev[y][x]*slope);
    beginShape();
    vertex(x,y,e00*slope+roadHeight);
    vertex(x,y+roadWidth,inter(e00,e10,roadWidth)*slope+roadHeight);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight);
    vertex(x+roadWidth,y,inter(e00,e01,roadWidth)*slope+roadHeight);
    endShape();
  }else{
    beginShape();
    texture(img);
    vertex(x,y,e00*slope+roadHeight,0,0);
    vertex(x,y+roadWidth,inter(e00,e10,roadWidth)*slope+roadHeight,0,roadImage2.height);
    vertex(x+roadWidth,y+roadWidth,inter(e00,e11,roadWidth)*slope+roadHeight,roadImage2.width,roadImage2.height);
    vertex(x+roadWidth,y,inter(e00,e01,roadWidth)*slope+roadHeight,roadImage2.width,0);
    endShape();
  }
  if(water[y][x] > 0){
    float low;
    if(e00 <  e01){
      if(e00 < e10){
        low = e00;
      }else{
        low = inter(e00,e10,roadWidth);
      }
    }else{
      if(e00 < e10){
        low = inter(e00,e01,roadWidth);
      }else{
        low = inter(e00,e11,roadWidth);
      }
    }
    int[] col = {100,100,100};
    drawBlock(x+roadWidth/2,y+roadWidth/2,roadWidth/2,roadWidth/2,elev[y][x]*slope,low*slope,col,false,false);
  }
}
boolean dry(int x, int y){
  return (water[y][x] <= 0 && water[y+1][x] <= 0
  && water[y][x+1] <= 0 && water[y+1][x+1] <= 0);
}
boolean treeAboveElev(int x, int y){
  return (trees[y][x] > 0 || trees[y+1][x] > 0
  || trees[y][x+1] > 0 || trees[y+1][x+1] > 0);
}
boolean road2(int x, int y){
  if(water[y][x] == 0) return true;
  if(x%20 == 0 || y%20 == 0) return true;
  return false;
}
void drawHoriBridge(int x, int y, int z){
  for(int x2 = x+1; x2 < city2[y][x][z].roof; x2++){
    int[] col = {140,140,140};
    if(water[y][x2] > 0 && bridges[y][x2] == 1){
      drawBlock(x2+roadWidth/2,y-roadWidth/4,roadWidth/2,roadWidth/4,elev[y][x2]*slope,(elev[y][x2]+water[y][x2]*brh)*slope+brrh,col,false,false);
      drawBlock(x2+roadWidth/2,y+roadWidth*5/4,roadWidth/2,roadWidth/4,elev[y][x2]*slope,(elev[y][x2]+water[y][x2]*brh)*slope+brrh,col,false,false);
    }
    drawHoriRoad(x2,y);
    drawRoadPiece(x2,y,roadImage3);
  }
}
void drawVertBridge(int x, int y, int z){
  for(int y2 = y+1; y2 < city2[y][x][z].roof; y2++){
    int[] col = {140,140,140};
    if(water[y2][x] > 0 && bridges[y2][x] == 2){
      drawBlock(x-roadWidth/4,y2+roadWidth/2,roadWidth/4,roadWidth/2,elev[y2][x]*slope,(elev[y2][x]+water[y2][x]*brh)*slope+brrh,col,false,false);
      drawBlock(x+roadWidth*5/4,y2+roadWidth/2,roadWidth/4,roadWidth/2,elev[y2][x]*slope,(elev[y2][x]+water[y2][x]*brh)*slope+brrh,col,false,false);
    }
    drawVertRoad(x,y2);
    drawRoadPiece(x,y2,roadImage4);
  }
}
void drawFlag(int x, int y, int z){
  if(full >= 1){
    float bx = x+city2[y][x][z].x;
    float by = y+city2[y][x][z].y;
    float ground = city2[y][x][z].e2*slope;
    float roof = city2[y][x][z].e*slope+city2[y][x][z].h;
    drawRoofBlock(x,y,z,bx,by,0.0025,0.0025,ground,roof,false,false);
    int[] col = {178,148,65};
    setShade3(col,1,x,y,elev[y][x]*slope);
    drawRoofBlock(x,y,z,bx,by,0.005,0.005,roof,roof+0.02,true,true);
    float ang = city2[y][x][z].wm;
    float angDown = -(float(city2[y][x][z].roof)*PI/30)*0.67;
    beginShape();
    texture(flag);
    vertex(bx,by,roof-0.007,0,0);
    vertex(bx,by,roof-0.04,0,flag.height);
    vertex(bx+0.09*cos(ang)*cos(angDown),by+0.06*sin(ang)*cos(angDown),roof-0.04+0.06*sin(angDown),flag.width,flag.height);
    vertex(bx+0.09*cos(ang)*cos(angDown),by+0.06*sin(ang)*cos(angDown),roof-0.007+0.06*sin(angDown),flag.width,0);
    endShape(CLOSE);
  }
}
void drawTL(int x, int y, int z){
  if(full >= 1){
    float bx = x+city2[y][x][z].x;
    float by = y+city2[y][x][z].y;
    float ground = city2[y][x][z].e2*slope;
    float roof = city2[y][x][z].e*slope+city2[y][x][z].h;
    float out = city2[y][x][z].wm;
    int side = city2[y][x][z].roof;
    drawRoofBlock(x,y,z,bx,by,0.0025,0.0025,ground,roof,true,false);
    if(side <= 1){
      drawRoofBlock(x,y,z,bx,by+out/2*float(side*2-1),0.0025,out/2+0.0025,roof-0.005,roof,true,false);
      drawRoofBlock(x,y,z,bx,by+out*float(side*2-1),0.006,0.006,roof-0.017,roof+0.012,true,false);
      for(int i = 0; i < 3; i++){
        int[] c = HSL2RGB(i*60,0.6,0.3);
        setShade3(c,1,x,y,elev[y][x]*slope);
        drawRoofBlock(x,y,z,bx,by+out*float(side*2-1),0.007,0.005,roof+0.004-0.01*i,roof+0.011-0.01*i,true,true);
      }
    }else{
      drawRoofBlock(x,y,z,bx+out/2*float(side*2-5),by,out/2+0.0025,0.0025,roof-0.0025,roof,true,false);
      drawRoofBlock(x,y,z,bx+out*float(side*2-5),by,0.006,0.006,roof-0.017,roof+0.012,true,false);
      for(int i = 0; i < 3; i++){
        int[] c = HSL2RGB(i*60,0.6,0.3);
        setShade3(c,1,x,y,elev[y][x]*slope);
        drawRoofBlock(x,y,z,bx+out*float(side*2-5),by,0.005,0.007,roof+0.004-0.01*i,roof+0.011-0.01*i,true,true);
      }
    }
  }
}
void drawSL(int x, int y, int z){
  if(full >= 1){
    float bx = x+city2[y][x][z].x;
    float by = y+city2[y][x][z].y;
    float ground = city2[y][x][z].e2*slope;
    float roof = city2[y][x][z].e*slope+city2[y][x][z].h;
    float out = city2[y][x][z].wm;
    int side = city2[y][x][z].roof;
    drawRoofBlock(x,y,z,bx,by,0.0025,0.0025,ground,roof,true,false);
    if(side <= 1){
      drawRoofBlock(x,y,z,bx,by+out/2*float(side*2-1),0.0025,out/2+0.0025,roof-0.0025,roof,true,false);
      drawRoofBlock(x,y,z,bx,by+out*float(side*2-1),0.01,0.01,roof-0.007,roof+0.0025,true,false);
      int[] c = {132,132,100};
      setShade3(c,1,x,y,elev[y][x]*slope);
      drawRoofBlock(x,y,z,bx,by+out*float(side*2-1),0.007,0.007,roof-0.01,roof-0.005,true,true);
    }else{
      drawRoofBlock(x,y,z,bx+out/2*float(side*2-5),by,out/2+0.0025,0.0025,roof-0.0025,roof,true,false);
      drawRoofBlock(x,y,z,bx+out*float(side*2-5),by,0.01,0.01,roof-0.007,roof+0.0025,true,false);
      int[] c = {132,132,100};
      setShade3(c,1,x,y,elev[y][x]*slope);
      drawRoofBlock(x,y,z,bx+out*float(side*2-5),by,0.007,0.007,roof-0.01,roof-0.005,true,true);
    }
  }
}
void drawYN(int x, int y, int z){
  float d = dist(x,y,elev[y][x]*slope+3,cam[0],cam[1],cam[2]);
  float bx = city2[y][x][z].x+city2[y][x][z].w/2;
  float by = city2[y][x][z].y+city2[y][x][z].l/2;
  float ground = city2[y][x][z].e2*slope;
  pushMatrix();
  translate(x+bx,y+by,ground);
  scale(0.1);
  int todo = min(3+full*29,32);
  for(int tx = 0; tx <= 1; tx++){
    for(int ty = 0; ty <= 1; ty++){
      for(int h = 0; h < 90; h++){
        for(int ang = 0; ang < todo; ang++){
          if(int(h/3)%2 == 0 && ((ang == 20 && tx == 0 && ty == 0) || (ang == 28 && tx == 1 && ty == 0) || (ang == 4 && tx == 1 && ty == 1) || (ang == 12 && tx == 0 && ty == 1))){
            int[] col = HSL2RGB(((90-h)*4+timer*5)%360,1,0.5);
            int[] col2 = HSL2RGB(((89-h)*4+timer*5)%360,1,0.5);
            beginShape();
            setShade3(col,1,x,y,elev[y][x]*slope+float(h)/15);
            vertex(YNCoords[tx][ty][h][ang][0]*1.01,YNCoords[tx][ty][h][ang][1]*1.01,YNCoords[tx][ty][h][ang][2]);
            setShade3(col2,1,x,y,elev[y][x]*slope+float(h)/15);
            vertex(YNCoords[tx][ty][h+1][ang][0]*1.01,YNCoords[tx][ty][h+1][ang][1]*1.01,YNCoords[tx][ty][h+1][ang][2]);
            setShade3(col2,1,x,y,elev[y][x]*slope+float(h)/15);
            vertex(YNCoords[tx][ty][h+1][ang+1][0]*1.01,YNCoords[tx][ty][h+1][ang+1][1]*1.01,YNCoords[tx][ty][h+1][ang+1][2]);
            setShade3(col,1,x,y,elev[y][x]*slope+float(h)/15);
            vertex(YNCoords[tx][ty][h][ang+1][0]*1.01,YNCoords[tx][ty][h][ang+1][1]*1.01,YNCoords[tx][ty][h][ang+1][2]);
            endShape();
          }
          beginShape();
          setShade4(YNCoords[tx][ty][h][ang][3],x,y,elev[y][x]*slope+float(h)/15);
          vertex(YNCoords[tx][ty][h][ang][0],YNCoords[tx][ty][h][ang][1],YNCoords[tx][ty][h][ang][2]);
          setShade4(YNCoords[tx][ty][h+1][ang][3],x,y,elev[y][x]*slope+float(h)/15);
          vertex(YNCoords[tx][ty][h+1][ang][0],YNCoords[tx][ty][h+1][ang][1],YNCoords[tx][ty][h+1][ang][2]);
          setShade4(YNCoords[tx][ty][h+1][ang+1][3],x,y,elev[y][x]*slope+float(h)/15);
          vertex(YNCoords[tx][ty][h+1][ang+1][0],YNCoords[tx][ty][h+1][ang+1][1],YNCoords[tx][ty][h+1][ang+1][2]);
          setShade4(YNCoords[tx][ty][h][ang+1][3],x,y,elev[y][x]*slope+float(h)/15);
          vertex(YNCoords[tx][ty][h][ang+1][0],YNCoords[tx][ty][h][ang+1][1],YNCoords[tx][ty][h][ang+1][2]);
          endShape();
        }
      }
    }
  }
  int[] col3 = {255,0,0};
  if(full >= 1){
    for(int ang = 0; ang < 32; ang++){
      float ang1 = float(ang)*PI/16;
      float ang2 = float(ang+1)*PI/16;
      setShade4(120,x,y,elev[y][x]*slope+6);
      beginShape();
      vertex(cos(ang1)*3.5,sin(ang1)*3.5,30);
      vertex(cos(ang2)*3.5,sin(ang2)*3.5,30);
      vertex(0,0,30);
      endShape();
      setShade4(220,x,y,elev[y][x]*slope+6);
      beginShape();
      vertex(cos(ang1)*3.5,sin(ang1)*3.5,32);
      vertex(cos(ang2)*3.5,sin(ang2)*3.5,32);
      vertex(0,0,32);
      endShape();
      setShade4(abs(ang1-PI)*30+60,x,y,elev[y][x]*slope+6);
      beginShape();
      vertex(cos(ang1)*0.6,sin(ang1)*0.6,32);
      vertex(cos(ang2)*0.6,sin(ang2)*0.6,32);
      vertex(0,0,42);
      endShape();
      beginShape();
      setShade4(abs(ang1-PI)*30+120,x,y,elev[y][x]*slope+6);
      vertex(cos(ang1)*3.5,sin(ang1)*3.5,30);
      vertex(cos(ang1)*3.5,sin(ang1)*3.5,32);
      setShade4(abs(ang2-PI)*30+120,x,y,elev[y][x]*slope+6);
      vertex(cos(ang2)*3.5,sin(ang2)*3.5,32);
      vertex(cos(ang2)*3.5,sin(ang2)*3.5,30);
      endShape();
      if(int(ang/2)%2 == 0){
        beginShape();
        setShade3(col3,1,x,y,elev[y][x]*slope+6);
        vertex(cos(ang1)*3.52,sin(ang1)*3.52,30.8);
        vertex(cos(ang1)*3.52,sin(ang1)*3.52,31.2);
        vertex(cos(ang2)*3.52,sin(ang2)*3.52,31.2);
        vertex(cos(ang2)*3.52,sin(ang2)*3.52,30.8);
        endShape();
      }
    }
  }
  popMatrix();
  setShade3(col3,1,x,y,elev[y][x]*slope+8.5);
  if(full >= 1) drawRoofBlock(x,y,z,x+bx,y+by,0.015,0.015,ground+4.18,ground+4.21,true,true);
}
void drawTP(int x, int y, int z){
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  if(full >= 1){
    float bx = x+city2[y][x][z].x;
    float by = y+city2[y][x][z].y;
    float ground = city2[y][x][z].e2*slope;
    float broof = city2[y][x][z].e*slope+city2[y][x][z].h;
    float out = city2[y][x][z].wm/2;
    int side = city2[y][x][z].roof;
    drawRoofBlock(x,y,z,bx,by,0.0025,0.0025,ground,broof,true,false);
    if(side <= 1){
      drawRoofBlock(x,y,z,bx,by,0.0025+out,0.0025,broof-0.02,broof-0.015,true,false);
      drawRoofBlock(x,y,z,bx,by,0.0025+out/2,0.0025,broof-0.01,broof-0.005,true,false);
    }else{
      drawRoofBlock(x,y,z,bx,by,0.0025,0.0025+out,broof-0.02,broof-0.015,true,false);
      drawRoofBlock(x,y,z,bx,by,0.0025,0.0025+out/2,broof-0.01,broof-0.005,true,false);
    }
    int c = city2[y][x][z].wx;
    if(c >= 0){
      float ex = 0;
      float ey = 0;
      float eroof = 0;
      if(side == 0){
        ex = x+city2[y-1][x][c].x;
        ey = (y-1)+city2[y-1][x][c].y;
        eroof = city2[y-1][x][c].e*slope+city2[y-1][x][c].h;
      }else{
        ex = (x-1)+city2[y][x-1][c].x;
        ey = y+city2[y][x-1][c].y;
        eroof = city2[y][x-1][c].e*slope+city2[y][x-1][c].h;
      }
      float a = atan2(ey-by,ex-bx);
      setShade4(0,x,y,elev[y][x]*slope);
      float in = 0;
      float droop = dist(bx,by,ex,ey)*float(city2[y][x][z].wy)*0.01;
      for(int i = 0; i < 5; i++){
        in = float(i)/5;
        float bdroop = (pow((in-0.5),2)/0.25-1)*droop;
        float edroop = (pow((in-0.3),2)/0.25-1)*droop;
        beginShape();
        vertex(inter(bx,ex,in),inter(by,ey,in),inter(broof,eroof,in)+bdroop);
        vertex(inter(bx,ex,in+0.2),inter(by,ey,in+0.2),inter(broof,eroof,in+0.2)+edroop);
        vertex(inter(bx,ex,in+0.2),inter(by,ey,in+0.2),inter(broof,eroof,in+0.2)+wireWidth+edroop);
        vertex(inter(bx,ex,in),inter(by,ey,in),inter(broof,eroof,in)+wireWidth+bdroop);
        endShape(CLOSE);
        beginShape();
        vertex(inter(bx,ex,in),inter(by,ey,in),inter(broof,eroof,in)+bdroop);
        vertex(inter(bx,ex,in+0.2),inter(by,ey,in+0.2),inter(broof,eroof,in+0.2)+edroop);
        vertex(inter(bx,ex,in+0.2)+cos(a+PI/2)*wireWidth,inter(by,ey,in+0.2)+sin(a+PI/2)*wireWidth,inter(broof,eroof,in+0.2)+edroop);
        vertex(inter(bx,ex,in)+cos(a+PI/2)*wireWidth,inter(by,ey,in)+sin(a+PI/2)*wireWidth,inter(broof,eroof,in)+bdroop);
        endShape(CLOSE);
      }
    }
  }
}
void drawTree(int x, int y, int z){
  if(full >= 1){
    float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
    setShade3(city2[y][x][z].c2,1,x,y,elev[y][x]*slope);
    float trunkWidth = city2[y][x][z].wm;
    float px = city2[y][x][z].x;
    float py = city2[y][x][z].y;
    float pe = city2[y][x][z].e2*slope;
    float ph = city2[y][x][z].h;
    if(full >= 2){
      if(city2[y][x][z].roof < tree[0]){
        drawPointyTrunk(x,y,px,py,pe,ph,trunkWidth);
        for(int i = 0; i < leafCount; i++){
          drawLeaf(x,y,z,px,py,pe,ph,i);
        }
      }else if(city2[y][x][z].roof >= tree[1] && city2[y][x][z].roof < tree[2]){
        drawStraightTrunk(x,y,px,py,pe,ph,trunkWidth);
        for(int i = 0; i < 12; i++){
          Leaf l = city2[y][x][z].leaves[i];
          drawLeafBall(x,y,z,px+l.ang,py+l.w,pe,ph+l.droop,l.l,d,(i>=4));
        }
      }else{
        drawStraightTrunk(x,y,px,py,pe,ph,trunkWidth);
        drawLeafBall(x,y,z,px,py,pe,ph,city2[y][x][z].leaves[0].l,d,false);
      }
    }else{
      drawSimpleTrunk(x,y,px,py,pe,ph,trunkWidth);
    }
  }
}
void drawPointyTrunk(int x, int y, float px, float py, float pe, float ph, float trunkWidth){
  int[] col = {0,0,0};
  drawPyramid(x+px,y+py,trunkWidth,trunkWidth,pe,pe+ph,col,false,true);
}
void drawStraightTrunk(int x, int y, float px, float py, float pe, float ph, float trunkWidth){
  int[] col = {0,0,0};
  drawBlock(x+px,y+py,trunkWidth,trunkWidth,pe,pe+ph,col,false,true);
}
void drawSimpleTrunk(int x, int y, float px, float py, float pe, float ph, float trunkWidth){
  beginShape();
  vertex(x+px-trunkWidth,y+py,pe);
  vertex(x+px+trunkWidth,y+py,pe);
  vertex(x+px+trunkWidth,y+py,pe+ph);
  vertex(x+px-trunkWidth,y+py,pe+ph);
  endShape();
}
void drawLeaf(int x, int y, int z, float px, float py, float pe, float ph, int i){
  Leaf l = city2[y][x][z].leaves[i];
  float lw = ph*l.w;
  float ll = ph*l.l;
  float lh1 = ((float(i)/float(leafCount))*0.7+0.3)*ph+pe;
  float lh2 = -l.droop*ll;
  pushMatrix();
  translate(x+px,y+py,lh1);
  scale(0.1);
  setShade(x,y,z,l.shade);
  beginShape();
  vertex(10*cos(l.ang+PI/2)*lw/2,10*sin(l.ang+PI/2)*lw/2,0);
  vertex(10*cos(l.ang-PI/2)*lw/2,10*sin(l.ang-PI/2)*lw/2,0);
  vertex(10*cos(l.ang)*ll,10*sin(l.ang)*ll,10*lh2);
  endShape();
  popMatrix();
}
void drawLeafBall(int x, int y, int z, float px, float py, float pe, float ph, float r, float d, boolean berry){
  if(berry){
    int col[] = {120,0,255};
    setShade3(col, 1, x+city2[y][x][z].x, y+city2[y][x][z].y, city2[y][x][z].e+city2[y][x][z].h/2);
  }else{
    setShade(x,y,z,1);
  }
  pushMatrix();
  translate(x+px,y+py,pe+ph);
  lights();
  scale(r);
  sphere(1);
  popMatrix();
  noLights();
}
void drawPool(int x, int y, int z){
  int[] col = {30,30,30};
  setShade3(col,1,x,y,elev[y][x]*slope);
  float px = city2[y][x][z].x;
  float py = city2[y][x][z].y;
  float pw = city2[y][x][z].w;
  float pl = city2[y][x][z].l;
  beginShape();
  vertex(x+px,y+py,getElev(x,y,px,py)*slope+roadHeight);
  vertex(x+px+pw,y+py,getElev(x,y,px+pw,py)*slope+roadHeight);
  vertex(x+px+pw,y+py+pl,getElev(x,y,px+pw,py+pl)*slope+roadHeight);
  vertex(x+px,y+py+pl,getElev(x,y,px,py+pl)*slope+roadHeight);
  endShape(CLOSE);
  
  float br = 1-(1-ripple[y][x][abs(timer%18-9)])*3;
  setShade(x,y,z,0.9*br);
  beginShape();
  vertex(x+px+pw*0.1,y+py+pl*0.1,getElev(x,y,px+pw*0.1,py+pl*0.1)*slope+roadHeight*2);
  vertex(x+px+pw*0.9,y+py+pl*0.1,getElev(x,y,px+pw*0.9,py+pl*0.1)*slope+roadHeight*2);
  vertex(x+px+pw*0.9,y+py+pl*0.9,getElev(x,y,px+pw*0.9,py+pl*0.9)*slope+roadHeight*2);
  vertex(x+px+pw*0.1,y+py+pl*0.9,getElev(x,y,px+pw*0.1,py+pl*0.9)*slope+roadHeight*2);
  endShape(CLOSE);
}
void drawPark(int x, int y, int z){
  int[] col = {30,30,30};
  setShade3(col,1,x,y,elev[y][x]*slope);
  float px = city2[y][x][z].x;
  float py = city2[y][x][z].y;
  float pw = city2[y][x][z].w;
  float pl = city2[y][x][z].l;
  vertex(x+px,y+py,getElev(x,y,px,py)*slope+roadHeight);
  vertex(x+px+pw,y+py,getElev(x,y,px+pw,py)*slope+roadHeight);
  vertex(x+px+pw,y+py+pl,getElev(x,y,px+pw,py+pl)*slope+roadHeight);
  vertex(x+px,y+py+pl,getElev(x,y,px,py+pl)*slope+roadHeight);
  endShape(CLOSE);
  
  setShade(x,y,z,0.9);
  beginShape();
  vertex(x+px+pw*0.1,y+py+pl*0.1,getElev(x,y,px+pw*0.1,py+pl*0.1)*slope+roadHeight*2);
  vertex(x+px+pw*0.9,y+py+pl*0.1,getElev(x,y,px+pw*0.9,py+pl*0.1)*slope+roadHeight*2);
  vertex(x+px+pw*0.9,y+py+pl*0.9,getElev(x,y,px+pw*0.9,py+pl*0.9)*slope+roadHeight*2);
  vertex(x+px+pw*0.1,y+py+pl*0.9,getElev(x,y,px+pw*0.1,py+pl*0.9)*slope+roadHeight*2);
  endShape(CLOSE);
  if(full >= 1){
    for(int i = 0; i < 49; i++){
      if(city2[y][x][z].f[i] >= 1){
        fill(flowerColors[city2[y][x][z].f[i]-1]);
        float gx = px+pw*(0.2+(i%7)*0.1);
        float gy = py+pl*(0.2+int(i/7)*0.1);
        beginShape();
        vertex(x+gx-0.02,y+gy,getElev(x,y,gx,gy)*slope);
        vertex(x+gx-0.02,y+gy,getElev(x,y,gx,gy)*slope+0.02);
        vertex(x+gx+0.02,y+gy,getElev(x,y,gx,gy)*slope+0.02);
        vertex(x+gx+0.02,y+gy,getElev(x,y,gx,gy)*slope);
        endShape(CLOSE);
        beginShape();
        vertex(x+gx,y+gy-0.02,getElev(x,y,gx,gy)*slope);
        vertex(x+gx,y+gy-0.02,getElev(x,y,gx,gy)*slope+0.02);
        vertex(x+gx,y+gy+0.02,getElev(x,y,gx,gy)*slope+0.02);
        vertex(x+gx,y+gy+0.02,getElev(x,y,gx,gy)*slope);
        endShape(CLOSE);
      }
    }
  }
}
void drawBuilding(int x, int y, int z){
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  float bx = x+city2[y][x][z].x;
  float by = y+city2[y][x][z].y;
  float bh = city2[y][x][z].h;
  float bw = city2[y][x][z].w;
  float bl = city2[y][x][z].l;
  float ground = city2[y][x][z].e2*slope;
  float roof = city2[y][x][z].e*slope+city2[y][x][z].h;
  if(full >= 2){
    drawBlock(bx+bw/2,by+bl/2,bw/2,bl/2,ground, roof, city2[y][x][z].c,false,false);
    drawWindows(x,y,z,d);
    drawRoof(x,y,z,bx,bw,by,bl,bh);
  }else{
    setShade(x,y,z,0.9);
    beginShape();
    vertex(bx,by,ground);
    vertex(bx,by,roof);
    vertex(bx+bw,by,roof);
    vertex(bx+bw,by,ground);
    endShape(CLOSE);
  }
}
void roofTrans(int x, int y, int z, float bx, float by){
  pushMatrix();
  translate(bx,by,city2[y][x][z].e*slope);
  scale(0.1);
}
void drawRoof(int x, int y, int z, float bx, float bw, float by, float bl, float bh){
  float roof = city2[y][x][z].h;
  float roof2 = city2[y][x][z].h+city2[y][x][z].e*slope;
  float r = max(0.15,city2[y][x][z].roof2-0.2)*0.1;
  float x1 = -bw*r;
  float x3 = bw/2;
  float x5 = bw+bw*r;
  float y1 = -bl*r;
  float y3 = bl/2;
  float y5 = bl+bl*r;
  r = city2[y][x][z].roof2*0.1+0.03;
  float x2 = bw*r;
  float x4 = bw-bw*r;
  float y2 = bl*r;
  float y4 = bl-bl*r;
  float xce = city2[y][x][z].x+city2[y][x][z].w/2;
  float yce = city2[y][x][z].y+city2[y][x][z].l/2;
  if(city2[y][x][z].roof%9 >= 2 && city2[y][x][z].roof%9 <= 5){
    roofTrans(x,y,z,bx,by);
    setShade2(x,y,z,0.5);
    beginShape();
    vertex(x1*10,y1*10,roof*10);
    vertex(x5*10,y1*10,roof*10);
    vertex(x5*10,y5*10,roof*10);
    vertex(x1*10,y5*10,roof*10);
    endShape(CLOSE);
    popMatrix();
  }
  switch(city2[y][x][z].roof%9){
    case 0:
      break;
    case 1:
      roofTrans(x,y,z,bx,by);
      setShade2(x,y,z,1);
      beginShape();
      vertex(x2*10,y4*10,roof*10+roadHeight);
      vertex(x4*10,y4*10,roof*10+roadHeight);
      vertex(x4*10,y2*10,roof*10+roadHeight);
      vertex(x2*10,y2*10,roof*10+roadHeight);
      endShape(CLOSE);
      popMatrix();
      break;
    case 2:
      roofTrans(x,y,z,bx,by);
      setShade2(x,y,z,0.8);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(0,y3*10,roof*10+bl*2.5);
      vertex(x1*10,y5*10,roof*10);
      endShape(CLOSE);
      
      setShade2(x,y,z,0.7);
      beginShape();
      vertex(x5*10,y1*10,roof*10);
      vertex(bw*10,y3*10,roof*10+bl*2.5);
      vertex(x5*10,y5*10,roof*10);
      endShape(CLOSE);
      
      setShade2(x,y,z,1);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(0,y3*10,roof*10+bl*2.5);
      vertex(bw*10,y3*10,roof*10+bl*2.5);
      vertex(x5*10,y1*10,roof*10);
      endShape(CLOSE);
      
      setShade2(x,y,z,0.9);
      beginShape();
      vertex(x1*10,y5*10,roof*10);
      vertex(0,y3*10,roof*10+bl*2.5);
      vertex(bw*10,y3*10,roof*10+bl*2.5);
      vertex(x5*10,y5*10,roof*10);
      endShape(CLOSE);
      popMatrix();
      break;
    case 3:
      roofTrans(x,y,z,bx,by);
      setShade2(x,y,z,0.8);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x3*10,0,roof*10+bl*2.5);
      vertex(x5*10,y1*10,roof*10);
      endShape(CLOSE);
       setShade2(x,y,z,0.7);
      beginShape();
      vertex(x1*10,y5*10,roof*10);
      vertex(x3*10,bl*10,roof*10+bl*2.5);
      vertex(x5*10,y5*10,roof*10);
      endShape(CLOSE);
      
      setShade2(x,y,z,1);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x3*10,0,roof*10+bl*2.5);
      vertex(x3*10,bl*10,roof*10+bl*2.5);
      vertex(x1*10,y5*10,roof*10);
      endShape(CLOSE);
      
      setShade2(x,y,z,0.9);
      beginShape();
      vertex(x5*10,y1*10,roof*10);
      vertex(x3*10,0,roof*10+bl*2.5);
      vertex(x3*10,bl*10,roof*10+bl*2.5);
      vertex(x5*10,y5*10,roof*10);
      endShape(CLOSE);
      popMatrix();
      break;
    case 4:
      roofTrans(x,y,z,bx,by);
      setShade2(x,y,z,1.0);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x5*10,y1*10,roof*10);
      vertex(x3*10,y3*10,roof*10+bl*4);
      endShape(CLOSE);
      setShade2(x,y,z,0.9);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x1*10,y5*10,roof*10);
      vertex(x3*10,y3*10,roof*10+bl*4);
      endShape(CLOSE);
      setShade2(x,y,z,0.8);
      beginShape();
      vertex(x1*10,y5*10,roof*10);
      vertex(x5*10,y5*10,roof*10);
      vertex(x3*10,y3*10,roof*10+bl*4);
      endShape(CLOSE);
      setShade2(x,y,z,0.7);
      beginShape();
      vertex(x5*10,y1*10,roof*10);
      vertex(x5*10,y5*10,roof*10);
      vertex(x3*10,y3*10,roof*10+bl*4);
      endShape(CLOSE);
      popMatrix();
      break;
    case 5:
      roofTrans(x,y,z,bx,by);
      setShade2(x,y,z,0.9);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x5*10,y1*10,roof*10);
      vertex(x4*10,y2*10,roof*10+bl*3);
      vertex(x2*10,y2*10,roof*10+bl*3);
      endShape(CLOSE);
      setShade2(x,y,z,0.8);
      beginShape();
      vertex(x1*10,y1*10,roof*10);
      vertex(x1*10,y5*10,roof*10);
      vertex(x2*10,y4*10,roof*10+bl*3);
      vertex(x2*10,y2*10,roof*10+bl*3);
      endShape(CLOSE);
      setShade2(x,y,z,0.7);
      beginShape();
      vertex(x1*10,y5*10,roof*10);
      vertex(x5*10,y5*10,roof*10);
      vertex(x4*10,y4*10,roof*10+bl*3);
      vertex(x2*10,y4*10,roof*10+bl*3);
      endShape(CLOSE);
      setShade2(x,y,z,0.6);
      beginShape();
      vertex(x5*10,y1*10,roof*10);
      vertex(x5*10,y5*10,roof*10);
      vertex(x4*10,y4*10,roof*10+bl*3);
      vertex(x4*10,y2*10,roof*10+bl*3);
      endShape(CLOSE);
      setShade2(x,y,z,1.0);
      beginShape();
      vertex(x4*10,y2*10,roof*10+bl*3);
      vertex(x4*10,y4*10,roof*10+bl*3);
      vertex(x2*10,y4*10,roof*10+bl*3);
      vertex(x2*10,y2*10,roof*10+bl*3);
      endShape(CLOSE);
      popMatrix();
      break;
    case 6:
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.4,bl*0.4,roof2,roof2+bl*0.16,false,false);
      break;
    case 7:
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.35,bl*0.35,roof2,roof2+bl*0.2,false,false);
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.07,bl*0.07,roof2+bl*0.2,roof2+bl*0.7,false,false);
      break;
    case 8:
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.4,bl*0.4,roof2,roof2+bl*0.2,false,false);
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.2,bl*0.2,roof2+bl*0.2,roof2+bl*0.4,false,false);
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.03,bl*0.03,roof2+bl*0.4,roof2+bl*1.2,false,false);
      int cz = int(city2[y][x][z].c2[0]+city2[y][x][z].c2[1]+city2[y][x][z].c2[2])%7;
      int[] col = {0,0,0};
      int col2 = 0;
      if(cz == 0) col2 = 4;
      if(cz == 1) col2 = 6;
      if(cz == 2) col2 = 2;
      if(cz == 3) col2 = 3;
      if(cz == 4) col2 = 1;
      if(cz == 5) col2 = 5;
      if(cz == 6) col2 = 7;
      if(col2%2 == 1) col[2] = 255;
      if(int(col2/2)%2 == 1) col[1] = 255;
      if(col2 >= 4) col[0] = 255;
      setShade3(col,1,x,y,elev[y][x]*slope);
      drawRoofBlock(x,y,z,xce+x,yce+y,bw*0.09,bl*0.09,roof2+bl*1.2,roof2+bl*1.33,true,true);
      break;
  }
  if(city2[y][x][z].roof >= 9){
    int p = (city2[y][x][z].c3[0]+city2[y][x][z].c3[1]+city2[y][x][z].c3[2])%8;
    if(p < 4){
      float cx = bx+bw*(0.3+0.4*int(p/2));
      float cy = by+bl*(0.3+0.4*(p%2));
      float cs = min(bw,bl)*0.1;
      float h = 0.33;
      if(city2[y][x][z].roof%9 <= 0) h = 0.2;
      if(city2[y][x][z].roof%9 == 4) h = 0.4;
      if(city2[y][x][z].roof%9 == 4) h = 0.47;
      drawRoofBlock(x,y,z,cx,cy,cs,cs,roof2,roof2+bl*0.4,false,false);
    }
  }
}
void drawRoofBlock(int x, int y, int z, float xc, float yc, float xs, float ys, float blockBottom, float blockTop, boolean bot, boolean singleColor){
  pushMatrix();
  translate(xc,yc,blockBottom);
  float b = (blockTop-blockBottom)*10;
  float m = xs*10;
  float n = ys*10;
  scale(0.1);
  if(!singleColor) setShade2(x,y,z,0.9);
  beginShape();
  vertex(-m,-n,0);
  vertex(m,-n,0);
  vertex(m,-n,b);
  vertex(-m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade2(x,y,z,0.8);
  beginShape();
  vertex(-m,-n,0);
  vertex(-m,n,0);
  vertex(-m,n,b);
  vertex(-m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade2(x,y,z,0.7);
  beginShape();
  vertex(-m,n,0);
  vertex(m,n,0);
  vertex(m,n,b);
  vertex(-m,n,b);
  endShape(CLOSE);
  if(!singleColor) setShade2(x,y,z,0.6);
  beginShape();
  vertex(m,-n,0);
  vertex(m,n,0);
  vertex(m,n,b);
  vertex(m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade2(x,y,z,1);
  beginShape();
  vertex(xs*10,ys*10,b);
  vertex(-xs*10,ys*10,b);
  vertex(-xs*10,-ys*10,b);
  vertex(xs*10,-ys*10,b);
  endShape(CLOSE);
  if(bot){
    if(!singleColor) setShade2(x,y,z,0.5);
    beginShape();
    vertex(xs*10,-ys*10,0);
    vertex(xs*10,ys*10,0);
    vertex(-xs*10,ys*10,0);
    vertex(-xs*10,-ys*10,0);
    endShape(CLOSE);
  }
  popMatrix();
}

void drawBlock(float xc, float yc, float xs, float ys, float blockBottom, float blockTop, int[] c, boolean bot, boolean singleColor){
  float zc = (blockBottom+blockTop)/2;
  drawBlockRaw(xc,yc,xs,ys,blockBottom,blockTop,xc,yc,zc,c,bot,singleColor);
}
void drawRect(float xc, float yc, float xs, float ys, float blockTop, float fogX, float fogY, float fogZ, int[] c, boolean bot, boolean singleColor){
  pushMatrix();
  translate(xc,yc,blockTop);
  if(!singleColor) setShade3(c,1,fogX,fogY,fogZ);
  scale(0.1);
  beginShape();
  vertex(xs*10,-ys*10,0);
  vertex(xs*10,ys*10,0);
  vertex(-xs*10,ys*10,0);
  vertex(-xs*10,-ys*10,0);
  endShape(CLOSE);
  popMatrix();
}
void drawBlockRaw(float xc, float yc, float xs, float ys, float blockBottom, float blockTop, float fogX, float fogY, float fogZ, int[] c, boolean bot, boolean singleColor){
  pushMatrix();
  translate(xc,yc,blockBottom);
  float b = (blockTop-blockBottom)*10;
  float zc = (blockBottom+blockTop)/2;
  float m = xs*10;
  float n = ys*10;
  scale(0.1);
  if(!singleColor) setShade3(c,0.9,fogX,fogY,fogZ);
  beginShape();
  vertex(-m,-n,0);
  vertex(m,-n,0);
  vertex(m,-n,b);
  vertex(-m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.8,fogX,fogY,fogZ);
  beginShape();
  vertex(-m,-n,0);
  vertex(-m,n,0);
  vertex(-m,n,b);
  vertex(-m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.7,fogX,fogY,fogZ);
  beginShape();
  vertex(-m,n,0);
  vertex(m,n,0);
  vertex(m,n,b);
  vertex(-m,n,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.6,fogX,fogY,fogZ);
  beginShape();
  vertex(m,-n,0);
  vertex(m,n,0);
  vertex(m,n,b);
  vertex(m,-n,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,1,fogX,fogY,fogZ);
  beginShape();
  vertex(xs*10,ys*10,b);
  vertex(-xs*10,ys*10,b);
  vertex(-xs*10,-ys*10,b);
  vertex(xs*10,-ys*10,b);
  endShape(CLOSE);
  if(bot){
    if(!singleColor) setShade3(c,0.5,fogX,fogY,fogZ);
    beginShape();
    vertex(xs*10,-ys*10,0);
    vertex(xs*10,ys*10,0);
    vertex(-xs*10,ys*10,0);
    vertex(-xs*10,-ys*10,0);
    endShape(CLOSE);
  }
  popMatrix();
}
void drawPyramid(float xc, float yc, float xs, float ys, float blockBottom, float blockTop, int[] c, boolean bot, boolean singleColor){
  pushMatrix();
  translate(xc,yc,blockBottom);
  float b = (blockTop-blockBottom)*10;
  float zc = (blockBottom+blockTop)/2;
  float m = xs*10;
  float n = ys*10;
  scale(0.1);
  if(!singleColor) setShade3(c,0.9,xc,yc,zc);
  beginShape();
  vertex(-m,-n,0);
  vertex(m,-n,0);
  vertex(0,0,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.8,xc,yc,zc);
  beginShape();
  vertex(-m,-n,0);
  vertex(-m,n,0);
  vertex(0,0,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.7,xc,yc,zc);
  beginShape();
  vertex(-m,n,0);
  vertex(m,n,0);
  vertex(0,0,b);
  endShape(CLOSE);
  if(!singleColor) setShade3(c,0.6,xc,yc,zc);
  beginShape();
  vertex(m,-n,0);
  vertex(m,n,0);
  vertex(0,0,b);
  endShape(CLOSE);
  if(bot){
    if(!singleColor) setShade3(c,0.5,xc,yc,zc);
    beginShape();
    vertex(xs*10,-ys*10,0);
    vertex(xs*10,ys*10,0);
    vertex(-xs*10,ys*10,0);
    vertex(-xs*10,-ys*10,0);
    endShape(CLOSE);
  }
  popMatrix();
}
void drawSlice(float xc, float yc, float rs, float re, float angs, float ange, float blockBottom, float blockTop, int[] c, boolean bot, boolean singleColor, boolean sides){
  pushMatrix();
  translate(xc,yc,blockBottom);
  float b = (blockTop-blockBottom)*10;
  float zc = (blockBottom+blockTop)/2;
  scale(0.1);
  if(!singleColor) setShade3(c,1,xc,yc,zc);
  beginShape();
  vertex(cos(angs)*rs*10, sin(angs)*rs*10,b);
  vertex(cos(ange)*rs*10, sin(ange)*rs*10,b);
  vertex(cos(ange)*re*10, sin(ange)*re*10,b);
  vertex(cos(angs)*re*10, sin(angs)*re*10,b);
  endShape();
  if(!singleColor) setShade3(c,shadedCurve(inter(angs+PI,ange+PI,0.5)),xc,yc,zc);
  beginShape();
  vertex(cos(angs)*re*10, sin(angs)*re*10,b);
  vertex(cos(ange)*re*10, sin(ange)*re*10,b);
  vertex(cos(ange)*re*10, sin(ange)*re*10,0);
  vertex(cos(angs)*re*10, sin(angs)*re*10,0);
  endShape();
  if(!singleColor) setShade3(c,shadedCurve(inter(angs,ange,0.5)),xc,yc,zc);
  beginShape();
  vertex(cos(angs)*rs*10, sin(angs)*rs*10,b);
  vertex(cos(ange)*rs*10, sin(ange)*rs*10,b);
  vertex(cos(ange)*rs*10, sin(ange)*rs*10,0);
  vertex(cos(angs)*rs*10, sin(angs)*rs*10,0);
  endShape();
  if(sides){
    if(!singleColor) setShade3(c,shadedCurve(inter(angs+PI/2,ange+PI/2,0.5)),xc,yc,zc);
    beginShape();
    vertex(cos(angs)*rs*10, sin(angs)*rs*10,b);
    vertex(cos(angs)*re*10, sin(angs)*re*10,b);
    vertex(cos(angs)*re*10, sin(angs)*re*10,0);
    vertex(cos(angs)*rs*10, sin(angs)*rs*10,0);
    endShape();
    if(!singleColor) setShade3(c,shadedCurve(inter(angs+PI*3/2,ange+PI*3/2,0.5)),xc,yc,zc);
    beginShape();
    vertex(cos(ange)*rs*10, sin(ange)*rs*10,b);
    vertex(cos(ange)*re*10, sin(ange)*re*10,b);
    vertex(cos(ange)*re*10, sin(ange)*re*10,0);
    vertex(cos(ange)*rs*10, sin(ange)*rs*10,0);
    endShape();
  }
  popMatrix();
}
float shadedCurve(float n){
  n = (n+2*PI)%(2*PI);
  n = n*2/PI;
  float n2 = n%1;
  if(n <= 1){
    return inter(0.6,0.7,n2);
  }else if(n <= 2){
    return inter(0.7,0.8,n2);
  }else if(n <= 3){
    return inter(0.8,0.9,n2);
  }
  return inter(0.9,0.6,n2);
}
void drawWindows(int x, int y, int z, float d){
  int door = (city2[y][x][z].c[0]+city2[y][x][z].c[1])%3-1;
  int n = city2[y][x][z].name;
  int nb = int(n/120);
  int ne = n%120;
  int nbl = int(nb/40);
  int nel = int(ne/40);
  int nbn = nb%40;
  int nen = ne%40;
  PImage imgb = beginSign[nbl][nbn];
  PImage imge = endSign[nel][nen];
  float dividerb = len[nbl]/(len[nbl]+20+len[nel]);
  float dividere = (20+len[nbl])/(len[nbl]+20+len[nel]);
  float windowWidth = (city2[y][x][z].w-edgeMargin*2)/city2[y][x][z].wx;
  float windowHeight = (city2[y][x][z].h-edgeMargin*3)/city2[y][x][z].wz;
  float y3 = city2[y][x][z].l+roadHeight;
  float y4 = -roadHeight;
  int windowFloor = city2[y][x][z].wz-1;
  boolean multi = false;
  float veryBottom = (city2[y][x][z].e2-city2[y][x][z].e)*slope;
  int rand = (city2[y][x][z].c[0]+city2[y][x][z].c[1]+city2[y][x][z].c[2])%4;
  if(rand == 0){
    windowFloor = 1;
  }else if((rand == 3 && !(nbl == 0 && nel == 0)) || (nbl == 2 && nel == 2)){
    multi = true;
    if(nbl == nel){
      dividerb = 0;
      dividere = 0;
    }else if(nbl > nel){
      dividerb = 0;
      dividere = 1-len[nel]/len[nbl];
    }else{
      dividerb = 1-len[nbl]/len[nel];
      dividere = 0;
    }
  }
  pushMatrix();
  translate(x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e*slope);
  scale(0.1);
  for(int z2 = 0; z2 < city2[y][x][z].wz; z2++){
    float zs = windowHeight*z2+edgeMargin*2+city2[y][x][z].wm*windowHeight;
    float ze = windowHeight*(z2+1)+edgeMargin*2-city2[y][x][z].wm*windowHeight;
    if(city2[y][x][z].name >= 1 && (z2 == windowFloor || (z2 == windowFloor-1 && multi))){
      if(multi){
        if(z2 == windowFloor){
          drawSignX2(x,y,z,zs,ze,windowWidth,dividerb,imgb,1);
          drawSignX2(x,y,z,zs,ze,windowWidth,dividerb,imgb,-1);
        }else if(z2 == windowFloor-1){
          drawSignX2(x,y,z,zs,ze,windowWidth,dividere,imge,1);
          drawSignX2(x,y,z,zs,ze,windowWidth,dividere,imge,-1);
        } 
      }else if(z2 == windowFloor){
        drawSignX(x,y,z,zs,ze,windowWidth,dividerb,dividere,imgb,imge,1);
        drawSignX(x,y,z,zs,ze,windowWidth,dividerb,dividere,imgb,imge,-1);
      }
    }else if(full >= 2){
      for(int x2 = 0; x2 < city2[y][x][z].wx; x2++){
        float xs = windowWidth*x2+edgeMargin+city2[y][x][z].wm*windowWidth;
        float xe = windowWidth*(x2+1)+edgeMargin-city2[y][x][z].wm*windowWidth;
        setShade4(city2[y][x][z].wb*0.7,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
        if(z2 == 0 && ((x2 == 0 && door == -1) || (x2 == city2[y][x][z].wx-1 && door == 1) || (x2 == int(city2[y][x][z].wx/2) && door == 0))){
          beginShape();
          vertex(xs*10,y3*10,veryBottom*10);
          vertex(xe*10,y3*10,veryBottom*10);
          vertex(xe*10,y3*10,ze*10);
          vertex(xs*10,y3*10,ze*10);
          endShape(CLOSE);
          setShade4(city2[y][x][z].wb*0.9,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
          beginShape();
          vertex(xs*10,y4*10,veryBottom*10);
          vertex(xe*10,y4*10,veryBottom*10);
          vertex(xe*10,y4*10,ze*10);
          vertex(xs*10,y4*10,ze*10);
          endShape(CLOSE);
        }else{
          beginShape();
          vertex(xs*10,y3*10,zs*10);
          vertex(xe*10,y3*10,zs*10);
          vertex(xe*10,y3*10,ze*10);
          vertex(xs*10,y3*10,ze*10);
          endShape(CLOSE);
          setShade4(city2[y][x][z].wb*0.9,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
          beginShape();
          vertex(xs*10,y4*10,zs*10);
          vertex(xe*10,y4*10,zs*10);
          vertex(xe*10,y4*10,ze*10);
          vertex(xs*10,y4*10,ze*10);
          endShape(CLOSE);
        }
      }
    }
  }
  float windowLength = (city2[y][x][z].l-edgeMargin*2)/city2[y][x][z].wy;
  windowHeight = (city2[y][x][z].h-edgeMargin*2)/city2[y][x][z].wz;
  float x3 = city2[y][x][z].w+roadHeight;
  float x4 = -roadHeight;
  for(int z2 = 0; z2 < city2[y][x][z].wz; z2++){
    float zs = windowHeight*z2+city2[y][x][z].wm*windowHeight+edgeMargin;
    float ze = -city2[y][x][z].wm*windowHeight+windowHeight*(z2+1)+edgeMargin;
    if(city2[y][x][z].name >= 1 && (z2 == windowFloor || (z2 == windowFloor-1 && multi))){
      if(multi){
        if(z2 == windowFloor){
          drawSignY2(x,y,z,zs,ze,windowLength,dividerb,imgb,1);
          drawSignY2(x,y,z,zs,ze,windowLength,dividerb,imgb,-1);
        }else if(z2 == windowFloor-1){
          drawSignY2(x,y,z,zs,ze,windowLength,dividere,imge,1);
          drawSignY2(x,y,z,zs,ze,windowLength,dividere,imge,-1);
        }
      }else if(z2 == windowFloor){
        drawSignY(x,y,z,zs,ze,windowLength,dividerb,dividere,imgb,imge,1);
        drawSignY(x,y,z,zs,ze,windowLength,dividerb,dividere,imgb,imge,-1);
      }
    }else if(full >= 2){
      for(int y2 = 0; y2 < city2[y][x][z].wy; y2++){
        float ys = city2[y][x][z].wm*windowLength+windowLength*y2+edgeMargin;
        float ye = -city2[y][x][z].wm*windowLength+windowLength*(y2+1)+edgeMargin;
        setShade4(city2[y][x][z].wb*0.6,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
        if(z2 == 0 && ((y2 == 0 && door == -1) || (y2 == city2[y][x][z].wy-1 && door == 1) || (y2 == int(city2[y][x][z].wy/2) && door == 0))){
          beginShape();
          vertex(x3*10,ys*10,veryBottom*10);
          vertex(x3*10,ye*10,veryBottom*10);
          vertex(x3*10,ye*10,ze*10);
          vertex(x3*10,ys*10,ze*10);
          endShape(CLOSE);
          setShade4(city2[y][x][z].wb*0.8,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
          beginShape();
          vertex(x4*10,ys*10,veryBottom*10);
          vertex(x4*10,ye*10,veryBottom*10);
          vertex(x4*10,ye*10,ze*10);
          vertex(x4*10,ys*10,ze*10);
          endShape(CLOSE);
        }else{
          beginShape();
          vertex(x3*10,ys*10,zs*10);
          vertex(x3*10,ye*10,zs*10);
          vertex(x3*10,ye*10,ze*10);
          vertex(x3*10,ys*10,ze*10);
          endShape(CLOSE);
          setShade4(city2[y][x][z].wb*0.8,x+city2[y][x][z].x,y+city2[y][x][z].y,(zs+ze)/2);
          beginShape();
          vertex(x4*10,ys*10,zs*10);
          vertex(x4*10,ye*10,zs*10);
          vertex(x4*10,ye*10,ze*10);
          vertex(x4*10,ys*10,ze*10);
          endShape(CLOSE);
        }
      }
    }
  }
  popMatrix();
}
class Van{
  float x,y,vx,vy,tiltX,tiltY;
  int dire,toTurnTimer,toDire;
  boolean b = false;
  float bridgeEndX = 0;
  float bridgeEndY = 0;
  float bridgeLength = 0;
  int[] c = {(int)random(0,255),(int)random(0,255),(int)random(0,255)};
  Van(float ix, float iy, float ivx, float ivy, float itx, float ity, int idire, int ittt, int itd){
    x = ix;
    y = iy;
    vx = ivx;
    vy = ivy;
    tiltX = itx;
    tiltY = ity;
    dire = idire;
    toTurnTimer = ittt;
    toDire = itd;
  }
}
class Building{
  float x, y, w, l, h, e, e2, wm, roof2;
  int[] c, c2, c3, f;
  int t, wx, wy, wz,wb,name, roof;
  Leaf[] leaves;
  Building(float ix, float iy, float iw, float il, float ih, float ie, float ie2, int[] ic, int[] ic2, int[] ic3, int[] tf, int it,
  int iwx, int iwy, int iwz, float iwm, int iwb, int iname, int iroof, float iroof2, Leaf[] ileaves){
    x = ix;
    y = iy;
    w = iw;
    l = il;
    h = ih;
    e = ie;
    e2 = ie2;
    c = ic;
    c2 = ic2;
    c3 = ic3;
    f = tf;
    t = it;
    wx = iwx;
    wy = iwy;
    wz = iwz;
    wm = iwm;
    wb = iwb;
    name = iname;
    roof = iroof;
    roof2 = iroof2;
    leaves = ileaves;
  }
}
class Leaf{
  float ang, shade, droop, w, l;
  Leaf(float iang, float ishade, float idroop, float iw, float il){
    ang = iang;
    shade = ishade;
    droop = idroop;
    w = iw;
    l = il;
  }
}
class Cloud{
  float x,y,z,r;
  Cloud(float ix, float iy, float iz, float ir){
    x = ix;
    y = iy;
    z = iz;
    r = ir;
  }
}
void setShade(int x, int y, int z, float shade){
  float maxColor = max(max(city2[y][x][z].c[0],city2[y][x][z].c[1]),city2[y][x][z].c[2]);
  float subtr = maxColor*(1-shade);
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  float tween = min(max(d/fog,0),1);
  int[] col = {int(city2[y][x][z].c[0]-subtr),int(city2[y][x][z].c[1]-subtr),int(city2[y][x][z].c[2]-subtr)};
  int[] bg2 = setBg2(x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e*slope+city2[y][x][z].h/2);
  fill(fogger(col,bg2,tween));
}
int[] setBg2(float x, float y, float z){
  PVector sun = new PVector(-200-cam[0],-200-cam[1],(sunHeight+75)-cam[2]);
  sun.normalize();
  PVector building = new PVector(x-cam[0],y-cam[1],z-cam[2]);
  building.normalize();
  float sunness = max (0, sun.dot(building));
  sunness = pow (sunness, 8);
  return foggerArray (bg, sunColor, sunness);
}
void setShade2(int x, int y, int z, float shade){
  float maxColor = max(max(city2[y][x][z].c3[0],city2[y][x][z].c3[1]),city2[y][x][z].c3[2]);
  float subtr = maxColor*(1-shade);
  float d = dist(x,y,elev[y][x]*slope,cam[0],cam[1],cam[2]);
  float tween = min(max(d/fog,0),1);
  int[] col = {int(city2[y][x][z].c3[0]-subtr),int(city2[y][x][z].c3[1]-subtr),int(city2[y][x][z].c3[2]-subtr)};
  int[] bg2 = setBg2(x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e*slope+city2[y][x][z].h/2);
  fill(fogger(col,bg2,tween));
}
void setShade3(int[] n, float shade,float x, float y, float z){
  float d = dist(x,y,z,cam[0],cam[1],cam[2]);
  float maxColor = max(max(n[0],n[1]),n[2]);
  float subtr = maxColor*(1-shade);
  float tween = min(max(d/fog,0),1);
  int[] col = {int(n[0]-subtr),int(n[1]-subtr),int(n[2]-subtr)};
  int[] bg2 = setBg2(x,y,z);
  fill(fogger(col,bg2,tween));
}
void setShade4(float n, float x, float y, float z){
  float d = dist(x,y,z,cam[0],cam[1],cam[2]);
  float tween = min(max(d/fog,0),1);
  int x2 = int(n);
  int[] col = {x2,x2,x2};
  int[] bg2 = setBg2(x,y,z);;
  fill(fogger(col,bg2,tween));
}
void setBlankBuilding(int x, int y, int z){
  int col[] = new int[0];
  Leaf[] leaves = new Leaf[0];
  city2[y][x][z] = new Building(0,0,1,1,1,1,0,col,col,col,col,0,1,1,1,1,10,0,0,0,leaves);
}
void setTint(int[] n,float shade,float x, float y, float z){
  float d = dist(x,y,z,cam[0],cam[1],cam[2]);
  float maxColor = max(max(n[0],n[1]),n[2]);
  float subtr = maxColor*(1-shade);
  float tween = min(max(d/fog,0),1);
  int[] col = {int(n[0]-subtr),int(n[1]-subtr),int(n[2]-subtr)};
  int[] bg2 = setBg2(x,y,z);
  tint(fogger(col,bg2,tween));
}
void setNewBuilding(int x, int y, int z){
  float h = 0;
  float w = 0;
  float l = 0;
  int wx, wy, wz;
  wx = wy = wz = 0;
  float wm = 0;
  int ty = 1;
  if(random(0,1) < 0.05) ty = 2;
  if(random(0,1) < 0.05) ty = 3;
  if(z >= buildingCount2){
    ty = 4;
    if(random(0,1) < 0.1) ty = 5;
    if(random(0,1) < 0.04 && city[y][x] > 0.12) ty = 6;
    if(random(0,1) < 0.04) ty = 7;
    if(random(0,1) < 0.06) ty = 8;
  }
  if(city[y][x] == cityMax && z == 0){
    ty = 9;
  }
  int roof = int(random(0,15));
  int bridge;
  boolean ok = true;
  float bridgeDensity = 0.24;
  if(z == 0 && city[y][x] >= 0){
    if(city[y][x+1] < 0 || !dry(x+1,y)){
      bridge = -10000;
      for(int x2 = x+1; x2 < min(x+16,299); x2++){
        if(bridges[y][x2]%2 == 1 || bridges[y-1][x2]%2 == 1){
          ok = false;
          break;
        } 
        if(city[y][x2] > 0 && dry(x2,y)){
          bridge = x2;
          break;
        }
      }
      if(bridge >= 0 && random(0,1) < bridgeDensity && ok){
        ty = 10;
        roof = bridge;
      }
    }else if(city[y+1][x] < 0 || !dry(x,y+1)){
      bridge = -10000;
      for(int y2 = y+1; y2 < min(y+16,299); y2++){
        if(bridges[y2][x] >= 2 || bridges[y2][x-1] >= 2){
          ok = false;
          break;
        } 
        if(city[y2][x] > 0 && dry(x,y2)){
          bridge = y2;
          break;
        }
      }
      if(bridge >= 0 && random(0,1) < bridgeDensity && ok){
        ty = 11;
        roof = bridge;
      }
    }
  }
  if(x == YNX && y == YNY && z >= 1){
    ty = max(int(random(0,9)),4);
  }
  float br = random(0.2,1);
  float br2;
  if(br < 0.45){
    br2 = random(0.8,1.0);
  }else{
    br2 = random(0,0.2);
  }
  int[] col = HSL2RGB(random(0,360),random(0,1),br);
  int[] col2 = HSL2RGB(random(0,360),random(0,1),br2);
  int[] col3;
  Leaf[] leaves = new Leaf[0];
  if(roof%9 <= 1){
    col3 = HSL2RGB(random(0,360),random(0,0.4),random(0.1,1));
  }else{
    if(random(0,1) < 0.5){
      col3 = new int[3];
      for(int i = 0; i < 3; i++){
        col3[i] = int(col[i]*0.6);
      }
    }else{
      col3 = HSL2RGB(random(0,360),random(0.1,0.9),random(0.1,0.7));
    }
  }
  int[] flowers = {0};
  int n = 0;
  boolean garden = (z >= 1 && city2[y][x][z-1].t == 2);
  if(garden || city[y][x] < 0){
    ty = 4;
  }
  if(ty == 1){
    h = random(0.1,0.1+city[y][x]*city[y][x]*5);
    if((roof == 8 && h < 0.4) || (roof == 7 && h < 0.3)) roof = 2+int(random(0,2));
    if(h > 0.5 && random(0,1) < 0.1) roof = 0;
    w = random(max(0.05, h*0.15),min(0.25,h*2));
    l = random(max(0.05, h*0.15),min(0.25,h*2));
    wx = max(round(random(w*18,w*40)),1);
    wy = max(round(random(l*18,l*40)),1);
    wz = max(round(random(h*22,h*26)),1);
    wm = random(0.05,0.18);
    if(h > 0.5 || random(0,1) < 0.7){
      int maxLength = min(int(max(w,l)*10)+1,3);
      int nb = int(random(0,40*maxLength));
      int ne =  int(random(0,40*maxLength));
      n = nb*120+ne;
    }else{
      n = 0;
    }
  }else if(ty == 2 || ty == 3){
    h = 1;
    w = random(0.15,0.5);
    l = random(0.15,0.5);
    if(ty == 2){
      col = HSL2RGB(random(90,130),random(0.5,0.8),random(0.3,0.7));
      flowers = new int[49];
      for(int i = 0; i < 49; i++){
        flowers[i] = max(int(random(-3,flowerColors.length+1)),0);
      }
    }else{
      int col4[] = {45,125,178};
      col = col4;
    }
  }else if(ty == 4){
    //if(city[y][x] < 0)
    col2 = HSL2RGB(random(20,40),random(0.3,0.9),random(0.1,0.35));
    if(roof < tree[0]){
      col = HSL2RGB(random(90,130),random(0.5,0.9),random(0.1,0.4));
      h = random(0.1,0.3);
      wm = random(0.005,0.01);
    }else if(roof < tree[1]){
      col = HSL2RGB(random(90,130),random(0.5,0.9),random(0.18,0.66));
      h = random(0.07,0.27);
      wm = random(0.0025,0.008);
    }else if(roof < tree[2]){
      col = HSL2RGB(random(105,130),random(0.5,0.9),random(0.2,0.3));
      h = random(0.02,0.035);
      wm = random(0.003,0.007);
    }else{
      col = HSL2RGB(random(320,350),random(0.55,0.75),random(0.7,0.9));
      h = random(0.07,0.12);
      wm = random(0.0035,0.008);
    }
    int leafCount2 = 1;
    if(roof < tree[0]){
      leafCount2 = leafCount;
    }else if(roof >= tree[1] && roof < tree[2]){
      leafCount2 = 12;
    }
    leaves = new Leaf[leafCount2];
    for(int i = 0; i < leafCount2; i++){
      float r;
      float lw = 1;
      float ang = 0;
      float droop = random(0,0.6);
      if(roof < tree[0]){
        float s = min(2.2-(2*float(i)/float(leafCount)),1);
        r = random(0.14*s,0.3*s);
        lw = random(0.06*s,0.14*s);
        ang = random(0,2*PI);
      }else if(roof >= tree[1] && roof < tree[2]){
        if(i < 4){
          r = random(0.012,0.025);
          lw = random(-0.013,0.013);
          ang = random(-0.013,0.013);
          droop = random(-0.0025,0.0075);
        }else{
          int j = int((i-4)/2);
          r = random(0.003,0.003);
          float parentAng = atan2(leaves[j].w,leaves[j].ang);
          float ang2 = parentAng+random(-PI*0.6,PI*0.6);
          float angUp = random(-PI*0.4,PI*0.4);
          ang = cos(ang2)*cos(angUp)*leaves[j].l;
          lw = sin(ang2)*cos(angUp)*leaves[j].l;
          droop = sin(angUp)*leaves[j].l;
          ang += leaves[j].ang;
          lw += leaves[j].w;
          droop += leaves[j].droop;
        }
      }else{
        r = pow(random(0,1),2)*0.05+0.025;
      }
      leaves[i] = new Leaf(ang,random(0.5,1),droop,lw,r);
    }
    w = wm;
    l = wm;
  }else if(ty == 5){
    w = 0.0001;
    l = 0.0001;
    h = random(0.13,0.4);
    wm = random(0,PI*2);
  }else if(ty == 9){
    w = 1-roadWidth;
    l = 1-roadWidth;
  }else if(ty == 10 || ty == 11){
    w = 0.0001;
    l = 0.0001;
    col3 = HSL2RGB(random(0,360),random(0,0.4),random(0,0.4));
  }
  float fx;
  float fy;
  if(ty >= 6 && ty <= 8){
    roof = int(random(0,4));
    if(roof <= 1){
      fy = roadWidth+0.02+0.96*float(roof)*(1-roadWidth);
      fx = random(roadWidth+0.02,0.96);
    }else{
      fx = roadWidth+0.02+0.96*float(roof-2)*(1-roadWidth);
      fy = random(roadWidth+0.02,0.96);
    }
    w = 0.0001;
    l = 0.0001;
    if(ty == 6){
      h = random(0.1,0.22);
      wm = random(roadWidth*0.3,roadWidth*0.7);
      col3 = HSL2RGB(random(0,360),random(0,0.4),random(0,0.4));
    }else if(ty == 7){
      h = random(0.08,0.2);
      wm = random(roadWidth*0.2,roadWidth*0.5);
      col3 = HSL2RGB(random(0,360),random(0,0.4),random(0,0.4));
    }else{
      h = random(0.12,0.25);
      wm = random(roadWidth*0.15,roadWidth*0.25);
      col3 = HSL2RGB(random(20,40),random(0.3,0.6),random(0.1,0.35));
      wx = -1 ;
      if(random(0,1) < 0.95){
        if(roof == 0 && water[y-1][x] == 0){
          for(int i = 0; i < city2[y-1][x].length; i++){
            if(city2[y-1][x][i].t == 8 && city2[y-1][x][i].roof == 1){
              wx = i;
            }
          }
        }else if(roof == 2 && water[y][x-1] == 0){
          for(int i = 0; i < city2[y][x-1].length; i++){
            if(city2[y][x-1][i].t == 8 && city2[y][x-1][i].roof == 3){
              wx = i;
            }
          }
        }
      }
      wy = int(random(5,20));
    }
  }else if(garden){
    Building c = city2[y][x][z-1];
    fx = random(c.x+c.w*0.3,c.x+c.w*0.7);
    fy = random(c.y+c.l*0.3,c.y+c.l*0.7);
  }else if(ty == 9){
    fx = roadWidth;
    fy = roadWidth;
    setYNCoords();
  }else{
    float minX = roadWidth;
    float maxX = 1-w;
    float minY = roadWidth;
    float maxY = 1-l;
    if(city[y][x] <= 0){
      if(y > 0 && x > 0 && city[y-1][x] > 0 && city[y][x-1] > 0 && dry(x,y-1) && dry(x-1,y)){
      }else if(y > 0 && city[y-1][x] > 0 && dry(x,y-1)){
        minY = 0;
      }else if(x > 0 && city[y][x-1] > 0 && dry(x-1,y)){
        minX = 0;
      }else{
        minY = 0;
        minX = 0;
      }
    }
    fx = random(minX,maxX);
    fy = random(minY,maxY);
    if(city[y][x] <= 0 && y > 0 && x > 0 && city[y-1][x-1] > 0 && dry(x-1,y-1) && minX == 0 && minY == 0 && fx < roadWidth && fy < roadWidth){
      fx = 1-(1-fx)*(1-roadWidth);
    }
  }
  float high = 0;
  float low = 1;
  if(ty == 9){
    for(int x2 = 0; x2 < 3; x2++){
      for(int y2 = 0; y2 < 3; y2++){
        float e = elev[y+y2][x+x2];
        if(e > high) high = e;
        if(e < low) low = e;
      }
    }
  }else{
    high = getExtremeElev(x,y,fx,fy,w,l,1);
    low = getExtremeElev(x,y,fx,fy,w,l,-1);
  }
  if(ty == 10){
     for(int x2 = x+1; x2 < roof; x2++){
      bridges[y][x2] += 1;
    } 
  }else if(ty == 11){
    for(int y2 = y+1; y2 < roof; y2++){
      bridges[y2][x] += 2;
    }
  }
  city2[y][x][z] = new Building(fx,fy,w,
  l,h,high,low,col,col2,col3,flowers,ty,wx,wy,wz,wm,int(random(10,100)),
  n, roof, random(0,1),leaves);
}
boolean collides(int x, int y, int z){
  if(z == 0) return false;
  for(int z2 = 0; z2 < z; z2++){
    if(city2[y][x][z].t == 4 && z2 == z-1 && city2[y][x][z-1].t == 2){
    }else if(city2[y][x][z2].t == 9){
    }else{
      if (city2[y][x][z].x+city2[y][x][z].w >= city2[y][x][z2].x &&
      city2[y][x][z2].x+city2[y][x][z2].w >= city2[y][x][z].x &&
      city2[y][x][z].y+city2[y][x][z].l >= city2[y][x][z2].y &&
      city2[y][x][z2].y+city2[y][x][z2].l >= city2[y][x][z].y){
        return true;
      }
    }
  }
  return false;
}
void setYNCoords(){
  float cylHeight = 3;
  float cylSpace = 0.3;
  float cylWidth = 0.17;
  for(int tx = 0; tx <= 1; tx++){
    for(int ty = 0; ty <= 1; ty++){
      for(int h = 0; h < 91; h++){
        cylWidth = 0.075+h*0.0005;
        for(int ang = 0; ang < 33; ang++){
          float ang1 = float(ang)*PI/16;
          float out = max(pow(0.98,h)-0.2,0)*1.75;
          YNCoords[tx][ty][h][ang][0] = (float(tx*2-1)*cylSpace*out+cos(ang1)*cylWidth)*10;
          YNCoords[tx][ty][h][ang][1] = (float(ty*2-1)*cylSpace*out+sin(ang1)*cylWidth)*10;
          YNCoords[tx][ty][h][ang][2] = cylHeight*(float(h)/90)*10;
          YNCoords[tx][ty][h][ang][3] = abs(ang1-PI)*30+60;
        }
      }
    }
  }
}
int[] HSL2RGB(float hue, float sat, float lum){
    float v;
    float red, green, blue;
    float m;
    float sv;
    int sextant;
    float fract, vsf, mid1, mid2;
 
    red = lum;   // default to gray
    green = lum;
    blue = lum;
    v = (lum <= 0.5) ? (lum * (1.0 + sat)) : (lum + sat - lum * sat);
    m = lum + lum - v;
    sv = (v - m) / v;
    hue /= 60.0;  //get into range 0..6
    sextant = floor(hue);  // int32 rounds up or down.
    fract = hue - sextant;
    vsf = v * sv * fract;
    mid1 = m + vsf;
    mid2 = v - vsf;
 
    if (v > 0){
        switch (sextant){
            case 0: red = v; green = mid1; blue = m; break;
            case 1: red = mid2; green = v; blue = m; break;
            case 2: red = m; green = v; blue = mid1; break;
            case 3: red = m; green = mid2; blue = v; break;
            case 4: red = mid1; green = m; blue = v; break;
            case 5: red = v; green = m; blue = mid2; break;
        }
    }
    int col[] = {int(red*255),int(green*255),int(blue*255)};
    return col;
}
float getElev(int ix, int iy, float fx, float fy){
  float z;
  if(tri[iy][ix]){
    if(fx+fy < 1.0){
      float d = fx+fy;
      float a = inter(elev[iy][ix],elev[iy][ix+1],d);
      float b = inter(elev[iy][ix],elev[iy+1][ix],d);
      z = inter(b,a,fx/d);
    }else{
      float d = (1-fx)+(1-fy);
      float a = inter(elev[iy+1][ix+1],elev[iy+1][ix],d);
      float b = inter(elev[iy+1][ix+1],elev[iy][ix+1],d);
      z = inter(b,a,(1-fx)/d);
    }
  }else{
    if((1-fx)+fy < 1.0){
      float d = (1-fx)+fy;
      float a = inter(elev[iy][ix+1],elev[iy][ix],d);
      float b = inter(elev[iy][ix+1],elev[iy+1][ix+1],d);
      z = inter(b,a,(1-fx)/d);
    }else{
      float d = fx+(1-fy);
      float a = inter(elev[iy+1][ix],elev[iy+1][ix+1],d);
      float b = inter(elev[iy+1][ix],elev[iy][ix],d);
      z = inter(b,a,fx/d);
    }
  }
  return z;
}
float getElev2(int x, int y){
  int x2 = x%2;
  int y2 = y%2;
  int x3 = int(x/2);
  int y3 = int(y/2);
  int x4 = min(int(x/2)+1,w-1);
  int y4 = min(int(y/2)+1,h-1);
  if(x2 == 0 && y2 == 0){
    return elev[y3][x3];
  }else if(x2 == 0 && y2 == 1){
    return (elev[y3][x3]+elev[y4][x3])/2.0;
  }else if(x2 == 1 && y2 == 0){
    return (elev[y3][x3]+elev[y3][x4])/2.0;
  }else if(x2 == 1 && y2 == 1){
    float avg0000 = (elev[y3][x3]+elev[y4][x4])/2.0;
    float avg0110 = (elev[y4][x3]+elev[y3][x4])/2.0;
    return min(avg0000,avg0110);
  }
  return elev[y3][x3];
}
float getExtremeElev(int ix,int iy,float fx, float fy, float w, float l, float sign){
  float ground = -sign*10000;
  for(int ax = 0; ax < 2; ax++){
    for(int ay = 0; ay < 2; ay++){
      float e = getElev(ix,iy,fx+w*ax,fy+l*ay);
      if(e*sign > ground*sign) ground = e;
    }
  }
  return ground;
}
color fill2(int x, int y){
  if(full == 0){
    if(city[y][x] > 0){
      return color(40,40,40);
    }else{
      return color(0,120,0);
    }
  }else{
    return fogged(x,y,false);
  }
}
void drawLand(int x, int y){
  if(tri[y][x]){
    beginShape();
    fill(fill2(x,y));
    vertex(x,y,elev[y][x]*slope);
    fill(fill2(x+1,y));
    vertex(x+1,y,elev[y][x+1]*slope);
    fill(fill2(x,y+1));
    vertex(x,y+1,elev[y+1][x]*slope);
    endShape(CLOSE);
    
    beginShape();
    fill(fill2(x+1,y+1));
    vertex(x+1,y+1,elev[y+1][x+1]*slope);
    fill(fill2(x+1,y));
    vertex(x+1,y,elev[y][x+1]*slope);
    fill(fill2(x,y+1));
    vertex(x,y+1,elev[y+1][x]*slope);
    endShape(CLOSE);
  }else{
    beginShape();
    fill(fill2(x,y));
    vertex(x,y,elev[y][x]*slope);
    fill(fill2(x+1,y));
    vertex(x+1,y,elev[y][x+1]*slope);
    fill(fill2(x+1,y+1));
    vertex(x+1,y+1,elev[y+1][x+1]*slope);
    endShape(CLOSE);
    
    beginShape();
    fill(fill2(x+1,y+1));
    vertex(x+1,y+1,elev[y+1][x+1]*slope);
    fill(fill2(x,y));
    vertex(x,y,elev[y][x]*slope);
    fill(fill2(x,y+1));
    vertex(x,y+1,elev[y+1][x]*slope);
    endShape(CLOSE);
  }
  if(x == w/2+5 && y >= int(sludgeProg)){
    float e00 = elev[y][x];
    float e01 = elev[y][x+1];
    float e10 = elev[y+1][x];
    float e11 = elev[y+1][x+1];
    float wayz = 0;
    float lineWayz = 0;
    if(y == int(sludgeProg)) wayz = sludgeProg-int(sludgeProg);
    if(y == int(sludgeProg+0.06)) lineWayz = (sludgeProg+0.06)-int(sludgeProg+0.06);
    /*setShade4(150,x,y,elev[y][x]*slope);
    pushMatrix();
    translate(x,y,0);
    scale(0.1);
    if(y >= int(sludgeProg+0.06)){
      if(lineWayz == 0){
        beginShape();
        vertex(roadWidth*0.67*10,0,(inter(e00,e01,roadWidth*0.67)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.73*10,0,(inter(e00,e01,roadWidth*0.73)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.73*10,10,(inter(e10,e11,roadWidth*0.73)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.67*10,10,(inter(e10,e11,roadWidth*0.67)*slope+roadHeight*0.3)*10);
        endShape();
      }else{
        beginShape();
        vertex(roadWidth*0.67*10,lineWayz*10,(inter(inter(e00,e01,roadWidth*0.67),inter(e10,e11,roadWidth*0.67),lineWayz)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.73*10,lineWayz*10,(inter(inter(e00,e01,roadWidth*0.73),inter(e10,e11,roadWidth*0.73),lineWayz)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.73*10,10,(inter(e10,e11,roadWidth*0.73)*slope+roadHeight*0.3)*10);
        vertex(roadWidth*0.67*10,10,(inter(e10,e11,roadWidth*0.67)*slope+roadHeight*0.3)*10);
        endShape();
      }
    }
    popMatrix();*/
    if(y == int(sludgeProg)){  
      pushMatrix();
      float xBot = x+roadWidth*0.52;
      float yBot = y+wayz;
      float zBot = (inter(inter(e00,e01,roadWidth*0.52),inter(e10,e11,roadWidth*0.52),wayz)*slope+roadHeight);
      translate(xBot,yBot,zBot);
      scale(0.0007);
      scale(-1,-1,1);
      rotateX(atan2((e00-e10)*slope,1));
      rotateY(-atan2((e00-e01)*slope,1));
      //van.draw();
      
      float s = 5;
      float sRad = 1.3;
      float vibrate = 0.18;
      float tireHeight = sRad*0.9-abs((timer%6)-3)*vibrate;
      int[] c = {60,60,60};
      //drawBlockRaw(0,0,s,s,0+tireHeight,s*2,xBot,yBot,zBot,c,true,false);
      translate(0,0,sRad*1.55);
      
      beginShape();
      texture(robotFace[timer%40]);
      vertex(s,s,s*2+tireHeight,0,0);
      vertex(-s,s,s*2+tireHeight,600,0);
      vertex(-s,s,0+tireHeight,600,600);
      vertex(s,s,0+tireHeight,0,600);
      endShape();
      
      beginShape();
      texture(robotBack);
      vertex(s,-s,s*2+tireHeight,0,0);
      vertex(-s,-s,s*2+tireHeight,600,0);
      vertex(-s,-s,0+tireHeight,600,600);
      vertex(s,-s,0+tireHeight,0,600);
      endShape();
      
      beginShape();
      texture(robotSide);
      vertex(s,s,s*2+tireHeight,0,0);
      vertex(s,-s,s*2+tireHeight,600,0);
      vertex(s,-s,0+tireHeight,600,600);
      vertex(s,s,0+tireHeight,0,600);
      endShape();
      
      beginShape();
      texture(robotSide);
      vertex(-s,-s,s*2+tireHeight,0,0);
      vertex(-s,s,s*2+tireHeight,600,0);
      vertex(-s,s,0+tireHeight,600,600);
      vertex(-s,-s,0+tireHeight,0,600);
      endShape();
      
      beginShape();
      texture(robotTop);
      vertex(s,s,s*2+tireHeight,0,0);
      vertex(-s,s,s*2+tireHeight,600,0);
      vertex(-s,-s,s*2+tireHeight,600,600);
      vertex(s,-s,s*2+tireHeight,0,600);
      endShape();
      int[] cBot = {200,200,200};
      setShade3(cBot,1.0,xBot,yBot,zBot);
      
      sphereDetail(30);
      
      float prog = (timer%14)/14.0;
      
      float heightA = abs(sin(prog*PI))*s*3;
      float heightB = abs(sin(prog*PI))*s;
      float heightC = abs(sin(prog*PI))*s*2;
      
      float offsetA = prog*s*4/3;
      float offsetB = -prog*s*2/3;
      float offsetC = -prog*s*2/3;
      
      lights();
      directionalLight(58,65,80, -1, -1, -1);
      ambientLight(78,85,100, -1, -1, -1);
      translate(-s*2/3+offsetA,s*2/3,s*2.2+heightA+tireHeight);
      sphere(s/4);
      translate(s*2/3+offsetB-offsetA,0,heightB-heightA);
      sphere(s/4);
      translate(s*2/3+offsetC-offsetB,0,heightC-heightB);
      sphere(s/4);
      
      translate(-s*2/3-offsetC,-s*2/3,-heightC-s*2.2-tireHeight);
      sphereDetail(9);
      noLights();
      
      int[] cBot2 = {100,60,20};
      setShade3(cBot2,1.0,xBot,yBot,zBot);
      translate(s-sRad,s-sRad,0);
      
      drawWheel(sRad,sRad*0.8);
      translate(-s*2+sRad*2,0,0);
      drawWheel(sRad,sRad*0.8);
      translate(0,-s*2+sRad*2,0);
      drawWheel(sRad,sRad*0.8);
      translate(s*2-sRad*2,0,0);
      drawWheel(sRad,sRad*0.8);

      popMatrix();
      ambient(0);
      specular(0); 
    }
  }
}
void drawWheel2(float r, float w){
  scale(0.01);
  drawWheel(r*100, w*100);
  scale(100);
}
void drawWheel(float r, float w){
  for(int i = 0; i < 32; i++){
    float ang1 = i/16.0*PI;
    float ang2 = (i+1)/16.0*PI;
    fill(((i+timer)%4)*25);
    beginShape();
    vertex(-w,cos(ang1)*r,sin(ang1)*r);
    vertex(-w,cos(ang2)*r,sin(ang2)*r);
    vertex(w,cos(ang2)*r,sin(ang2)*r);
    vertex(w,cos(ang1)*r,sin(ang1)*r);
    endShape();
    
    beginShape();
    vertex(-w,cos(ang1)*r,sin(ang1)*r);
    vertex(-w,cos(ang2)*r,sin(ang2)*r);
    vertex(-w*1.05,0,0);
    endShape();
    beginShape();
    vertex(w,cos(ang1)*r,sin(ang1)*r);
    vertex(w,cos(ang2)*r,sin(ang2)*r);
    vertex(w*1.05,0,0);
    endShape();
  }
  fill(140);
  for(int i = 0; i < 16; i++){
    float ang1 = i/8.0*PI;
    float ang2 = (i+1)/8.0*PI;
    
    beginShape();
    vertex(-w*1.05,cos(ang1)*r*0.5,sin(ang1)*r*0.5);
    vertex(-w*1.05,cos(ang2)*r*0.5,sin(ang2)*r*0.5);
    vertex(-w*1.1,0,0);
    endShape();
    beginShape();
    vertex(w*1.05,cos(ang1)*r*0.5,sin(ang1)*r*0.5);
    vertex(w*1.05,cos(ang2)*r*0.5,sin(ang2)*r*0.5);
    vertex(w*1.1,0,0);
    endShape();
  }
}
void drawWater(int x, int y){
  beginShape();
  fill(fogged(x,y,true));
  vertex(x,y,(elev[y][x]+water[y][x])*slope);
  fill(fogged(x+1,y,true));
  vertex(x+1,y,(elev[y][x+1]+water[y][x+1])*slope);
  fill(fogged(x+1,y+1,true));
  vertex(x+1,y+1,(elev[y+1][x+1]+water[y+1][x+1])*slope);
  fill(fogged(x,y+1,true));
  vertex(x,y+1,(elev[y+1][x]+water[y+1][x])*slope);
  endShape(CLOSE);
}
void drawBlobTree(int x, int y){
  float e00 = getElev2(x,y)*slope;
  float e01 = getElev2(x+1,y)*slope;
  float e11 = getElev2(x+1,y+1)*slope;
  float e10 = getElev2(x,y+1)*slope;
  beginShape();
  setShade3(treeColor,treeTileColors[y][x],float(x)/2,float(y)/2,trees[y][x]*slope+e00);
  vertex(float(x)/2,float(y)/2,trees[y][x]*slope+e00);
  setShade3(treeColor,treeTileColors[y][x+1],float(x+1)/2,float(y)/2,trees[y][x+1]*slope+e01);
  vertex(float(x+1)/2,float(y)/2,trees[y][x+1]*slope+e01);
  setShade3(treeColor,treeTileColors[y+1][x+1],float(x+1)/2,float(y+1)/2,trees[y+1][x+1]*slope+e11);
  vertex(float(x+1)/2,float(y+1)/2,trees[y+1][x+1]*slope+e11);
  setShade3(treeColor,treeTileColors[y+1][x],float(x)/2,float(y+1)/2,trees[y+1][x]*slope+e10);
  vertex(float(x)/2,float(y+1)/2,trees[y+1][x]*slope+e10);
  endShape(CLOSE);
}
void drawSignX(int x, int y, int z, float zs,  float ze, float windowWidth,
float dividerb, float dividere, PImage imgb, PImage imge, int side){
  float s = (side+1)/2;
  float y3 = city2[y][x][z].l*s+roadHeight*side;
  float xw = city2[y][x][z].w;
  float p1 = xw*(1-s);
  float p2 = xw*(1-s+dividerb*side);
  float p3 = xw*(1-s+dividere*side);
  float p4 = xw*s;
  setTint(city2[y][x][z].c2,1,x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e+city2[y][x][z].h/2);
  beginShape();
  texture(imgb);
  vertex(p1*10,y3*10,zs*10,0,imgb.height);
  vertex(p2*10,y3*10,zs*10,imgb.width,imgb.height);
  vertex(p2*10,y3*10,ze*10,imgb.width,0);
  vertex(p1*10,y3*10,ze*10,0,0);
  endShape(CLOSE);
  beginShape();
  texture(imge);
  vertex(p3*10,y3*10,zs*10,0,imge.height);
  vertex(p4*10,y3*10,zs*10,imge.width,imge.height);
  vertex(p4*10,y3*10,ze*10,imge.width,0);
  vertex(p3*10,y3*10,ze*10,0,0);
  endShape(CLOSE);
  noTint();
}
void drawSignY(int x, int y, int z, float zs,  float ze, float windowLength,
float dividerb, float dividere, PImage imgb, PImage imge, int side){
  float s = (side+1)/2;
  float x3 = city2[y][x][z].w*s+roadHeight*side;
  float yw = city2[y][x][z].l;
  float p4 = yw*(1-s);
  float p3 = yw*(s-dividere*side);
  float p2 = yw*(s-dividerb*side);
  float p1 = yw*s;
  setTint(city2[y][x][z].c2,1,x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e+city2[y][x][z].h/2);
  beginShape();
  texture(imgb);
  vertex(x3*10,p1*10,zs*10,0,imgb.height);
  vertex(x3*10,p2*10,zs*10,imgb.width,imgb.height);
  vertex(x3*10,p2*10,ze*10,imgb.width,0);
  vertex(x3*10,p1*10,ze*10,0,0);
  endShape(CLOSE);
  beginShape();
  texture(imge);
  vertex(x3*10,p3*10,zs*10,0,imge.height);
  vertex(x3*10,p4*10,zs*10,imge.width,imge.height);
  vertex(x3*10,p4*10,ze*10,imge.width,0);
  vertex(x3*10,p3*10,ze*10,0,0);
  endShape(CLOSE);
  noTint();
}
void drawSignX2(int x, int y, int z, float zs,  float ze, float windowWidth,
float divide, PImage imgb, int side){
  float s = (side+1)/2;
  float y3 = city2[y][x][z].l*s+roadHeight*side;
  float xw = city2[y][x][z].w;
  float p1 = xw*(1-s);
  float p4 = xw*s-(side*(divide))*xw;
  setTint(city2[y][x][z].c2,1,x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e+city2[y][x][z].h/2);
  beginShape();
  texture(imgb);
  vertex(p1*10,y3*10,zs*10,0,imgb.height);
  vertex(p4*10,y3*10,zs*10,imgb.width,imgb.height);
  vertex(p4*10,y3*10,ze*10,imgb.width,0);
  vertex(p1*10,y3*10,ze*10,0,0);
  endShape(CLOSE);
  noTint();
}
void drawSignY2(int x, int y, int z, float zs,  float ze, float windowLength,
float divide,PImage imgb,int side){
  float s = (side+1)/2;
  float x3 = city2[y][x][z].w*s+roadHeight*side;
  float yw = city2[y][x][z].l;
  float p4 = yw*(1-s)+(side*(divide))*yw;
  float p1 = yw*s;
  setTint(city2[y][x][z].c2,1,x+city2[y][x][z].x,y+city2[y][x][z].y,city2[y][x][z].e+city2[y][x][z].h/2);
  beginShape();
  texture(imgb);
  vertex(x3*10,p1*10,zs*10,0,imgb.height);
  vertex(x3*10,p4*10,zs*10,imgb.width,imgb.height);
  vertex(x3*10,p4*10,ze*10,imgb.width,0);
  vertex(x3*10,p1*10,ze*10,0,0);
  endShape(CLOSE);
  noTint();
}
float getDim(int dim, int t, float s){
  int t0 = max(0,t-1);
  int t1 = min(camCoor.length-1,t);
  int t2 = min(camCoor.length-1,t+1);
  int t3 = min(camCoor.length-1,t+2);
  
  if(camCoor[t0][10] == 1){
    t0 = t1;
  }
  if(camCoor[t1][10] == 1){
    t2 = t1;
    t3 = t1;
  }
  if(camCoor[t2][10] == 1){
    t3 = t2;
  }
  return 0.5*((2*camCoor[t1][dim])+(-camCoor[t0][dim]+camCoor[t2][dim])*s
  +(2*camCoor[t0][dim]-5*camCoor[t1][dim]+4*camCoor[t2][dim]-camCoor[t3][dim])*s*s+
  (-camCoor[t0][dim]+3*camCoor[t1][dim]-3*camCoor[t2][dim]+camCoor[t3][dim])*s*s*s);
}
