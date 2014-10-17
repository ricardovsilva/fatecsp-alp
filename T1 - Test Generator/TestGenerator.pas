Program TestGenerator ;
  uses StringUtils;
  
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
  filePath : String[20];
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