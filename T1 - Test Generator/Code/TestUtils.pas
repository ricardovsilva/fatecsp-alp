unit TestUtils;
interface
  function AssertString(expected, actual, functionName : string) : boolean;
  function AssertInteger(expected, actual : integer; functionName : string) : boolean;
  function AssertReal(expected, actual : real; functionName : string) : boolean;
  
implementation
  
  function AssertString(expected, actual, functionName : string) : boolean;
  var
    result : boolean;
  begin
    result := expected = actual;
    if result then
      Writeln('OK - ', functionName)
    else
    begin
      Writeln('FAILED - ', functionName);
      Writeln('         expected: ', expected);
      Writeln('         actual:   ', actual);
      Writeln;
    end;
    
    AssertString := result;
  end;
  
  function AssertInteger(expected, actual : integer; functionName : string) : boolean;
  var
    expectedString, actualString : string;
  begin
    str(expected, expectedString);
    str(actual, actualString);
    
    AssertInteger := AssertString(expectedString, actualString, functionName);
  end;
  
  function AssertReal(expected, actual : real; functionName : string) : boolean;
  var
    expectedString, actualString : string;
  begin
    str(expected, expectedString);
    str(actual, actualString);
    
    AssertReal := AssertString(expectedString, actualString, functionName);
  end;
end.
