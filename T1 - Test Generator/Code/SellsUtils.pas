unit SellsUtils;
interface
  uses
   Stringutils,
   ProductUtils;
  
  Type
    Sell = Record
    Datetime : string;
    Quantity : integer;
    Product : Product;
    Price : Real;
  End;
  
  function SellToString(sellToParse : Sell) : string;
    
  Procedure GenerateRandomSells(sellsPath: string; productsPath : string; year : integer; month : integer; quantity : integer; pricePercentage : integer);
  Procedure WriteSellOnFile(sellsPath : string; sellToWrite : Sell);
  
implementation
  uses
    StringUtils,
    RealUtils,
    RandomUtils,
    DateTimeUtils,
    ProductUtils;
  
    (*Generate random sells based on parameters.
   *Parameters are:
   *   sellsPath - Path of file where sells generated will be saved.
   *   productsPath - Path of products to generate sells.
   *   year - Year at sells will be generated.
   *   month - Month at sells will be generated.
   *   quantity - Quantity of random sells that will be generated. *)
  Procedure GenerateRandomSells(sellsPath: string; productsPath : string; year : integer; month : integer; quantity : integer; pricePercentage : integer);
  var
    day : integer;
    sellsFile : Text;
    currentSell : sell;
    i : integer;
    randomProduct : Product;
  begin
    Assign(sellsFile, sellsPath);
    Append(sellsFile);
    
    for i := 1 to quantity do
    begin
       day := GenerateRandomDay(month, year);
       currentSell.Datetime := GetsDateTime(year, month, day);
       
       currentSell.Product := GetsRandomProduct(productsPath);
       
       currentSell.Product.Price := AddRandomPercentage(currentSell.Product.Price, pricePercentage);
       
       Randomize;       
       currentSell.Quantity := Random(100) + 1;
       currentSell.Price := currentSell.Product.Price * currentSell.Quantity;
       
       WriteSellOnFile(sellsPath, currentSell);
    end
  end;   
  
  (*Receives one sell and returns it csv formated.
   * The format will be:
   * productCode;dateTime;quantity;TotalPrice*)
  function SellToString(sellToParse : Sell) : string;
  const
    decimalLength = 2;
  var
    sellString : string;
    quantity : string;
  begin
    str(sellToParse.Quantity, quantity);
  
    sellString := sellToParse.Product.Code + ';';
    sellString := sellString + sellToParse.Datetime + ';';
    sellString := sellString + quantity + ';';
    sellString := sellString + RealToStr(sellToParse.Price, decimalLength);
    
    SellToString := sellString;
  end;
    
  (*This procedure append sell on file*)
  Procedure WriteSellOnFile(sellsPath : string; sellToWrite : Sell);
  var
    sellsFile : Text;
  begin
    Assign(sellsFile, sellsPath);
    Append(sellsFile);
    
    Writeln(sellsFile, SellToString(sellToWrite));
    Close(sellsFile);
  end;
end.