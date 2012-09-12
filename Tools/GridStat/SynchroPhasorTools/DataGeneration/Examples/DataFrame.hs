
import Synchro

myData = 
	SynchroData {
		dsync = mkSync DataFrame Version1,
		dframeSize = mkFrameSize 0,
		dstreamId = mkIdCode 7734,
		dsoc = mySoc,
		dfracSec = myFracSec,
		stat = mkStat Good InSync TimeStamp 
					  NotTriggered ChangeEffected NotModified
					  Unused D_S10 Manual,
		dchk = mkChk 0,
		phasors = myPhasors,
		freq = mkFreq 2500,
		dFreq = mkDFreq 0,
		analogs = myAnalogs,
		digitals = myDigitals
	}

mySoc = mkSoc 1149580800
myFracSec = mkFracSec (mkLeapSecond Backward NotOccured NotPending) 16817 LockedUTC

myPhasors = [ 	(mkPhasor 14635 0), 
				(mkPhasor (-7318) (-12676)), 
				(mkPhasor (-7318) (12675)),
				(mkPhasor 1092 0)  ]
				
myAnalogs = [	(mkAnalog $ mkFloat32 100),
				(mkAnalog $ mkFloat32 1000),
				(mkAnalog $ mkFloat32 10000)  ]
				
myDigitals = [	(mkDigital 15378)	]
	
finalData = finalizeData myData

dataSet = makeDataSet
			finalData
			(\i soc -> soc + i)
			
			[( \i (re, im) -> (re + (i `mod` 4), im + (i `mod` 5)) ),
			 ( \i (re, im) -> (re + (i `mod` 2), im + (i `mod` 8)) ),
			 ( \i (re, im) -> (re + (i `mod` 7), im + (i `mod` 3)) ),
			 ( \i (re, im) -> (re + (i `mod` 8), im + (i `mod` 4)) )]
			
			[(\i a -> a + (i `mod` 3)),
			 (\i a -> a + (i `mod` 8)),
			 (\i a -> a + (i `mod` 5))]
			
			[(\i di -> di)]
			
			1 100
	
main = 
	writeDataFrame finalData True "myData.txt" >>
	writeDataFrameHex finalData "myData.syd" >>
	writeDataSetHex dataSet "myDataSet.syda"

