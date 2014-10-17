unit DateTimeUtils;

interface
  function IsMonth(number : integer) : boolean;
  function GenerateRandomDay (month : integer) : integer;
  function RequestMonthNumber(message : string) : integer;  

implementation
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