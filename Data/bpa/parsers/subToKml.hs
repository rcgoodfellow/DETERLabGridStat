import Text.ParserCombinators.Parsec

{- many is a function that takes a function as an agrument and tries to 
   repetedly parse the input using the funciton passed to it returning
   the results in a list-}

csvFile :: GenParser Char st [[String]]
csvFile = 
  do result <- many line
     eof
     return result
     
line :: GenParser Char st [String]
line = 
  do result <- cells
     eol
     return result
     
cells :: GenParser Char st [String]
cells
  (gid: ',' :sta_code: ',' :name: ',' :typ: ',' :owner: ',' :geo) = 
  return ([gid, sta_code, name, typ, owner, geo])

{-      
cells :: GenParser Char st [String]
cells = 
  do gid <- cellContent
     sta_code <- cellContent
     name <- cellContent
     typ <- cellContent
     owner <- cellContent
     geo <- cellContent
     return ([gid, sta_code, name, typ, owner, geo])
     
remainingCells :: GenParser Char st [String]
remainingCells = 
  (char ',' >> cells)
  <|> (return [])
  
cellContent :: GenParser Char st String
cellContent = 
  many (noneOf ",\n")

-}
  
  
eol :: GenParser Char st Char
eol = char '\n'

parseCSV :: String -> Either ParseError [[String]]
parseCSV input = parse csvFile "(unknown)" input

--parseCSVFile :: String -> Either ParseError [[String]]
parseCSVFile input =
  do content <- readFile input
     return $ parseCSV content
     


