{
 ************************************************************************************************************
 *                                                                                                          *
 *  AUTO-RECOVER NOTICE: This file was automatically recovered from an earlier Propeller Tool session.      *
 *                                                                                                          *
 *  ORIGINAL FOLDER:     C:\Users\Matthew Ho\Desktop\                                                       *
 *  TIME AUTO-SAVED:     22 hours, 14 minutes ago (5/11/2021 1:14:51 pm)                                    *
 *                                                                                                          *
 *  OPTIONS:             1)  RESTORE THIS FILE by deleting these comments and selecting File -> Save.       *
 *                           The existing file in the original folder will be replaced by this one.         *
 *                                                                                                          *
 *                           -- OR --                                                                       *
 *                                                                                                          *
 *                       2)  IGNORE THIS FILE by closing it without saving.                                 *
 *                           This file will be discarded and the original will be left intact.              *
 *                                                                                                          *
 ************************************************************************************************************
.}
{
 Project: EE-7 Practical 1
 Platform: Parallax Project USB Board
 Revision: 1.1
 Author: Matthew Ho Wai Kiat
 Date: 10 Nov 2021
 Log:
   Date: Desc
   25/10/2021:  Object for Sensor Control
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        '_Ms_001 =_ConClkFreq/1_000

  'Ultrasonic 1(Front)
  ultra1SCL = 6
  ultra1SDA = 7
  'Ultrasonic 2(Back)
  ultra2SCL = 20
  ultra2SDA = 21

  tof1SCL = 0
  tof1SDA = 1
  tof1RST = 14
  tofAdd = $29

  tof2SCL = 2
  tof2SDA = 3
  tof2RST = 15

VAR 'Global variable
    long cogIDNum, cog1Stack[128]
    long _Ms_001

OBJ

  'Term  : "FullDuplexSerial.spin"       'UART communication
  ToF[2]   : "EE-7_Tof.spin"
  Ultra    : "EE-7_Ultra_v2.spin"

PUB Start(mainMSVal, mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)

  _Ms_001 := mainMSVal

  Stop

  cogIDNum := cognew(sensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add), @cog1Stack)

  return

PUB Stop

  if cogIDNum
    cogstop(cogIDNum~)
PUB sensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)

  Ultra.Init(ultra1SCL, ultra1SDA, 0)
  Ultra.Init(ultra2SCL, ultra2SDA, 1)

  tofInit       'Initialise ToF Sensors

  repeat
    long[mainUltra1Add] := Ultra.readSensor(0)
    long[mainUltra2Add] := Ultra.readSensor(1)
    long[mainToF1Add]   := ToF[0].GetSingleRange(tofAdd)
    long[mainToF2Add]   := ToF[1].GetSingleRange(tofAdd)
    Pause(50)


PRI tofInit | i
 {{}}
  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return


PRI  Pause(ms)  | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return
