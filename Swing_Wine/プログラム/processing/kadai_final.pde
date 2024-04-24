/*
 学生番号：2310026
 氏名：大塚眞柊
 知識メディア方法論 最終課題
 
 使用した外部ライブラリ「Minim」(音を出すためのライブラリ)
 
 使用した音源
 bgm 「8bit Game Menu」 https://www.youtube.com/watch?v=LXMQPiXUBHA
 
 効果音ラボ　https://soundeffect-lab.info
 speedup「決定ボタンを押す20」
 speeddown「ビープ音3」
 breakblorck「石が砕ける」
 hit bar「カーソル移動1」
 hit wall「カーソル移動9」
 */

import ddf.minim.*;
import processing.serial.*;
Serial serial;

Minim minim;
AudioPlayer bgm;
AudioPlayer breakblock;
AudioPlayer speedup;
AudioPlayer speeddown;
AudioPlayer hitBar;
AudioPlayer hitWall;

Ball ball = new Ball();
Bar bar = new Bar();
final int MAX_BLOCKS = 20;
Block[] block = new Block[MAX_BLOCKS];
String ballEffect = null;
boolean vanishCollision = false;
int ms; //milli second
int time;
int begin_time;
int flagCount = 0;
boolean breakTiming;  //ブロックを壊したタイミング
int interval; //シリアル通信の感覚を開けるための変数

int[] data = new int[3]; //arduinoから送られてきたデータ (y,z,重さ)
int dataY;
int dataZ;

int weightStatus_neutral = 0;     //何も乗っていない時の重さセンサの値
int weightStatus_emptyGlass = 0;  //グラスだけが乗っている時の重さセンサの値
int weightStatus_fullGlass = 0;   //飲み物入りのグラスが乗っている時の重さセンサの値
int weightStatus_end = 0;         //ゲームが終わった時のグラスの重さの値

CollisionChecker collisionChecker = new CollisionChecker();

int gameStep;//ゲームの状態

String[] vectorArray = new String[8];
int vectorCount = 0;

void setup() {
  serial = new Serial(this, "COM3", 9600);

  size(600, 720);
  background(0, 200, 255);
  textSize(40.0f);
  fill(0, 0, 0);

  arrangeBlocks();
  gameStep = 0;
  stroke(0, 0, 0);
  breakTiming = false;
  interval = 0;

  minim = new Minim(this);
  bgm = minim.loadFile("./sound/8bit Game Menu.mp3");
  breakblock = minim.loadFile("./sound/breakblock.mp3");
  speedup = minim.loadFile("./sound/speedup.mp3");
  speeddown = minim.loadFile("./sound/speeddown.mp3");
  hitBar = minim.loadFile("./sound/hit bar.mp3");
  hitWall = minim.loadFile("./sound/hit wall.mp3");

  delay(2000);  //センサの値が安定するまで待つ

  bgm.setVolume(0.01);
  bgm.setGain(-20);
  bgm.play();
}

void draw() {
  background(0, 200, 255);

  /*bgmが修了したら最初から再度流す*/
  int pos = bgm.position( );
  if (pos >= 44000) {
    bgm.play(0);
  }

  vector();

  if (spinCheck_clock()) {
    println("clock");
  }
  if (spinCheck_counter()) {
    println("counter");
  }

  flagCount = 0;
  ballEffect = null;
  
  println(data[2]);

  if (gameStep == 0) {
    text("Place the glass on the stand.", 60, 300);

    if (weightStatus_neutral == 0) {
      weightStatus_neutral = judgeWeight(); //何も乗っていない時の重さセンサの値を取り出す
    }

    if (judgeWeight() > weightStatus_neutral + 1) { //台にグラスを乗せるまで待機(+1は誤差を苦慮して加えている)
      gameStep = 1;

      delay(2000);

      weightStatus_emptyGlass = judgeWeight();  //空のグラスの重さを取得
    }
  }

  if (gameStep == 1) {
    textSize(50.0f);
    text("Fill your glass with a drink.", 35, 300);
    textSize(30.0f);
    text("Once you have done that, press the spacebar.", 25, 350);
    if (key == ' ') {
      weightStatus_fullGlass = judgeWeight();  //飲み物入りのグラスの重さを取得
      gameStep = 2;
      begin_time = millis();  //セットアップが完了したらその開始時間を取得
    }
  }

  if (gameStep == 2 || gameStep == 3) {
    strokeWeight(3);
    stroke(200, 200, 200);
    line(500, 0, 500, height);
    strokeWeight(1);
    stroke(0, 0, 0);

    bar.move(data);
    ball.move(gameStep, bar, spinCheck_clock(), spinCheck_counter());
    collisionChecker.checkCollision(ball, bar);

    for (int i = 0; i < MAX_BLOCKS; i++) {
      block[i].move();
      collisionChecker.checkCollision(ball, block[i], vanishCollision);
    }

    bar.render();
    ball.render();

    for (int i = 0; i < MAX_BLOCKS; i++) {
      block[i].render();
    }

    if (gameStep == 2) {
      textSize(50.0f);
      fill(0, 0, 0);
      text("Tilt your glass forward.", 60, 450);

      if (vectorArray[0] == "UP") {  //グラスを奥に倒すとボール発射
        gameStep = 3;
      }
    }
    if (ball.missCounter != ball.missCounterBefore) {
      gameStep = 2;
      ball.missCounterBefore = ball.missCounter;
    }

    if (ballEffect != null) {
      if (ballEffect == "big") {
        if (ball.radius < 70.0f) {
          //ball.radius = ball.radius + 0.2f;
        }
      } else if (ballEffect == "penetrate") {
        vanishCollision = true;
      }
    }


    ms = millis() - begin_time;  //ミリ秒数取得
    time = 60 - (ms / 1000);

    fill(0, 0, 0);
    textSize(50.0f);
    text(time, 520, 50);

    textSize(30.0f);
    for (int i = 0; i < MAX_BLOCKS; i++) {
      if (block[i].hitFlag) {
        flagCount++;
      }
    }

    if (flagCount == MAX_BLOCKS) {
      gameStep = 4;
    }

    if (time < 0) {
      textSize(100.0f);
      text("Game Over!", 60, 300);
      noLoop();
    }
    if (ball.missCounter >= 5) {
      textSize(100.0f);
      text("Game Over!", 60, 300);
      noLoop();
    }
  }

  if (gameStep == 4) {
    textSize(40.0f);
    text("Place the glass on the stand.", 60, 300);

    if (weightStatus_neutral  < judgeWeight()) {
      delay(5000);

      weightStatus_end = judgeWeight(); //最後にグラスを台に乗せた時の重さセンサの値を取り出す

      gameStep = 5;
    }
  }

  if (gameStep == 6) {
    println("start " + weightStatus_emptyGlass, "end " + weightStatus_end);

    if (weightStatus_emptyGlass - 1 < weightStatus_end && weightStatus_end < weightStatus_emptyGlass +1 && weightStatus_end != 0) {
      textSize(100.0f);
      text("Clear!", 180, 300);
      noLoop();
    } else if (weightStatus_end != 0) {
      textSize(100.0f);
      text("Game Over!", 60, 300);
      noLoop();
    }
  }

  /*結果の描画を正しくするための処理(ループを1回回して描画をリセットする)*/
  if (gameStep == 5) {
    gameStep = 6;
  }
}

