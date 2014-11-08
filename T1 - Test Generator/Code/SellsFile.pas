unit SellsFile;
interface
	uses
		ProductUtils;

	function GetsTotalSellsByDate(year, month, day : integer; sellsFilePath : string) : Real;

	function GetsTotalSellsByProduct(productCode : integer; sellsFilePath : string) : Real;

	function GetsQuantityOfSelledProduct(sellsFilePath : string) : integer;

	function GetsTotalSelled(sellsFilePath : string) : Real;

implementation

	(*Its function receives date and gets total sells to that date
	 * The parameters are:
	 *   year - year of date to gets total of sells
	 *   month - month of date to gets total of sells
	 *   day - day of date to gets total of sells
	 *   sellsFilePath - path of file with sells *)
	function GetsTotalSellsByDate(year, month, day : integer; sellsFilePath : string) : Real;
	begin
		Writeln('Funcao GetsTotalSellsByDate nao esta implementada ainda.')
	end;

	(*Its function receives one product code, and returns the sum of sells
	 *of its product *)
	function GetsTotalSellsByProduct(productCode : integer; sellsFilePath : string) : Real;
	begin
		Writeln('Funcao GetsTotalSellsByProduct nao esta implementada ainda.')
	end;

	(*This function gets the sum of all product quantities.*)
	function GetsQuantityOfSelledProduct(sellsFilePath : string) : integer;
	begin
		Writeln('Funcao GetsQuantityOfSelledProducts nao foi implementada ainda');
	end;

	(*This function gets the sum of all sells. It's must multiply quantity by unit price*)
	function GetsTotalSelled(sellsFilePath : string) : Real;
	begin
		Writeln('Funcao GetsTotalSelled nao implementada ainda.')
	end;
end.
