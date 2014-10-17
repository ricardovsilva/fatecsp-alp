unit StringUtils;

interface 
Type
  SplitedText = array[1..255] of String[255];

function StrToReal (s: String): Real;
function Split(textToSplit : String[255]; separatorChar : char) : SplitedText;
function StringIsEmpty(textToVerify : String[255]) : boolean;
function StringStartsWith(stringToVerify: string[255]; startChar : char) : boolean;

implementation
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

(*Verify if string starts with given char*)
function StringStartsWith(stringToVerify: string[255]; startChar : char) : boolean;
begin
  StringStartsWith := stringToVerify[1] = startChar;
end;

end.