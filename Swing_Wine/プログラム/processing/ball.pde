class Ball {

  float x = 400.0f;
  float y = 250.0f;

  float vX = 0.1f;
  float vY = 5.0f;

  float tmpVX = vX;
  float tmpVY = vY;

  float radius = 10.0f;

  int missCounter = 0;
  int missCounterBefore = 0;

  int speedDisplayTime = 100;
  int remainingTime = speedDisplayTime;


  void move(int gameStep, Bar bar, boolean spinClock, boolean spinCounter) {
    if (gameStep == 2) {  //ボール発射前なら
      x = bar.x + bar.barWidth / 2;
      y = bar.y - radius - 1.0f;
    }


    if (gameStep == 3) {  //ボール発射後なら
      x = x + vX;
      y = y - vY;

      if (spinClock) {
        if (remainingTime > 0) {
          text("SPEED UP", x+20, y);
          remainingTime--;
        }

        if (vY >= 0) {
          vY += 0.1f;
        } else if (vY < 0) {
          vY -= 0.1f;
        }

        speedup.play(0);
      }
      if (spinCounter) {
        if (remainingTime > 0) {
          text("SPEED DOWN", x+20, y);
          remainingTime--;
        }

        if (vY >= 0) {
          vY -= 0.1f;
        } else if (vY < 0) {
          vY += 0.1f;
        }

        speeddown.play(0);
      }

      if (remainingTime == 0) {
        remainingTime = speedDisplayTime;
      }


      if ( x + radius> width -100.0f || x - radius < 0 ) {
        vX = -vX;
        hitWall.play(0);
      }
      //if  ( y > height || y < 0 ) {   // 下端で跳ね返る場合の条件
      if  ( y - radius < 0 ) {

        vY = -vY;
        
        hitWall.play(0);

        /* ボールが下端に行くと１ミス */
      } else if ( y > height + radius ) {  // ボールの半径分画面より下にしてボールを完全に画面外に出す
        missCounterBefore = missCounter;
        missCounter++;

        //x = 100;    // 初期位置に戻す
        //y = 200;

        println("Miss:" + missCounter + "!!");

        /* 何度かミスするとゲームオーバー */
        //if ( missCounter >= 1 ) {
        //  textSize(100.0f);
        //  text("Game Over!", 80, 300);
        //  noLoop();
        //}
      }
    }
  }

  void render() {
    fill(105, 28, 42);
    ellipse(x, y, radius * 2, radius * 2);
  }

  /* 衝突通知 */
  void reactToCollisionBlock() {
    vY = -vY;
    breakblock.play(0);
  }
  void reactToCollisionBar(Bar bar) {
    vY = -vY;
    //ボールのx軸速度をバーの当たった位置によって変える
    vX = (x - (bar.x + (bar.barWidth / 2))) / ((bar.barWidth/2) / 10.0f);

    hitBar.play(0);
  }
}

//void moveBall() {
//  /*当たり判定*/
//  if(ballX >= barX && ballX <= barX + barWidth && ballY + ballRadius >= barY &&
//       ballY - ballRadius <= barY + barHeight){
//    ballVY = -ballVY;
//  }

//  if(ballY >= barY && ballY <= barY + barHeight && ballX + ballRadius >= barX && ballX + ballRadius <=barX + barWidth){
//    ballVX = -ballVX;
//  }
//  if(ballY >= barY && ballY <= barY + barHeight && ballX - ballRadius >= barX && ballX - ballRadius <= barX + barWidth){
//    ballVX = -ballVX;
//  }

//  /*ボールの動き*/
//  ballX = ballX + ballVX;
//  ballY = ballY + ballVY;

//  if (ballX - ballRadius <= 0) {
//    ballVX = -ballVX;
//  }
//  if (ballX + ballRadius >= width) {
//    ballVX = -ballVX;
//  }
//  if (ballY - ballRadius <= 0) {
//    ballVY = -ballVY;
//  }
//  /*画面下の判定*/
//  /*
//  if (ballY + ballRadius >= height) {
//    ballVY = -ballVY;
//  }
//  */
//}

//void drawBall(){
//  ellipse(ballX, ballY, ballRadius*2, ballRadius*2);
//}
