unit SellsFile;
interface
	uses
		DateTimeUtils,
		ProductUtils,
		SellsUtils;

	function GetsTotalSellsByDate(year, month, day : integer; sellsFilePath : string) : Real;

	function GetsTotalSellsByProduct(productCode : string; sellsFilePath : string) : Real;

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
	var
		fileVar: Text;
		currentSell : Sell;
		currentLine, dateToSearch : string;
		totalSelled : Real;
	begin
		totalSelled := 0;
		dateToSearch := GetsDateTime(year, month, day);

		Assign(fileVar, sellsFilePath);
    Reset(fileVar);

    while not EOF(fileVar) do
    begin
    	Readln(fileVar, currentLine);
    	currentSell := StringToSell(currentLine);

    	if currentSell.DateTime = dateToSearch then
    		totalSelled := totalSelled + (currentSell.Price);
    end;

    Close(fileVar);
    
    GetsTotalSellsByDate := totalSelled;
	end;

	(*Its function receives one product code, and returns the sum of sells
	 *of its product *)
	function GetsTotalSellsByProduct(productCode : string; sellsFilePath : string) : Real;
	var
		fileVar: Text;
		currentSell : Sell;
		currentLine, currentCode : string;
		totalSelled : Real;
	begin
		totalSelled := 0;

		Assign(fileVar, sellsFilePath);
		Reset(fileVar);

		while not EOF(fileVar) do
		begin
			Readln(fileVar, currentLine);
			currentSell := StringToSell(currentLine);
			currentCode := RemoveVerifierDigit(currentSell.Product.code);

			if currentCode = productCode then
			begin
				totalSelled := totalSelled + currentSell.Price;
			end;
		end;

		GetsTotalSellsByProduct := totalSelled;
	end;

	(*This function gets the sum of all product quantities.*)
	function GetsQuantityOfSelledProduct(sellsFilePath : string) : integer;
	begin
		Writeln('Funcao GetsQuantityOfSelledProducts nao foi implementada ainda');
	end;

	(*This function gets the sum of all sells. It's must multiply quantity by unit price*)
	function GetsTotalSelled(sellsFilePath : string) : Real;
	var
		fileVar: Text;
		currentSell : Sell;
		currentLine : string;
		totalSelled : Real;
	begin
		totalSelled := 0;

		Assign(fileVar, sellsFilePath);
		Reset(fileVar);

		while not EOF(fileVar) do
		begin
			Readln(fileVar, currentLine);
			currentSell := StringToSell(currentLine);

			totalSelled := totalSelled + currentSell.Price;
		end;

		Close(fileVar);
		GetsTotalSelled := totalSelled;
	end;
end.
