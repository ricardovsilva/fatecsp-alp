unit ProductHandler;

interface
  uses 
    ProductUtils;
  procedure DisplaySelectedMenu(option : integer);
  procedure ShowConsultProduct;
  procedure ShowDeleteProduct;
  procedure ShowProductMenu;
  procedure ShowRegisterProduct;
  
implementation

  (*Show Main Menu of product functions.*)
  procedure ShowProductMenu;
  var
    option : integer;
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
        ShowProductMenu;
      end  
    else
      begin
        DisplaySelectedMenu(option);
      end
  end;
  
  (*Receives number of selected option then displays menu*)
  procedure DisplaySelectedMenu(option : integer);
  const
    consult = 1;
    register = 2;
    deleteProduct = 3;
    return = 4;
  begin
    if option = consult then
      ShowConsultProduct
    else if option = register then
      ShowRegisterProduct
    else if option = deleteProduct then
      ShowDeleteProduct
  end;
  
  (*Shows menu to consult information about one product*)
  procedure ShowConsultProduct;
  begin
  
  end;
  
  (*Shows menu to register new product*)
  procedure ShowRegisterProduct;
  begin
  
  end;
  
  (*Shows menu to delete product*)
  procedure ShowDeleteProduct;
  begin
    
  end;
end.