unit StatisticsFile;
interface
	procedure GenerateTotalSellsPerDay(statisticsFile, sellsFile : string);
	procedure GenerateTotalSellsPerProduct(statisticsPath, sellsPath, productsPath : string);
	procedure GenerateTotalAndStatisticsOfMonth(statisticsPath, sellsPath, productsPath : string);
	procedure GenerateMediumOfSells(statisticsPath, sellsPath, productsPath : string);
	procedure GenerateTotalOfProductsSelled(statisticsPath, sellsPath : string);
	procedure GenerateMediumPerSell(statisticsPath, sellsPath : string);
	procedure GenerateMediumPerProduct(statisticsPath, sellsPath, productPath : string);
    procedure ClearStatisticsFile(statisticsPath: string);
	
implementation
	uses
	 SellsUtils,
	 SellsFile,
	 ProductUtils,
	 StringUtils,
	 DateTimeUtils,
	 sysUtils,
	 strUtils,
	 RealUtils;

	procedure GenerateTotalSellsPerDay(statisticsFile, sellsFile : string);
	const
		HEADER = 'TOTAIS DE VENDAS POR DIA:';
		decimalPlaces = 2;
	var
		currentDate, lastDate, currentLine, textToWrite: string;
		currentSell : Sell;
		sellsFileVar, statisticsFileVar : Text;
		yy, mm, dd, monthDays : integer;
		dateSplited : SplitedText;
		currentTotal : Real;
	begin
		Assign(sellsFileVar, sellsFile);
		Reset(sellsFileVar);

		Readln(sellsFileVar, currentLine);
		currentSell := StringToSell(currentLine);
		currentDate := currentSell.DateTime;

		val(copy(currentDate, 1,4), yy);
		val(copy(currentDate, 6,2), mm);

		Close(sellsFileVar);

		monthDays := GetsQuantityOfDays(mm, yy);

		Assign(statisticsFileVar, statisticsFile);
		Append(statisticsFileVar);

		Writeln(statisticsFileVar, HEADER);
		for dd := 1 to monthDays do
		begin
			if(IsWorkingDay(yy, mm, dd)) then
			begin
				currentTotal := GetsTotalSellsByDate(yy, mm, dd, sellsFile);
				textToWrite := Concat(AddChar('0',IntToStr(dd), 2), '/', AddChar('0', IntToStr(mm), 2), '/', IntToStr(yy),'    ', FloatToStrF(currentTotal, fffixed, 12, 2));
				textToWrite := StringReplace(textToWrite, '.', ',', [rfReplaceAll, rfIgnoreCase]);
				Writeln(statisticsFileVar, textToWrite);
			end;		
		end;

		Close(statisticsFileVar);
	end;

	procedure GenerateTotalSellsPerProduct(statisticsPath, sellsPath, productsPath : string);
	const
		HEADER = 'TOTAIS DE VENDAS POR PRODUTO: ';
	var
		productList : Products;
		quantityOfProducts, i : integer;
		statisticsFile : Text;
		currentTotal : Real;
		codeText : string;
	begin
		productList := GetsProducts(productsPath);
		quantityOfProducts := LengthOfProducts(ProductList);

		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		Writeln(statisticsFile, '');
		Writeln(statisticsFile, HEADER);
		for i := 1 to quantityOfProducts do
		begin
			currentTotal := GetsTotalSellsByProduct(productList[i].Code, sellsPath);
			codeText := Concat(productList[i].Code, '-', CalculateVerifierDigit(productList[i].code));

			Writeln(statisticsFile, codeText, '    ', FloatToStrf(currentTotal, fffixed, 12, 2));
		end;

		Close(statisticsFile);
	end;


	procedure GenerateTotalAndStatisticsOfMonth(statisticsPath, sellsPath, productsPath : string);
	const
		HEADER = 'TOTAL E ESTATÍSTICAS DO MÊS';
	var
		statisticsFile: Text;
	begin
		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		Writeln(statisticsFile, '');
		Writeln(statisticsFile, HEADER);
		Writeln(statisticsFile, 'Total de Vendas                    ', FloatToStrf(GetsTotalSelled(sellsPath), fffixed, 12, 2));

		Close(statisticsFile);
	end;

	procedure GenerateMediumOfSells(statisticsPath, sellsPath, productsPath : string);
	var
		sellsFile, statisticsFile: Text;
		currentLine : string;
		currentSell : sell;
		currentDate : string;
		yy, mm, dd, monthDays, workDays : integer;
		totalSelled : real;
		medium : real;
	begin
		workDays := 0;

		Assign(sellsFile, sellsPath);
		Reset(sellsFile);

		Readln(sellsFile, currentLine);
		currentSell := StringToSell(currentLine);
		currentDate := currentSell.DateTime;

		val(copy(currentDate, 1,4), yy);
		val(copy(currentDate, 6,2), mm);

		Close(sellsFile);

		monthDays := GetsQuantityOfDays(mm, yy);

		for dd := 1 to monthDays do
			if(IsWorkingDay(yy, mm, dd)) then
				workDays := workDays + 1;

		totalSelled := GetsTotalSelled(sellsPath);
		medium := totalSelled / workDays;

		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		Writeln(statisticsFile,'Média de Vendas por dia útil       ', FloatToStrF(medium, fffixed, 12, 2));

		Close(statisticsFile);
	end;

	procedure GenerateTotalOfProductsSelled(statisticsPath, sellsPath : string);
	var
		variableName: Integer;
		statisticsFile : Text;
		total : real;
	begin
		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		total := GetsQuantityOfSelledProduct(sellsPath);
		Writeln(statisticsFile, 'Quantidade de produtos vendidos    ', FloatToStrF(total, fffixed, 12, 0));

		Close(statisticsFile);
	end;

	procedure GenerateMediumPerSell(statisticsPath, sellsPath : string);
	var
		numberOfSells : real;
		totalOfSells, medium : real;
		sellsFile, statisticsFile : text;
	begin
		totalOfSells := GetsTotalSelled(sellsPath);
		numberOfSells := 0;

		numberOfSells := GetsQuantityOfSelledProduct(sellsPath);

		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		medium := totalOfSells / numberOfSells;

		Writeln(statisticsFile, 'Média de Vendas por ítem           ', FloatToStrf(medium, fffixed, 12, 2));
		Close(statisticsFile);
	end;

	procedure GenerateMediumPerProduct(statisticsPath, sellsPath, productPath : string);
	var
		quantitySelled: Real;
		totalSelled : Real;
		quantityOfProducts : integer;
		medium : real;
		statisticsFile : Text;
	begin
		totalSelled := GetsTotalSelled(sellsPath);
		quantitySelled := GetsQuantityOfSelledProduct(sellsPath);
		quantityOfProducts := LengthOfProducts(GetsProducts(productPath));

		medium := (totalSelled / quantitySelled) / quantityOfProducts;

		Assign(statisticsFile, statisticsPath);
		Append(statisticsFile);

		Writeln(statisticsFile, 'Média de Vendas Por Produto:       ', FloatToStrf(medium, fffixed, 12, 2));

		Close(statisticsFile);
	end;
	
	procedure ClearStatisticsFile(statisticsPath: string);
	var
	  statisticsFile: Text;
	begin
	  Assign(statisticsFile, statisticsPath);
	  Rewrite(statisticsFile);
	  Close(statisticsFile);
	end;
end.