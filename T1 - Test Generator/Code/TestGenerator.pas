Program TestGenerator ;
  uses 
    ProductHandler,
    StringUtils,
    Realutils,
    RandomUtils,
    DateTimeUtils,
    ProductUtils,
    SellsUtils,
    MainMenu; 
    
var
  filePath, sellsPath : String[20];
  tempSell : Sell;
  tempProduct : Product;
  i : integer;
Begin
  filePath := 'Produtos.txt';
  sellsPath := 'Vendas.txt';
   
  ShowMainMenu(filePath, sellsPath);
  Clrscr;
  Writeln('Obrigado por utilizar o gerador automatico de testes...');
  Readkey;
End.