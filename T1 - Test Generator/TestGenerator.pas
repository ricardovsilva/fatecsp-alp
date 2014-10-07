Program TestGenerator ;

  Type
      Product = Record
      Code : String[4];
      Name : String[30];
      Price : Real;
  End;
  
  Type
    Sell = Record
    Datetime : String[10];
    ProductCode : String[4];
    Quantity: integer;
    Price: Real;
  End;
  
  Type
    Sells = array[1..65532] of Sell;
  
  Type
    Products = array[1..15] of Product;
  
  Type
    SplitedText = array[1..255] of String[255];
    
  (*Converts string to real. This function was copied from 
  http://professorwellingtontelles.blogspot.com.br/2011/06/converter-string-em-real-em-pascal.html
  at 2014-10-07*)
  function StrToReal (s: String): Real;  
  var  
    r : Real;  
    p : Integer;  
  begin  
    Val (s,r,p);  
    if p > 0 then Val (copy(s,1,p-1),r,p);  
      StrToReal := r;  
  end;
  
  (*Parse array of strings into Product struct*)  
  function ParseProduct(productInfo : SplitedText) : Product;
    var
      returnProduct : Product;
      codeIndex, nameIndex, priceIndex : integer;
    Begin
      codeIndex := 1;
      nameIndex := 2;
      priceIndex := 3;
      
      returnProduct.Code := productInfo[codeIndex];
      returnProduct.Name := productInfo[nameIndex];
      returnProduct.Price := StrToReal(productInfo[priceIndex]);
      
      ParseProduct := returnProduct;
    End; 
  
  (*Split text passed by parameter using separator char to do split.*)
  function Split(textToSplit : String[255]; separatorChar : char) : SplitedText;
  var
    i, offset, counter : integer;
    returnArray : SplitedText;
    breakedText : string[255];
  Begin
    counter := 1;
    offset := 1;
    for i:= 1 to Length(textToSplit) do
    begin
      if textToSplit[i] = separatorChar then
      begin
        breakedText := copy(textToSplit, offset, i - offset);
        offset := offset + length(breakedText) + 1;
        if length(breakedText) > 0 then
        begin
          returnArray[counter] := breakedText;
          counter := counter + 1;
        end
      end
    end;
      
    Split := returnArray;
  End;
  
  (*Verify if string passed by parameter contains only empty chars*)
  function StringIsEmpty(textToVerify : String[255]) : boolean;
  var
    returnValue : boolean;
    i, emptyChar : integer;
  Begin
    emptyChar := 0;
    returnValue := true;
    
    for i:= 1 to length(textToVerify) do
    begin
      returnValue := returnValue and (ord(textToVerify[i]) = emptyChar);
    end;
    
    StringIsEmpty := returnValue;
  end; 
  
  function StringStartsWith(stringToVerify: string[255]; startChar : char) : boolean;
  begin
    StringStartsWith := stringToVerify[1] = startChar;
  end;
    
  function LineIsValid(line : String[255]): boolean;
  Begin
    LineIsValid:= not StringIsEmpty(line) and not StringStartsWith(line, '#');
  end;
  
  (*Gets lines of products from file passed by parameter*) 
  function GetsProducts(filePath : String[255]) : Products;
  var
    productsVar : Products;
    counter : integer;
    line: string[255];
    separator: char;
    fileVar : Text;
  Begin
    counter := 1;
    separator := ';';
    
    Assign(fileVar, filePath);
    Reset(fileVar);
   
    while not EOF(fileVar) do
    begin
      Readln(fileVar, line);
      if LineIsValid(line) then
      begin
        productsVar[counter] := ParseProduct(Split(line, separator));
        counter := counter + 1;
      end
    end;
    
    GetsProducts := productsVar;
  End;
  
  (*Requests to user quantity of random sells that will be generated*)
  function RequestQuantityOfSells : integer;
  var
    quantity : integer;
  Begin
    Write('Digite a quantidade de vendas a serem geradas aleatoriamente: ');
    Readln(quantity);
    
    RequestQuantityOfSells := quantity;
  End;

  (*Request the number of month to random generate sells*)
  function RequestMonthNumber : integer;
  var
    monthNumber : integer;
  begin
    repeat
      Write('Digite o mes as quais as vendas serao geradas: ');
      Readln(monthNumber);
      
    until ((monthNumber > 1) and (monthNumber < 12)) or (monthNumber = 1) or (monthNumber = 12);
  end;
  
  (*Generate random day of the month*)
  function GenerateRandomDay (month : integer) : integer;
  var
    daysInMonth, year : integer;
  begin
    year := 2014;
    daysInMonth := 30;
    
    Randomize;
    GenerateRandomDay := Random(daysInMonth) + 1;
  end;
  
  (*Generate sellsQuantity random sells into monthNumber month of year 2014*)
  function GenerateRandomSells(sellsQuantity, monthNumber : integer; productsList : products) : Sells;
  var
    i, randomDay : integer;
  begin
    for i:= 0 to sellsQuantity do
    begin
      Writeln(GenerateRandomDay(monthNumber));      
    end; 
  end;
  
  (*Prints all products of array*)
  procedure PrintProducts(productsArray : Products);
  var
    i : integer;
  begin
    for i:= 1 to 15 do
    begin
      begin
        Writeln('Code: ', productsArray[i].Code);
        Writeln('Description: ', productsArray[i].Name);
        WriteLn('Price: ', productsArray[i].Price:6:2);
        WriteLn;
      end
    end
  end;

var
  sellsVar : Sells;
  filePath : String[255];
  productsList : Products;
  sellsQuantity, monthNumber : integer;
Begin
  filePath := 'Produtos.txt';
  
  productsList := GetsProducts(filePath);   
  sellsQuantity := RequestQuantityOfSells;
  monthNumber := RequestMonthNumber;
  
  sellsVar := GenerateRandomSells(sellsQuantity, monthNumber, productsList);
  
  Readln;
End.