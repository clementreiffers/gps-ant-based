void setup() {
  //size(500, 500);
  fullScreen();
  background(color(0));
  //size(300,300);
  smooth();
}

class Population {  
  //initalisation du labyrinthe
  int nbr_m = 20;
  int labyposx[]=new int[1000];
  int labyposy[]=new int[1000];
  int labylong[]=new int[1000];
  int labylarg[]=new int[1000];

  //initialisation du tresor 
  int tx = mouseX;
  int ty = mouseY;
  int taille_tresor = 100;
  boolean verify = false;
  color couleur;

  //initialisation des voitures
  int taille = 10;
  int nbr = 10000;
  int[] positionsx = new int[nbr];
  int[] positionsy = new int[nbr];
  int[] dx = new int[nbr];
  int[] dy = new int[nbr];
  int[] sx = new int[nbr];
  int[] sy = new int[nbr];
  int max_vitesse = 5;
  int[][] nombre_points = new int[nbr][1];


  //pour enregistrement du trajet
  int[][] trajetx = new int[nbr][nbr];
  int[][] trajety = new int[nbr][nbr];
  int e = 0;
  int bon_trajet = 0;


  Population(int nombre, int x, int y, color c) {  
    nbr = nombre;
    //s pour étaler la zone de spawn
    int s = 0; 
    couleur = c;
    for (int i=0; i<nombre; i++) {
      if (s<nombre/4) {
        positionsx[i] = x;
        positionsy[i] = y;
        s++;
      }
      if (s<nombre/2 && s>=nombre/4) {
        positionsx[i] = x+30;
        positionsy[i] = y;
        s++;
      }
      if (s<nombre/4*3&&s>=nombre/2) {
        positionsx[i] = x;
        positionsy[i] = y+30;
        s++;
      }
      if (s<nombre&&s>=nombre/4*3) {
        positionsx[i] = x+30;
        positionsy[i] = y+30;
        s++;
      } else {
        positionsx[i] = x+30;
        positionsy[i] = y+30;
      }
      dx[i]=int(random(1, max_vitesse));
      dy[i]=int(random(1, max_vitesse));
      sx[i]=signe();
      sy[i]=signe();
    }
    int i = 0;
    int n = 0;
    while (i<nbr_m) {
      if (n<int(nbr_m/4)) {
        labyposx[i] = int(random(0, 500));
        labyposy[i] = int(random(0, 500));
        labylong[i] = int(random(2*max_vitesse, 500));
        labylarg[i] = int(random(2*max_vitesse, 500));
        n++;
      }
      if (n<int(nbr_m/4)*2&&n>=int(nbr_m/4)) {
        labyposx[i] = int(random(500, 1000));
        labyposy[i] = int(random(0, 500));
        labylong[i] = int(random(2*max_vitesse, 300));
        labylarg[i] = int(random(2*max_vitesse, 300));
        n++;
      }
      if (n<int(nbr_m/4)*3&&n>=int(nbr_m/4)*2) {
        labyposx[i] = int(random(0, 500));
        labyposy[i] = int(random(500, 500));
        labylong[i] = int(random(2*max_vitesse, 300));
        labylarg[i] = int(random(2*max_vitesse, 100));
        n++;
      }      
      if (n<nbr_m&&n>=int(nbr_m/4)*3) {
        labyposx[i] = int(random(500, 1000));
        labyposy[i] = int(random(500, 1000));
        labylong[i] = int(random(2*max_vitesse, 300));
        labylarg[i] = int(random(2*max_vitesse, 300));
        n++;
      }
      i++;
    }
  }

