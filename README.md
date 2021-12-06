# Semi-Autonomous Land-Based Locomotive code

**Main_Code:**
MyLiteKit

**Sub_Codes:**
MotorControl,
SensorControl,
CommControl

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Description

## MyLiteKit
MyLiteKit is the main code loaded into the platform. It contains 3 encapsulated codes:SensorControl, MotorControl and CommControl. the code is modified here to achieve semi-autonomous behaviour.
 
## MotorControl 
MotorControl contains the code and methods used to control the movement of the platform in 4 directions: Forward, Reverse, Left and Right.

## SensorControl 
SensorControl contains the code and methods used by the UltraSonic and Time-of-Flight(ToF) sensors to continuously take in readings to ensure the platform stops moving when it approaches wall or cliff 

## CommControl 
CommControl contains the code and methods used to communicate instructions between transmitter and the receiver to execute movements accordingly. 
