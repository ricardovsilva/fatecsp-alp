Program TestEngine ;
uses
  DateTimeUtilsTests,
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

  Writeln('-------SellsUtilsTests--------');
  result := CalculateVerifierDigitTest and result;
  result := SellToStringTest and result;

  c:= ReadKey;
End.
