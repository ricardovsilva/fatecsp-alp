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
      Writeln('[2] Por nome');
      Writeln('[3] Listar todos');
      Writeln('[4] Voltar ao menu anterior');
      Readln(option);
      
      DisplaySelectedProductConsultMenu(option, productFile);
    until (option > 0) and (option < 5) and not (option = 4);
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
      
      Writeln('Pressione qualquer tecla para continuar');
      Readkey;
  end;
  
  (*Display product by given name*)
  procedure DisplayByName(filePath : string);
  begin
  end;

  (*Display all products*)  
  procedure DisplayAll(filePath : string);
  begin
  end;
end.