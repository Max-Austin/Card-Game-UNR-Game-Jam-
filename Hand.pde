

class Hand{
  private boolean playerHand;
  private Card[] cards = new Card[maxHandSize];
  private int handSize;
  boolean[] openIndices = {true, true, true, true, true, true, true, true, true, true};
  int monsterCount = 0;
  
  Hand(Card[] c, boolean p, int h){
    this.cards = c;
    this.playerHand = p;
    this.handSize = h;
  }
  
  Hand(boolean p){
    this.handSize = -1;
    this.playerHand = p;
  }
  
  boolean addCardToHand(Card c){
    boolean canAdd = handSize != maxHandSize-1;
    
    if(canAdd){
      handSize++;
      drawCard.amp(0.3);
      if(!drawCard.isPlaying()){
        drawCard.play();
      }
      else{
        drawCard.jump(0.1);
      }
      if(c.type != Type.SPE){
        monsterCount++;
      }
      int i = 0;
      while(!openIndices[i]){
        if(i != 9){
          i++;
        }
      }
      cards[i] = c;
      openIndices[i] = false;
        //println(handSize);
        if(playerHand){
          cards[i].setShow(true);
          
          cards[i].setPos(playerHandPos[i].x, playerHandPos[i].y);
        }
        else{
          cards[i].setPos(compHandPos[i].x, compHandPos[i].y);
        }
    }
    else{
      println("Hand is full");
    }
    return canAdd;
  }
  
  boolean removeCardFromHand(int index){
    if(handSize != -1){
      if(cards[index].type != Type.SPE){
        monsterCount--;
      }
      openIndices[index] = true;
      handSize--;
      return true;
    }
    return false;
  }
  
  void drawHand(){
    if(!firstHandsDrawn){
      for(int i = 0; i <= handSize; i++){
        cards[i].drawCard();
      }
    }
    if(firstHandsDrawn){
      for(int i = 0; i < maxHandSize; i++){
        cards[i].drawCard();
      }
    }
  }
  
  int getHandSize(){
    return handSize;
  }
  Card getCardAtIndex(int i){
    return cards[i];
  }
  int getIndexOf(Card c){
    for(int i = 0; i < maxHandSize; i++){
      if(cards[i].isEqual(c)){
        return i;
      }
    }
    return -1;
  }
}
