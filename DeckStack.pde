class DeckStack{
  private Card[] cards = new Card[deckSize];
  private int top;
  
  DeckStack(Card[] c){
    this.cards = c;
    this.top = deckSize;
  }
  DeckStack(){
    this.cards = new Card[deckSize];
    top = -1;
  }
  
  boolean pop(){
    boolean canPop = !isEmpty();
    if(canPop){
      top--;
    }
    else{
      println("Cannot Pop");
    }
    return canPop;
  }
  
  boolean push(Card c){
    boolean canPush = top != deckSize-1;
    
    if(canPush){
      println("Pushed " + c.type, c.power);
      cards[top+1] = c;
      top++;
      println("Top: " + top);
    }
    else{
      println("Cannot Push");
    }
    return canPush;
  }
  
  Card peek(){
    boolean canPeek = !isEmpty();
    if(canPeek){
      return cards[top];
    }
    else{
      println("Cannot Peek");
      return null;
    }
  }
  
  boolean isEmpty() {
    return top == -1;
  }
  
  int getTop(){
    return top;
  }
  
  boolean shuffleDeck(){
    boolean canShuffle = !isEmpty();
    if(canShuffle){
      cards = shuffle(cards, top);
      //printStack();
    }
    else{
      println("Cannot Shuffle");
    }
    return canShuffle;
  }
  
  void drawDeck(){
    if(top >= 2){
      cards[top-2].drawCard();
    }
    if(top >= 1){
      cards[top-1].drawCard();
    }
    if(top != -1){
      peek().drawCard();
    }
  }
  
  void printStack(){
    println("=========DECK==========");
    println(top);
    for(int i = top; i >= 0; i--){
      println(i + ": " + cards[i].type, cards[i].power);
    }
  }
  
  void setPosOfAll(PVector v){
    if(top != -1){
      for(int i = 0; i < top+1; i++){
        cards[i].setPos(v.x, v.y);
        println("Setting pos of index " + i);
      }
    }
  }
}
