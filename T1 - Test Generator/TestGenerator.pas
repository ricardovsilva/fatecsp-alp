Program TestGenerator ;
  uses StringUtils;
  
  Type
    Sell = Record
    Datetime : String[10];
    ProductCode : String[4];
    Quantity: integer;
    Price: Real;
  End;
  
  Type
    Sells = array[1..65532] of Sell;
  
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