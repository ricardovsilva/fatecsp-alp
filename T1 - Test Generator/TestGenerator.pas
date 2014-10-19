Program TestGenerator ;
  uses 
    DateTimeUtils,
    ProductHandler,
    ProductUtils,
    SellUtils,
    StringUtils,
    Realutils;
  
  (*Requests to user quantity of random sells that will be generated*)
  function RequestQuantityOfSells : integer;
  var
    quantity : integer;
  Begin
    Write('Digite a quantidade de vendas a serem geradas aleatoriamente: ');
    Readln(quantity);
    
    RequestQuantityOfSells := quantity;
  End;
  
  (*Generate sellsQuantity random sells into monthNumber month of year 2014*)
  function GenerateRandomSells(sellsQuantity, monthNumber : integer; productsList : products) : Sells;
  const
    year = 2014;
  var
    i, randomDay : integer;
  begin
    for i:= 0 to sellsQuantity do
    begin
      Writeln(GenerateRandomDay(monthNumber, year));      
    end; 
  end;

const
  testMode = false;
var
  r : real;
  s : string[20];
  
  sellsVar : Sells;
  filePath : String[20];
  productsList : Products;
  sellsQuantity, monthNumber : integer;
Begin
  filePath := 'Produtos.txt';
  
  if not testMode then
  begin
    ShowProductMenu(filePath);  
    productsList := GetsProducts(filePath);   
    sellsQuantity := RequestQuantityOfSells;
    monthNumber := RequestMonthNumber('Digite o mês para gerar as vendas');
    
    sellsVar := GenerateRandomSells(sellsQuantity, monthNumber, productsList);
  end
  
  else
  begin
    r := 1234.50;
     
  end;
    s:= RealToStr(r, 2);
    Writeln(s);
    Readkey;
  Readln;
End.