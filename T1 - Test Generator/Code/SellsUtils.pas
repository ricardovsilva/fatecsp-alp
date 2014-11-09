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
  function CalculateVerifierDigit(sellCode : string):string;
  function StringToSell(sellString : string) : Sell;

  Procedure GenerateRandomSells(sellsPath: string; productsPath : string; year : integer; month : integer; quantityPerDay : integer; pricePercentage : integer);

implementation
  uses
    RealUtils,
    RandomUtils,
    DateTimeUtils;

    (*Generate random sells based on parameters.
   *Parameters are:
   *   sellsPath - Path of file where sells generated will be saved.
   *   productsPath - Path of products to generate sells.
   *   year - Year at sells will be generated.
   *   month - Month at sells will be generated.
   *   quantityPerDay - Quantity of random sells per day that will be generated. *)
  Procedure GenerateRandomSells(sellsPath: string; productsPath : string; year : integer; month : integer; quantityPerDay : integer; pricePercentage : integer);
  var
    day : integer;
    sellsFile : Text;
    currentSell : sell;
    i : integer;
    productArray : Products;
	quantityOfDays: integer;
  begin
    Assign(sellsFile, sellsPath);
    Rewrite(sellsFile);

    productArray := GetsProducts(productsPath);

	quantityOfDays := GetsQuantityOfDays(month, year);
	
	//Just one use of Randomize per program.
	Randomize;
	for day := 1 to quantityOfDays do
		if IsWorkingDay(year, month, day) then
			for i := 1 to quantityPerDay do
			begin
			   currentSell.Datetime := GetsDateTime(year, month, day);
			   
			   currentSell.Product := GetsRandomProduct(productsPath, productArray);
			   
			   currentSell.Product.Price := AddRandomPercentage(currentSell.Product.Price, pricePercentage);

			   //Randomize;
			   currentSell.Quantity := Random(100) + 1;
			   currentSell.Price := currentSell.Product.Price * currentSell.Quantity;
               
			   Writeln(sellsFile, SellToString(currentSell));
			end;
    Close(sellsFile);
  end;

  (*Receives one sell and returns it csv formated.
   * The format will be:
   * productCode-verifierDigit;dateTime;quantity;unityPrice*)
  function SellToString(sellToParse : Sell) : string;
  const
    decimalLength = 2;
  var
    sellString : string;
    quantity : string;
  begin
    str(sellToParse.Quantity, quantity);

    sellString := concat(sellToParse.Product.Code, '-', CalculateVerifierDigit(sellToParse.Product.Code),';');
    sellString := concat(sellString,sellToParse.Datetime,';');
    sellString := concat(sellString,quantity,';');
    sellString := concat(sellString,RealToStr(sellToParse.Product.Price, decimalLength));

    SellToString := sellString;
  end;
  
  (* Receives one string with the following format:
  * 3001-3;12/03/2012;16;37.80;
  * The format above is:
  * productCode-verifierDigit;dateTime;quantity;unityPrice
  * the return is one Sell record
  *)
  function StringToSell(sellString : string) : Sell;
  const
    codePosition = 1;
    datePosition = 2;
    quantityPosition = 3;
    pricePosition = 4;
  var
    arrayString : SplitedText;
	  returnSell : Sell;
  begin
    arrayString := Split(sellString, ';');
	
	  returnSell.Product.Code := RemoveVerifierDigit(arrayString[codePosition]);
	  returnSell.Datetime := arrayString[datePosition];
    returnSell.Quantity := StrToInteger(arrayString[quantityPosition]);
    returnSell.Product.Price := StrToReal(arrayString[pricePosition]);
    returnSell.Price := returnSell.Product.Price * returnSell.Quantity;
	
	  StringToSell := returnSell;
  end;
  

  (*Receives one sell code, calculates and returns the verifier digit.*)
  function CalculateVerifierDigit(sellCode : string):string;
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
