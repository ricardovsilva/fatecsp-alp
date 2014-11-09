unit StatisticsFile;
interface
	procedure GenerateTotalSellsPerDay(statisticsFile, sellsFile : string);
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
		HEADER = 'TOTAIS DE VENDAS POR DIA';
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
end.