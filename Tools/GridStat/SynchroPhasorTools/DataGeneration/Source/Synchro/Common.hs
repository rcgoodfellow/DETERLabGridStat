module Synchro.Common 
	(
	-- Classes
	Eval(..),

	-- Types
	Sync, FrameType(..), StandardVersion(..), FrameSize,
	IdCode, SOC(..), FracSec, LeapSecond, Direction(..), Occured(..), Pending(..),
	MsgTimeQuality(..), Chk,
	
	-- Functions
	mkSync, mkFrameSize, mkIdCode, mkSoc, mkFracSec, mkLeapSecond, mkChk,
	initFoldMapEval, twoByTwo, breakHexOut

	) where
	
import Synchro.Utility
import Data.ByteString(ByteString, pack)
	
class Eval e where
	eval :: e -> String
	
data Sync = Sync FrameType StandardVersion deriving (Show)
mkSync :: FrameType -> StandardVersion -> Sync
mkSync ft sv = Sync ft sv
instance Eval Sync where
	eval (Sync ft sv) = "AA" ++ (eval ft) ++ (eval sv)

data FrameType = DataFrame | HeaderFrame | ConfigFrame1 | ConfigFrame2 | 
					ConfigFrame3 deriving (Show)
instance Eval FrameType where
	eval DataFrame 		= "0"
	eval HeaderFrame	= "1"
	eval ConfigFrame1	= "2"
	eval ConfigFrame2	= "3"
	eval ConfigFrame3	= "5"					

data StandardVersion = Version1 | Version2 deriving (Show)
instance Eval StandardVersion where
	eval Version1	= "1"
	eval Version2	= "2"

-- FrameSize
data FrameSize = FrameSize Integer deriving (Show)
mkFrameSize :: Integer -> FrameSize
mkFrameSize a = FrameSize $ uNcheck 16 a "FRAMESIZE"
instance Eval FrameSize where
	eval (FrameSize i) = sh 2 i

-- IdCode
data IdCode = IdCode Integer deriving (Show)
mkIdCode :: Integer -> IdCode
mkIdCode a = case a of
			65535 -> error "ICODE 65535 is reserved"
			otherwise -> IdCode $ uNcheck 16 a "IDCODE"
instance Eval IdCode where
	eval (IdCode i) = sh 2 i

-- SOC
data SOC = SOC Integer deriving (Show)
mkSoc :: Integer -> SOC
mkSoc a = SOC $ uNcheck 32 a "SOC"
instance Eval SOC where
	eval (SOC i) = sh 4 i

-- FracSec
data FracSec = FracSec LeapSecond Integer MsgTimeQuality deriving (Show)
mkFracSec :: LeapSecond -> Integer -> MsgTimeQuality -> FracSec
mkFracSec ls val mtq = FracSec ls (uNcheck 24 val "frac numerator") mtq
instance Eval FracSec where
	eval (FracSec ls d mtq) = (eval ls) ++ (eval mtq) ++ (sh 3 d)

data LeapSecond = LeapSecond Direction Occured Pending deriving (Show)
mkLeapSecond :: Direction -> Occured -> Pending -> LeapSecond
mkLeapSecond d o p = LeapSecond d o p
instance Eval LeapSecond where
	eval (LeapSecond d o p) = sh 0 $ (drVal d) + (oVal o) + (pVal p)

data Direction = Forward | Backward deriving (Show)
drVal :: Direction -> Integer
drVal Forward = 4
drVal Backward = 0
data Occured = Occured | NotOccured deriving (Show)
oVal :: Occured -> Integer
oVal Occured = 2
oVal NotOccured = 0
data Pending = Pending | NotPending deriving (Show)
pVal :: Pending -> Integer
pVal Pending = 1
pVal NotPending = 0

data MsgTimeQuality = ClockFailure | S10 | S | MS100 | MS10 | MS |
						US100 | US10 | US | NS100 | NS10 | NS | 
						LockedUTC deriving (Show)
instance Eval MsgTimeQuality where
	eval ClockFailure = sh 0 15
	eval S10 = sh 0 11
	eval S = sh 0 10
	eval MS100 = sh 0 9
	eval MS10 = sh 0 8
	eval MS = sh 0 7
	eval US100 = sh 0 6
	eval US10 = sh 0 5
	eval US = sh 0 4
	eval NS100 = sh 0 3
	eval NS10 = sh 0 2
	eval NS = sh 0 1
	eval LockedUTC = sh 0 0
	
data Chk = Chk Integer deriving (Show)
mkChk :: Integer -> Chk
mkChk a = Chk $ uNcheck 16 a "CHK"
instance Eval Chk where
	eval (Chk i) = sh 2 i

initFoldMapEval :: Eval a => [a] -> String -> (String -> String) -> String				
initFoldMapEval lst sep pretty	=
	pretty $ take ((length str) - (length sep)) str
	 	where
			str = foldr (\a b -> a ++ sep ++ b) [] $ map eval lst

breakHexOut :: String -> ByteString
breakHexOut ls = pack $ map (\x -> read ("0x" ++ x)) ls'
	where
		ls' = twoByTwo ls

twoByTwo :: String -> [String]
twoByTwo [] = []
twoByTwo (x:y:xs) = [[x] ++ [y]] ++ twoByTwo xs




