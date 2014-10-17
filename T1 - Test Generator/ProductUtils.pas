unit ProductUtils;

interface
  uses StringUtils;
  Type
      Product = Record
      Code : String[4];
      Name : String[30];
      Price : Real;
  End;
  Type
    Products = array[1..255] of Product;
    
  function ParseProduct(productInfo : SplitedText) : Product;
  function GetsProductByCode(filePath : string; productCode : integer) : Product;
  function GetsProducts(filePath : String[255]) : Products;
  function LengthOfProducts(productArray : Products) : integer;
  function LineIsValid(line : String[255]): boolean;
  
  procedure PrintProduct(productToPrint : Product);
  procedure PrintProducts(productsArray : Products);
    
implementation
  uses StringUtils;

  (*Parse array of strings into Product struct*)  
  function ParseProduct(productInfo : SplitedText) : Product;
  var
    returnProduct : Product;
    codeIndex, nameIndex, priceIndex : integer;
  Begin
    codeIndex := 1;
    nameIndex := 2;
    priceIndex := 3;
    
    returnProduct.Code := productInfo[codeIndex];
    returnProduct.Name := productInfo[nameIndex];
    returnProduct.Price := StrToReal(productInfo[priceIndex]);
    
    ParseProduct := returnProduct;
  End;  
  
  (*Gets lines of products from file passed by parameter*) 
  function GetsProducts(filePath : String[255]) : Products;
  var
    productsVar : Products;
    counter : integer;
    line: string[255];
    separator: char;
    fileVar : Text;
  Begin
    counter := 1;
    separator := ';';
    
    Assign(fileVar, filePath);
    Reset(fileVar);
   
    while not EOF(fileVar) do
    begin
      Readln(fileVar, line);
      if LineIsValid(line) then
      begin
        productsVar[counter] := ParseProduct(Split(line, separator));
        counter := counter + 1;
      end
    end;
    
    Close(fileVar);
    GetsProducts := productsVar;
  End;
  
  (*Gets the length of products array*)
  function LengthOfProducts(productArray : Products) : integer;
  const
    maxSize = 255;
  var
    counter : integer;
  begin
    counter := 0;
    
    while not StringIsEmpty(productArray[counter + 1].Code) do
    begin
      counter := counter + 1;
    end;
    
    LengthOfProducts := counter;
  end;
  
  (*Verify if line is not an comment*)
  function LineIsValid(line : String[255]): boolean;
  Begin
    LineIsValid:= not StringIsEmpty(line) and not StringStartsWith(line, '#');
  end;
  
  (*Returns product from file searching by code*)
  function GetsProductByCode(filePath : string; productCode : integer) : Product;
  var
    productList : Products;
    i, productCount : integer;
    currentProductCode, c : integer;
  begin
    productList := GetsProducts(filePath);
    productCount := LengthOfProducts(productList);
    
    for i := 1 to productCount do
    begin
      Val(productList[i].Code, currentProductCode, c);
      
      if currentProductcode = productCode then
      begin
        GetsProductByCode := productList[i];
      end;
    end;    
  end;
  
  (*Print product passed by parameter*)
  procedure PrintProduct(productToPrint : Product);
  begin
    Writeln('Código: ', productToPrint.Code);
    Writeln('Descrição: ', productToPrint.Name);
    WriteLn('Preço: ', productToPrint.Price:6:2);
    WriteLn;
  end;
  
  (*Prints all products of array*)
  procedure PrintProducts(productsArray : Products);
  var
    i : integer;
  begin
    for i:= 1 to 15 do
    begin
      begin
        PrintProduct(productsArray[i]);
      end
    end
  end;
end.
