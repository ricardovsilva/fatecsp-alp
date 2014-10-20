unit MainMenu;
interface
  procedure DisplaySelectedMenu(productsPath : string; sellsPath: string; selectedOption : integer);
  procedure ShowMainMenu(productsPath : string; sellsPath : string);

implementation
uses
  ProductHandler,
  AboutScreen,
  SellsScreen;
  (* Show main menu. The parameters are:
   * productsPath - The path to products file.
   * sellsPath - The path to file where sells will be generated. *)
  procedure ShowMainMenu(productsPath : string; sellsPath : string);
  const
    quit = 4;
  var
    option : integer;
  begin
    option := 0;
    
    while option <> quit do
    begin    
      Clrscr;
      Writeln('----------M E N U----------');
      Writeln('[1] Menu de Produtos');
      Writeln('[2] Menu de Vendas');
      Writeln('[3] Sobre este programa');
      Writeln('[4] Sair');
      Writeln('');
      Write('Digite a opção desejada: ');
      Readln(option);
      
      if (option < 1) or (option > 4) then
      begin
        ShowMainMenu(productsPath, sellsPath);
      end
      
      else
      begin
        DisplaySelectedMenu(productsPath, sellsPath, option);
      end;
    end;
  end;
  
  procedure DisplaySelectedMenu(productsPath : string; sellsPath: string; selectedOption : integer);
  const
    product = 1;
    sells = 2;
    about = 3;
  begin
    if selectedOption = product then
    begin
      ShowProductMenu(productsPath);
    end
    
    else if selectedOption = sells then
    begin
      ShowSellsScreen(sellsPath, productsPath);
    end
    
    else if selectedOption = about then
    begin
      ShowAboutMenu;
    end;
    
  end;
end.