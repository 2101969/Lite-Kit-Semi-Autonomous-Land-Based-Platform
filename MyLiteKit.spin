 {Project: EE-9 Practical 1
 Platform: Parallax Project USB Board
 Revision: 1.1
 Author: Matthew Ho Wai Kiat
 Date: 26/11/2021
 Log:
   Date: Desc
   26/11/2021:{
   Combine the Sensor, Motor and Comm Objects to make the land based
   prototype move
   }}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 =_ConClkFreq/1_000

      'Comm Control
    commForward = 1
    commReverse = 2
    commLeft    = 3
    commRight   = 4
    commStopAll = 5

    'Sensor limit
    senUltraSafeVal = 500
    senToFSafeVal = 200

VAR
  long mainToF1Val, mainToF2Val, mainUltra1Val, mainUltra2Val
  long Mot1, Mot2, Mot3, Mot4
  long CommVal
OBJ
  MotorCon      : "MotorControl.spin"
  SensorCon     : "SensorControl.spin"
  CommCon       : "CommControl.spin"

PUB Main


  SensorCon.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val) 'Initialise Sensors
  MotorCon.Start(_Ms_001, @Mot1, @Mot2, @Mot3, @Mot4) 'Initialise Motors
  CommCon.Start(_Ms_001, @CommVal) 'Initialise Communication
  Pause(3000)

  repeat
    case CommVal
      commForward:
       if((mainUltra1Val > senUltraSafeVal) and (mainToF1Val < 250))
         Forward
         Pause(50)
       elseif((mainUltra1Val < senUltraSafeVal) or (mainToF1Val > 250))
         StopAllMotors
         Pause(50)
      commReverse:
       if((mainUltra2Val > senUltraSafeVal) and (mainToF2Val < 250))
         Reverse
         Pause(50)
       elseif((mainUltra2Val < senUltraSafeVal) or (mainToF2Val > 250))
         StopAllMotors
         Pause(50)
      commLeft:
        TurnLeft
         Pause(50)

      commRight:
        TurnRight
        Pause(50)

      commStopAll:
        StopAllMotors
        Pause(50)

    Pause(20)
PUB Forward

 Mot1 := 150         'change variable for motor 1 to actuate forward
 Mot2 := 150         'change variable for motor 2 to actuate forward
 Mot3 := 150         'change variable for motor 3 to actuate forward
 Mot4 := 150         'change variable for motor 4 to actuate forward

PUB Reverse

 Mot1 := -150        'change variable for motor 1 to actuate reverse
 Mot2 := -150        'change variable for motor 2 to actuate reverse
 Mot3 := -150        'change variable for motor 3 to actuate reverse
 Mot4 := -150        'change variable for motor 4 to actuate reverse

PUB TurnLeft

 Mot1 := 150         'change variable for motor 1 to actuate forward
 Mot2 := -150        'change variable for motor 2 to actuate reverse
 Mot3 := 150         'change variable for motor 3 to actuate forward
 Mot4 := -150        'change variable for motor 4 to actuate reverse

PUB TurnRight

 Mot1 := -150        'change variable for motor 1 to actuate reverse
 Mot2 := 150         'change variable for motor 1 to actuate forward
 Mot3 := -150        'change variable for motor 1 to actuate reverse
 Mot4 := 150         'change variable for motor 1 to actuate forward

PUB StopAllMotors

 Mot1 := 0
 Mot2 := 0
 Mot3 := 0
 Mot4 := 0
PRI Pause(ms)  | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return