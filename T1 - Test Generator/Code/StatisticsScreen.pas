unit StatisticsScreen;
interface
	procedure ShowStatisticsScreen(sellsPath, productsPath, statisticsPath: string);

implementation
  uses
   crt,
   sysutils,
   StatisticsFile;

	(*Show statiscs screen with all information about statiscs file generation*)
	procedure ShowStatisticsScreen(sellsPath, productsPath, statisticsPath : string);
	begin
		clrscr;
		Writeln('Gerando arquivo de estatistica...');
		GenerateTotalSellsPerDay(statisticsPath, sellsPath);
		GenerateTotalSellsPerProduct(statisticsPath, sellsPath, productsPath);
		Readkey;
	end;
end.
