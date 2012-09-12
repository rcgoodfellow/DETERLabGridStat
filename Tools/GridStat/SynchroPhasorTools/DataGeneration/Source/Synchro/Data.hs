module Synchro.Data
	(
	
	SynchroData(..), Stat, DataErr(..), PmuSync(..), DataSort(..), PmuTrigger(..), ConfChange(..),
	ModState(..), TimeQuality(..), UnlockedTime(..), TriggerReason(..), Phasor,
	
	mkStat, mkUserTriggerReason, mkPhasor, mkFreq, mkDFreq, mkAnalog, mkInt32, mkFloat32,
	mkDigital,
	
	finalizeData, writeDataFrame, writeDataFrameHex, makeDataSet, writeDataSetHex,
	
	--DEBUG
	syncDataStr, showHexFloat, prettyHex
	
	) where
		
import Synchro.Common
import Synchro.Utility
import Data.Int
import qualified Data.ByteString as BS (writeFile)
import Control.Applicative

data SynchroData = SynchroData
	{
		dsync :: Sync,
		dframeSize :: FrameSize,
		dstreamId :: IdCode,
		dsoc :: SOC,
		dfracSec :: FracSec,
		
		stat :: Stat,
		phasors :: [Phasor],
		freq :: Freq,
		dFreq :: DFreq,
		analogs :: [Analog],
		digitals :: [Digital],
		
		dchk :: Chk
		
	} deriving (Show)
	
data Stat = Stat DataErr PmuSync DataSort PmuTrigger ConfChange ModState
				TimeQuality UnlockedTime TriggerReason deriving (Show)
mkStat :: DataErr -> PmuSync -> DataSort -> PmuTrigger -> ConfChange -> ModState ->
				TimeQuality -> UnlockedTime -> TriggerReason -> Stat
mkStat de ps ds pt cc ms tq ut tr = Stat de ps ds pt cc ms tq ut tr
instance Eval Stat where
	eval (Stat de ps ds pt cc ms tq ut tr) = 
			sh 0 ((read $ eval de) + (read $ eval ps)) ++ 
			sh 0 ((read $ eval pt) + (read $ eval cc)) ++ 
			sh 0 ((read $ eval ms) + (read $ eval tq)) ++ 
			sh 0 ((read $ eval ut) + (read $ eval tr))
data DataErr = Good | NoData | PmuTest | PmuError deriving (Show)
instance Eval DataErr where
	eval Good = sh 0 0
	eval NoData = sh 0 1
	eval PmuTest = sh 0 2
	eval PmuError = sh 0 3	
data PmuSync = InSync | OutOfSync deriving (Show)
instance Eval PmuSync where
	eval InSync = sh 0 0
	eval OutOfSync = sh 0 0
data DataSort = TimeStamp | Arrival deriving (Show)
instance Eval DataSort where
	eval TimeStamp = sh 0 0
	eval Arrival = sh 0 1
data PmuTrigger = Triggered | NotTriggered deriving (Show)
instance Eval PmuTrigger where
	eval Triggered = sh 0 1
	eval NotTriggered = sh 0 0
data ConfChange = WillChange | ChangeEffected deriving (Show)
instance Eval ConfChange where
	eval WillChange = sh 0 1
	eval ChangeEffected = sh 0 0
data ModState = PostProc | NotModified deriving (Show)
instance Eval ModState where
	eval PostProc = sh 0 1
	eval NotModified = sh 0 0
data TimeQuality = GM10 | M10 | M1 | U100 | U10 | U1 | N100 | Unused deriving (Show)
instance Eval TimeQuality where
	eval GM10 = sh 0 7
	eval M10 = sh 0 6
	eval M1 = sh 0 5
	eval U100 = sh 0 4
	eval U10 = sh 0 3
	eval U1 = sh 0 2
	eval N100 = sh 0 1
	eval Unused = sh 0 0
data UnlockedTime = D_S10 | D_S100 | D_S1000 | D_GS1000 deriving (Show)
instance Eval UnlockedTime where
	eval D_S10 = sh 0 0 
	eval D_S100 = sh 0 1
	eval D_S1000 = sh 0 2
	eval D_GS1000 = sh 0 3
data TriggerReason = TDigital | DfreqHigh | PhaseAngleDiff | MagLow | FreqHighOrLow |
						MagHigh | Manual | Reserved | UserDefined Integer deriving (Show)
