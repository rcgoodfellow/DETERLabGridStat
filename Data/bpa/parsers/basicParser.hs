{- This little haskell script is used to generate a KML file from PostGIS partial KML  
   ouput along with some additional information such as name and style-}

import Data.List.Split
import Data.String.Utils

listifyCsvData :: String -> [[String]]
listifyCsvData input = map (splitOn ";") $ tail $ splitOn "\n" input

listifyCsvFile :: String -> IO [[String]]
listifyCsvFile input = 
  do 
    dta <- readFile input
    return ( listifyCsvData dta )
    
fileToKmlString :: String -> ([[String]] -> String) -> IO String
fileToKmlString input f = 
  do
    dta <- readFile input
    return ( f $ listifyCsvData dta )
    
fileToKmlFile :: String -> String -> ([[String]] -> String) -> IO ()
fileToKmlFile input output f = 
  do
    dta <- fileToKmlString input f
    writeFile output dta
    
kmlHeader :: String
kmlHeader =
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n" ++ 
  "<kml xmlns=\"http://www.opengis.net/kml/2.2\"> \n" ++
  "  <Document> \n"

kmlFooter :: String
kmlFooter = 
  "  </Document> \n" ++
  "</kml> \n"
    
kmlifySubstation :: [[String]] -> String
kmlifySubstation input = kmlHeader ++
                         (kmlBody input makeSubstationPlacemark) ++
                         kmlFooter
                         
kmlifyTline :: [[String]] -> String                         
kmlifyTline input = kmlHeader ++
                    tlineStyle ++
                    (kmlBody input makeTlinePlacemark) ++
                    kmlFooter

kmlBody :: [[String]] -> ([String] -> String) -> String
kmlBody input f = foldl (++) [] $  map f input
  
makePlacemark :: String -> String -> String -> String                  
makePlacemark name body style = 
  "<Placemark> \n" ++
  "  <name>" ++ name ++ "</name> \n" ++
  "  <styleUrl>" ++ style ++ "</styleUrl> \n" ++
  "  " ++ body ++ " \n" ++
  "</Placemark> \n"                  
  
makeSubstationPlacemark :: [String] -> String
makeSubstationPlacemark [gid, sta_code, name, typ, owner, geo] = 
  makePlacemark name geo ""
makeSubstationPlacemark _ = " "


tlineStyle :: String
tlineStyle = 
  "<Style id=\"tlineStyle\">\n" ++
  "  <LineStyle>\n" ++
  "    <color>7f00ffff</color>\n" ++
  "    <width>4</width>\n" ++
  " </LineStyle>\n" ++
  "</Style>\n"
  
makeTlinePlacemark :: [String] -> String
makeTlinePlacemark [gid, name, kv, code, owner, geo] =
  makePlacemark (replace "&" " and " name) geo "#tlineStyle"
makeTlinePlacemark _ = " "

  
  



    