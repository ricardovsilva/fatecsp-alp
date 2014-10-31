unit ProductConsultScreen;
interface
  procedure ShowConsultProduct(productFile : string);
  procedure DisplaySelectedProductConsultMenu(option : integer; filePath : string);
  procedure DisplayByCode(filePath : string);
  procedure DisplayByName(filePath : string);
  procedure DisplayAll(filePath : string);
  
implementation
  uses
    StringUtils,
    ProductUtils;
    
  (*Shows menu to consult information about one product*)
  procedure ShowConsultProduct(productFile : string);
    var 
      productList : Products;
      option : integer;
  begin
    productList := GetsProducts(productFile);

    repeat
      ClrScr;  
      Writeln('------P R O D U T O S------'); 
      Writeln('------C O N S U L T A------');
      Writeln('Existem ', LengthOfProducts(productList), ' produtos cadastrados');
      Writeln('Como deseja consultar? ');
      Writeln('[1] Por código de produto');
      Writeln('[2] Por descrição');
      Writeln('[3] Listar todos');
      Writeln('[4] Voltar ao menu anterior');
      Readln(option);
      
      DisplaySelectedProductConsultMenu(option, productFile);
    until option = 4;
  end;
  
  (*Shows menu selected by user*)
  procedure DisplaySelectedProductConsultMenu(option : integer; filePath : string);
  const
    byCode = 1;
    byName = 2;
    listAll = 3;
  begin
    if option = byCode then
    begin
      DisplayByCode(filePath);
    end
    
    else if option = byName then
    begin
      DisplayByName(filePath);
    end
    
    else if option = listAll then
    begin
      DisplayAll(filePath);
    end;
  end;
  
  (*Display product by given code*)
  procedure DisplayByCode(filePath : string);
  var 
    productCode : integer;
    productFound : Product;
  begin
      Clrscr;
      Writeln('------P R O D U T O S------'); 
      Writeln('------C O N S U L T A------');
      Writeln('-----P O R  C Ó D I G O----');
      Writeln('Por favor, digite o código do produto: ');
      Readln(productCode);
      
      productFound := GetsProductByCode(filePath, productCode);
      if not StringIsEmpty(productFound.Code) then
      begin
        PrintProduct(productFound);
      end
      else
      begin
        Writeln('Produto não encontrado!');
      end;
      
      Writeln('Pressione qualquer tecla para continuar...');
      Readkey;
  end;
  
  (*Display product by given name*)
  procedure DisplayByName(filePath : string);
  var
    productName : string[30];
    currentProduct : Product;
  begin
    Clrscr;
    
    Writeln('------P R O D U T O S------'); 
    Writeln('------C O N S U L T A------');
    Writeln('------P O R  N O M E-------');
    Writeln('Por favor, digite o nome do produto: ');
    Readln(productName);
    
    currentProduct := GetsProductByName(filePath, productName);
    if not StringIsEmpty(currentProduct.Name) then
      PrintProduct(currentProduct)
    else
      Writeln('Produto não encontrado!');
      
    Writeln('Pressione qualquer tecla para continuar...');
    Readkey;    
  end;

  (*Display all products*)  
  procedure DisplayAll(filePath : string);
  begin
    clrscr;
    Writeln('------P R O D U T O S------'); 
    Writeln('------C O N S U L T A------');
    Writeln('---------T O D O S---------');
    PrintProducts(GetsProducts(filePath));
    
    Writeln('Pressione qualquer tecla para continuar...');
    Readkey;
  end;
end.