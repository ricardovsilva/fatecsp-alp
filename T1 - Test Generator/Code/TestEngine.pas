Program TestEngine ;
uses
  SellsUtilsTests;
var
  result : boolean;
Begin
  Writeln('------SellsUtilsTests------');
  result := CalculateVerifierDigitTest;
  result := result and SellToStringTest;
  Readkey;
End.