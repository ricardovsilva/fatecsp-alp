Program TestEngine ;
uses
  DateTimeUtilsTests,
  ProductUtilsTests,
  SellsUtilsTests,
  crt;
var
  c : string;
  result : boolean;
Begin
  clrscr;
  result := true;

  Writeln('------DateTimeUtilsTests------');
  result := WeekDayTest and result;

  Writeln('------ProductUtilsTests------');
  result := RemoveVerifierDigitTest;


  Writeln('-------SellsUtilsTests--------');
  result := CalculateVerifierDigitTest and result;
  result := SellToStringTest and result;
  result := StringToSellTest and result;

  c:= ReadKey;
End.
