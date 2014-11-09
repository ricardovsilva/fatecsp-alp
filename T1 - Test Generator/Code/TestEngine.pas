Program TestEngine ;
uses
  DateTimeUtilsTests,
  ProductUtilsTests,
  SellsUtilsTests,
  SellsFileTests,
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
  result := RemoveVerifierDigitTest and result;

  Writeln('--------SellsFileTests--------');
  result := GetsTotalSellsByDateTest and result;

  Writeln('-------SellsUtilsTests--------');
  result := CalculateVerifierDigitTest and result;
  result := SellToStringTest and result;
  result := StringToSellTest and result;

  c:= ReadKey;
End.
