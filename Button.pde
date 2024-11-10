class Button{
  float x, y, bWidth, bHeight;
  String t;
  Button(float x, float y, float w, float h, String t){
    this.x = x;
    this.y = y;
    this.bWidth = w;
    this.bHeight = h;
    this.t = t;
  }
  
  boolean mouseOver(){
    boolean ret = false;
    if(mouseX >=  x - (bWidth/2) && mouseX <= x + (bWidth/2) && mouseY >= y - (bHeight/2) && mouseY <= y + (bHeight/2)){
      ret = true;
    }
    return ret;
  }
  
  void drawButton(){
    fill(#3F69D1);
    stroke(255);
    if(mouseOver()){
      fill(#38DE7B);
    }
    rect(x, y, bWidth, bHeight, 4);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(40);
    text(t, x, y);
  }
}
