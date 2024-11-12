/*

Every deck has 40 cards 1-4 power of each type and 14 spells

Spells are:
Counterspell - Cancel the last spell your opponent played
2x Power-Up - Double your monster's power
2x Power-Down - Halve Your oponents monsters power
Conflagerate - Triple your volcano monsters power
Tsunami - Triple your ocean monsters power
Overgrowth - Triple your forest monsters power
Earthquake - Triple your land monsters power
Echo - Triple your cave monsters power
Deadlift - Triple your brawl monsters power
Tornado - Triple your sky monsters power
Overload - Triple your voltage monsters power
Psycho Shift - Triple your neuron monsters power

KNOWN BUGS:
When you place a card in the prep zone, move it back to hand, then back to pre zone, it cannot be selected to be put in battle zone

*/

import processing.sound.*;

SoundFile musicLoop;
SoundFile drawCard;
SoundFile moveCard;
SoundFile battleWon;
SoundFile battleLost;

PImage menuBackground;
PImage gameBackground;
PImage blankCard;
PImage typeChart;
PImage cardBack;
PImage battlePhaseImg;
PImage prepPhaseImg;
PImage battleWonImg;
PImage battleLostImg;
PImage logo;
PImage[] skyFrames = new PImage[4];
PImage[] volcFrames = new PImage[4];
PImage[] oceFrames = new PImage[4];
PImage[] forFrames = new PImage[4];
PImage[] lanFrames = new PImage[4];
PImage[] cavFrames = new PImage[4];
PImage[] braFrames = new PImage[4];
PImage[] voltFrames = new PImage[4];
PImage[] neuFrames = new PImage[4];
PImage[] speFrames = new PImage[4];

import java.util.*;
static int deckSize = 50;
static int maxHandSize = 10;

int playerDeckX;
int playerDeckY;
static int compDeckX = 100;
static int compDeckY = 100;
static int cardWidth = 82;
static int cardHeight = 128;
static int handPadX = 10;
static int handPadY = 100;
static int menuOffSetY = 150;

PVector[] playerHandPos = new PVector[10];
PVector[] compHandPos = new PVector[10];
PVector[] playerPrepPos = new PVector[3];
PVector[] compPrepPos = new PVector[3];
PVector playerBattlePos;
PVector compBattlePos;
PVector playerSpellPos;
PVector compSpellPos;
PVector playerDiscardPos;
PVector compDiscardPos;

static enum Type {VOLC, OCE, FOR, LAN, CAV, BRA, SKY, VOLT, NEU, SPE};

DeckStack playerDeck = new DeckStack();
DeckStack compDeck = new DeckStack();
Hand playerHand = new Hand(true);
Hand compHand = new Hand(false);

boolean initialHandsDrawn = false;
boolean prepPhase = false;
boolean battlePhase = false;
boolean phaseIndicatorFlashed = false;
boolean[] prepSlotsOpen = {true, true, true};
boolean compPrepCardsChosen = false;
boolean compBattleCardChosen = false;
boolean spellPhase = false;
boolean compSpellCardChosen = false;
boolean fightPhase = false;
boolean combatCalced = false;
boolean playerWonBattle = false;
boolean compWonBattle = false;
boolean menu = true;
boolean rules = false;
boolean drawTypeChart = false;

int phaseIndicatorFrameCount = 0; //counter needs reset
int playerCardsInPrepZone = 0; //counter needs reset
int playerCardsInBattleZone = 0; //counter needs reset
int playerIndexOfCardInBattleZone = -1;
int compIndexOfCardInBattleZone = -1;
int compCardsInPrepZone = 0; //counter needs reset
int compCardsInBattleZone = 0; //counter needs reset
int playerCardsInSpellZone = 0; //counter needs reset
int playerIndexOfCardInSpellZone = -1;
int compIndexOfCardInSpellZone = -1;
int totalCardsMoved = 0;

int playerScore = 0;
int compScore = 0;
boolean gameOver = false;

Button returnToMenuFromRules;
Button returnToMenuFromGame;
static int numMenuButtons = 3;
Button[] menuButtons = new Button[numMenuButtons];
static int menuButtonWidth = 800;
static int menuButtonHeight = 100;
static int menuButtonPadY = 30;

Random rand = new Random(System.currentTimeMillis());

