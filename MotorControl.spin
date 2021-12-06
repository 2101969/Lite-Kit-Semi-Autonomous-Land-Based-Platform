{
 Project: EE-6 Practical 1
 Platform: Parallax Project USB Board
 Revision: 1.1
 Author: Matthew Ho Wai Kiat
 Date: 1 Nov 2021
 Log:
   Date: Desc
   Object for Motor Control
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        '_Ms_001 =_ConClkFreq/1_000

 motor1 = 10
 motor2 = 11
 motor3 = 12
 motor4 = 13

 motor1Zero = 1520
 motor2Zero = 1520
 motor3Zero = 1520
 motor4Zero = 1520
 back = 400
VAR long _Ms_001'Global variable
    long cog2ID, MotorStack[128]
OBJ

  Motors : "Servo8Fast_vZ2.spin"

PUB Start(mainMSVal, Motor1Add, Motor2Add, Motor3Add, Motor4Add)

  _Ms_001 := mainMSVal

 StopCore

 cog2ID := cognew(Set(Motor1Add, Motor2Add, Motor3Add, Motor4Add),@MotorStack)

 return
PUB Set(Motor1Add, Motor2Add, Motor3Add, Motor4Add)
 Motors.Init
 Motors.AddSlowPin(motor1)
 Motors.AddSlowPin(motor2)
 Motors.AddSlowPin(motor3)
 Motors.AddSlowPin(motor4)
 Motors.Start
 Pause(100)

 'Motors.Set(motor, speed)

 repeat
    Motors.Set(motor1,(Motor1Zero + long[Motor1Add])) 'Desginated Motor(1) + (base value(1) + derivation from base value(1))
    Motors.Set(motor2,(Motor2Zero + long[Motor2Add])) 'Desginated Motor(2) + (base value(2) + derivation from base value(2))
    Motors.Set(motor3,(Motor3Zero + long[Motor3Add])) 'Desginated Motor(3) + (base value(3) + derivation from base value(3))
    Motors.Set(motor4,(Motor4Zero + long[Motor4Add])) 'Desginated Motor(4) + (base value(4) + derivation from base value(4))
    Pause(1000)
PUB StopCore
  if cog2ID
    cogstop(cog2ID~)

PUB StopAllMotors
   Motors.Set(motor1, motor1Zero)
   Motors.Set(motor2, motor2Zero)
   Motors.Set(motor3, motor3Zero)
   Motors.Set(motor4, motor4Zero)
   'Pause(1800)
PUB Forward | i
  repeat i from 0 to 300 step 100 '10%
    Motors.Set(motor1, motor1Zero+i)
    Motors.Set(motor2, motor2Zero+i)
    Motors.Set(motor3, motor3Zero+i)
    Motors.Set(motor4, motor4Zero+i)
    Pause(100)
 'StopAllMotors

 'Set
PUB Reverse | i

 repeat i from 0 to 300 step 100 '10%
    Motors.Set(motor1, motor1Zero-i)
    Motors.Set(motor2, motor2Zero-i)
    Motors.Set(motor3, motor3Zero-i)
    Motors.Set(motor4, motor4Zero-i)
    Pause(100)
 'StopAllMotors
 'Set
PUB TurnLeft | i

 repeat i from 0 to 300 step 100 '10%
    Motors.Set(motor1, motor1Zero+i)
    Motors.Set(motor2, motor2Zero-i)
    Motors.Set(motor3, motor3Zero+i)
    Motors.Set(motor4, motor4Zero-i)
    Pause(100)
 'StopAllMotors
 'Set
PUB TurnRight | i

 repeat i from 0 to 300 step 100 '10%
    Motors.Set(motor1, motor1Zero-i)
    Motors.Set(motor2, motor2Zero+i)
    Motors.Set(motor3, motor3Zero-i)
    Motors.Set(motor4, motor4Zero+i)
    Pause(100)
 'StopAllMotors
 'Set
PRI  Pause(ms)  | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return