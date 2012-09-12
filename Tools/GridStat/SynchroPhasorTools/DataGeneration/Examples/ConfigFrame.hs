
import Synchro

myConfig = 
	SynchroConfig {
			sync = mkSync ConfigFrame2 Version1,
			frameSize = mkFrameSize 0,
			streamId = mkIdCode 7734,
			soc = mkSoc 1149577200,
			fracSec = mkFracSec (mkLeapSecond Forward NotOccured Pending) 463000 US100,
			timeBase = mkTimeBase 1000000,
			numPmu = mkNumPmu 1,
			stn = mkStn "Station A",
			sourceId = mkIdCode 7734,
			format = mkFormat int16 floatingPoint int16 rectangular,
			phNmr = mkPhNmr 4,
			anNmr = mkAnNmr 3,
			dgNmr = mkDgNmr 1,
			chNams = mkChs,
			phUnits = mkPhUnits,
			anUnits = mkAnUnits,
			digUnits = mkDigUnits,
			fnom = Sixty,
			cfgCnt = mkCfgCnt 22,
			dataRate = 30,
			chk = (mkChk 0)
		}
		
		
mkChs = [mkChNam "VA", mkChNam "VB", mkChNam "VC", mkChNam "I1", 
			mkChNam "ANALOG1", mkChNam "ANALOG2", mkChNam "ANALOG3",
			mkChNam "BREAKER 1 STATUS", mkChNam "BREAKER 2 STATUS",
			mkChNam "BREAKER 3 STATUS", mkChNam "BREAKER 4 STATUS",
			mkChNam "BREAKER 5 STATUS", mkChNam "BREAKER 6 STATUS",
			mkChNam "BREAKER 7 STATUS", mkChNam "BREAKER 8 STATUS",
			mkChNam "BREAKER 9 STATUS", mkChNam "BREAKER A STATUS",
			mkChNam "BREAKER B STATUS", mkChNam "BREAKER C STATUS",
			mkChNam "BREAKER D STATUS", mkChNam "BREAKER E STATUS",
			mkChNam "BREAKER F STATUS", mkChNam "BREAKER G STATUS"]
			
			
mkPhUnits = [mkPhUnit Voltage  (mkScaleFactor 915527), 
			mkPhUnit Voltage  (mkScaleFactor 915527), 
			mkPhUnit Voltage  (mkScaleFactor 915527), 
			mkPhUnit Current  (mkScaleFactor 45776)]
			
mkAnUnits = [mkAnUnit SinglePoint (mkScaleFactor 1),
			mkAnUnit RMS (mkScaleFactor 1),
			mkAnUnit Peak (mkScaleFactor 1)]
			
mkDigUnits = [mkDigUnit 0 65535]
		
finalConfig = finalizeConfig myConfig

main = 
	writeConfig finalConfig True "myConfig.txt" >>
	writeConfigHex finalConfig "myHexConfig.syc"
	
	