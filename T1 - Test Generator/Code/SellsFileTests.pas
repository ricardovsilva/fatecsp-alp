unit SellsFileTests;
interface
  uses
    SellsUtils,
    SellsFile;

  function GetsTotalSellsByDateTest : Boolean;
  function GetsTotalSelledTest : Boolean;
  function GetsTotalSellsByProductTest : Boolean;

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

    function GetsTotalSelledTest : Boolean;
    var
      target: string;
      expected, actual : real;
    begin
      target := 'VendasTest.txt';
      expected := 1566084.63;

      actual := GetsTotalSelled(target);

      GetsTotalSelledTest := AssertReal(expected, actual, 'SellsFileTests.GetsTotalSelledTest');
    end;

    function GetsTotalSellsByProductTest : Boolean;
    var
      target, targetCode: string;
      expected, actual : real;
    begin
      target := 'VendasTest.txt';
      targetCode := '6415';

      expected := 788.16;
      actual := GetsTotalSellsByProduct(targetCode, target);

      GetsTotalSellsByProductTest := AssertReal(expected, actual, 'SellsFileTests.GetsTotalSellsByProductTest');
    end;
end.
