#include <Wire.h>
#include <ADXL345.h>
ADXL345 adxl;
int x, y, z;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  adxl.powerOn();
}

void loop() {
  // put your main code here, to run repeatedly:
  int sensorValue = analogRead(A0);
  //Serial.println(sensorValue);

  adxl.readXYZ(&x, &y, &z);

  y -= 11;              //初期値を0に補正
  y = (y * 250) / 250;  //y軸の値を絶対値250を最大値として、0から250にする
  if (y >= 250) {
    y = 250;
  } else if (y <= -250) {
    y = -250;
  }

  z += 28;              //初期値を0に補正
  z = (z * 250) / 250;  //z軸の値を絶対値250を最大値として、0から250にする
  if (z >= 250) {
    z = 250;
  } else if (z <= -250) {
    z = -250;
  }
  Serial.print(y);
  Serial.print(" ");
  Serial.print(z);
  Serial.print(" ");
  Serial.println(sensorValue);

  delay(10);
}
