unit ProductRegisterScreen;
interface

  procedure ShowProductRegisterScreen(productFile : string);
  
implementation
  uses 
    ProductUtils,
    InputUtils;

  (*Shows screen to register new product*)  
  procedure ShowProductRegisterScreen(productFile: string);
  var
    newProduct : Product;
  begin
    ClrScr;
  
    Writeln('------P R O D U T O S------');  
    Writeln('------R E G I S T R O------');
    
    newProduct.Code := GetsIntegerAsString('Por favor, digite o código do produto (entre 1100 e 1199): ', 1100, 1199);
    
    Writeln('Digite o nome do produto (maximo de 30 caracters): ');
    Readln(newProduct.Name);
    
    Write('Digite o valor do produto (para decimo use ponto - . ): ');
    Readln(newProduct.Price);
    
    if AddNewProduct(productFile, newProduct) then
    begin
      Writeln('Produto inserido com sucesso!');
    end
    
    else
    begin
      Writeln('A T E N Ç Ã O - O produto não foi cadastrado ');
      Writeln('                pois já existe outro produto ');
      Writeln('                com o mesmo código cadastrado.');
    end;
    
    Writeln('Pressione qualquer tecla para continuar...');
    Readkey;
  end;
end.