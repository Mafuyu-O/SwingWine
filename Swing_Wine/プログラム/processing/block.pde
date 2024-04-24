final int BLOCK_WIDTH = 100;
final int BLOCK_HEIGHT = 20;
final int BLOCK_ROWS  =  4;    // ブロックの横一列の個数
final int BLOCK_GAP  =  5;      // ブロックとブロックの間隔
final int BLOCK_FIRST_X = 40;

void arrangeBlocks() {
  for (int i = 0; i < MAX_BLOCKS; i++) {
    block[i] = new Block();
    block[i].blockWidth = BLOCK_WIDTH;
    block[i].blockHeight = BLOCK_HEIGHT;
    block[i].x = BLOCK_GAP + i % BLOCK_ROWS * (BLOCK_WIDTH + BLOCK_GAP) + BLOCK_FIRST_X;
    block[i].y = BLOCK_GAP + i / BLOCK_ROWS * (BLOCK_HEIGHT + BLOCK_GAP);
  }
}

class Block {

  float x = 50.0f;
  float y = 0.0f;
  float blockWidth = 100;
  float blockHeight = 30;
  boolean hitFlag = false;

  /* Blockを並べる関数 */
  void arrangeBlock(int x0, int y0) {
    x = x0;
    y = y0;
  }

  void render() {
    if (hitFlag == false) {
      fill(255,255,255);
      rect(x, y, blockWidth, blockHeight);
    }
  }

  void move() {
    // ブロックは動かない
  }

  /* 衝突通知 */
  void reactToCollision() {
    hitFlag = true;
  }
}

//final int MAX_BLOCKS = 100;
//final int BLOCK_ROWS = 10;
////final int BLOCK_COLUMNS = 3;
//final int BLOCK_GAP = 2;
//final float BLOCK_SETUP_X = 130.0f;
//final float BLOCK_SETUP_Y = 50.0f;

//float[] blockX = new float[MAX_BLOCKS];
//float[] blockY = new float[MAX_BLOCKS];
//float[] blockWidth = new float[MAX_BLOCKS];
//float[] blockHeight = new float[MAX_BLOCKS];
//boolean[] hitFlag = new boolean[MAX_BLOCKS];


//void drawBlock() {
//  for (int i = 0; i < MAX_BLOCKS; i++) {
//    if (hitFlag[i] == false) {
//      rect(blockX[i], blockY[i], blockWidth[i], blockHeight[i]);
//    }
//  }
//}

//void hitBlock() {
//  for (int i = 0; i < MAX_BLOCKS; i++) {
//    if (hitFlag[i] == false) {
//      if ( ballX > blockX[i] && ballX < blockX[i] + blockWidth[i]) {
//        if (ballY + ballRadius > blockY[i] && ballY + ballRadius < blockY[i] + blockHeight[i] ||
//          ballY - ballRadius > blockY[i] && ballY - ballRadius < blockY[i] + blockHeight[i]) {
//          ballVY = -ballVY;
//          hitFlag[i]= true;
//        }
//      }
//    }
//  }
//}

//void arrangeBlocks() {
//  for (int i  = 0; i < MAX_BLOCKS; i++) {
//    blockWidth[i] = 100.0f;
//    blockHeight [i] = 10.0f;
//    hitFlag [i] = false;
//    blockX[i] = BLOCK_SETUP_X + BLOCK_GAP + i % BLOCK_ROWS * (blockWidth[i] + BLOCK_GAP);
//    blockY[i] = BLOCK_SETUP_Y + BLOCK_GAP + i / BLOCK_ROWS * (blockHeight[i] + BLOCK_GAP);
//  }
//}
