module GSST.CodeGen
	(
	
	codeGen, blueText, redText, greenText
	
	) where
		
import GSST.AST	
import System.Terminal.Core	

codeGen :: Broker -> IO ()
codeGen b = 
	(putStrLn $ (greenText "OK")) >> -- If we made it here parsing was successfull
	(putStrLn $ (blueText "Generating Configuration Files")) >>
	(putStr $ (blueText "Publishers...\t\t\t\t")) >>
	return b >>= 
	genPubs >>		
	(putStrLn $ (greenText "OK")) >> 
	(putStr $ (blueText "Subscribers...\t\t\t\t")) >>
	return b >>=
	genSubs >> 
	(putStrLn $ (greenText "OK")) >> 
	(putStr $ (blueText "Broker...\t\t\t\t")) >>
	return b >>=
	genBroker >>
	(putStrLn $ (greenText "OK")) >>
	(putStrLn $ (greenText "Done") {-show b-})	
	
	
genBroker :: Broker -> IO Broker
genBroker br = 
	return br >>=
		( \br'@(Broker bName _ (DataPlane fwEngs links) _ _) ->
									(writeFile (bName ++ "Broker.xml") (brokerXmlStr (bName, fwEngs, links)) ) >>
		( return br )
	)	

brokerXmlStr :: (Name, [ForwardingEngine], [Link]) -> String
brokerXmlStr (brName, fwEngs, links) = 
	"<QoSBroker name=\"" ++ brName ++ "\">" ++ "\r\n\t" ++
		"<VertexTable>" ++ "\r\n\t\t" ++
		(genVertexes brName fwEngs 10000) ++ "\r\t" ++
		"</VertexTable>" ++ "\r\n\t" ++
		"<EdgeTable>" ++ "\r\n\t\t" ++
		(genLinks brName links ( lf, (lf+1) )) ++ "\r\t" ++
		"</EdgeTable>" ++ "\r\n" ++
	"</QoSBroker>"
	where
		lf = 10001 + length fwEngs

genLinks :: Name -> [Link] -> (Int, Int) -> String
genLinks _ [] _ = ""
genLinks brName (ln:lns) p@(p1,p2) = (linkXml brName ln p) ++ "\r\n\t\t" ++ ( genLinks brName lns ((p1+2), (p2+2)) )

linkXml :: Name -> Link -> (Int, Int) -> String
linkXml brName (Link a b) (pa, pb) =
	"<Edge latency=\"0\" bandwidth=\"0\" type=\"0\" " ++ 
	"srcName=\"" ++ (qName brName a) ++	"\" dstName=\"" ++ (qName brName b) ++ "\" " ++
	"srcPort=\"" ++ (show pa) ++		"\" dstPort=\"" ++ (show pb) ++ "\" " ++
	"srcAddr=\"" ++ linkName a b a ++	"\" dstAddr=\"" ++ linkName a b b ++ "\"" ++
	"/> \r\n\t\t" ++
	
	"<Edge latency=\"0\" bandwidth=\"0\" type=\"0\" " ++ 
	"srcName=\"" ++ (qName brName b) ++	"\" dstName=\"" ++ (qName brName a) ++ "\" " ++
	"srcPort=\"" ++ (show pb) ++		"\" dstPort=\"" ++ (show pa) ++ "\" " ++
	"srcAddr=\"" ++ linkName a b b ++	"\" dstAddr=\"" ++ linkName a b a ++ "\"" ++
	"/> \r\n\t\t"
	where
		linkName a b to = to ++ "-" ++ a ++ "-" ++ b;
		qName bName name = bName ++ "." ++ name

genVertexes :: Name -> [ForwardingEngine] -> Int -> String
genVertexes _ [] _ = ""
genVertexes brName (fe:fes) port = (vertexXml brName fe port) ++ "\r\n\t\t" ++ (genVertexes brName fes (port + 1))

vertexXml :: Name -> ForwardingEngine -> Int -> String
vertexXml brName (ForwardingEngine name) port = "<Vertex msgPerSec=\"5000\" type=\"0\"" ++ 
										" name=\"" ++ brName ++ "." ++ name ++ "\"" ++ 
										" port=\"" ++ (show port) ++ "\"/>"

genPubs :: Broker -> IO Broker
genPubs br = 
	return br >>= 
		( \br'@(Broker bName (NameServer nsPort nsName) _ p _) -> sequence
						(map (\(n, str) -> writeFile (bName ++ n ++ ".xml") str) 
						     (pubXmlStrs (bName, nsName, nsPort, p))
						) >>
		( return br )		
	)
	
