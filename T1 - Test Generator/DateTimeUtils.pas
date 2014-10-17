unit DateTimeUtils;

interface
  function RequestMonthNumber(message : string) : integer;  
  function GenerateRandomDay (month : integer) : integer;

implementation
  (*Request the number of month*)
  function RequestMonthNumber(message : string) : integer;
  var
    monthNumber : integer;
  begin
    repeat
      Write(message);
      Readln(monthNumber);
      
    until ((monthNumber > 1) and (monthNumber < 12)) or (monthNumber = 1) or (monthNumber = 12);
  end;
  
  (*Generate random day of the month*)
  function GenerateRandomDay (month : integer) : integer;
  var
    daysInMonth, year : integer;
  begin
    year := 2014;
    daysInMonth := 30;
    
    Randomize;
    GenerateRandomDay := Random(daysInMonth) + 1;
  end;
end.