void setup(){
  size(1900,1080);
  textAlign(CENTER, CENTER);
  
  playerDeckX = width-100;
  playerDeckY = height-handPadY;
  
  menuBackground = loadImage("assets/Menu-Background.png");
  gameBackground = loadImage("assets/Game-Background.png");
  blankCard = loadImage("assets/blankcard.png");
  typeChart = loadImage("assets/type-chart.PNG");
  cardBack = loadImage("assets/CardBack.png");
  prepPhaseImg = loadImage("assets/PrepPhase.png");
  battlePhaseImg = loadImage("assets/BattlePhase.png");
  logo = loadImage("assets/Logo.png");
  battleWonImg = loadImage("assets/BattleWon.png");
  battleLostImg = loadImage("assets/BattleLost.png");
  
  musicLoop = new SoundFile(this, "assets/music-loop.mp3");
  drawCard = new SoundFile(this, "assets/draw.wav");
  moveCard = new SoundFile(this, "assets/move-card.wav");
  battleWon = new SoundFile(this, "assets/battle-won.wav");
  battleLost = new SoundFile(this, "assets/battle-lost.wav");
  
  imageMode(CENTER);
  rectMode(CENTER);
  
  initializeFrames();
  initializeDecks();
  
  playerHandPos[0] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(4*cardWidth+4*handPadX), height-handPadY);
  playerHandPos[1] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(3*cardWidth+3*handPadX), height-handPadY);
  playerHandPos[2] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(2*cardWidth+2*handPadX), height-handPadY);
  playerHandPos[3] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(cardWidth+handPadX), height-handPadY);
  playerHandPos[4] = new PVector((width/2)-(handPadX/2)-(cardWidth/2), height-handPadY);
  playerHandPos[5] = new PVector((width/2)+(handPadX/2)+(cardWidth/2), height-handPadY);
  playerHandPos[6] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(cardWidth+handPadX), height-handPadY);
  playerHandPos[7] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(2*cardWidth+2*handPadX), height-handPadY);
  playerHandPos[8] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(3*cardWidth+3*handPadX), height-handPadY);
  playerHandPos[9] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(4*cardWidth+4*handPadX), height-handPadY);
  
  compHandPos[0] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(4*cardWidth+4*handPadX), handPadY);
  compHandPos[1] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(3*cardWidth+3*handPadX), handPadY);
  compHandPos[2] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(2*cardWidth+2*handPadX), handPadY);
  compHandPos[3] = new PVector((width/2)-(handPadX/2)-(cardWidth/2)-(cardWidth+handPadX), handPadY);
  compHandPos[4] = new PVector((width/2)-(handPadX/2)-(cardWidth/2), handPadY);
  compHandPos[5] = new PVector((width/2)+(handPadX/2)+(cardWidth/2), handPadY);
  compHandPos[6] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(cardWidth+handPadX), handPadY);
  compHandPos[7] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(2*cardWidth+2*handPadX), handPadY);
  compHandPos[8] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(3*cardWidth+3*handPadX), handPadY);
  compHandPos[9] = new PVector((width/2)+(handPadX/2)+(cardWidth/2)+(4*cardWidth+4*handPadX), handPadY);
  
  playerPrepPos[0] = new PVector((width/2) - (cardWidth + handPadX), (height/2)+((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  playerPrepPos[1] = new PVector((width/2), (height/2)+((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  playerPrepPos[2] = new PVector((width/2) + (cardWidth + handPadX), (height/2)+((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  
  compPrepPos[0] = new PVector((width/2) - (cardWidth + handPadX), (height/2)-((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  compPrepPos[1] = new PVector((width/2), (height/2)-((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  compPrepPos[2] = new PVector((width/2) + (cardWidth + handPadX), (height/2)-((handPadX/2) + (cardHeight/2) + cardHeight + handPadX));
  
  playerBattlePos = new PVector((width/2), (height/2) + ((handPadX/2) + cardHeight/2));
  compBattlePos = new PVector((width/2), (height/2) - ((handPadX/2) + cardHeight/2));
  
  playerSpellPos = new PVector(playerBattlePos.x + cardWidth + handPadX, playerBattlePos.y);
  compSpellPos = new PVector(compBattlePos.x - (cardWidth + handPadX), compBattlePos.y);
  
  playerDiscardPos = new PVector(compDeckX, playerDeckY);
  compDiscardPos = new PVector(playerDeckX, compDeckY+50);
  
  returnToMenuFromRules = new Button(width/2, height - (2*menuButtonHeight), menuButtonWidth, menuButtonHeight, "Main Menu");
  returnToMenuFromGame = new Button(width - 150, 50, menuButtonWidth/3, menuButtonHeight/2, "Main Menu");
  menuButtons[0] = new Button(width/2, (height/2) + menuOffSetY - (menuButtonHeight + (menuButtonPadY/2)), menuButtonWidth, menuButtonHeight, "Start Game");
  menuButtons[1] = new Button(width/2, (height/2) + menuOffSetY, menuButtonWidth, menuButtonHeight, "Rules");
  menuButtons[2] = new Button(width/2, (height/2) + (menuButtonHeight + (menuButtonPadY/2) + menuOffSetY), menuButtonWidth, menuButtonHeight, "High Scores (Under Construction)");
}

void menu(){
  fill(255);
  textSize(90);
  textAlign(CENTER, CENTER);
  pushMatrix();
  translate(width/2, 200+menuOffSetY);
  scale(0.75);
  image(logo, 0, 0);
  popMatrix();
  for(int i = 0; i < numMenuButtons; i++){
    menuButtons[i].drawButton();
  }
}
void rules(){
  int currentX = 50;
  int currentY = 30;
  int yIncrement = 40;
  int xIncrement = 40;
  fill(255);
  textSize(50);
  text("RULES", width/2, currentY);
  currentY += yIncrement;
  textSize(25);
  textAlign(LEFT, TOP);
  text("Who am I playing against? A computer that makes purely random decisions.", currentX, currentY);
  currentY += yIncrement;
  text("Card Types:", currentX, currentY);
  currentY += yIncrement;
  currentX += xIncrement;
  text("Terrain: Used to battle, each terrain card has a type and power level indicated on the card.", currentX, currentY);
  currentY += yIncrement;
  text("Spell: Used to enhance terrain cards.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("Type Matchups:", currentX, currentY);
  currentY += yIncrement;
  currentX += xIncrement;
  text("Some types of terrain cards are better against others. Hold TAB at any time to show the typing cheat-sheet.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("Prep Phase:", currentX, currentY);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Prepare at most 3 terrain cards to potentially do battle, and, after finalizing your choice, your opponents' prepped cards are revealed.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("Battle Phase:", currentX, currentY);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Pick one card that will face off against your opponent's choice. After finalizing your choice your opponent's choice is revealed", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("Spell Phase:", currentX, currentY);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Pick a spell to enhance your terrain cards. Some spells can only be played when you have a certain type of terrain card battling. For example, the", currentX, currentY);
  currentY += yIncrement;
  text("spell Overload can only be played while you have a Voltage type terrain in battle.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("Spell Multipliers:", currentX, currentY);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Spells apply a multiplier to the power of your terrain card: Power-Up applies a 2x, Power-Down applies a 0.5x to your opponnent, and all spells that are", currentX, currentY);
  currentY += yIncrement;
  text("type-specific apply a 3x.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  text("When does the game end?", currentX, currentY);
  currentX += xIncrement;
  currentY += yIncrement;
  text("The game ends when either player has 0 cards in their deck or either player has no terrain cards in hand.", currentX, currentY);
  textAlign(CENTER, CENTER);
  returnToMenuFromRules.drawButton();
}

void draw(){
  background(#26C4D1);
  if(menu || rules){
    //image(menuBackground, width/2, height/2);
    background(#106F66);
  }
  else{
    image(gameBackground, width/2, height/2);
  }
  
  if(!musicLoop.isPlaying()){
    musicLoop.play();
    musicLoop.amp(0.15);
  }
  
  if(menu){
    menu();
  }
  if(rules){
    rules();
  }
  if(!menu && !rules){
    returnToMenuFromGame.drawButton();
    if(!gameOver){
      playerDeck.drawDeck();
      compDeck.drawDeck();
      playerHand.drawHand();
      compHand.drawHand();
      
      drawScores();
    
      if(!initialHandsDrawn){ 
        drawFullHands();
        if(compDeck.top == -1 || playerDeck.top == -1){
          gameOver = true;
        }
      }
    
      if(prepPhase){
        prepPhase();
      }
      else if(battlePhase){
        battlePhase();
      }
      else if(spellPhase){
        spellPhase();
      }
      else if(fightPhase){
        fightPhase();
      }
    }
    else{
      if(phaseIndicatorFrameCount <= 1000){
        textSize(60);
        fill(255);
        stroke(255);
        if(playerScore < compScore){
          text("You Win!", width/2, height/2);
        }
        else if(compScore < playerScore){
          text("You Lose :(", width/2, height/2);
        }
        phaseIndicatorFrameCount++;
      }
      else{
        resetGame();
      }
    }
  }
  if(drawTypeChart){
    pushMatrix();
    translate(width/2, height/2);
    scale(1.5);
    image(typeChart, 0, 0);
    popMatrix();
  }
  
}

void initializeFrames(){
  skyFrames[0] = loadImage("assets/Sky0001.png");
  skyFrames[1] = loadImage("assets/Sky0002.png");
  skyFrames[2] = loadImage("assets/Sky0003.png");
  skyFrames[3] = loadImage("assets/Sky0004.png");
  
  volcFrames[0] = loadImage("assets/VOL0001.png");
  volcFrames[1] = loadImage("assets/VOL0002.png");
  volcFrames[2] = loadImage("assets/VOL0003.png");
  volcFrames[3] = loadImage("assets/VOL0004.png");
  
  oceFrames[0] = loadImage("assets/OCE0001.png");
  oceFrames[1] = loadImage("assets/OCE0002.png");
  oceFrames[2] = loadImage("assets/OCE0003.png");
  oceFrames[3] = loadImage("assets/OCE0004.png");
  
  lanFrames[0] = loadImage("assets/LND0001.png");
  lanFrames[1] = loadImage("assets/LND0002.png");
  lanFrames[2] = loadImage("assets/LND0003.png");
  lanFrames[3] = loadImage("assets/LND0004.png");
  
  forFrames[0] = loadImage("assets/For0001.png");
  forFrames[1] = loadImage("assets/For0002.png");
  forFrames[2] = loadImage("assets/For0003.png");
  forFrames[3] = loadImage("assets/For0004.png");
  
  cavFrames[0] = loadImage("assets/Cave.png");
  cavFrames[1] = loadImage("assets/Cave.png");
  cavFrames[2] = loadImage("assets/Cave.png");
  cavFrames[3] = loadImage("assets/Cave.png");
  
  braFrames[0] = loadImage("assets/BRL0001.png");
  braFrames[1] = loadImage("assets/BRL0002.png");
  braFrames[2] = loadImage("assets/BRL0003.png");
  braFrames[3] = loadImage("assets/BRL0004.png");
  
  voltFrames[0] = loadImage("assets/VLT0001.png");
  voltFrames[1] = loadImage("assets/VLT0002.png");
  voltFrames[2] = loadImage("assets/VLT0003.png");
  voltFrames[3] = loadImage("assets/VLT0004.png");
  
  neuFrames[0] = loadImage("assets/NRO0001.png");
  neuFrames[1] = loadImage("assets/NRO0002.png");
  neuFrames[2] = loadImage("assets/NRO0003.png");
  neuFrames[3] = loadImage("assets/NRO0004.png");
  
  speFrames[0] = loadImage("assets/Spell.png");
  speFrames[1] = loadImage("assets/Spell.png");
  speFrames[2] = loadImage("assets/Spell.png");
  speFrames[3] = loadImage("assets/Spell.png");
}

void initializeDecks(){
  playerDeck = new DeckStack();
  compDeck = new DeckStack();
  for(Type t : Type.values()){
    for(int j = 1; j < 5; j++){
      if(t != Type.SPE){
        switch(t){
          case SKY:
            playerDeck.push(new Card(playerDeckX, playerDeckY, skyFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, skyFrames, false, t, j, "", 1));
          break;
          case VOLC:
            playerDeck.push(new Card(playerDeckX, playerDeckY, volcFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, volcFrames, false, t, j, "", 1));
          break;
          case OCE:
            playerDeck.push(new Card(playerDeckX, playerDeckY, oceFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, oceFrames, false, t, j, "", 1));
          break;
          case FOR:
            playerDeck.push(new Card(playerDeckX, playerDeckY, forFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, forFrames, false, t, j, "", 1));
          break;
          case LAN:
            playerDeck.push(new Card(playerDeckX, playerDeckY, lanFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, lanFrames, false, t, j, "", 1));
          break;
          case CAV:
            playerDeck.push(new Card(playerDeckX, playerDeckY, cavFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, cavFrames, false, t, j, "", 1));
          break;
          case BRA:
            playerDeck.push(new Card(playerDeckX, playerDeckY, braFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, braFrames, false, t, j, "", 1));
          break;
          case VOLT:
            playerDeck.push(new Card(playerDeckX, playerDeckY, voltFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, voltFrames, false, t, j, "", 1));
          break;
          case NEU:
            playerDeck.push(new Card(playerDeckX, playerDeckY, neuFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, neuFrames, false, t, j, "", 1));
          break;
          default:
            playerDeck.push(new Card(playerDeckX, playerDeckY, skyFrames, false, t, j, "", 1));
            compDeck.push(new Card(compDeckX, compDeckY, skyFrames, false, t, j, "", 1));
          break;
        }
      }
    }
  }
  //CUT COUNTERSPELL ADD IN LATER IF TIME ALLOWS
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Power-Up", 2));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Power-Down", 0.5));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Power-Down", 0.5));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Power-Down", 0.5));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Power-Down", 0.5));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Conflagerate", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Conflagerate", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Tsunami", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Tsunami", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Overgrowth", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Overgrowth", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Earthquake", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Earthquake", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Echo", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Echo", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Deadlift", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Deadlift", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Tornado", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Tornado", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Overload", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Overload", 3));
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Psycho Shift", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Psycho Shift", 3));
  
  playerDeck.shuffleDeck();
  compDeck.shuffleDeck();
}

void mouseReleased(){
  if(menu){
    int indexOfButtonClicked = -1;
    for(int i = 0; i < numMenuButtons; i++){
      if(menuButtons[i].mouseOver()){
        indexOfButtonClicked = i;
      }
    }
    if(indexOfButtonClicked == 0){
      menu = false;
    }
    if(indexOfButtonClicked == 1){
      rules = true;
      menu = false;
    }
    if(indexOfButtonClicked == 2){
      
    }
  }
  if(rules){
    if(returnToMenuFromRules.mouseOver()){
      rules = false;
      menu = true;
    }
  }
  else{
    if(returnToMenuFromGame.mouseOver()){
      menu = true;
      resetGame();
    }
    if(!menu){
      int indexOfCardClicked = -1;
      for(int i = 0; i < playerHand.getHandSize()+1; i++){
        if(playerHand.getCardAtIndex(i).mouseOver()){
          indexOfCardClicked = i;
        }
      }
      if(prepPhase){
        //card is clicked to put into prep zone
        if(indexOfCardClicked != -1 && playerCardsInPrepZone != 3 && playerHand.cards[indexOfCardClicked].prepSlotTaken == -1 && playerHand.cards[indexOfCardClicked].type != Type.SPE){
          if(prepSlotsOpen[playerCardsInPrepZone]){
            prepSlotsOpen[playerCardsInPrepZone] = false;
            playerHand.cards[indexOfCardClicked].prepSlotTaken = playerCardsInPrepZone;
            println("Found slot at: " + playerCardsInPrepZone);
            playerHand.cards[indexOfCardClicked].setPos(playerPrepPos[playerCardsInPrepZone].x, playerPrepPos[playerCardsInPrepZone].y);
            playerHand.cards[indexOfCardClicked].inPrepZone = true;
          }
          else{
            boolean slotFound = false;
            for(int i = 0; i < 3; i++){
              if(prepSlotsOpen[i] && !slotFound){
                prepSlotsOpen[i] = false;
                playerHand.cards[indexOfCardClicked].prepSlotTaken = i;
                playerHand.cards[indexOfCardClicked].setPos(playerPrepPos[i].x, playerPrepPos[i].y);
                println("Found slot at: " + i);
                playerHand.cards[i].inPrepZone = true;
                slotFound = true;
              }
            }
          }
          playerCardsInPrepZone++;
        }
        //card is clicked to remove from prep zone
        else if(indexOfCardClicked != -1 && playerCardsInPrepZone != 0 && playerHand.cards[indexOfCardClicked].prepSlotTaken != -1){
          println("Moving card back to hand");
          playerHand.cards[indexOfCardClicked].setPos(playerHandPos[indexOfCardClicked].x, playerHandPos[indexOfCardClicked].y);
          prepSlotsOpen[playerHand.cards[indexOfCardClicked].prepSlotTaken] = true;
          playerHand.cards[indexOfCardClicked].prepSlotTaken = -1;
          playerHand.cards[indexOfCardClicked].inPrepZone = false;
          playerCardsInPrepZone--;
        }
      }
      if(battlePhase){
        if(indexOfCardClicked != -1 && playerCardsInBattleZone != 1 && !playerHand.cards[indexOfCardClicked].inBattleZone && playerHand.cards[indexOfCardClicked].inPrepZone){
          println("SHOULD SEE THIS ONCE");
          playerHand.cards[indexOfCardClicked].setPos(playerBattlePos.x, playerBattlePos.y);
          playerHand.cards[indexOfCardClicked].inBattleZone = true;
          playerIndexOfCardInBattleZone = indexOfCardClicked;
          playerCardsInBattleZone++;
          playerCardsInPrepZone--;
        }
        else if(indexOfCardClicked != -1 && playerCardsInBattleZone == 1 && !playerHand.cards[indexOfCardClicked].inBattleZone && playerHand.cards[indexOfCardClicked].inPrepZone){
          println("Prep Zone Slot of card clicked: " + playerHand.cards[indexOfCardClicked].prepSlotTaken);
          playerHand.cards[playerIndexOfCardInBattleZone].setPos(playerPrepPos[playerHand.cards[playerIndexOfCardInBattleZone].prepSlotTaken].x, playerPrepPos[playerHand.cards[playerIndexOfCardInBattleZone].prepSlotTaken].y);
          playerHand.cards[indexOfCardClicked].setPos(playerBattlePos.x, playerBattlePos.y);
          playerHand.cards[indexOfCardClicked].inBattleZone = true;
          playerHand.cards[playerIndexOfCardInBattleZone].inBattleZone = false;
          playerIndexOfCardInBattleZone = indexOfCardClicked;
        }
      }
      if(spellPhase){
        //select a spell to put in spell zone
        if(indexOfCardClicked != -1 && playerHand.cards[indexOfCardClicked].type == Type.SPE && !playerHand.cards[indexOfCardClicked].inSpellZone && playerCardsInSpellZone != 1 && checkValidSpell(playerHand.cards[playerIndexOfCardInBattleZone], playerHand.cards[indexOfCardClicked])){
          playerHand.cards[indexOfCardClicked].setPos(playerSpellPos.x, playerSpellPos.y);
          playerHand.cards[indexOfCardClicked].inSpellZone = true;
          playerCardsInSpellZone++;
          playerIndexOfCardInSpellZone = indexOfCardClicked;
        }
        //selected the spell in spell zone to put back in hand
        else if(indexOfCardClicked == playerIndexOfCardInSpellZone && indexOfCardClicked != -1){
          playerHand.cards[playerIndexOfCardInSpellZone].setPos(playerHandPos[playerIndexOfCardInSpellZone].x, playerHandPos[playerIndexOfCardInSpellZone].y);
          playerHand.cards[playerIndexOfCardInSpellZone].inSpellZone = false;
          playerIndexOfCardInSpellZone = -1;
          playerCardsInSpellZone--;
        }
        //select a spell to swap with current spell zone card
        else if(indexOfCardClicked != -1 && playerHand.cards[indexOfCardClicked].type == Type.SPE && !playerHand.cards[indexOfCardClicked].inSpellZone && playerCardsInSpellZone == 1 && checkValidSpell(playerHand.cards[playerIndexOfCardInBattleZone], playerHand.cards[indexOfCardClicked])){
          playerHand.cards[indexOfCardClicked].setPos(playerSpellPos.x, playerSpellPos.y);
          playerHand.cards[playerIndexOfCardInSpellZone].inSpellZone = false;
          playerHand.cards[playerIndexOfCardInSpellZone].setPos(playerHandPos[playerIndexOfCardInSpellZone].x, playerHandPos[playerIndexOfCardInSpellZone].y);
          playerHand.cards[indexOfCardClicked].inSpellZone = true;
          playerIndexOfCardInSpellZone = indexOfCardClicked;
        }
      }
    }
  }
}

void keyPressed(){
  if(key == TAB){
    drawTypeChart = true;
  }
}

void keyReleased(){
  if(key == TAB){
    drawTypeChart = false;
  }
  
  if(prepPhase && playerCardsInPrepZone == 3 && key == ENTER){
    prepPhase = false;
    phaseIndicatorFlashed = false;
    battlePhase = true;
    compPrepCardsChosen = false;
    phaseIndicatorFrameCount = 0;
    for(int i = 0; i < maxHandSize; i++){
      if(compHand.cards[i].inPrepZone){
        compHand.cards[i].setShow(true);
      }
    }
  }
  else if(prepPhase && playerCardsInPrepZone < 3  && playerCardsInPrepZone >= 1 && playerHand.monsterCount < 3 && key == ENTER){
    prepPhase = false;
    phaseIndicatorFlashed = false;
    battlePhase = true;
    compPrepCardsChosen = false;
    phaseIndicatorFrameCount = 0;
    for(int i = 0; i < maxHandSize; i++){
      if(compHand.cards[i].inPrepZone){
        compHand.cards[i].setShow(true);
      }
    }
  }
  else if(battlePhase && playerCardsInBattleZone == 1 && key == ENTER){
    if(!compBattleCardChosen){
    int rnd = rand.nextInt(10);
     while(!compHand.cards[rnd].inPrepZone){
        rnd = rand.nextInt(10);
      }
      compHand.cards[rnd].setPos(compBattlePos.x, compBattlePos.y);
      compBattleCardChosen = true;
      compIndexOfCardInBattleZone = rnd;
    }
    phaseIndicatorFlashed = false;
    battlePhase = false;
    spellPhase = true;
    phaseIndicatorFrameCount = 0;
  }
  else if(spellPhase && playerCardsInBattleZone == 1 && key == ENTER){
    //draw card move all cards back to hands
    compBattleCardChosen = false;
    phaseIndicatorFrameCount = 0;
    if(compIndexOfCardInSpellZone != -1){
      compHand.cards[compIndexOfCardInSpellZone].setShow(true);
    }
    spellPhase = false;
    fightPhase = true;
  }
  else if(fightPhase){
    playerWonBattle = false;
    compWonBattle = false;
    resetControllers();
  }
}

Card[] shuffle(Card[] c, int numItems){
  int rnd = rand.nextInt(numItems);
  Card[] temp = new Card[numItems+1];
  for(int i = 0; i < temp.length-1; i++){
    temp[i] = c[rnd];
    c = removeItem(c, rnd);
    numItems--;
    rnd = rand.nextInt(numItems+1);
  }
  temp[temp.length-1] = c[0];
  return temp;
}

void drawFullHands(){
  if(playerHand.getHandSize() != 9){
    playerHand.addCardToHand(playerDeck.peek());
    playerDeck.pop();
  }
  if(compHand.getHandSize() != 9){
    compHand.addCardToHand(compDeck.peek());
    compDeck.pop();
  }
  if(compHand.getHandSize() == 9 && playerHand.getHandSize() == 9){
    initialHandsDrawn = true;
    prepPhase = true;
  }
  if(playerHand.handSize == 9 && compHand.handSize == 9){
    for(int i = 0; i < maxHandSize; i++){
      playerHand.cards[i].inPrepZone = false;
      playerHand.cards[i].inBattleZone = false;
      playerHand.cards[i].inSpellZone = false;
      playerHand.cards[i].prepSlotTaken = -1;
      
      compHand.cards[i].inPrepZone = false;
      compHand.cards[i].inBattleZone = false;
      compHand.cards[i].inSpellZone = false;
      compHand.cards[i].prepSlotTaken = -1;
      compHand.cards[i].show = false;
      if(playerHand.monsterCount == 0 || compHand.monsterCount == 0){
        gameOver = true;
      }
      
    }
    println("Player monster count: " + playerHand.monsterCount);
    println("Comp monster count: " + compHand.monsterCount);
    println("Player cards in deck: " + (playerDeck.top+1));
    println("Comp cards in deck: " + (compDeck.top+1));
  }
}

void prepPhase(){
  textAlign(CENTER, CENTER);
  if(!phaseIndicatorFlashed){
    textSize(60);
    fill(255);
    stroke(255);
    image(prepPhaseImg, width/2, height/2);
    phaseIndicatorFrameCount++;
    if(phaseIndicatorFrameCount >= 100){
      phaseIndicatorFlashed = true;
    }
  }
  textSize(20);
  fill(255);
  stroke(255);
  text("Select 3 terrain cards to put on the field. ENTER to finalize", width/2, height - ((handPadY/2) + cardHeight + 10));
  
  if(!compPrepCardsChosen){
    int rnd = rand.nextInt(10);
    int monstersNeededInPrepZone = 3;
    if(compHand.monsterCount < 3){
      monstersNeededInPrepZone = compHand.monsterCount;
    }
    for(int i = 0; i < monstersNeededInPrepZone; i++){
      while(compHand.cards[rnd].type == Type.SPE || compHand.cards[rnd].inPrepZone){
        rnd = rand.nextInt(10);
      }
      println("Found card to place in prep zone from comps hand: " );
      compHand.cards[rnd].printCard();
      compHand.cards[rnd].setPos(compPrepPos[i].x, compPrepPos[i].y);
      compHand.cards[rnd].inPrepZone = true;
    }
    compPrepCardsChosen = true;
  }
}

void battlePhase(){
  textAlign(CENTER, CENTER);
  if(!phaseIndicatorFlashed){
    textSize(60);
    fill(255);
    stroke(255);
    image(battlePhaseImg, width/2, height/2);
    phaseIndicatorFrameCount++;
    if(phaseIndicatorFrameCount >= 100){
      phaseIndicatorFlashed = true;
    }
  }
  textSize(20);
  fill(255);
  stroke(255);
  text("Select 1 card to put into Battle. ENTER to finalize", width/2, height - ((handPadY/2) + cardHeight + 10));
}

void spellPhase(){
  textAlign(CENTER, CENTER);
  /*
  if(!phaseIndicatorFlashed){
    textSize(60);
    fill(255);
    stroke(255);
    text("Spell Phase", width/2, height/2);
    phaseIndicatorFrameCount++;
    if(phaseIndicatorFrameCount >= 200){
      phaseIndicatorFlashed = true;
    }
  }
  */
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  stroke(255);
  text("Select a spell you'd like to play (if any). ENTER to finalize", width/2, height - ((handPadY/2) + cardHeight + 10));
  
  if(!compSpellCardChosen){
    println("Finding spell");
    for(int i = 0; i < maxHandSize; i++){
      if(compHand.cards[i].type == Type.SPE && checkValidSpell(compHand.cards[compIndexOfCardInBattleZone], compHand.cards[i])){
        println("Found spell to place in spell zone from comps hand: " );
        compHand.cards[i].printCard();
        compHand.cards[i].setPos(compSpellPos.x, compSpellPos.y);
        compHand.cards[i].inSpellZone = true;
        compIndexOfCardInSpellZone = i;
        break;
      }
    }
    compSpellCardChosen = true;
  }
}

void fightPhase(){
  float playerPower, compPower;
  playerPower = compPower = 0;
  if(!combatCalced){
    Card blank0Mult = new Card(0, 0, speFrames, false, Type.SPE, 0, "", 1);
    Type compType = compHand.cards[compIndexOfCardInBattleZone].type;
    Type playerType = playerHand.cards[playerIndexOfCardInBattleZone].type;
    //both players have a spell
    if(compIndexOfCardInSpellZone != -1 && playerIndexOfCardInSpellZone != -1){
      //niether player has a power down
      if(compHand.cards[compIndexOfCardInSpellZone].name != "Power-Down" && playerHand.cards[playerIndexOfCardInSpellZone].name != "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], blank0Mult);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], blank0Mult);
      }
      //comp has power-down player doesn't
      if(compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down" && playerHand.cards[playerIndexOfCardInSpellZone].name != "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], compHand.cards[compIndexOfCardInSpellZone]);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult);
      }
      //comp doesn't have power down and player does
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down" && compHand.cards[compIndexOfCardInSpellZone].name != "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], playerHand.cards[playerIndexOfCardInSpellZone]);
      }
      //both players have a power down
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down" && compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, compHand.cards[compIndexOfCardInSpellZone]);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, playerHand.cards[playerIndexOfCardInSpellZone]);
      }
    }
    //comp has no spell while player does
    else if(compIndexOfCardInSpellZone == -1 && playerIndexOfCardInSpellZone != -1){
      //player has a power down
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, playerHand.cards[playerIndexOfCardInSpellZone]);
      }
      //neither have a power down
      else{
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], blank0Mult);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult);
      }
    }
    //comp has a spell and player doesn't
    else if(compIndexOfCardInSpellZone != -1 && playerIndexOfCardInSpellZone == -1){
      //comp has a power down
      if(compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, compHand.cards[compIndexOfCardInSpellZone]);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult);
      }
      //neither have a power down
      else{
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], blank0Mult);
      }
    }
    //neither has a spell
    else if(compIndexOfCardInSpellZone == -1 && playerIndexOfCardInSpellZone == -1){
      playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult);
      compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult);
    }
    println("Player power: " + playerPower);
    println("Comp power: " + compPower);
    if(playerPower > compPower){
      playerScore--;
      battleWon.play();
      playerWonBattle = true;
    }
    if(compPower > playerPower){
      compScore--;
      battleLost.play();
      compWonBattle = true;
    }
    playerHand.cards[playerIndexOfCardInBattleZone].setPos(playerDiscardPos.x, playerDiscardPos.y);
    playerHand.removeCardFromHand(playerIndexOfCardInBattleZone);
    compHand.cards[compIndexOfCardInBattleZone].setPos(compDiscardPos.x, compDiscardPos.y);
    compHand.removeCardFromHand(compIndexOfCardInBattleZone);
    if(playerIndexOfCardInSpellZone != -1){
      playerHand.cards[playerIndexOfCardInSpellZone].setPos(playerDiscardPos.x, playerDiscardPos.y);
      playerHand.removeCardFromHand(playerIndexOfCardInSpellZone);
    }
    if(compIndexOfCardInSpellZone != -1){
      compHand.cards[compIndexOfCardInSpellZone].setPos(compDiscardPos.x, compDiscardPos.y);
      compHand.removeCardFromHand(compIndexOfCardInSpellZone);
    }
    combatCalced = true;
    phaseIndicatorFrameCount = 0;
    phaseIndicatorFlashed = false;
  }
  if(playerWonBattle){
    if(!phaseIndicatorFlashed){
      textSize(60);
      fill(255);
      stroke(255);
      image(battleWonImg, width/2, height/2);
      phaseIndicatorFrameCount++;
      if(phaseIndicatorFrameCount >= 100){
        phaseIndicatorFlashed = true;
      }
    }
  }
  if(compWonBattle){
    if(!phaseIndicatorFlashed){
        textSize(60);
        fill(255);
        stroke(255);
        image(battleLostImg, width/2, height/2);
        phaseIndicatorFrameCount++;
        if(phaseIndicatorFrameCount >= 100){
          phaseIndicatorFlashed = true;
        }
      }
  }
  if(!compWonBattle && !playerWonBattle){
    if(!phaseIndicatorFlashed){
        textSize(60);
        fill(255);
        stroke(255);
        text("Tie!", width/2, height/2);
        phaseIndicatorFrameCount++;
        if(phaseIndicatorFrameCount >= 200){
          phaseIndicatorFlashed = true;
        }
      }
  }
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  stroke(255);
  text("ENTER to continue to next turn", width/2, height - ((handPadY/2) + cardHeight + 10));
}

