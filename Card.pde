class Card{
  private int power;
  private boolean show;
  private PImage img;
  private Type type;
  private String name;
  private float scaleIncrement, x, y, targetX, targetY;
  private boolean upScale, inPrepZone, moving, inBattleZone, inSpellZone;
  private int prepSlotTaken = -1;
  private float multiplier;
  
  Card(float x, float y, PImage i, boolean s, Type t, int p, String n, float m){
    this.x = x;
    this.y = y;
    this.targetX = x;
    this.targetY = y;
    this.show = s;
    this.img = i;
    this.type = t;
    this.power = p;
    this.name = n;
    this.multiplier = m;
    scaleIncrement = 0;
    upScale = true;
    inPrepZone = false;
    inBattleZone = false;
    inSpellZone = false;
    moving = false;
  }
 
  void setPos(float finalX, float finalY){
    targetX = finalX;
    targetY = finalY;
  }
  
  void setShow(boolean s){
    show = s;
  }
  boolean getInPrepZone(){
    return inPrepZone;
  }
  
  void drawCard(){
    float incrementX = (targetX-x)/20;
    float incrementY = (targetY-y)/20;
    if(show){
      pushMatrix();
      translate(x,y);
      if(mouseOver() && !mousePressed){
        if(upScale){
          scale(1 + scaleIncrement);
          scaleIncrement += 0.003;
          if(scaleIncrement >= 0.1){
            upScale = false;
          }
        }
        else{
          scale(1 + scaleIncrement);
          scaleIncrement -= 0.003;
          if(scaleIncrement <= 0){
            upScale = true;
          }
        }
        displayImage();
      }
      else{
        displayImage();
        
        scaleIncrement = 0;
        upScale = true;
      }
      popMatrix();
    }
    else{
      //replace this with card back image
      pushMatrix();
      translate(x,y);
      displayImage();
      popMatrix();
    }
    
    if(x != targetX || y != targetY){
      moving = true;
    }
    if(moving){
      x+=incrementX;
      y+=incrementY;
      if((targetX-x) <= 1 && (targetY-y) <= 1 && (targetX-x) >= -1 && (targetY-y) >= -1){
        x = targetX;
        y = targetY;
        moving = false;
      }
    }
    
  }
  
  boolean mouseOver(){
    if(mouseX >= x-(cardWidth/2) && mouseX <= x+(cardWidth/2) && mouseY >= y-(cardHeight/2) && mouseY <= y+(cardHeight/2)){
      return true;
    }
    return false;
  }
  
  void printCard(){
    println(type, power);
  }
  
  boolean isEqual(Card c){
    if(this.type == c.type && this.power == c.power){
      return true;
    }
    return false;
  }
  
  void displayImage(){
    stroke(255);
    switch(type){
      case VOLC:
      fill(#E30B0B);
      break;
      case OCE:
      fill(#2A0F98);
      break;
      case FOR:
      fill(#115D0A);
      break;
      case LAN:
      fill(#746917);
      break;
      case CAV:
      fill(#868686);
      break;
      case BRA:
      fill(#6905AD); //dark purple
      break;
      case SKY:
      fill(#5ECEBE);
      break;
      case VOLT:
      fill(#E5F05A);
      break;
      case NEU:
      fill(#E86CE0);
      break;
      case SPE:
      fill(#35B43C);
      break;
      default:
      fill(255);
      break;
    }
    if(!show){
      fill(100, 120, 120);
    }
    rect(0,0,cardWidth,cardHeight);
    
    textAlign(CENTER, CENTER);
    //stroke(0);
    fill(0);
    if(show){
      if(type != Type.SPE){
        
        textSize(30);
        text(power, 0, 0);
        textSize(20);
        text(type.toString(), 0, 20);
      }
      else if(type == Type.SPE){
        textSize(15);
        text(name, 0, 0);
      }
    }
  }
  
}
