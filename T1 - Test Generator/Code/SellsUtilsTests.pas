unit SellsUtilsTests;
interface
  uses SellsUtils;
  
    function CalculateVerifierDigitTest:boolean;
  
implementation
  
    (* Test function CalculateVerifierDigit from
   * SellsUtils. This function returns a value
   * indicating whether test pass *)
  function CalculateVerifierDigitTest:boolean;
  var
    target, actual, expected : string;
    result : boolean;
  begin
    target := '1958';
    expected := '2';
    actual := CalculateVerifierDigit(target);
    
    result := actual = expected;
    
    if result = false then
    begin
      Writeln('Fail on SellsUtils.CalculateVerifierDigitTest: ');
      Writeln('    expected: ' + expected);
      Writeln('    actual: ' + actual);
    end
    else
      Writeln('OK - SellsUtils.CalculateVerifierDigitTest');
      
    CalculateVerifierDigitTest := result;      
  end;
  
end.