instance Eval TriggerReason where
	eval Manual = sh 0 0
	eval MagLow = sh 0 1
	eval MagHigh = sh 0 2
	eval PhaseAngleDiff = sh 0 3
	eval FreqHighOrLow = sh 0 4
	eval DfreqHigh = sh 0 5
	eval Reserved = sh 0 6
	eval TDigital = sh 0 7
	eval (UserDefined i) = sh 0 i
mkUserTriggerReason :: Integer -> TriggerReason
mkUserTriggerReason i
	| i < 8 || i > 15 = error "User defined triggers are restricted to values 8 - 15"
	| otherwise = UserDefined i
	
data Phasor = Phasor SPReal SPImaginary deriving (Show)
type SPReal = Int16
type SPImaginary = Int16
mkPhasor :: SPReal -> SPImaginary -> Phasor
mkPhasor re im = Phasor re im
instance Eval Phasor where
	eval (Phasor re im) = (sh 2 (fromIntegral re)) ++ (sh 2 (fromIntegral im))	

data Freq = Freq Integer deriving (Show)
mkFreq :: Integer -> Freq
mkFreq i = Freq $ uNcheck 16 i "FREQ"
instance Eval Freq where
	eval (Freq i) = sh 2 i

data DFreq = DFreq Integer deriving (Show)
mkDFreq :: Integer -> DFreq
mkDFreq i = DFreq $ uNcheck 16 i "DFREQ"
instance Eval DFreq where
	eval (DFreq i) = sh 2 i
	
data Analog = Analog NumberFormat deriving (Show)
mkAnalog :: NumberFormat -> Analog
mkAnalog nf = Analog nf
instance Eval Analog where
	eval (Analog nf) = eval nf
data NumberFormat = IEEEInt32 Integer | IEEEFloat32 Float deriving (Show)
mkInt32 :: Integer -> NumberFormat
mkInt32 i = IEEEInt32 i
mkFloat32 :: Float -> NumberFormat
mkFloat32 i = IEEEFloat32 i
instance Eval NumberFormat where
	eval (IEEEInt32 i) = sh 4 i
	eval (IEEEFloat32 i) = showHexFloat i
	
data Digital = Digital Integer deriving (Show)
mkDigital :: Integer -> Digital
mkDigital i = Digital $ uNcheck 16 i "DIGITAL"
instance Eval Digital where
	eval (Digital i) = sh 2 i