void serialEvent(Serial p) {
  String string = p.readStringUntil('\n');

  if (string != null) {
    string = trim(string);
    data = int(split(string, ' '));
  }
}

int judgeWeight() {
  int total = 0;
  for (int i = 0; i < 100; i++) {
    total += data[2];
  }
  return total / 100;
}

void vector() {
  if (data[0] < -30 && data[1] < -20) {
    addList("UP_LEFT");
  } else if (data[0] > 30 && data[1] > 20) {
    addList("DOWN_RIGHT");
  } else if (data[0]< -30 && data[1] > 20) {
    addList("DOWN_LEFT");
  } else if (data[0] > 30 && data[1] < -20) {
    addList("UP_RIGHT");
  } else if (data[0] < -30) {
    addList("LEFT");
  } else if (data[0] > 30) {
    addList("RIGHT");
  } else if (data[1] < -20) {
    addList("UP");
  } else if (data[1] > 20) {
    addList("DOWN");
  }
}

void addList(String str) {
  if (vectorArray[0] != str) {
    for (int i = 6; i >= 0; i--) {
      vectorArray[i + 1] = vectorArray[i];
    }
    vectorArray[0] = str;
  }
}

boolean spinCheck_clock() {
  int[] countCheck_clock = new int[8];    //時計回りのチェック

  for (int i = 0; i < 8; i++) {
    if (vectorArray[(i+0) % 8] == "UP") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+1) % 8] == "UP_RIGHT") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+2) % 8] == "RIGHT") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+3) % 8] == "DOWN_RIGHT") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+4) % 8] == "DOWN") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+5) % 8] == "DOWN_LEFT") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+6) % 8] == "LEFT") {
      countCheck_clock[i]++;
    }
    if (vectorArray[(i+7) % 8] == "UP_LEFT") {
      countCheck_clock[i]++;
    }
  }

  for (int i = 0; i < 8; i++) {
    if (countCheck_clock[i] == 8) {
      return true;
    }
  }
  return false;
}

boolean spinCheck_counter() {
  int[] countCheck_counter = new int[8];  //反時計回りのチェック
  for (int i = 0; i < 8; i++) {
    countCheck_counter[i] = 0;
  }

  for (int i = 0; i < 8; i++) {
    if (vectorArray[(i+0) % 8] == "UP") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+1) % 8] == "UP_LEFT") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+2) % 8] == "LEFT") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+3) % 8] == "DOWN_LEFT") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+4) % 8] == "DOWN") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+5) % 8] == "DOWN_RIGHT") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+6) % 8] == "RIGHT") {
      countCheck_counter[i]++;
    }
    if (vectorArray[(i+7) % 8] == "UP_RIGHT") {
      countCheck_counter[i]++;
    }
  }

  for (int i = 0; i < 8; i++) {
    if (countCheck_counter[i] == 8) {
      return true;
    }
  }
  return false;
}

void stop() {
  bgm.close();
  breakblock.close();
  speedup.close();
  speeddown.close();
  hitBar.close();
  hitWall.close();

  minim.stop();
  super.stop();
}
