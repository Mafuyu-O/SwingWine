class Bar {

  float x;
  float y;

  float vX = 5.0f;
  float vY = 5.0f;

  float barWidth = 200.0f;
  float barHeight = 50.0f;

  /* Barを動かす */
  void move(int[] data) {
    x = (data[0] + 300) - barWidth / 2;
    y = (data[1] + 600) - barHeight / 2;
  }

  void render() {
    fill(255,255,255);
    rect(x, y, barWidth, barHeight);
  }

  /* 衝突通知 */
  void reactToCollision() {
    // バーは何もしない
  }
}

/*バーの動き*/
//void moveBar() {
//  if (keyPressed) {
//    if (keyCode == RIGHT && barX + barWidth <= width) {
//      barX = barX + barVX;
//    }
//    if (keyCode == LEFT && barX >= 0) {
//      barX = barX - barVX;
//    }

//    if (keyCode == UP && barY >= 0) {
//      barY = barY - barVY;
//    }
//    if (keyCode == DOWN && barY + barHeight <= height) {
//      barY = barY + barVY;
//    }
//  }
//}

//void drawBar(){
//  rect(barX, barY, barWidth, barHeight);
//}
