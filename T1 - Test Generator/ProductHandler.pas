unit ProductHandler;

interface
  procedure DisplaySelectedProductMenu(option : integer; productFile : string);
  procedure ShowDeleteProduct;
  procedure ShowProductMenu(productFile : string);
  procedure ShowRegisterProduct;
  
implementation
  uses 
    ProductUtils,
    ProductConsultScreen;

  (*Show Main Menu of product functions.*)
  procedure ShowProductMenu(productFile : string);
  const
    consultProduct = 1;
    registerProduct = 2;
    deleteProduct = 3;
    returnToMainMenu = 4;
  var
    option : integer;
  begin  
    while option <> returnToMainMenu do
    begin    
      ClrScr;
      Writeln('------P R O D U T O S------');    
      Writeln('[1] Consultar produto.');
      Writeln('[2] Cadastrar novo produto.');
      Writeln('[3] Deletar produto.');
      Writeln('[4] Voltar ao menu principal.');
      Writeln('Digite a opção desejada: ');
      
      Readln(option);
      if (option < 1) or (option > 4) then
      begin
        ShowProductMenu(productFile);
      end
      else
      begin
          DisplaySelectedProductMenu(option, productFile);
      end;
    end;
  end;
  
  (*Receives number of selected option then displays menu*)
  procedure DisplaySelectedProductMenu(option : integer; productFile : string);
  const
    consult = 1;
    register = 2;
    deleteProduct = 3;
    return = 4;
  begin
    if option = consult then
    begin
      ShowConsultProduct(productFile)
    end
    
    else if option = register then
    begin
      ShowRegisterProduct
    end
    
    else if option = deleteProduct then
    begin
      ShowDeleteProduct
    end;
  end;
  
  (*Shows menu to register new product*)
  procedure ShowRegisterProduct;
  begin
    Writeln(' ');
  end;
  
  (*Shows menu to delete product*)
  procedure ShowDeleteProduct;
  begin
    Writeln(' ');
  end;
end.