float calcScore(Card mon, Type oppType, Card spe, Card powerDown){ //if no power down was played pass a blank 0x spell
  float p = mon.power;
  print(p + " * ");
  switch(mon.type){
    case VOLC:
    if(oppType == Type.FOR || oppType == Type.CAV){
      p *=2;
      print("2");
    }
    break;
    case OCE:
    if(oppType == Type.VOLC || oppType == Type.LAN){
      p *=2;
      print("2");
    }
    break;
    case FOR:
    if(oppType == Type.OCE || oppType == Type.LAN || oppType == Type.VOLT){
      p *=2;
      print("2");
    }
    break;
    case LAN:
    if(oppType == Type.VOLC || oppType == Type.CAV || oppType == Type.VOLT){
      p *=2;
      print("2");
    }
    break;
    case CAV:
    if(oppType == Type.FOR || oppType == Type.VOLT || oppType == Type.NEU){
      p *=2;
      print("2");
    }
    break;
    case BRA:
    if(oppType == Type.LAN || oppType == Type.CAV){
      p *=2;
      print("2");
    }
    break;
    case SKY:
    if(oppType == Type.FOR || oppType == Type.BRA){
      p *=2;
      print("2");
    }
    break;
    case VOLT:
    if(oppType == Type.OCE || oppType == Type.SKY){
      p *=2;
      print("2");
    }
    break;
    case NEU:
    if(oppType == Type.BRA){
      p *=2;
      print("2");
    }
    break;
    default:
    
    break;
  }
  print(" * ");
  p *= spe.multiplier;
  print(spe.multiplier);
  print(" * ");
  p *= powerDown.multiplier;
  println(powerDown.multiplier);
  
  return p;
}

