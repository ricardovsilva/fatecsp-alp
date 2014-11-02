unit DateTimeUtils;

interface
  function IsLeapYear(year : integer) : boolean;
  function IsMonth(number : integer) : boolean;
  function GenerateRandomDay (month : integer; year: integer) : integer;
  function GetsDateTime(year : integer; month : integer; day : integer) : string;
  function GetsQuantityOfDays(month : integer; year : integer) : integer;
  function RequestMonthNumber(message : string) : integer;
  function WeekDay ( Day, Month, Year : Integer ) : Integer;
  function IsWorkingDay(year, month, day : integer) : boolean;

  Type
    DateTime = record
      year : integer;
      month : integer;
      day : integer;
  end;

implementation
  uses
    StringUtils, sysutils;
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

  (*Receives year, month and day and returns the weekday.
    This function was get from
    http://computer-programming-forum.com/29-pascal/aa194b47b3e9a518.htm
    at 2014-10-31*)
  function WeekDay ( Day, Month, Year : Integer ) : Integer;
    function FirstThursday (Year: Integer) : Integer;
    begin
      FirstThursday := 7 - (1 + (Year-1600) + (Year-1597) div 4
      - (Year-1501) div 100 + (Year-1201) div 400) mod 7;
    end; (* FirstThursday *)
    function DayNumber (Day, Month, Year : Integer) : Integer;
    var
      ordNumber : integer;
      ordIsTrue : boolean;
    const DaysBeforeMonth : array [1..12] of Integer =
          (0,31,59,90,120,151,181,212,243,273,304,334);
    begin
      ordIsTrue := (Month > 2) and
        (Year mod 4 = 0) and ((Year mod 100 <> 0) or
        (Year mod 400 = 0));
      if(ordIsTrue) then ordNumber := 0 else ordNumber :=1;
      DayNumber := DaysBeforeMonth[Month] + Day +  ordNumber;
    end; (* DayNumber *)
  begin
    WeekDay:=(7+DayNumber(Day,Month,Year)-FirstThursday(Year)+3) mod 7;
  end; (* WeekDay *)
  {}
  function WeekDayString (Day, Month, Year : Integer) : String;
  const DayStr = 'MonTueWedThuFriSatSun';
  begin
    WeekDayString := Copy (DayStr, 3*WeekDay(Day,Month,Year)+1, 3);
  end;

  function IsWorkingDay(year, month, day : integer) : boolean;
    var
      date : TDateTime;
    begin
      date := EncodeDate(year, month, day);
      IsWorkingDay := date <> 1;
    end;
end.
