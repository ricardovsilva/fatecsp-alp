unit DateTimeUtils;

interface
  function IsLeapYear(year : integer) : boolean;
  function IsMonth(number : integer) : boolean;
  function GenerateRandomDay (month : integer; year: integer) : integer;
  function GetsDateTime(year : integer; month : integer; day : integer) : string;
  function GetsQuantityOfDays(month : integer; year : integer) : integer;
  function RequestMonthNumber(message : string) : integer;  

implementation
  uses
    StringUtils;
  const
    janDays = 31;
    febDays = 28;
    marDays = 31;
    aprDays = 30;
    mayDays = 31;
    junDays = 30;
    julDays = 31;
    augDays = 31;
    sepDays = 30;
    octDays = 31;
    novDays = 30;
    decDays = 31;

  (*Gets number of days of given month. If month is not valid
  function will return 0*)
  function GetsQuantityOfDays(month : integer; year : integer) : integer;
  var
    months : array[1..12] of integer;
    days : integer;
  begin
    if not IsMonth(month) then
    begin
      GetsQuantityOfDays := 0;
    end
    else
    begin
      months[1] := janDays;
      months[2] := febDays;
      months[3] := marDays;
      months[4] := aprDays;
      months[5] := mayDays;
      months[6] := junDays;
      months[7] := julDays;     
      months[8] := augDays;   
      months[9] := sepDays;    
      months[10] := octDays;
      months[11] := novDays;
      months[12] := decDays;
      
      days := months[month];
      
      if IsLeapYear(year) and (month = 2) then
        days := days + 1;
    end;
    
    GetsQuantityOfDays := days;
  end;
  
  (*Verify if given year is leap year*)
  function IsLeapYear(year : integer) : boolean;
  begin
    IsLeapYear := (year mod 4) = 0;
  end;
  
  (*Verify if given number is month number*)  
  function IsMonth(number : integer) : boolean;
  begin
    IsMonth := ((number > 1) and (number < 12)) or (number = 1) or (number = 12);
  end;
  
  (*Request the number of month*)
  function RequestMonthNumber(message : string) : integer;
  var
    monthNumber : integer;
  begin
    repeat
      Write(message);
      Readln(monthNumber);
      
    until IsMonth(monthNumber);
  end;
  
  (*Generate random day of the month*)
  function GenerateRandomDay (month : integer; year: integer) : integer;
  var
    daysInMonth : integer;
  begin
    daysInMonth := GetsQuantityOfDays(month, year);
    
    Randomize;
    GenerateRandomDay := Random(daysInMonth) + 1;
  end;
  
  (*Receives year, month and day and returns string formated yyyy-mm-dd*)
  function GetsDateTime(year : integer; month : integer; day : integer) : string;
  var
    y, m, d : string;
  begin
    str(year, y);
    str(month, m);
    str(day, d);
   
    m:= AddPadLeft(m, '0', 2);
    d:= AddPadLeft(d, '0', 2);
    
    GetsDateTime := concat(y,'-',m,'-',d);
  end;
end.