boolean checkValidSpell(Card mon, Card spe){
  boolean ret = true;
  switch(spe.name){
    case "Conflagerate":
      if(mon.type == Type.VOLC){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Tsunami":
      if(mon.type == Type.OCE){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Overgrowth":
      if(mon.type == Type.FOR){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Earthquake":
      if(mon.type == Type.LAN){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Echo":
      if(mon.type == Type.CAV){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Deadlift":
      if(mon.type == Type.BRA){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Tornado":
      if(mon.type == Type.SKY){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Overload":
      if(mon.type == Type.VOLT){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    case "Psycho Shift":
      if(mon.type == Type.NEU){
        ret = true;
      }
      else{
        ret = false;
      }
    break;
    default:
      ret = true;
    break;
  }
  if(ret){
    println("Valid Spell");
  }
  else{
    println("Not a Valid Spell");
  }
  return ret;
}

Card[] removeItem(Card[] a, int index){
  Card[] newArr = new Card[a.length-1];
  for(int i = index; i < a.length-1; i++){
    a[i] = a[i+1];
  }
  for(int i = 0; i < newArr.length; i++){
    newArr[i] = a[i];
  }
  return newArr;
}

void drawScores(){
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(25);
  text("Score: " + playerScore, playerDeckX, playerDeckY - ((cardHeight/2) + (3*handPadX/2)));
  text("Score: " + compScore, compDeckX, compDeckY + (cardHeight/2) + (3*handPadX/2));
}

void resetControllers(){
  initialHandsDrawn = false;
  prepPhase = false;
  battlePhase = false;
  phaseIndicatorFlashed = false;
  prepSlotsOpen[0] = true;
  prepSlotsOpen[1] = true;
  prepSlotsOpen[2] = true;
  compPrepCardsChosen = false;
  compBattleCardChosen = false;
  spellPhase = false;
  compSpellCardChosen = false;
  fightPhase = false;
  combatCalced = false;
  
  phaseIndicatorFrameCount = 0; //counter needs reset
  playerCardsInPrepZone = 0; //counter needs reset
  playerCardsInBattleZone = 0; //counter needs reset
  playerIndexOfCardInBattleZone = -1;
  compIndexOfCardInBattleZone = -1;
  compCardsInPrepZone = 0; //counter needs reset
  compCardsInBattleZone = 0; //counter needs reset
  playerCardsInSpellZone = 0; //counter needs reset
  playerIndexOfCardInSpellZone = -1;
  compIndexOfCardInSpellZone = -1;
  
  for(int i = 0; i < maxHandSize; i++){
    if(!playerHand.openIndices[i]){
      playerHand.cards[i].setPos(playerHandPos[i].x, playerHandPos[i].y);
    }
    if(!compHand.openIndices[i]){
      compHand.cards[i].setPos(compHandPos[i].x, compHandPos[i].y);
    }
  }
}

void resetGame(){
  resetControllers();
  initializeDecks();
  gameOver = false;
  playerScore = 0;
  compScore = 0;
  menu = true;
  while(playerHand.handSize > -1 && compHand.handSize > -1){
    playerHand.removeCardFromHand(playerHand.handSize);
    compHand.removeCardFromHand(compHand.handSize);
  }
}