  void bouger() {
    for (int i =0; i<nbr; i++) {
      if (positionsx[i]>tx && positionsx[i]<tx+taille_tresor) {
        if (positionsy[i]>ty && positionsy[i]<ty+taille_tresor) {
          bon_trajet = i;
          verify = true;
        }
      }
      trajetx[i][e] = positionsx[i];
      trajety[i][e] = positionsy[i];
      positionsy[i] = positionsy[i]+dy[i]*sy[i];
      positionsx[i] = positionsx[i]+dx[i]*sx[i];
      nombre_points[i][0]++;

      //pour vérifier les bords de l'écran
      if (positionsx[i]>width-taille-max_vitesse || positionsx[i]< max_vitesse) {
        sx[i] = -sx[i];
        dx[i] = int(random(1, max_vitesse));
      }  
      if (positionsy[i]>height-taille-max_vitesse || positionsy[i]< max_vitesse) {
        sy[i] = -sy[i];
        dy[i]= int(random(1, max_vitesse));
      }
      //pour vérifier les bords des obstacles
      int n =0;
      while (n<nbr_m) {
        if (positionsx[i]>labyposx[n]&& positionsx[i]<labyposx[n]+labylong[n]-taille /*|| positionsy[i]+dy[i]>labyposy[n]+taille && positionsy[i]+dy[i]<labyposy[n]+labylarg[n]+taille*/) {
          if (positionsy[i]>labyposy[n]+taille) {
            sy[i] = -sy[i];
            //dy[i]= int(random(1, max_vitesse));
          }     
          if (positionsy[i]>labyposy[n]+labylarg[n]+taille) {
            sy[i] = -sy[i];
            //dy[i]= int(random(1, max_vitesse));
          }
        } 
        if (positionsy[i]>labyposy[n]-taille && positionsy[i]<labyposy[n]+labylarg[n]) {
          if (positionsx[i]>labyposx[n]-taille) {
            sx[i] = -sx[i];
            //dx[i] = int(random(1, max_vitesse));
            //positionsx[i] = positionsx[i]+dx[i]*sx[i];
          }     
          if (positionsx[i]>labyposx[n]+labylong[n]) {
            sx[i] = -sx[i];
            //dx[i] = int(random(1, max_vitesse));
            //positionsx[i] = positionsx[i]+dx[i]*sx[i];
          }
        }
        n++;
      }
    }
    e++;
  }
  void dessiner() {
    for (int i=0; i<nbr; i++) {
      fill(couleur);
      rect(positionsx[i], positionsy[i], taille, taille);
    }
  }
  void dessiner_voiture_principale() {
    for (int i=0; i<e; i++) {
      //background(color(0));
      tr.dessiner();
      dessiner_laby();
      fill(couleur);
      rect(trajetx[bon_trajet][i], trajety[bon_trajet][i], taille, taille);
    }
  }
}
class Tresor {
  int tx, ty, tt;
  Tresor(int x, int y, int taille) {
    tx = x;
    ty = y;
    tt = taille;
  }
  void dessiner() {
    fill(color(255, 0, 0));
    rect(tx, ty, tt, tt);
  }
}
int nombre = 1000;

color red = color(255, 0, 0);
int ppol_x = 100, ppol_y = 800, tx, ty;
Population chose1 = new Population(nombre, ppol_x, ppol_y, red); //nombre, x, y
Tresor tr = new Tresor(chose1.tx, chose1.ty, chose1.taille_tresor);

/* ajout */
color green = color(0, 255, 0);
int ppol_x2 = 700, ppol_y2, tx2, ty2;
Population chose2 = new Population(nombre, chose1.tx, chose1.ty, green);
Tresor tr2 = new Tresor(ppol_x, ppol_y, chose2.taille_tresor);
/**/
//pour comparer les chemins
int ch1=0, ch2 = 0;
boolean term1 = false, term2 = false;
//pour image
color white = color(255);

void dessiner_logo() {
  
  fill(100);
  rect(width-400, 0, 500, 100);
  PImage dara;
  dara = loadImage("DARA.png");
  
  int taille_img = 100;
  image(dara, width-taille_img, 0, taille_img, taille_img);
  fill(white);
  textSize(20);
  textAlign(RIGHT);
  text("démarrer : ↑", width-taille_img, 30);
  text("afficher le meilleur chemin : ↓", width-taille_img, 60);
  text("afficher le mappage : ←", width-taille_img, 90);
}