syncDataStr :: SynchroData -> Bool -> String
syncDataStr
	sy@SynchroData{
		dsync=sync',dframeSize=frameSize',dstreamId=streamId',dsoc=soc',
		dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
		dFreq=dFreq',analogs=analog',digitals=digitals',dchk=chk'
		
	} human
		=
			(pretty $ eval sync') ++ sep ++
			(pretty $ eval frameSize') ++ sep ++
			(pretty $ eval streamId') ++ sep ++
			(pretty $ eval soc') ++ sep ++ 
			(pretty $ eval fracSec') ++ sep ++
			(pretty $ eval stat') ++ sep ++
			obrac ++
			(initFoldMapEval phasors' sep pretty) ++
			cbrac ++ sep ++
			(pretty $ eval freq') ++ sep ++
			(pretty $ eval dFreq') ++ sep ++
			obrac ++
			(initFoldMapEval analog' sep pretty) ++
			cbrac ++ sep ++
			obrac ++ 
			(initFoldMapEval digitals' sep pretty) ++
			cbrac ++ sep ++ 
			(pretty $ eval chk') 
			
				where
					sep = case human of
						True -> "\n "
						False -> ""
					obrac = case human of
						True -> "["
						False -> ""
					cbrac = case human of
						True -> "]"
						False -> ""
					pretty = case human of
						True -> prettyHex
						False -> (\s -> s)
	
	
finalizeData :: SynchroData -> SynchroData
finalizeData = computeDataCrc . computeDataFrameSize

writeDataFrame :: SynchroData -> Bool -> String -> IO ()
writeDataFrame sc human fileName = writeFile fileName (syncDataStr sc human)

writeDataFrameHex :: SynchroData -> String -> IO ()
writeDataFrameHex sc filename = BS.writeFile filename hexMsg
	where
		msg = syncDataStr sc False
		hexMsg = breakHexOut msg

writeDataSetHex :: [SynchroData] -> String -> IO ()
writeDataSetHex ds filename = 
	BS.writeFile filename $
	breakHexOut $
	foldl (++) [] $
	map (\x -> syncDataStr x False) ds
	
computeDataFrameSize :: SynchroData -> SynchroData
computeDataFrameSize
	sy@SynchroData{
		dsync=sync',dframeSize=frameSize',dstreamId=streamId',dsoc=soc',
		dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
		dFreq=dFreq',analogs=analog',digitals=digitals',dchk=chk'

	}
		=
			SynchroData{
				dsync=sync',dstreamId=streamId',dsoc=soc',
				dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
				dFreq=dFreq',analogs=analog',digitals=digitals',dchk=chk',
				
				dframeSize=mkFrameSize syStrByteLen

			}
				where
					syStr = syncDataStr sy False
					sysStrLen = length syStr
					syStrByteLen = ceiling $ (fromIntegral sysStrLen) / 2.0
					--inpt = take (sysStrLen - 4) syStr
					--crc = mkCrc $ hxsToArr inpt
	
computeDataCrc :: SynchroData -> SynchroData
computeDataCrc
	sy@SynchroData{
		dsync=sync',dframeSize=frameSize',dstreamId=streamId',dsoc=soc',
		dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
		dFreq=dFreq',analogs=analog',digitals=digitals',dchk=chk'

	}
		=
			SynchroData{
				dsync=sync',dstreamId=streamId',dsoc=soc',dframeSize=frameSize',
				dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
				dFreq=dFreq',analogs=analog',digitals=digitals',
				
				
				dchk= mkChk (fromIntegral crc)
				

			}
				where
					syStr = syncDataStr sy False
					sysStrLen = length syStr
					syStrByteLen = ceiling $ (fromIntegral sysStrLen) / 2.0
					inpt = take (sysStrLen - 4) syStr
					crc = mkCrc $ hxsToArr inpt
	
	

makeDataSet :: 
	SynchroData -> 									-- Start Point
	(Integer -> Integer -> Integer)   -> 			-- SOC Func
	[(Integer -> (Integer, Integer) -> 
							(Integer, Integer))] ->	-- Phasor Funcs
	[(Integer -> Integer -> Integer)] -> 			-- Analog Funcs
	[(Integer -> Integer -> Integer)] -> 			-- Digital Funcs
	Integer -> 										-- begin (index)
	Integer -> 										-- end
	[SynchroData]

makeDataSet
	sy@SynchroData{
		dsync=sync',dframeSize=frameSize',dstreamId=streamId',dsoc=soc'@(SOC soci'),
		dfracSec=fracSec',stat=stat',phasors=phasors',freq=freq',
		dFreq=dFreq',analogs=analog',digitals=digitals',dchk=chk'
	} fSOC fP fA fDI idx end
		| idx == end = 
			[finalizeData $ SynchroData{
				dsync=sync',dframeSize=frameSize',dstreamId=streamId',
				dfracSec=fracSec',stat=stat',freq=freq',dFreq=dFreq',
				dchk=chk',
				
				
				dsoc= mkSoc $ fSOC idx soci',
				
				phasors=	
					map mkPhasorP $				
					fP 
					`mf` 
					[ idx | i <- [1..(length phasors')] ]
					`mf`
					(map extractPhasor phasors'),
						
				analogs=analog',
				digitals=digitals'
			}]
		| otherwise =  	(finalizeData $ SynchroData{
				dsync=sync',dframeSize=frameSize',dstreamId=streamId',
				dfracSec=fracSec',stat=stat',freq=freq',dFreq=dFreq',
				dchk=chk',
				
				
				dsoc= mkSoc $ fSOC idx soci',
				phasors=	
					map mkPhasorP $				
					fP 
					`mf`
					[ idx | i <- [1..(length phasors')] ]
					`mf`
					(map extractPhasor phasors'),
					
				analogs=analog',
				digitals=digitals'
			}) : makeDataSet sy fSOC fP fA fDI (idx + 1) end
	
-- multi-filter
mf :: [(a->b)] -> [a] -> [b]
mf f a
	| lf < la = mf' f a 0 lf
	| otherwise = mf' f a 0 la
		where
			lf = length f
			la = length a
			
mf' :: [(a->b)] -> [a] -> Int -> Int -> [b]
mf' f a i lim 
	| i == lim = []
	| otherwise = (f !! i) (a !! i) : mf' f a (i+1) lim

mkPhasorP :: (Integer, Integer) -> Phasor
mkPhasorP (re, im) = Phasor (fromInteger re) (fromInteger im)

extractReal :: Phasor -> Integer
extractReal (Phasor re im) = (fromIntegral re)

extractImag :: Phasor -> Integer
extractImag (Phasor re im) = (fromIntegral im)

extractPhasor :: Phasor -> (Integer, Integer)
extractPhasor (Phasor re im) = ( (fromIntegral re), (fromIntegral im) )
	
	
	
	
	
	
	
	
	