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
 Project: EE-8 Practical 1
 Platform: Parallax Project USB Board
 Revision: 1.1
 Author: Matthew Ho Wai Kiat
 Date: 18 Nov 2021
 Log:
   Date: Desc
   18/11/2021: Object for Comm Control
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        '_ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        '_Ms_001 =_ConClkFreq/1_000

      commRxPin = 18
      commTxPin = 19
      commBaud  = 9600

      commStart   = $7A
      commForward = $01
      commReverse = $02
      commLeft    = $03
      commRight   = $04
      commStopAll = $AA
VAR long cog3ID, cog3Stack[128]
    long _Ms_001

OBJ

  Comm   : "FullDuplexSerial.spin"       'UART communication control
  Motor  : "MotorControl.spin"

PUB Start(mainMSVal, RxSig)

  _Ms_001 := mainMSVal

  Stop

  cog3ID := cognew(Main(RxSig), @cog3Stack)

  return


PUB Stop
  if cog3ID
    cogstop(cog3ID~)
PUB Main(rxSig) | RxSigAdd'Declaration and Initialisation

  Comm.Start(commTxPin, commRxPin, 0 ,commBaud)
  Pause(3000)

 repeat

   RxSigAdd := Comm.RxCheck
    if (RxSigAdd == commStart)
      repeat
       RxSigAdd := Comm.RxCheck
       case RxSigAdd
         commForward:
          long[rxSig] := 1
          'return

         commReverse:
          long[rxSig] := 2
          'return

         commLeft:
          long[rxSig] := 3
          'return

         commRight:
          long[rxSig] := 4
        'return

         commStopAll:
          long[rxSig] := 5
        'return



PRI  Pause(ms)  | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return