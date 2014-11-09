unit SellsFileTests;
interface
  uses
    SellsUtils,
    SellsFile;

  function GetsTotalSellsByDateTest : Boolean; 

implementation
  uses
    ProductUtils,
    TestUtils;

    function GetsTotalSellsByDateTest : Boolean;	
    var
      target: string;
      expected, actual : real;
      year, month, day : integer;
    begin
      target := 'VendasTest.txt';
      year := 2012;
      month := 02;
      day := 01;

      expected := 49506.03;
      actual := GetsTotalSellsByDate(year, month, day, target);

      GetsTotalSellsByDateTest := AssertReal(expected, actual, 'SellsFileTests.GetsTotalSellsByDate');
    end;
end.
