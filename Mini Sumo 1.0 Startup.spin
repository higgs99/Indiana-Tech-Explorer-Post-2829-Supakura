CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ

  tb          : "Touch_Buttons"
  maincode    : "Mini Sumo 1.0 Main Code"
  lcd         : "Serial_LcdMJL"
  
VAR

    long rnum, bcog
    
PUB Main 
  
  bcog := tb.start(_CLKFREQ/100)                         ' Launch the touch buttons driver sampling 100 times a second
  dira[23..20]~~                                        ' Set the LEDs as outputs
   
  maincode.start
  lcd.init(20, 2400, 4)
  lcd.cls
  buttons

PUB buttons | bar, lstate
  lcd.cls
  bar := 0     
  displayroutine(bar)
  repeat
    
    outa[21..23] := bar                       ' Light the LEDs when touching the corresponding buttons 
    waitcnt(clkfreq/30+cnt)
    waitcnt(clkfreq/30+cnt)
    case tb.state
        
        %10000000:
                    if lstate == %000000000
                        bar++
                        
                        if bar > 10
                            bar := 0

                        displayroutine(bar) 
        %01000000:
                    if lstate == %000000000
                        bar--
                        if bar < 0
                            bar := 0
                        
                        displayroutine(bar)
        %00100000:
                    rnum := bar
                    select
                    
    displayir               
    lstate := tb.state


Pub select
    lcd.cls
    lcd.str(string("- Routine Selected -"))
    lcd.str(string(3))
    lcd.str(string("Routine: "))
    lcd.str(string("("))
    lcd.dec(rnum)
    
    lcd.str(string(") "))
    lcd.str(description(rnum))
    repeat until tb.state == %00010000
        if tb.state == %10000000
            lcd.cls
            buttons
        displayir
        waitcnt(clkfreq/10 + cnt)
        outa[23..21] := %001
        waitcnt(clkfreq/10 + cnt)
        outa[23..21] := %000 
                    
    start
        
Pub start
    lcd.cls
    lcd.str(string("Release to Start!"))
    
    repeat until tb.state == %00000000
        waitcnt(clkfreq/35 + cnt)
        outa[23..21] := %111
        waitcnt(clkfreq/35 + cnt)
        outa[23..21] := %000
    lcd.cls
    lcd.finalize
    cogstop(bcog)
    
    maincode.routine(rnum)

pri displayroutine(r)
    lcd.str(string(1, "   choose routine:"))
    lcd.str(string(2))
    lcd.str(string("   ("))
    lcd.dec(r)
    lcd.str(string(") : "))
    lcd.str(description(r))

pri displayir

    lcd.str(string(4, " F: "))
    lcd.bin(maincode.getsensorsfront, 5)

    lcd.str(string("  B: "))
    lcd.bin(maincode.getsensorsback, 5)

pri description(sr) | dstring


    case sr
        0: dstring := string("charge      ")
        1: dstring := string("loopright   ")
        2: dstring := string("loop left   ")
        3: dstring := string("spin+charge ")
        4: dstring := string("turn right  ")
        5: dstring := string("turn left   ")
        6: dstring := string("d6          ")
        7: dstring := string("d7          ")
        8: dstring := string("d8          ")
        9: dstring := string("d9          ")
       10: dstring := string("d10         ")

    return dstring
    