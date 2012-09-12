{
module Tokens where
import GSST.CodeGen
}

%wrapper "monad"

$digit = [0-9]
$alpha = [a-zA-z]

@keyword = Broker|Name|Port|NameServer|
			DataPlane|ForwardingEngines|Links|
			Publisher|Name|Edge|
				PubVar|Name|Rate|
			Subscriber|Name|Edge|
				SubVar|PubName|Name|Rate|Redundancy|Latency

tokens :-

	$white+							{ mySkip }
	"\n"							{ mySkip }
	"\t"							{ mySkip }
	"\r"							{ mySkip }
	"\n\r"							{ mySkip }
	";"								{ mkL TSemi }
	"["								{ mkL TOList }
	"]"								{ mkL TCList }
	"{"								{ mkL TOElem }
	"}"								{ mkL TCElem }
	"("								{ mkL TOLink }
	")"								{ mkL TCLink }
	","								{ mkL TComma }
	"="								{ mkL TEquals }
	eof								{ mkL TEof }
	@keyword						{ mkL TKeyword }
	$digit+							{ mkL TNumber }
	$alpha [$alpha $digit \_]*		{ mkL TLabel }

	
{
data Token = 
	TSemi			|
	TOList			|
	TCList			|
	TOElem			|
	TCElem			|
	TOLink			|
	TCLink			|
	TComma			|
	TNumber			|
	TLabel 			|
	TEquals			|
	TKeyword 		|
	TEof
	deriving (Eq,Show)

mkL :: Token -> AlexInput -> Int -> Alex Lexeme
mkL c (p,_,_,str) len = return (L p c (take len str))

data Lexeme = L AlexPosn Token String

lexError s = do
  (p,c,_,input) <- alexGetInput
  alexError (showPosn p ++ ": " ++ s ++ 
		   (if (not (null input))
		     then " at " ++ show (head input)
		     else " at end of file"))

mySkip input len = myScan

myBegin code input len = do alexSetStartCode code; myScan

myScan = do
	inp <- alexGetInput
	sc <- alexGetStartCode
	case alexScan inp sc of
		AlexEOF -> alexEOF
		AlexError inp' -> lexError (redText "lexical error")
		AlexSkip inp' len -> do
			alexSetInput inp'
			myScan
		AlexToken inp' len action -> do
			alexSetInput inp'
			action (ignorePendingBytes inp) len
--			myScan

scanner str = runAlex str $ do
  let loop i = do tok@(L _ cl _) <- myScan; 
		  case cl of
			TEof -> return i
			otherwise -> do loop $! (i+1)

  loop 0

alexEOF = return (L undefined TEof "") 

showPosn (AlexPn _ line col) = show line ++ ':': show col

printResult :: (Show b) => Either String b -> IO ()

printResult (Left a) = putStrLn a
printResult (Right b) = putStrLn $ "Parse OK - " ++ show b ++ " tokens"


lexGo = do
  s <- getContents
  printResult (scanner s)
}
