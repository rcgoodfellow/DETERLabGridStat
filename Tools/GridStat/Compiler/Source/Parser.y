{
module Main where
import Tokens
import GSST.AST
import GSST.CodeGen
}

%name gsst
%tokentype { Lexeme }
%error { parseError }

%token
	';'								{ (L _ TSemi _) }
	'['								{  (L _ TOList _) }
	']'								{ (L _ TCList _) }
	'{'								{ (L _ TOElem _) }
	'}'								{ (L _ TCElem _) }
	'('								{ (L _ TOLink _) }
	')'								{ (L _ TCLink _) }
	','								{ (L _ TComma _) }
	'='								{ (L _ TEquals _) }
	label							{ (L _ TLabel $$) }
	num								{ (L _ TNumber $$) }
	name							{ (L _ TKeyword "Name") }
	broker							{ (L _ TKeyword "Broker") }
	port							{ (L _ TKeyword "Port") }
	dataPlane						{ (L _ TKeyword "DataPlane") }
	forwardingEngines				{ (L _ TKeyword "ForwardingEngines") }
	links							{ (L _ TKeyword "Links") }
	publisher						{ (L _ TKeyword "Publisher") }
	edge							{ (L _ TKeyword "Edge") }
	pubVar							{ (L _ TKeyword "PubVar") }
	rate							{ (L _ TKeyword "Rate") }
	subscriber						{ (L _ TKeyword "Subscriber") }
	subVar							{ (L _ TKeyword "SubVar") }
	pubName							{ (L _ TKeyword "PubName") }
	redundancy						{ (L _ TKeyword "Redundancy") }
	latency							{ (L _ TKeyword "Latency") }
	nameServer						{ (L _ TKeyword "NameServer") }
	
%%

Go : broker '{' BrokerName NameServer DataPlane Pubs Subs '}'				{codeGen (Broker $3 $4 $5 $6 $7)}

BrokerName : name '=' label ';'								 				{$3}

NameServer : nameServer '{' port '=' num ';' name '=' label ';' '}'			{NameServer (read $5) $9}

DataPlane : dataPlane '{' ForwardingEngines ';' Links ';' '}'				{DataPlane $3 $5}

ForwardingEngines : forwardingEngines '=' '[' FeList ']'					{$4}

FeList : label ',' FeList													{(ForwardingEngine $1):$3}
	   | label																{[(ForwardingEngine $1)]}

Links : links '=' '[' LnList ']'											{$4}

LnList : '(' label ',' label ')' ',' LnList									{(Link $2 $4):$7}
	   | '(' label ',' label ')'											{[(Link $2 $4)]}

Pubs : Pub Pubs																{$1:$2}
	 | Pub																	{[$1]}

Subs : Sub Subs																{$1:$2}
	 | Sub																	{[$1]}

Pub : publisher '{' name '=' label ';' edge '=' label ';' PubVarList '}' {Publisher $5 $9 $11}

PubVarList : PubVar PubVarList												{$1:$2}
	       | PubVar															{[$1]}

PubVar : pubVar '{' name '=' label ';' rate '=' num ';' '}'					{PubVar $5 (read $9)}

Sub : subscriber '{' name '=' label ';' edge '=' label ';' SubVarList '}' {Subscriber $5 $9 $11}

SubVarList : SubVar SubVarList												{$1:$2}
		   | SubVar															{[$1]}
		
SubVar : subVar '{' PubName SubName Rate Redundancy Latency '}'				{SubVar $3 $4 $5 $6 $7}

PubName : pubName '=' label ';'												{$3}
SubName : name '=' label ';'												{$3}
Rate : rate '=' num ';'														{read $3}
Redundancy : redundancy '=' num ';'											{read $3}
Latency : latency '=' num ';'												{read $3}



{



showLex :: Lexeme -> String
showLex (L pos t str) = {-(show t) ++ ":" ++-} str ++ " " ++ (showPosn pos)

showLexIO :: Lexeme -> IO ()
showLexIO l = putStrLn $ showLex l

parseError :: [Lexeme] -> a
parseError [] = error "Incomplete Input"
parseError (tk:tks) = error $ (redText "Parse error") ++ " at: " ++ (showLex tk)

data ParseResult a = ParseOk a
					| ParseFail String

type P a = String -> Int -> ParseResult a

thenP :: P a -> (a -> P b) -> P b
m `thenP` k = \s l ->
	case m s l of
		ParseFail s -> ParseFail s
		ParseOk a -> k a s l
		
returnP :: a -> P a
returnP a = \s l -> ParseOk a

{- parser str = runAlex str $ do
  let loop i = do tok@(L _ cl _) <- myScan; 
		  case cl of
			TEof -> return i
			otherwise -> do loop $! (i+1)
  loop 0 -}
	
parser2 str = do
  let loop l = do tok@(L _ cl _) <- myScan; 
		  case cl of
			TEof -> return l
			otherwise -> do loop $! (l++[tok])
  loop []

yprintResult :: (Show b) => Either String b -> IO ()

yprintResult (Left a) = putStrLn a
yprintResult (Right b) = putStrLn $ "Parse OK - " ++ show b ++ " tokens"


main = getContents >>=                         		                -- IO String
  ( \str -> return (parser2 str) >>=     		                  	-- String -> IO Alex [Lexeme]
  ( \ax_lx -> return $! (unAlex ax_lx) AlexState {
											alex_pos = alexStartPos,
											alex_inp = str,
											alex_chr = '\n',
											alex_bytes = [],
											alex_scd = 0 }
								) >>= 								-- Alex [Lexeme] -> IO Either String (AlexState, a)
  ( \ax_et -> case ax_et of										    -- Either String (AlexState, a) -> IO ()
    (Left a) -> putStrLn a
    (Right ((AlexState a b c d e), lx)) -> do { 
			{-sequence $ map showLexIO lx;-} 
			putStr $ "\n" ++ (blueText "Parsing System Specification...\t\t");
			gsst lx;})
  )
}
