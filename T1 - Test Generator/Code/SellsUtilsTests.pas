unit SellsUtilsTests;
interface
  uses 
    SellsUtils;
    
  function CalculateVerifierDigitTest:boolean;
  function SellToStringTest:boolean;
  
implementation
  uses 
    ProductUtils,
    TestUtils,
    SellsUtils;
  
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
    
    result := AssertString(expected, actual, 'SellsUtilsTests.CalculateVerifierDigitTest');
        
    CalculateVerifierDigitTest := result;      
  end;
  
  function SellToStringTest:boolean;
  var
    target : Sell;
    targetProduct : Product;
    actual, expected : string;
  begin
    targetProduct.Code := '1958';
    targetProduct.Name := 'Caneta pentel';
    targetProduct.Price := 35.20;
  
    target.DateTime := '2014-08-27';
    target.Quantity := 39;
    target.Product := targetProduct;
    
    expected := '1958-2;2014-08-27;39;35.20';
    
    actual := SellToString(target);
    
    SellToStringTest := AssertString(expected, actual, 'SellsUtilsTests.SellToStringTest');
  end;
end.