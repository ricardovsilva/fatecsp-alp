unit TestUtils;
interface
  function AssertString(expected, actual, functionName : string) : boolean;
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
    end;
    
    AssertString := result;
  end;
end.
