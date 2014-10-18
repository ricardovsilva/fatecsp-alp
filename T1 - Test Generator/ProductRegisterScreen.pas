unit ProductRegisterScreen;
interface

  procedure ShowProductRegisterScreen(productFile : string);
  
implementation
  uses Produ ctUtils;

  (*Shows screen to register new product*)  
  procedure ShowProductRegisterScreen(productFile: string);
  var
    newProduct : Product;
  begin
    Writeln('------P R O D U T O S------');  
    Writeln('------R E G I S T R O------');
    
    Write('Digite o código do produto: ');
    Readln(newProduct.Code);
    
    Writeln('Digite o nome do produto (maximo de 30 caracters): ');
    Readln(newProduct.Name);
    
    Write('Digite o valor do produto (para decimo use ponto - . ): ');
    Readln(newProduct.Price);
  end;
end.