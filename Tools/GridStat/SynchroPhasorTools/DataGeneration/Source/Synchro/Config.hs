module Synchro.Config
 	(

	-- Types
	SynchroConfig(..),  TimeBase, NumPmu, Stn, Format, FreqT, AnalogT,
	PhasorT, PhasorF, PhNmr, AnNmr, DgNmr, ChNam, PhUnit, Electricity(..),
	ScaleFactor, AnUnit, AnalogMeasure(..), DigUnit, Normal, Set, Fnom(..),
	CfgCnt, DataRate, 

	-- Functions
	syncConfStr, writeConfig, mkTimeBase, mkNumPmu, mkStn, mkFormat, int16, 
	floatingPoint, rectangular, polar, mkPhNmr, mkAnNmr, mkDgNmr, mkChNam, mkPhUnit, 
	mkScaleFactor, mkAnUnit, mkDigUnit, mkCfgCnt, 
	
	finalizeConfig,writeConfigHex

	) where

import Synchro.Common		
import Synchro.Utility
import Data.Int
import qualified Data.ByteString as BS (writeFile)

data SynchroConfig = SynchroConfig 
					{ 	
						sync :: Sync,
					  	frameSize :: FrameSize,
					 	streamId :: IdCode, 
						soc :: SOC,
						fracSec :: FracSec,
						timeBase :: TimeBase, 
						numPmu :: NumPmu,
						stn :: Stn,
						sourceId :: IdCode,
						format :: Format,
						phNmr :: PhNmr,
						anNmr :: AnNmr,
						dgNmr :: DgNmr,
						chNams :: [ChNam],
						phUnits :: [PhUnit], 
					    anUnits :: [AnUnit],
					    digUnits :: [DigUnit],
					    fnom :: Fnom,
					    cfgCnt :: CfgCnt,
					 	dataRate :: DataRate,
					 	chk :: Chk
					
					} deriving (Show)

-- TimeBase
data TimeBase = TimeBase Integer deriving (Show)
mkTimeBase :: Integer -> TimeBase
mkTimeBase a = TimeBase $ uNcheck 24 a "TIMEBASE"
instance Eval TimeBase where
	eval (TimeBase i) = "00" ++ sh 3 i -- high bits are reserved for some 
									   --  mysterious flags according to std

-- NumPmu
data NumPmu = NumPmu Integer deriving (Show)
mkNumPmu :: Integer -> NumPmu
mkNumPmu a = NumPmu $ uNcheck 16 a "NUMPMU"
instance Eval NumPmu where
	eval (NumPmu i) = sh 2 i

-- Stn
data Stn = Stn String deriving (Show)
mkStn :: String -> Stn
mkStn a = Stn $ str16check a "STN"
instance Eval Stn where
	eval (Stn s) = mkHexStr s

--Format
data Format = Format FreqT AnalogT PhasorT PhasorF deriving (Show)
mkFormat :: FreqT -> AnalogT -> PhasorT -> PhasorF -> Format
mkFormat freq ana phasT phasF = Format freq ana phasT phasF
instance Eval Format where
	eval (Format f a pt pf) = "00" ++ ( sh 1 $ (valF f) + (valA a) +
									       (valPT pt) + (valPF pf) )
		where
			valF  a | a = 8 | otherwise = 0
			valA  a | a = 4 | otherwise = 0
			valPT a | a = 2 | otherwise = 0
			valPF a | a = 1 | otherwise = 0
type FreqT = Bool
type AnalogT = Bool
type PhasorT = Bool
type PhasorF = Bool
int16 :: Bool
int16 = False
floatingPoint :: Bool
floatingPoint = True
rectangular::Bool
rectangular = False
polar::Bool
polar = True

-- PhNmr
data PhNmr = PhNmr Integer deriving (Show)
mkPhNmr :: Integer -> PhNmr
mkPhNmr a = PhNmr $ uNcheck 16 a "PHNMR"
instance Eval PhNmr where
	eval (PhNmr i) = sh 2 i

-- AnNmr
data AnNmr = AnNmr Integer deriving (Show)
mkAnNmr :: Integer -> AnNmr
mkAnNmr a = AnNmr $ uNcheck 16 a "ANMR"
instance Eval AnNmr where
	eval (AnNmr i) = sh 2 i

