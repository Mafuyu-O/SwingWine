class CollisionChecker {

  /* BallとBlock */
  void checkCollision(Ball targetBall, Block targetBlock, boolean vanishCollision) {
    if (targetBlock.hitFlag == false) {
      if (targetBall.x > targetBlock.x && targetBall.x < targetBlock.x + targetBlock.blockWidth) {
        if ((targetBall.y - targetBall.radius > targetBlock.y && targetBall.y - targetBall.radius < targetBlock.y + targetBlock.blockHeight) ||
          (targetBall.y + targetBall.radius > targetBlock.y && targetBall.y + targetBall.radius < targetBlock.y + targetBlock.blockHeight)) {
          if (!vanishCollision) {
            targetBall.reactToCollisionBlock();
          }
          targetBlock.reactToCollision();

          breakTiming = true;
        }
      }
    }
  }

  /* BallとBar */
  void checkCollision(Ball targetBall, Bar targetBar) {
    if (targetBall.x > targetBar.x && targetBall.x < targetBar.x + targetBar.barWidth) {
      if (targetBall.y + targetBall.radius > targetBar.y && targetBall.y - targetBall.radius < targetBar.y + targetBar.barHeight) {
        targetBall.reactToCollisionBar(targetBar);
        targetBar.reactToCollision();
      }
    }
  }
}



/*当たり判定*/
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
