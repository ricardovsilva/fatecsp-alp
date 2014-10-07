Program TestGenerator ;

  Uses SysUtils;

  Type
      Product = Record
      Code : String[4];
      Name : String[30];
      Price : Real;
  End;
  
  Type
    Products = array[1..15] of Product;
  
  Type
    SplitedText = array[1..255] of String[255];
  
  (*Gets lines of products from file passed by parameter*) 
  function GetsProducts(filePath : String[255]) : Products;
    Begin
    End;
  
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
      returnProduct.Price := StrToFloat(productInfo[priceIndex]);
      
      ParseProduct := returnProduct;
    End; 
  
  (*Split text passed by parameter using separator char to do split.*)
  function Split(textToSplit : String[255]; separatorChar : char) : SplitedText;
  var
    i, offset, counter : integer;
    returnArray : SplitedText;
    breakedText : string[255];
  Begin
    counter := 1;
    offset := 1;
    for i:= 1 to Length(textToSplit) do
    begin
      if textToSplit[i] = separatorChar then
      begin
        breakedText := copy(textToSplit, offset, i - offset);
        offset := offset + length(breakedText) + 1;
        if length(breakedText) > 0 then
        begin
          returnArray[counter] := breakedText;
          counter := counter + 1;
        end
      end
    end;
      
    Split := returnArray;
  End;
  
  (*Verify if string passed by parameter contains only empty chars*)
  function StringIsEmpty(textToVerify : String[255]) : boolean;
  var
    returnValue : boolean;
    i, emptyChar : integer;
  Begin
    emptyChar := 0;
    returnValue := true;
    
    for i:= 1 to length(textToVerify) do
    begin
      returnValue := returnValue and (ord(textToVerify[i]) = emptyChar);
    end;
    
    StringIsEmpty := returnValue;
  end;

  (*Converts string to real. This function was copied from 
  http://professorwellingtontelles.blogspot.com.br/2011/06/converter-string-em-real-em-pascal.html
  at 2014-10-07*)
  function StrToReal (s: String): Real;  
  var  
    r : Real;  
    p : Integer;  
  begin  
    Val (s,r,p);  
    if p > 0 then Val (copy(s,1,p-1),r,p);  
      StrToReal := r;  
  end; 

var
  textSplited : SplitedText;
  separatorChar : char;
  target : Product;
  originalText : String[255];
Begin 
  originalText := '1019;Lapiseira Pentel 0.5mm;15.20;';
  separatorChar := ';';
  
  textSplited := Split(originalText, separatorChar);
  target := ParseProduct(textSplited);
  
  WriteLn('Code: ' + textSplited.Code);
  WriteLn('Description: ' + textSplited.Name);
  WriteLn('Price: ' + textSplited.Price);
  
  Readln;
End.