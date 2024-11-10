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
      cards[top+1] = c;
      top++;
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
    peek().drawCard();
  }
  
  void printStack(){
    println("=========DECK==========");
    println(top);
    for(int i = top; i >= 0; i--){
      println(i + ": " + cards[i].type, cards[i].power);
    }
  }
}
