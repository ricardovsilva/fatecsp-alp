unit DateTimeUtilsTests;
interface
uses
  DateTimeUtils;

  function WeekDayTest:boolean;

implementation
uses
  TestUtils;

  function WeekDayTest:boolean;
  var
    expected, actual : integer;
    target : DateTime;
  begin
    target.year := 2014;
    target.month := 10;
    target.day := 31;

    expected := 6; //friday.

    actual := WeekDay(target.year, target.month, target.day);

    WeekDayTest := AssertInteger(expected, actual, 'DateTimeUtilsTests.WeekDayTest');
  end;
end.
