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
		GenerateTotalAndStatisticsOfMonth(statisticsPath, sellsPath, productsPath);
		GenerateTotalOfProductsSelled(statisticsPath, sellsPath);
		GenerateMediumOfSells(statisticsPath, sellsPath, productsPath);
		GenerateMediumPerSell(statisticsPath, sellsPath);
		GenerateMediumPerProduct(statisticsPath, sellsPath, productsPath);
		Writeln('Arquivo gerado com sucesso! Pressione qualquer tecla para retornar ao menu anterior.')
		Readkey;
	end;
end.
