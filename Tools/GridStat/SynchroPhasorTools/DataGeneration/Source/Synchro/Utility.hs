module Synchro.Utility where
	
import qualified Data.Char as DC
import Data.Int
import Numeric
import Data.Bits
import Data.Word(Word8,Word16)
import Data.Binary.Put(runPut)
import Data.ByteString.Lazy(unpack)
import Data.Binary.IEEE754


showHexFloat :: Float -> String
showHexFloat f = foldl (++) [] 	$ map (\a -> sh 1 (fromIntegral a) ) 
								$ unpack $ runPut $ putFloat32be (f)

sh :: Integer -> Integer -> String
sh bytes a = (pad bytes) $ map DC.toUpper $ showHex (gate a) ""
	where gate a 
		| a < 0 = 65536 + a
		| otherwise = a

pad :: Integer -> String -> String
pad n a 
	| n == 0 = a
	| diff < 0 = error "bad number of digits in hex rep"
	| diff == 0 = a
	| otherwise = (mkPad diff) ++ a
		where
			diff = (n*2) - (fromIntegral (length a))

	
mkPad :: Integer -> String
mkPad 0 = ""
mkPad i = "0" ++ mkPad (i-1)

mkHexStr :: String -> String
mkHexStr s = foldl (++) [] $ map ((sh 0) . (fromIntegral . DC.ord)) s'
	where
		s' = to16 s

to16 :: String -> String
to16 s = s ++ (emptyString $ 16 - length s)

emptyString :: Int -> String
emptyString 0 = ""
emptyString i = " " ++ emptyString (i-1)




uNcheck :: Integer -> Integer -> String -> Integer
uNcheck n a s
	| a < 0 = error $ s ++ "must be greater than 0"
	| a >= 2^n = error $ s ++ "is limited to "++ (show n) ++ 
										" bit representation"
	| otherwise = a

str16check :: String -> String -> String
str16check s name
	| length s > 16 = error name ++ "must be less than 16 charachters"
	| length s == 0 = error name ++ "must have at least 1 charachter"
	| otherwise = s
	
fracCheck :: Double -> Double
fracCheck d
	| d < 0 = error "Fractional must be greater than or equal to 0"
	| d >= 1 = error "Fractional must be less than one"
	| otherwise = d
	
	
mkCrc :: [Word16] -> Word16
mkCrc msg = mkCrc' msg 0 0xFFFF

		

mkCrc' :: [Word16] -> Int -> Word16 -> Word16
mkCrc' msg i crc
	| i == (length msg) = crc
	| otherwise = mkCrc' msg (i+1) crc''''
	where
		tmp = (shift crc (-8)) `xor` (msg !! i)
		crc' = shift crc (8)
		quick = tmp `xor` (shift tmp (-4))
		crc'' = crc' `xor` quick
		quick' = shift quick (5)
		crc''' = crc'' `xor` quick'
		quick'' = shift quick' (7)
		crc'''' = crc''' `xor` quick''


prettyHex :: String -> String
prettyHex s = prettyHex' s 0


prettyHex' :: String -> Int -> String
prettyHex' s i
	| i == ((length s)) = ""
	| otherwise = [(s !! i)] ++ [(s !! (i+1))] ++ " " ++ prettyHex' s (i+2)
	
hxsToArr :: String -> [Word16]
hxsToArr s = hxsToArr' s 0


hxsToArr' :: String -> Int -> [Word16]
hxsToArr' s i
	| i == ((length s)) = []
	| otherwise = [read ( "0x" ++ [(s !! i)] ++ [(s !! (i+1))] )] ++ hxsToArr' s (i+2)
