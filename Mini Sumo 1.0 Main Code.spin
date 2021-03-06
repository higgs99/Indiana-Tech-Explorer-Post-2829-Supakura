CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

         jump = 8

         rights = 1
         lefts = 0

VAR
{{

    Pin 1 ---------------220 ohm resistor---------Ir LED--------ground


    Pin 2 ---------------far right pin of ir reciever
    Ground --------------middle pin of reciever
    3.3V-----------------far left pin of reciever

     Δ
    
    │││
    PG2

}}

  long irrf[5]
  long irrb[5]   
  long irfbits[5]
  long irbbits[5]
  long forwordvar
  long backwardvar
  long lastside
    
  LONG x
  long stack, stack2 
  long dstring

  long s1, s2
 
OBJ

    ir1 : "QuadIR"
    ir2 : "QuadIR"
    
    lcd : "Serial_LcdMJL"
    motor : "motorcontrol 1.0"
    
PUB Start
    ir1.Start(11+jump)   'flashlight
    ir2.Start(10+jump)   'flashlight

    
    motor.init
    'motor.speed(0, 0)
    cognew(sensors, @stack[1000])
    
PUB sensors
              
   repeat
      waitcnt(clkfreq/500+cnt)
      '=============================================================                                              
      ir1.IRDetect(1+jump, 3+jump, 5+jump, 7+jump, 9+jump)        '=
      ir2.IRDetect(0+jump, 2+jump, 4+jump, 6+jump, 8+jump)        '=
                                                                  '=
      irfbits[0] := ir1.GetIR(1)                                  '=
      irfbits[1] := ir1.GetIR(2)  << 1                            '=
      irfbits[2] := ir1.GetIR(3)  << 2                            '=
      irfbits[3] := ir1.GetIR(4)  << 3                            '=
      irfbits[4] := ir1.GetIR(5)  << 4                            '= <<<< SENSORS SECTION
                                                                  '=
      irbbits[0] := ir2.GetIR(1)                                  '=
      irbbits[1] := ir2.GetIR(2)  << 1                            '=
      irbbits[2] := ir2.GetIR(3)  << 2                            '=
      irbbits[3] := ir2.GetIR(4)  << 3                            '=
      irbbits[4] := ir2.GetIR(5)  << 4                            '= 
                    '---------   ----------   ----------   ----------   ----------         
      irrf.byte[0]:=irfbits[0] + irfbits[1] + irfbits[2] + irfbits[3] + irfbits[4]     
      irrb.byte[0]:=irbbits[0] + irbbits[1] + irbbits[2] + irbbits[3] + irbbits[4]
                                                                  '=
                                                                  '=
                                                                  '=
                                                                  '=
      '=============================================================
      
PUB getsensorsfront

    return irrf.byte[0]

PUB getsensorsback

    return irrb.byte[0]

pri display_block

        waitcnt(clkfreq/1000+cnt)
        lcd.str(string(1, " SEARCH AND DESTROY"))
        lcd.str(string(2, "      "))
        lcd.str(dstring)
        lcd.str(string(3, " F: "))
        lcd.bin(getsensorsfront, 5)

        lcd.str(string("  B: "))
        lcd.bin(getsensorsback, 5)