void dessiner_laby() {
  int i =0;
  while (i<=chose1.nbr_m) {
    noStroke();
    fill(color(255));
    rect(chose1.labyposx[i], chose1.labyposy[i], chose1.labylong[i]-chose1.max_vitesse, chose1.labylarg[i]+chose1.max_vitesse);
    i++;
  }
  fill(color(0, 255, 255));
  rect(ppol_x, ppol_y, 50, 50);
  /* ajout */
  rect(chose1.tx, chose1.ty, 50, 50);
  //dessiner_logo();
  /**/
}
int signe() {
  int a = 0;
  while (a==0) {
    a = int(random(-2, 2));
  }
  return a;
}
void draw() {
  /*
  fill(red);
   text("↑ : pour démarrer", 800,10);
   text("↓ : pour affichier quel est le meilleur chemin", 800,20);
   text("← : pour afficher le mappage", 800,30);*/
  for (int i = 0; i<chose1.nbr_m; i++) {
    chose2.labyposx[i]=chose1.labyposx[i];
    chose2.labyposy[i]=chose1.labyposy[i];
    chose2.labylong[i]=chose1.labylong[i];
    chose2.labylarg[i]=chose1.labylarg[i];
  }
  if (key == CODED) {
    if (keyCode == UP) {
      background(color(0));
      tr.dessiner();
      tr2.dessiner();
      if (chose1.verify!=true) {
        chose1.bouger();
        chose1.dessiner();
        dessiner_laby();
      }
      if (chose2.verify!= true) {
        /*ajout*/
        chose2.bouger();
        chose2.dessiner();
        dessiner_laby();
        /**/
      }
      if (chose1.verify &&chose2.verify) {
        chose1.dessiner_voiture_principale();
        chose2.dessiner_voiture_principale();
      }
    }
  } else {
    background(0);
    dessiner_laby();
    fill(color(255, 0, 0));
    rect(mouseX, mouseY, chose1.taille_tresor, chose1.taille_tresor);
    tx = mouseX;
    ty = mouseY;
    chose1.tx = tx;
    chose1.ty = ty;
    /*ajout*/
    chose2.tx = ppol_x;
    chose2.ty = ppol_y;
    for (int i=0; i<=nombre; i++) {
      chose2.positionsx[i]=mouseX;
      chose2.positionsy[i]=mouseY;
    }
    /**/
    tr.tx = tx;
    tr.ty = ty;
  }
  if (key == CODED) { 
    if (keyCode==DOWN) {
      textAlign(CENTER);
      textSize(100);
      if (chose1.nombre_points[chose1.bon_trajet][0]<chose2.nombre_points[chose2.bon_trajet][0]) {   
        background(0);
        chose1.dessiner_voiture_principale();
        chose2.dessiner_voiture_principale();
        dessiner_laby();
        tr.dessiner();
        tr2.dessiner();
        fill(red);
        text("prenez le chemin rouge !", 800, 500);
        text(str(chose1.nombre_points[chose1.bon_trajet][0]) + " points pour le chemin rouge", 800, 600);
        text(str(chose2.nombre_points[chose2.bon_trajet][0]) + " points pour le chemin vert", 800, 700);
      }
      if (chose1.nombre_points[chose1.bon_trajet][0]>chose2.nombre_points[chose2.bon_trajet][0]) {   
        background(0);
        chose1.dessiner_voiture_principale();
        chose2.dessiner_voiture_principale();
        dessiner_laby();
        tr.dessiner();
        tr2.dessiner();
        fill(green);
        text("prenez le chemin vert !", 800, 500);
        text(str(chose1.nombre_points[chose1.bon_trajet][0]) + " points pour le chemin rouge", 800, 600);
        text(str(chose2.nombre_points[chose2.bon_trajet][0]) + " points pour le chemin vert", 800, 700);
      }
      if (chose1.nombre_points[chose1.bon_trajet][0]==chose2.nombre_points[chose2.bon_trajet][0]) {
        background(0);
        chose1.dessiner_voiture_principale();
        chose2.dessiner_voiture_principale();
        dessiner_laby();
        tr.dessiner();
        tr2.dessiner();
        fill(color(0, 0, 255));
        text("prennez le chemin que vous voulez !", 800, 500);
        text(str(chose1.nombre_points[chose1.bon_trajet][0]) + " points pour le chemin rouge", 800, 600);
        text(str(chose2.nombre_points[chose2.bon_trajet][0]) + " points pour le chemin vert", 800, 700);
      }
    }
  }
  if (keyCode == LEFT) {
    background(0);
    for (int i=0; i<chose1.nbr; i++) {
      for (int n=0; n<chose1.nbr; n++) {
        fill(255);
        fill(red);
        rect(chose1.trajetx[i][n], chose1.trajety[i][n], 10, 10);
        fill(green);
        rect(chose2.trajetx[i][n], chose2.trajety[i][n], 10, 10);
      }
    }
  }
}
