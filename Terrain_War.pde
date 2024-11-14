/*
Written By: Max Austin
Art By: Victor Mendoza

Every deck has 40 cards 1-4 power of each type and 14 spells

Spells are:
Counterspell - Cancel the last spell your opponent played
2x Power-Up - Double your monster's power
2x Power-Down - Halve Your oponents monsters power
Incinerate - Triple your volcano monsters power
Tsunami - Triple your ocean monsters power
Overgrowth - Triple your forest monsters power
Earthquake - Triple your land monsters power
Echo - Triple your cave monsters power
Deadlift - Triple your brawl monsters power
Tornado - Triple your sky monsters power
Overload - Triple your voltage monsters power
Psycho Shift - Triple your neuron monsters power

KNOWN BUGS:

TO DO:
- High Scores
  - Should have a category for each level
- Levels
  - First level: No Spells, 3 types
  - Second Level: Spells, 3 tyeps
  - Third Level: Spells, 6 types
  - Fourth Level: Spells, 9 types
- Display discard piles
  - A way to see all cards in discard pile
- Button Click sound
- Make opponent smarter

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
PImage twoXIndicator;
PImage threeXIndicator;
PImage[] playerMultipliers = new PImage[3];
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
PImage[] playerMultiDisplay = new PImage[3];
PImage[] compMultiDisplay = new PImage[3];

color rulesHighlight = #AB40C1;

PFont headerFont;

import java.util.*;
static final int deckSize = 50;
static final int maxHandSize = 10;

int playerDeckX;
int playerDeckY;
static final int compDeckX = 100;
static final int compDeckY = 100;
static final int cardWidth = 82;
static final int cardHeight = 128;
static final int handPadX = 10;
static final int handPadY = 100;
static final int menuOffSetY = 150;
static final int pointsNeededToWin = 10;

PVector[] playerHandPos = new PVector[maxHandSize];
PVector[] compHandPos = new PVector[maxHandSize];
PVector[] playerPrepPos = new PVector[3];
PVector[] compPrepPos = new PVector[3];
PVector playerBattlePos;
PVector compBattlePos;
PVector playerSpellPos;
PVector compSpellPos;
PVector playerDiscardPos;
PVector compDiscardPos;
PVector[] playerMultiplierPos = new PVector[3];
PVector[] compMultiplierPos = new PVector[3];

static enum Type {VOLC, OCE, FOR, LAN, CAV, BRA, SKY, VOLT, NEU, SPE};

DeckStack playerDeck = new DeckStack();
DeckStack compDeck = new DeckStack();
DeckStack playerDiscard = new DeckStack();
DeckStack compDiscard = new DeckStack();
Hand playerHand = new Hand(true);
Hand compHand = new Hand(false);

boolean firstHandsDrawn = false;
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
boolean discardCardsMoved = false;

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
int playerMultipliersReceived = 0;
int compMultipliersReceived = 0;

static float multiIndicatorScaleFactor = 0.35;
static int multiIndicatorWidth = 40;
static int multiIndicatorHeight = 30;

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
  //size(1900,1080);
  fullScreen();
  textAlign(CENTER, CENTER);
  //println(dataPath("") + '/');
  
  playerDeckX = width-100;
  playerDeckY = height-handPadY;
  
  headerFont = createFont("data/MetalMania-Regular.ttf", 20);
  textFont(headerFont);
  
  imageMode(CENTER);
  rectMode(CENTER);
  
  initializeImages();
  initializeFrames();
  initializeDecks();
  initializeVectors();
  initializeSounds();
  
  returnToMenuFromRules = new Button(width/2, height - (menuButtonHeight), menuButtonWidth, menuButtonHeight, "Main Menu");
  returnToMenuFromGame = new Button(width - 150, 50, menuButtonWidth/3, menuButtonHeight/2, "Main Menu");
  menuButtons[0] = new Button(width/2, (height/2) + menuOffSetY - (menuButtonHeight + (menuButtonPadY/2)), menuButtonWidth, menuButtonHeight, "Start Game");
  menuButtons[1] = new Button(width/2, (height/2) + menuOffSetY, menuButtonWidth, menuButtonHeight, "Rules");
  menuButtons[2] = new Button(width/2, (height/2) + (menuButtonHeight + (menuButtonPadY/2) + menuOffSetY), menuButtonWidth, menuButtonHeight, "High Scores (Under Construction)");
}

void initializeVectors(){
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
  
  playerMultiplierPos[0] = new PVector(playerBattlePos.x - cardWidth, playerBattlePos.y);
  playerMultiplierPos[1] = new PVector(playerMultiplierPos[0].x - (multiIndicatorWidth) - handPadX, playerBattlePos.y);
  playerMultiplierPos[2] = new PVector(playerMultiplierPos[1].x - (multiIndicatorWidth) - handPadX, playerBattlePos.y);
  compMultiplierPos[0] = new PVector(compBattlePos.x + cardWidth, compBattlePos.y);
  compMultiplierPos[1] = new PVector(compMultiplierPos[0].x + (multiIndicatorWidth) + handPadX, compBattlePos.y);
  compMultiplierPos[2] = new PVector(compMultiplierPos[1].x + (multiIndicatorWidth) + handPadX, compBattlePos.y);
  
}

void initializeFrames(){
  skyFrames[0] = loadImage("data/Sky0001.png");
  skyFrames[1] = loadImage("data/Sky0002.png");
  skyFrames[2] = loadImage("data/Sky0003.png");
  skyFrames[3] = loadImage("data/Sky0004.png");
  
  volcFrames[0] = loadImage("data/VOL0001.png");
  volcFrames[1] = loadImage("data/VOL0002.png");
  volcFrames[2] = loadImage("data/VOL0003.png");
  volcFrames[3] = loadImage("data/VOL0004.png");
  
  oceFrames[0] = loadImage("data/OCE0001.png");
  oceFrames[1] = loadImage("data/OCE0002.png");
  oceFrames[2] = loadImage("data/OCE0003.png");
  oceFrames[3] = loadImage("data/OCE0004.png");
  
  lanFrames[0] = loadImage("data/LND0001.png");
  lanFrames[1] = loadImage("data/LND0002.png");
  lanFrames[2] = loadImage("data/LND0003.png");
  lanFrames[3] = loadImage("data/LND0004.png");
  
  forFrames[0] = loadImage("data/For0001.png");
  forFrames[1] = loadImage("data/For0002.png");
  forFrames[2] = loadImage("data/For0003.png");
  forFrames[3] = loadImage("data/For0004.png");
  
  cavFrames[0] = loadImage("data/Cave.png");
  cavFrames[1] = loadImage("data/Cave.png");
  cavFrames[2] = loadImage("data/Cave.png");
  cavFrames[3] = loadImage("data/Cave.png");
  
  braFrames[0] = loadImage("data/BRL0001.png");
  braFrames[1] = loadImage("data/BRL0002.png");
  braFrames[2] = loadImage("data/BRL0003.png");
  braFrames[3] = loadImage("data/BRL0004.png");
  
  voltFrames[0] = loadImage("data/VLT0001.png");
  voltFrames[1] = loadImage("data/VLT0002.png");
  voltFrames[2] = loadImage("data/VLT0003.png");
  voltFrames[3] = loadImage("data/VLT0004.png");
  
  neuFrames[0] = loadImage("data/NRO0001.png");
  neuFrames[1] = loadImage("data/NRO0002.png");
  neuFrames[2] = loadImage("data/NRO0003.png");
  neuFrames[3] = loadImage("data/NRO0004.png");
  
  speFrames[0] = loadImage("data/Spell.png");
  speFrames[1] = loadImage("data/Spell.png");
  speFrames[2] = loadImage("data/Spell.png");
  speFrames[3] = loadImage("data/Spell.png");
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
  playerDeck.push(new Card(playerDeckX, playerDeckY, speFrames, false, Type.SPE, 0, "Incinerate", 3));
  compDeck.push(new Card(compDeckX, compDeckY, speFrames, false, Type.SPE, 0, "Incinerate", 3));
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

void initializeImages(){
  menuBackground = loadImage("data/Menu-Background.png");
  gameBackground = loadImage("data/Game-Background.png");
  gameBackground.resize(width, height);
  blankCard = loadImage("data/blankcard.png");
  typeChart = loadImage("data/type-chart.PNG");
  cardBack = loadImage("data/CardBack.png");
  prepPhaseImg = loadImage("data/PrepPhase.png");
  battlePhaseImg = loadImage("data/BattlePhase.png");
  logo = loadImage("data/Logo.png");
  battleWonImg = loadImage("data/BattleWon.png");
  battleLostImg = loadImage("data/BattleLost.png");
  twoXIndicator = loadImage("data/2x.png");
  threeXIndicator = loadImage("data/3x.png");
}

void initializeSounds(){
  musicLoop = new SoundFile(this, "data/music-loop.mp3");
  drawCard = new SoundFile(this, "data/draw.wav");
  moveCard = new SoundFile(this, "data/move-card.wav");
  battleWon = new SoundFile(this, "data/battle-won.wav");
  battleLost = new SoundFile(this, "data/battle-lost.wav");
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
      playerDiscard.drawDeck();
      compDiscard.drawDeck();
      drawScores();
    
      if(!initialHandsDrawn){ 
        //println("DRAW CALL: Player hand size: " + playerHand.handSize + "     Comp hand size: " + compHand.handSize);
        drawFullHands();
        if(compDeck.top == -1 || playerDeck.top == -1){
          gameOver = true;
          println("Found game over");
        }
      }
      if(prepPhase){
        firstHandsDrawn = true;
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
        displayMultipliers();
      }
    }
    if(gameOver){
      if(phaseIndicatorFrameCount <= 1000){
        textSize(60);
        fill(255);
        stroke(255);
        if(playerScore > compScore){
          text("You Win!", width/2, height/2);
        }
        else if(compScore > playerScore){
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
            playerHand.cards[indexOfCardClicked].setPos(playerPrepPos[playerCardsInPrepZone].x, playerPrepPos[playerCardsInPrepZone].y);
            playerHand.cards[indexOfCardClicked].inPrepZone = true;
            println("prepSlotsOpen of " + playerCardsInPrepZone + ": " + prepSlotsOpen[playerCardsInPrepZone]);
          }
          else{
            boolean slotFound = false;
            for(int i = 0; i < 3; i++){
              if(prepSlotsOpen[i] && !slotFound){
                prepSlotsOpen[i] = false;
                playerHand.cards[indexOfCardClicked].prepSlotTaken = i;
                playerHand.cards[indexOfCardClicked].setPos(playerPrepPos[i].x, playerPrepPos[i].y);
                println("prepSlotsOpen of " + i + ": " + prepSlotsOpen[playerCardsInPrepZone]);
                playerHand.cards[indexOfCardClicked].inPrepZone = true;
                slotFound = true;
              }
            }
          }
          playerCardsInPrepZone++;
          
          println("inPrepZone of card clicked: " + playerHand.cards[indexOfCardClicked].inPrepZone);
          println("playerCardsInPrepZone: " + playerCardsInPrepZone);
          println("prepSlotTaken of Card clicked: " + playerHand.cards[indexOfCardClicked].prepSlotTaken);
          println();
        }
        //card is clicked to remove from prep zone
        else if(indexOfCardClicked != -1 && playerCardsInPrepZone != 0 && playerHand.cards[indexOfCardClicked].prepSlotTaken != -1){
          println("Moving card back to hand");
          playerHand.cards[indexOfCardClicked].setPos(playerHandPos[indexOfCardClicked].x, playerHandPos[indexOfCardClicked].y);
          prepSlotsOpen[playerHand.cards[indexOfCardClicked].prepSlotTaken] = true;
          println("prepSlotsOpen of " + playerHand.cards[indexOfCardClicked].prepSlotTaken + " : " + prepSlotsOpen[playerHand.cards[indexOfCardClicked].prepSlotTaken]);
          playerHand.cards[indexOfCardClicked].prepSlotTaken = -1;
          playerHand.cards[indexOfCardClicked].inPrepZone = false;
          playerCardsInPrepZone--;
          println("inPrepZone of card clicked: " + playerHand.cards[indexOfCardClicked].inPrepZone);
          println("playerCardsInPrepZone: " + playerCardsInPrepZone);
          println("prepSlotTaken of Card clicked: " + playerHand.cards[indexOfCardClicked].prepSlotTaken);
          println();
        }
      }
      if(battlePhase){
        if(indexOfCardClicked != -1 && playerCardsInBattleZone != 1 && !playerHand.cards[indexOfCardClicked].inBattleZone && playerHand.cards[indexOfCardClicked].inPrepZone){
          //println("SHOULD SEE THIS ONCE");
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
  //println("draw full hands call " + playerHand.handSize, compHand.handSize);
  if(playerHand.getHandSize() != 9){
    playerHand.addCardToHand(playerDeck.peek());
    playerDeck.pop();
    //println("Drawing to player hand, hand size: " + playerHand.handSize);
  }
  if(compHand.getHandSize() != 9){
    compHand.addCardToHand(compDeck.peek());
    compDeck.pop();
    //println("Drawing to comp hand, hand size: " + compHand.handSize);
  }
  if(compHand.getHandSize() == 9 && playerHand.getHandSize() == 9){
    //println("Both players have full hands");
    initialHandsDrawn = true;
    prepPhase = true;
    if(playerHand.monsterCount == 0 || compHand.monsterCount == 0){
      gameOver = true;
    }
  }
  
  if(playerHand.handSize == 9 && compHand.handSize == 9){
    
    println("Player monster count: " + playerHand.monsterCount);
    println("Comp monster count: " + compHand.monsterCount);
    println("Player cards in deck: " + (playerDeck.top+1));
    println("Comp cards in deck: " + (compDeck.top+1));
  }
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
  int currentX = width/20;
  if(width > 2000){
    currentX += (width/10);
  }
  int currentY = height/20;
  int yIncrement = 40;
  int xIncrement = 40;
  fill(255);
  textSize(50);
  text("RULES", width/2, currentY);
  currentY += yIncrement;
  textSize(30);
  textAlign(LEFT, TOP);
  fill(rulesHighlight);
  text("Who am I playing against?", currentX, currentY);
  fill(255);
  currentX+=300;
  text("A computer that makes purely random decisions.", currentX, currentY);
  currentY += yIncrement;
  currentX-=300;
  fill(rulesHighlight);
  text("Card Types:", currentX, currentY);
  currentY += yIncrement;
  currentX += xIncrement;
  fill(rulesHighlight);
  text("Terrain:" , currentX, currentY);
  fill(255);
  currentX += 95;
  text("Used to battle, each terrain card has a type and power level indicated on the card.", currentX, currentY);
  currentX -= 95;
  //rectMode(CORNER);
  //rect(currentX, currentY, 297, 10);
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Spell: ", currentX, currentY);
  fill(255);
  currentX += 70;
  text("Used to enhance terrain cards.", currentX, currentY);
  currentX-=70;
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Type Matchups:", currentX, currentY);
  fill(255);
  currentY += yIncrement;
  currentX += xIncrement;
  text("Some types of terrain cards are better against others. Hold TAB at any time to show the typing cheat-sheet.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Prep Phase:", currentX, currentY);
  fill(255);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Prepare at most 3 terrain cards to potentially do battle, and, after finalizing your choice, your opponents' prepped cards are revealed.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Battle Phase:", currentX, currentY);
  fill(255);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Pick one card that will face off against your opponent's choice. After finalizing your choice your opponent's choice is revealed", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Spell Phase:", currentX, currentY);
  fill(255);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Pick a spell to enhance your terrain cards. Some spells can only be played when you have a certain type of terrain card battling. For example, the", currentX, currentY);
  currentY += yIncrement;
  text("spell Overload can only be played while you have a Voltage type terrain in battle.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("Spell Multipliers:", currentX, currentY);
  fill(255);
  currentX += xIncrement;
  currentY += yIncrement;
  text("Spells apply a multiplier to the power of your terrain card: Power-Up applies a 2x, Power-Down applies a 0.5x to your opponnent, and all spells that are", currentX, currentY);
  currentY += yIncrement;
  text("type-specific apply a 3x.", currentX, currentY);
  currentX -= xIncrement;
  currentY += yIncrement;
  fill(rulesHighlight);
  text("When does the game end?", currentX, currentY);
  fill(255);
  currentX += xIncrement;
  currentY += yIncrement;
  text("The game ends when one player earns " + pointsNeededToWin + " points, either player has 0 cards in their deck, or either player has no terrain cards in hand.", currentX, currentY);
  textAlign(CENTER, CENTER);
  returnToMenuFromRules.drawButton();
}

void prepPhase(){
  textAlign(CENTER, CENTER);
  if(!phaseIndicatorFlashed){
    if(phaseIndicatorFrameCount <= 10){
      image(prepPhaseImg, (width/2)-(((width/2)+300)-((phaseIndicatorFrameCount*((width/2)+300))/10)), height/2);
    }
    else if (phaseIndicatorFrameCount < 90){
      image(prepPhaseImg, (width/2), height/2);
    }
    else {
      image(prepPhaseImg, (width/2)+(((width/2)+300)-(((100-phaseIndicatorFrameCount)*((width/2)+300))/10)), height/2);
    }
    phaseIndicatorFrameCount++;
    if(phaseIndicatorFrameCount >= 100){
      phaseIndicatorFlashed = true;
    }
  }
  if(!discardCardsMoved){
    //playerDiscard.printStack();
    //compDiscard.printStack();
    playerDiscard.setPosOfAll(playerDiscardPos);
    compDiscard.setPosOfAll(compDiscardPos);
    discardCardsMoved = true;
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
    if(phaseIndicatorFrameCount <= 10){
      image(battlePhaseImg, (width/2)-(((width/2)+300)-((phaseIndicatorFrameCount*((width/2)+300))/10)), height/2);
    }
    else if (phaseIndicatorFrameCount < 90){
      image(battlePhaseImg, (width/2), height/2);
    }
    else {
      image(battlePhaseImg, (width/2)+(((width/2)+300)-(((100-phaseIndicatorFrameCount)*((width/2)+300))/10)), height/2);
    }
    
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
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], blank0Mult, true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], blank0Mult, false);
      }
      //comp has power-down player doesn't
      if(compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down" && playerHand.cards[playerIndexOfCardInSpellZone].name != "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], compHand.cards[compIndexOfCardInSpellZone], true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult, false);
      }
      //comp doesn't have power down and player does
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down" && compHand.cards[compIndexOfCardInSpellZone].name != "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult, true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], playerHand.cards[playerIndexOfCardInSpellZone], false);
      }
      //both players have a power down
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down" && compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, compHand.cards[compIndexOfCardInSpellZone], true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, playerHand.cards[playerIndexOfCardInSpellZone], false);
      }
    }
    //comp has no spell while player does
    else if(compIndexOfCardInSpellZone == -1 && playerIndexOfCardInSpellZone != -1){
      //player has a power down
      if(playerHand.cards[playerIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult, true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, playerHand.cards[playerIndexOfCardInSpellZone], false);
      }
      //neither have a power down
      else{
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, playerHand.cards[playerIndexOfCardInSpellZone], blank0Mult, true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult, false);
      }
    }
    //comp has a spell and player doesn't
    else if(compIndexOfCardInSpellZone != -1 && playerIndexOfCardInSpellZone == -1){
      //comp has a power down
      if(compHand.cards[compIndexOfCardInSpellZone].name == "Power-Down"){
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, compHand.cards[compIndexOfCardInSpellZone], true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult, false);
      }
      //neither have a power down
      else{
        playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult, true);
        compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, compHand.cards[compIndexOfCardInSpellZone], blank0Mult, false);
      }
    }
    //neither has a spell
    else if(compIndexOfCardInSpellZone == -1 && playerIndexOfCardInSpellZone == -1){
      playerPower = calcScore(playerHand.cards[playerIndexOfCardInBattleZone], compType, blank0Mult, blank0Mult, true);
      compPower = calcScore(compHand.cards[compIndexOfCardInBattleZone], playerType, blank0Mult, blank0Mult, false);
    }
    println("Player power: " + playerPower);
    println("Comp power: " + compPower);
    if(playerPower > compPower){
      playerScore++;
      battleWon.play();
      playerWonBattle = true;
    }
    if(compPower > playerPower){
      compScore++;
      battleLost.play();
      compWonBattle = true;
    }
    if(compScore == pointsNeededToWin || playerScore == pointsNeededToWin){
      gameOver = true;
    }
    
    playerDiscard.push(playerHand.cards[playerIndexOfCardInBattleZone]);
    playerHand.removeCardFromHand(playerIndexOfCardInBattleZone);
    compDiscard.push(compHand.cards[compIndexOfCardInBattleZone]);
    compHand.removeCardFromHand(compIndexOfCardInBattleZone);
    if(playerIndexOfCardInSpellZone != -1){
      playerDiscard.push(playerHand.cards[playerIndexOfCardInSpellZone]);
      playerHand.removeCardFromHand(playerIndexOfCardInSpellZone);
    }
    if(compIndexOfCardInSpellZone != -1){
      compDiscard.push(compHand.cards[compIndexOfCardInSpellZone]);
      compHand.removeCardFromHand(compIndexOfCardInSpellZone);
    }
    combatCalced = true;
    phaseIndicatorFrameCount = 0;
    phaseIndicatorFlashed = false;
  }
  if(playerWonBattle){
    if(!phaseIndicatorFlashed){
      image(battleWonImg, width/2, height/2);
      phaseIndicatorFrameCount++;
      if(phaseIndicatorFrameCount >= 100){
        phaseIndicatorFlashed = true;
      }
    }
  }
  if(compWonBattle){
    if(!phaseIndicatorFlashed){
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

float calcScore(Card mon, Type oppType, Card spe, Card powerDown, boolean playerCalc){ //if no power down was played pass a blank 0x spell
  float p = mon.power;
  boolean typeMultiFound = false;
  print(p + " * ");
  switch(mon.type){
    case VOLC:
    if(oppType == Type.FOR || oppType == Type.CAV){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case OCE:
    if(oppType == Type.VOLC || oppType == Type.LAN){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case FOR:
    if(oppType == Type.OCE || oppType == Type.LAN || oppType == Type.VOLT){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case LAN:
    if(oppType == Type.VOLC || oppType == Type.CAV || oppType == Type.VOLT){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case CAV:
    if(oppType == Type.FOR || oppType == Type.VOLT || oppType == Type.NEU){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case BRA:
    if(oppType == Type.LAN || oppType == Type.CAV){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case SKY:
    if(oppType == Type.FOR || oppType == Type.BRA){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case VOLT:
    if(oppType == Type.OCE || oppType == Type.SKY){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    case NEU:
    if(oppType == Type.BRA){
      p *=2;
      typeMultiFound = true;
      print("2");
    }
    break;
    default:
    
    break;
  }
  if(playerCalc){
    if(typeMultiFound){
      playerMultiDisplay[playerMultipliersReceived] = twoXIndicator;
      playerMultipliersReceived++;
    }
    if(spe.multiplier == 2){
      playerMultiDisplay[playerMultipliersReceived] = twoXIndicator;
      playerMultipliersReceived++;
    }
    else if(spe.multiplier == 3){
      playerMultiDisplay[playerMultipliersReceived] = threeXIndicator;
      playerMultipliersReceived++;
    }
    if(powerDown.multiplier == 0.5){
      playerMultiDisplay[playerMultipliersReceived] = blankCard;
      playerMultipliersReceived++;
    }
  }
  if(!playerCalc){
    if(typeMultiFound){
      compMultiDisplay[compMultipliersReceived] = twoXIndicator;
      compMultipliersReceived++;
    }
    if(spe.multiplier == 2){
      compMultiDisplay[compMultipliersReceived] = twoXIndicator;
      compMultipliersReceived++;
    }
    else if(spe.multiplier == 3){
      compMultiDisplay[compMultipliersReceived] = threeXIndicator;
      compMultipliersReceived++;
    }
    if(powerDown.multiplier == 0.5){
      compMultiDisplay[compMultipliersReceived] = blankCard;
      compMultipliersReceived++;
    }
  }
  print(" * ");
  p *= spe.multiplier;
  print(spe.multiplier);
  print(" * ");
  p *= powerDown.multiplier;
  println(powerDown.multiplier);
  
  return p;
}

void displayMultipliers(){
  for(int i = 0; i < playerMultipliersReceived; i++){
    displayMultiplier(playerMultiDisplay[i], playerMultiplierPos[i]);
  }
  for(int i = 0; i < compMultipliersReceived; i++){
    displayMultiplier(compMultiDisplay[i], compMultiplierPos[i]);
  }
}

void displayMultiplier(PImage img, PVector pos){
  pushMatrix();
  translate(pos.x, pos.y);
  scale(multiIndicatorScaleFactor);
  image(img, 0, 0);
  popMatrix();
}

boolean checkValidSpell(Card mon, Card spe){
  boolean ret = true;
  switch(spe.name){
    case "Incinerate":
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
  discardCardsMoved = false;
  playerMultiDisplay = new PImage[3];
  compMultiDisplay = new PImage[3];
  playerMultipliersReceived = 0;
  compMultipliersReceived = 0;
  
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
    }
    for(int i = 0; i < compDiscard.top+1; i++){
      compDiscard.cards[i].show = true;
    }
}

void resetGame(){
  resetControllers();
  playerDeck = null;
  compDeck = null;
  initializeDecks();
  gameOver = false;
  playerScore = 0;
  compScore = 0;
  menu = true;
  firstHandsDrawn = false;
  playerDiscard = new DeckStack();
  compDiscard = new DeckStack();
  while(playerHand.handSize != -1 && compHand.handSize != -1){
    playerHand.removeCardFromHand(playerHand.handSize);
    compHand.removeCardFromHand(compHand.handSize);
  }
  playerHand = new Hand(true);
  compHand = new Hand(false);
  //playerDeck.shuffleDeck();
  //compDeck.shuffleDeck();
}