PUB Routine(r)

    case r
    
        1: 'spin R charge
                repeat 190                     'SPIN 90 DEGREES RIGHT
                    motor.speed(-200, 200)
                    jumptomain
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    motor.speed(200, 200)
                    jumptomain
                Main
                
        2: 'spin L charge
                repeat 190                     'SPIN 90 DEGREES LEFT
                    jumptomain
                    motor.speed(200, -200)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        3: 'backup+slamR
                repeat 300                     'BACKUP TO THE RIGHT
                    jumptomain
                    motor.speed(-200, 50)
                repeat 100                      'TURN 30 DEGREES
                    jumptomain
                    motor.speed(200, 0)
                repeat 100                      'CHARGE TO ROBOT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        4: 'backup+slamL
                repeat 300                     'BACKUP TO THE LEFT
                    jumptomain
                    motor.speed(50, -200)
                repeat 100                      'TURN 30 DEGREES
                    jumptomain
                    motor.speed(0, 200)
                repeat 100                      'CHARGE TO ROBOT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        5: 'spin R charge
                repeat 190                     'SPIN 90 DEGREES RIGHT
                    motor.speed(-200, 200)
                    jumptomain
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    motor.speed(200, 200)
                    jumptomain
                Main
                
        6: 'spin L charge
                repeat 190                     'SPIN 90 DEGREES LEFT
                    jumptomain
                    motor.speed(200, -200)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main


        7: 'right180slam
                repeat 800                     'SPIN 180 DEGREES RIGHT  (not in place- loop)
                    jumptomain
                    motor.speed(10, 200)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        8: 'left180slam
                repeat 800                     'SPIN 180 DEGREES LEFT  (not in place- loop)
                    jumptomain
                    motor.speed(200, 10)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        9: 'spin180chrge
                repeat 380                     'SPIN 180 DEGREES LEFT
                    jumptomain
                    motor.speed(200, -200)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main

        10: 'loop270s_slam
                repeat 1000                     'SPIN 180 DEGREES LEFT
                    jumptomain
                    motor.speed(10, 200)
                repeat 150                      'CHARGE FOR A SMALL AMOUNT
                    jumptomain
                    motor.speed(200, 200)    
                Main
            
         
        13:'charge
                
                repeat 500
                    motor.speed(200, 200)
                    jumptomain
                Main

        

        16: '90loop180side 
                repeat 190                     'SPIN 90 DEGREES LEFT
                    jumptomain
                    motor.speed(-200, 200)
                repeat 800                     'SPIN 180 DEGREES LEFT  (not in place- loop)
                    jumptomain
                    motor.speed(200, 10)
                Main               
        other: Main
    
pri jumptomain

    waitcnt(clkfreq/1000 + cnt)
    'if getsensorsback < 31
    '    Main
            
PUB Main

    lcd.init(20, 2400, 4)
    lcd.cls
    
    repeat
        display_block    
        
        case irrb
            %00000:
                dstring := string("charge!    ")
                charge
            %10000:
                dstring := string("tiny right ")
                tright
            %01000:
                dstring := string("charge     ")
                charge
            %11000:
                dstring := string("small right")
                sright
            %00100:
                dstring := string("charge     ")
                charge
            %10100:
                dstring := string("small right")
                sright
            %01100:
                dstring := string("charge     ")
                charge
            %11100:
                dstring := string("right      ")
                right
            %00010:
                dstring := string("charge     ")
                charge
            %10010:
                dstring := string("tiny right ")
                tright
            %01010:
                dstring := string("charge     ")
                charge
            %11010:
                dstring := string("right      ")
                right
            %00110:
                dstring := string("charge     ")
                charge
            %10110:
                dstring := string("tiny right ")
                tright
            %01110:
                dstring := string("charge     ")
                charge
            %11110:
                dstring := string("hard right ")
                hright
            %00001:
                dstring := string("tiny left  ")
                tleft
            %10001:
                dstring := string("charge     ")
                charge
            %01001:
                dstring := string("tiny left  ")
                tleft
            %11001:
                dstring := string("tiny right ")
                tright
            %00101:
                dstring := string("small right")
                sright
            %10101:
                dstring := string("charge     ")
                charge
            %01101:
                dstring := string("tiny left  ")
                tleft
            %11101:
                dstring := string("right      ")
                right
            %00011:
                dstring := string("small left ")
                sleft
            %10011:
                dstring := string("tiny left  ")
                tleft
            %01011:
                dstring := string("left       ")
                left
            %11011:
                dstring := string("charge     ")
                charge
            %00111:
                dstring := string("left       ")
                left
            %10111:
                dstring := string("left       ")
                left
            %01111:
                dstring := string("hard left  ")
                hleft
            %11111:
                dstring := string("seek       ")
                seek

        motor.speed(s1, s2)

pub tleft
    lastside := lefts
    s1 := 175
    s2 := 200
    
pub sleft
    lastside := lefts
    s1 := 100
    s2 := 200
    
pub left
    lastside := lefts
    s1 := 50
    s2 := 200

pub hleft
    lastside := lefts
    s1 := 10
    s2 := 200

pub charge

    s1 := 200
    s2 := 200

pub tright
    lastside := rights
    s1 := 200
    s2 := 175                         

pub sright
    lastside := rights
    s1 := 200
    s2 := 100

pub right
    lastside := rights
    s1 := 200
    s2 := 50

pub hright
    lastside := rights
    s1 := 200
    s2 := 10

pub seek
    if lastside == rights    
        s1 := 150
        s2 := -150

    if lastside == lefts    
        s1 := -150
        s2 := 150
             