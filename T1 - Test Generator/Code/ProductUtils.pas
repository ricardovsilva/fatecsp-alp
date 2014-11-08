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

  function AddNewProduct(filePath : string; newProduct : Product) : boolean;
  function GetsProducts(filePath : String) : Products;
  function GetsProductByCode(filePath : string; productCode : integer) : Product;
  function GetsProductByName(filePath : string; productName : string) : Product;
  function GetsRandomProduct(filePath: string ; productArray : Products) : Product;
  function LengthOfProducts(productArray : Products) : integer;
  function LineIsValid(line : String): boolean;
  function ParseProduct(productInfo : SplitedText) : Product;
  function ProductExists(productFile: string; productInfo : Product) : boolean;
  function ProductToString(productToParse : Product) : string;
  function RemoveVerifierDigit(code : string) : string;

  procedure PrintProduct(productToPrint : Product);
  procedure PrintProducts(productsArray : Products);

implementation
  uses
    RealUtils;

  (*Adds new product to file and returns a value indicating
   * that product was successfully added.
   * Parameters are:
   *    newProduct - Product to add.
   *    filePath - Path of file to add product.
   * Product will not added when other product with same code
   * already exists into file. *)
  function AddNewProduct(filePath : string; newProduct : Product) : boolean;
  var
    productFile : Text;
  begin
    if ProductExists(filePath, newProduct) then
    begin
      AddNewProduct := false;
    end

    else
    begin
      Assign(productFile, filePath);
      Append(productFile);
      Writeln(productFile, ProductToString(newProduct));
      Close(productFile);
      AddNewProduct := true;
    end;
  end;

  (* Verifies if other product with same code already exists into file
  * passed by parameter.
  * Parameters are:
  *    productFile - File to search by product.
  *    productInfo - Product that will be searched.
  * It returns a value indicating whether product exists into file. *)
  function ProductExists(productFile: string; productInfo : Product) : boolean;
  var
    searchedProduct : Product;
  begin
    searchedProduct := GetsProductByCode(productFile, StrToInteger(productInfo.Code));
    ProductExists := not StringIsEmpty(searchedProduct.Code);
  end;

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
  function GetsProducts(filePath : String) : Products;
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
      end;

    end;
    Close(fileVar);
    GetsProducts := productsVar;
  End;

  (*Retrieves random product from given file*)
  function GetsRandomProduct(filePath: string; productArray : Products) : Product;
  var
    productList : Products;
    quantity : integer;
    index : integer;
  begin
    productList := productArray;
    quantity := LengthOfProducts(productList);
    //Randomize;
    index := Random(quantity) + 1;

    GetsRandomProduct := productList[index];
  end;

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
  function LineIsValid(line : String): boolean;
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

  (*Returns product from file searching by description*)
  function GetsProductByName(filePath : string; productName : string) : Product;
  var
    productList : Products;
    i, productCount : integer;
    currentProduct : Product;
  begin
    productList := GetsProducts(filePath);
    productCount := LengthOfProducts(productList);

    for i := 1 to productCount do
    begin
      if productList[i].Name = productName then
        GetsProductByName := productList[i];
    end
  end;

  (*Receive product and returns string representation
   *of product file. code;name;price *)
  function ProductToString(productToParse : Product) : string;
  const
    codeLength = 4;
    decimalLength = 2;
  var
    returnText : string[255];
    price : string[10];
  begin
    price := RealToStr(productToParse.Price, decimalLength);

    returnText := productToParse.Code + ';';
    returnText := returnText + productToParse.Name + ';';
    returnText := returnText + price + ';';

    ProductToString := returnText;
  end;

  (*Receives one code with verifier digit and returns it without verifier digit*
   *Example: *
   *Input: '1234-5'
   *Output: '1234' *)
  function RemoveVerifierDigit(code : string) : string;
  const
    index = 1;
    count = 4;
  begin
    RemoveVerifierDigit := Copy(code, index, count);
  end;

  (*Print product passed by parameter*)
  procedure PrintProduct(productToPrint : Product);
  begin
    Writeln('C�digo: ', productToPrint.Code);
    Writeln('Descri��o: ', productToPrint.Name);
    WriteLn('Pre�o: ', productToPrint.Price:6:2);
    WriteLn;
  end;

  (*Prints all products of array*)
  procedure PrintProducts(productsArray : Products);
  var
    i : integer;
  begin
    for i:= 1 to LengthOfProducts(productsArray) do
    begin
      begin
        PrintProduct(productsArray[i]);
      end
    end
  end;
end.