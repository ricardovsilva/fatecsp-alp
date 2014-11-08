unit MainMenu;
interface
  procedure DisplaySelectedMenu(productsPath : string; sellsPath: string; selectedOption : integer);
  procedure ShowMainMenu(productsPath : string; sellsPath : string);

implementation
uses
  ProductHandler,
  AboutScreen,
  SellsScreen,
  StatisticsScreen,
  crt;
  (* Show main menu. The parameters are:
   * productsPath - The path to products file.
   * sellsPath - The path to file where sells will be generated. *)
  procedure ShowMainMenu(productsPath : string; sellsPath : string);
  const
    quit = 5;
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
      Writeln('[3] Gerar Estatisticas');
      Writeln('[4] Sobre este programa');
      Writeln('[5] Sair');
      Writeln('');
      Write('Digite a opção desejada: ');
      Readln(option);

      if (option < 1) or (option > 5) then
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
    statistics = 3;
    about = 4;
  begin
    if selectedOption = product then
    begin
      ShowProductMenu(productsPath);
    end

    else if selectedOption = sells then
    begin
      ShowSellsScreen(sellsPath, productsPath);
    end

    else if selectedOption = statistics then
    begin
      ShowStatisticsScreen(sellsPath, productsPath);
    end

    else if selectedOption = about then
    begin
      ShowAboutMenu;
    end;

  end;
end.