-- DgNmr		
data DgNmr = DgNmr Integer deriving (Show)
mkDgNmr :: Integer -> DgNmr
mkDgNmr a = DgNmr $ uNcheck 16 a "DGNMR"
instance Eval DgNmr where
	eval (DgNmr i) = sh 2 i

-- ChNam
data ChNam = ChNam String deriving (Show)
mkChNam :: String -> ChNam
mkChNam a = ChNam $ str16check a "CHNAM"
instance Eval ChNam where
	eval (ChNam a) = mkHexStr a

-- PhUnit
data PhUnit = PhUnit Electricity ScaleFactor deriving (Show)
mkPhUnit :: Electricity -> ScaleFactor -> PhUnit
mkPhUnit elec sf = PhUnit elec sf
instance Eval PhUnit where
	eval (PhUnit elec sf) = (eval elec) ++ (eval sf)
data Electricity = Voltage | Current deriving (Show)
instance Eval Electricity where
	eval Voltage = sh 1 0
	eval Current = sh 1 1
data ScaleFactor = ScaleFactor Integer deriving (Show)
mkScaleFactor :: Integer -> ScaleFactor
mkScaleFactor a = ScaleFactor $ uNcheck 24 a "Scale Factor (PHUNT)"
instance Eval ScaleFactor where
	eval (ScaleFactor i) = sh 3 i

-- AnUnit		
data AnUnit = AnUnit AnalogMeasure ScaleFactor deriving (Show)
mkAnUnit :: AnalogMeasure -> ScaleFactor -> AnUnit
mkAnUnit at sf = AnUnit at sf
instance Eval AnUnit where
	eval (AnUnit am sf) = (eval am) ++ (eval sf)
data AnalogMeasure = SinglePoint | RMS | Peak deriving (Show)
instance Eval AnalogMeasure where
	eval SinglePoint = sh 1 0
	eval RMS = sh 1 1
	eval Peak = sh 1 2

-- DigUnit
data DigUnit = DigUnit Normal Set deriving (Show)
type Normal = Integer
type Set = Integer
mkDigUnit :: Normal -> Set -> DigUnit
mkDigUnit n s = DigUnit n' s'
	where
		n' = uNcheck 16 n "Normal mask (DIGUNIT)"
		s' = uNcheck 16 s "Set mask (DIGUNIT)"
instance Eval DigUnit where
	eval (DigUnit n s) = (sh 2 n) ++ (sh 2 s)

-- Fnom
data Fnom = Sixty | Fifty deriving (Show)
instance Eval Fnom where
	eval Sixty = sh 2 0
	eval Fifty = sh 2 1

-- CfgCnt
data CfgCnt = CfgCnt Integer deriving (Show)
mkCfgCnt :: Integer -> CfgCnt
mkCfgCnt a = CfgCnt $ uNcheck 16 a "CFGCNT"
instance Eval CfgCnt where
	eval (CfgCnt i) = sh 2 i

type DataRate = Int16
	
