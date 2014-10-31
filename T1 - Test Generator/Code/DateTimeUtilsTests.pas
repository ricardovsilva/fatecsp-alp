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

    expected := 5; //friday.

    actual := WeekDay(2014, 10, 31);

    WeekDayTest := AssertInteger(expected, actual, 'DateTimeUtilsTests.WeekDayTest');
  end;
end.
