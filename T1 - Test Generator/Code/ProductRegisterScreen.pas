unit ProductRegisterScreen;
interface

  procedure ShowProductRegisterScreen(productFile : string);
  function GetsProductCode(message : string; min, max : integer) : string;
  
implementation
  uses ProductUtils;

  (*Shows screen to register new product*)  
  procedure ShowProductRegisterScreen(productFile: string);
  var
    newProduct : Product;
  begin
    ClrScr;
  
    Writeln('------P R O D U T O S------');  
    Writeln('------R E G I S T R O------');
    
    newProduct.Code := GetsProductCode('Por favor, digite o código do produto (entre 1100 e 1199): ', 1100, 1199);
    
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
  
  (* This function asks user to input product code. And only returns the product code when it was between
   * min and max. Parameters are: * 
   * message - Is the message that will be displayed to user asking for product code.
   * min - minimum value of code.
   * max - maximum value of code. *)
  function GetsProductCode(message : string; min, max : integer) : string;
    var 
      input : integer;
      output : string;
  begin
    repeat
      ClrScr;
      Writeln('------P R O D U T O S------');  
      Writeln('------R E G I S T R O------');
      Writeln(message);
      Readln(input);
    until (input > min) and (input < max);
    
    str(input, output);
    GetsProductCode := output;
  end;

end.