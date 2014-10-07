Program TestGenerator ;
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
   
  function GetsProducts(filePath : String[255]) : Products;
    Begin
    End;
    
  function ParseProduct(productLine : String[255]) : Product;
    Begin      
    End; 
    
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

var
  teste : string[255];
  target : SplitedText;
  separatorChar : char;
  i : integer;
Begin 
End.