-----------------------------------------------------------------------------
--synConfStr config humanFormat	
syncConfStr :: SynchroConfig -> Bool -> String
syncConfStr
	sy@SynchroConfig {
			sync=sync',frameSize=frameSize',streamId=streamId',soc=soc',
			fracSec=fracSec',timeBase=timeBase',numPmu=numPmu',stn=stn',
			sourceId=sourceId',format=format',phNmr=phNmr',anNmr=anNmr',
			dgNmr=dgNmr',chNams=chNams',phUnits=phUnits',anUnits=anUnits',
			digUnits=digUnits',fnom=fnom',cfgCnt=cfgCnt',dataRate=dataRate',
			chk = chk'
		} csv
			= 	
				(pretty $ eval sync') ++ sep ++
				(pretty $ eval frameSize') ++ sep ++
				(pretty $ eval streamId') ++ sep ++
				(pretty $ eval soc') ++ sep ++
				(pretty $ eval fracSec') ++ sep ++
				(pretty $ eval timeBase') ++ sep ++
				(pretty $ eval numPmu') ++ sep ++
				(pretty $ eval stn') ++ sep ++
				(pretty $ eval sourceId') ++ sep ++
				(pretty $ eval format') ++ sep ++
				(pretty $ eval phNmr') ++ sep ++
				(pretty $ eval anNmr') ++ sep ++
				(pretty $ eval dgNmr') ++ sep ++
				obrac ++
				(initFoldMapEval chNams' sep pretty) ++
				cbrac ++ sep ++
				obrac ++
				(initFoldMapEval phUnits' sep pretty) ++
				cbrac ++ sep ++
				obrac ++
				(initFoldMapEval anUnits' sep pretty) ++
				cbrac ++ sep ++
				obrac ++
				(initFoldMapEval digUnits' sep pretty) ++
				cbrac ++ sep ++
				(pretty $ eval fnom') ++ sep ++
				(pretty $ eval cfgCnt') ++ sep ++
				(pretty $ sh 2 $ fromIntegral dataRate') ++ sep ++
				(pretty $ eval chk')
				
				where
					sep = case csv of
						True -> "\n "
						False -> ""
					obrac = case csv of
						True -> "["
						False -> ""
					cbrac = case csv of
						True -> "]"
						False -> ""
					pretty = case csv of
						True -> prettyHex
						False -> (\s -> s)
			

writeConfig :: SynchroConfig -> Bool -> String -> IO ()
writeConfig sc human fileName = writeFile fileName (syncConfStr sc human)

writeConfigHex :: SynchroConfig -> String -> IO ()
writeConfigHex sc filename = BS.writeFile filename hexMsg
	where
		msg = syncConfStr sc False
		hexMsg = breakHexOut msg

-----------------------------------------------------------------------------
--finalizeConfig config
finalizeConfig :: SynchroConfig -> SynchroConfig
finalizeConfig = computeCrc . computeFrameSize

	
computeFrameSize :: SynchroConfig -> SynchroConfig
computeFrameSize 
	sy@SynchroConfig {
			sync=sync',frameSize=frameSize',streamId=streamId',soc=soc',
			fracSec=fracSec',timeBase=timeBase',numPmu=numPmu',stn=stn',
			sourceId=sourceId',format=format',phNmr=phNmr',anNmr=anNmr',
			dgNmr=dgNmr',chNams=chNams',phUnits=phUnits',anUnits=anUnits',
			digUnits=digUnits',fnom=fnom',cfgCnt=cfgCnt',dataRate=dataRate',
			chk = chk'
		} =
			SynchroConfig {
					sync=sync',streamId=streamId',soc=soc',fracSec=fracSec',
					timeBase=timeBase',numPmu=numPmu',stn=stn',
					sourceId=sourceId',format=format',phNmr=phNmr',
					anNmr=anNmr',dgNmr=dgNmr',chNams=chNams',phUnits=phUnits',
					anUnits=anUnits',digUnits=digUnits',fnom=fnom',
					cfgCnt=cfgCnt',dataRate=dataRate',
					chk = chk',
					
					frameSize=mkFrameSize syStrByteLen
				}
				
				where
					syStr = syncConfStr sy False
					sysStrLen = length syStr
					syStrByteLen = ceiling $ (fromIntegral sysStrLen) / 2.0
					--inpt = take (sysStrLen - 4) syStr
					--crc = mkCrc $ hxsToArr inpt
					
		
computeCrc :: SynchroConfig -> SynchroConfig
computeCrc 
	sy@SynchroConfig {
			sync=sync',frameSize=frameSize',streamId=streamId',soc=soc',
			fracSec=fracSec',timeBase=timeBase',numPmu=numPmu',stn=stn',
			sourceId=sourceId',format=format',phNmr=phNmr',anNmr=anNmr',
			dgNmr=dgNmr',chNams=chNams',phUnits=phUnits',anUnits=anUnits',
			digUnits=digUnits',fnom=fnom',cfgCnt=cfgCnt',dataRate=dataRate',
			chk = chk'
		} =
			SynchroConfig {
					sync=sync',frameSize=frameSize',streamId=streamId',
					soc=soc',fracSec=fracSec',timeBase=timeBase',
					numPmu=numPmu',stn=stn',sourceId=sourceId',format=format',
					phNmr=phNmr',anNmr=anNmr',dgNmr=dgNmr',chNams=chNams',
					phUnits=phUnits',anUnits=anUnits',digUnits=digUnits',
					fnom=fnom',cfgCnt=cfgCnt',dataRate=dataRate',
										
					chk = mkChk (fromIntegral crc)
				}

				where
					syStr = syncConfStr sy False
					sysStrLen = length syStr
					syStrByteLen = ceiling $ (fromIntegral sysStrLen) / 2.0
					inpt = take (sysStrLen - 4) syStr
					crc = mkCrc $ hxsToArr inpt
