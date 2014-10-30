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
  function CalculateVerifierDigit(sellCode : string[4]):string;
    
  Procedure GenerateRandomSells(sellsPath: string; productsPath : string; year : integer; month : integer; quantity : integer; pricePercentage : integer);
  
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
    productArray : Products;
  begin
    Assign(sellsFile, sellsPath);
    Append(sellsFile);
    
    productArray := GetsProducts(productsPath);
    
    for i := 1 to quantity do
    begin
       day := GenerateRandomDay(month, year);
       currentSell.Datetime := GetsDateTime(year, month, day);
       
       currentSell.Product := GetsRandomProduct(productsPath, productArray);
       
       currentSell.Product.Price := AddRandomPercentage(currentSell.Product.Price, pricePercentage);
       
       Randomize;       
       currentSell.Quantity := Random(100) + 1;
       currentSell.Price := currentSell.Product.Price * currentSell.Quantity;
       
       Writeln(sellsFile, SellToString(currentSell));
    end;
    
    Close(sellsFile);
  end;   
  
  (*Receives one sell and returns it csv formated.
   * The format will be:
   * productCode-verifierDigit;dateTime;quantity;TotalPrice*)
  function SellToString(sellToParse : Sell) : string;
  const
    decimalLength = 2;
  var
    sellString : string;
    quantity : string;
  begin
    str(sellToParse.Quantity, quantity);
  
    sellString := concat(sellToParse.Product.Code, '-', CalculateVerifierDigit(sellToParse.Product.Code,';');
    sellString := concat(sellString,sellToParse.Datetime,';');
    sellString := concat(sellString,quantity,';');
    sellString := concat(sellString,RealToStr(sellToParse.Price, decimalLength));

    SellToString := sellString;
  end;

  (*Receives one sell code, calculates and returns the verifier digit.*)
  function CalculateVerifierDigit(sellCode : string[4]):string;
    var 
    calc : string;
    i, sum: integer;
    toInt: Array [0..3]of integer;
  begin
    sum := 0;
    toInt[0] := StrToInteger(sellCode[1])*5;
    toInt[1] := StrToInteger(sellCode[2])*4;
    toInt[2] := StrToInteger(sellCode[3])*3;
    toInt[3] := StrToInteger(sellCode[4])*2;
    for i:= 0 to 3 do
      sum := sum + toInt[i];
    sum := sum mod 7;
  Str (sum, calc);
  CalculateVerifierDigit := calc;
  end;

end.