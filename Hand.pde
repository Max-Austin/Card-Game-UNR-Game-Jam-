

class Hand{
  private boolean playerHand;
  private Card[] cards = new Card[maxHandSize];
  private int handSize;
  boolean[] openIndices = {true, true, true, true, true, true, true, true, true, true};
  
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
      int i = handSize;
      while(!openIndices[i]){
        i++;
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
      openIndices[index] = true;
      return true;
    }
    return false;
  }
  
  void drawHand(){
    for(int i = 0; i <= handSize; i++){
      cards[i].drawCard();
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