pubXmlStrs :: (Name, Name, Int, [Publisher]) -> [(Name,String)]
pubXmlStrs (brName, nsName, nsPort, []) = []
pubXmlStrs (brName, nsName, nsPort, (p@(Publisher name _ _):ps)) = 
				(name, pubXmlStr (brName, nsName, nsPort, p)) : pubXmlStrs (brName, nsName, nsPort, ps)


pubXmlStr :: (Name, Name, Int, Publisher) -> String
pubXmlStr (brName, nsName, nsPort, (Publisher pName eName pVars)) = 
		"<PubInfo nameServerPort=\"" ++ (show nsPort) ++ "\" " ++
				 "nameServer=\"" ++ nsName ++ "\" " ++
				 "edgeFe=\"" ++ brName ++ "." ++ eName ++ "\" " ++
				 "name=\"" ++ brName ++ "." ++ pName ++ "\">\r\n\t" ++
			"<varInfo>" ++ "\r\n\t\t" ++
				 (pubVarXmlStrs pName pVars) ++ "\r\t" ++ 
			"<varInfo>" ++ "\r\n" ++
		"</PubInfo>"

pubVarXmlStrs :: Name -> [PubVar] -> String
pubVarXmlStrs brName [] = ""
pubVarXmlStrs brName (pv:pvs) = (pubVarXmlStr brName pv) ++ "\r\n\t\t" ++ (pubVarXmlStrs brName pvs)

--TODO: The type here needs to correspond to GS BLOB
pubVarXmlStr :: Name -> PubVar -> String
pubVarXmlStr brName (PubVar pvName rate) = 
	"<var id=\"-1\" type=\"0\" minInterval=\"" ++ interval ++ "\" maxInterval=\"" ++ interval ++ 
	    "\" security=\"0\" priority=\"3\" " ++ "name=\"" ++ brName ++ "." ++ pvName ++ "\"/>"
		where
			interval = show $ rateToInterval (fromIntegral rate)			
			
genSubs :: Broker -> IO Broker
genSubs br = 
	return br >>= 
		( \br'@(Broker bName (NameServer nsPort nsName) _ _ s) -> sequence
											(map (\(n, str) -> writeFile (bName ++ n ++ ".xml") str)
											     (subXmlStrs (bName, nsName, nsPort, s)) 
											) >>
		( return br )		
	)

subXmlStrs :: (Name, Name, Int, [Subscriber]) -> [(Name,String)]
subXmlStrs (brName, nsName, nsPort, []) = []
subXmlStrs (brName, nsName, nsPort, (s@(Subscriber name _ _):ss)) = 
			(name, subXmlStr (brName, nsName, nsPort, s)) : subXmlStrs (brName, nsName, nsPort, ss)


subXmlStr :: (Name, Name, Int, Subscriber) -> String
subXmlStr (brName, nsName, nsPort, (Subscriber sName eName sVars)) = 
		"<SubInfo nameServerPort=\"" ++ (show nsPort) ++ "\" " ++
				 "nameServer=\"" ++ nsName ++ "\" " ++
				 "edgeFe=\"" ++ brName ++ "." ++ eName ++ "\" " ++
				 "name=\"" ++ brName ++ "." ++ sName ++ "\">\r\n\t" ++
			"<varInfo>" ++ "\r\n\t\t" ++
				 (subVarXmlStrs sName sVars) ++ "\r\t" ++
			"<varInfo>" ++ "\r\n" ++
		"</SubInfo>"

subVarXmlStrs :: Name -> [SubVar] -> String
subVarXmlStrs brName [] = ""
subVarXmlStrs brName (sv:svs) = (subVarXmlStr brName sv) ++ "\r\n\t\t" ++ (subVarXmlStrs brName svs)

--TODO: The type here needs to correspond to GS BLOB
subVarXmlStr :: Name -> SubVar -> String
subVarXmlStr brName (SubVar pubName svName rate redundancy latency) = 
	"<var id=\"-1\" type=\"0\" minInterval=\"" ++ interval ++ "\" maxInterval=\"" ++ interval ++ 
	    "\" security=\"0\" priority=\"3\" " ++ "name=\"" ++ brName ++ "." ++ svName ++ "\"" ++
	     " redundancy=\"" ++ (show redundancy) ++ "\" latency=\"" ++ (show latency) ++ "\"" ++ " pubName=\"" ++ 
		pubName ++ "\"/>"
		where
			interval = show $ rateToInterval (fromIntegral rate)

rateToInterval :: (Integral b, RealFrac a) => a -> b
rateToInterval r = floor (1000 / r)

colorText :: String -> String -> String
colorText color s = "\27[" ++ color ++ s ++ "\27[00m"

blueText :: String -> String
blueText s = colorText "34m" s

redText :: String -> String
redText s = colorText "31m" s

greenText :: String -> String
greenText s = colorText "32m" s
