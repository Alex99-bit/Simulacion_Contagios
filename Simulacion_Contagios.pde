/*
  Este programa representa una simulación de contagios, donde t es el tiempo que tarda un paciente en curarse,
  los pacientes sanos se representan con azul, los enfermos con rojo y los curados con verde.
  
  Un paciente curado ya no puede transmitir la enfermedad, se puede modificar el size para el tamaño de pantalla,
  el rad para el radio de los pacientes, y el numero de pacientes que estan dentro del array Persona[n]
*/

class Persona{
  boolean sano;
  boolean curado;
  boolean tratamiento;
  float x,y,rad,despX,despY,t;
  int colorSano, colorEnfermo, colorCurado;
  float frameInicio;
  
  Persona(int mod){
    t = 4;
    x = random(width);
    y = random(height);
    despX = random(-15,15);
    despY = random(-15,15);
    rad = 50;
    colorSano = #01B3F4;
    colorEnfermo = #FF0000;
    colorCurado = #21FE01;
    
    int aux = (int)random(1,10);
    
    if(aux % mod == 0){
      sano = false;
    }else{
      sano = true;
    }
    
    curado = false;
    tratamiento = false;
  }
  
  void Dibuja(){
    if(curado){
      fill(colorCurado);
    }else{
      if(sano){
        fill(colorSano);
      }else{
        fill(colorEnfermo);
      }
    }
    
    circle(x,y,rad);
  }
  
  void Mueve(){
    x += despX;
    y += despY;
    
    if(x<=0 || x>=width){
      despX *= -1;
    }
    
    if(y<=0 || y>=height){
      despY *= -1;
    }
  }
  
  // Aqui se calcula si ya estuvieron enfermos para que despues de un tiempo se mejoren
  void Curacion(){
    if (!sano && !tratamiento && !curado) {
      frameInicio = frameCount;
      tratamiento = true;
    }
    
    if (!curado && !sano && tratamiento) {
      float tiempoTranscurrido = frameCount - frameInicio;
      if (tiempoTranscurrido >= (frameRate*t)) { // 180 frames (~3 segundos a 60 FPS) para la curación
        curado = true;
        sano = true;
        tratamiento = false; // Restablecer el tratamiento
      }
    }
  }
  
}


Persona[] alum = new Persona[10];

void setup(){
  size(1600,900);
  
  for(int i=0;i<alum.length;i++){
    alum[i] = new Persona(2);
  }
}

void draw(){
  background(200);
  frameRate(60);
  
  for(int i=0;i<alum.length;i++){
    alum[i].Dibuja();
    alum[i].Mueve();
    alum[i].Curacion();
    for(int j=i;j<alum.length;j++){
      // Si la distancia es menor a la suma de sus radios, estan chocando
      if(Distancia(alum[i].x,alum[j].x,alum[i].y,alum[j].y) < ((alum[i].rad/2) + (alum[j].rad/2))){
        
        if(!alum[i].sano && alum[j].sano){
          alum[j].sano = false;
        }
        
        if(!alum[j].sano && alum[i].sano){
          alum[i].sano = false;
        }
        
        /*alum[i].despX = -1;
        alum[i].despY *= -1;
        
        alum[j].despX *= -1;
        alum[j].despY *= -1;*/
      }
    }
  }
}

float Distancia(float x1,float x2,float y1,float y2){
  float deltaX,deltaY,cuadrado,distancia;
  
  deltaX = x1 - x2;
  deltaY = y1 - y2;
  cuadrado = (deltaX * deltaX) + (deltaY * deltaY);
  distancia = sqrt(cuadrado);
  
  return distancia;
}
