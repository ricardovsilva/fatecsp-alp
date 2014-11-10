unit AboutScreen;
interface
  procedure ShowAboutMenu;
implementation
  uses crt;

  procedure ShowAboutMenu;
  begin
    Clrscr;
    Writeln('----------------------------S O B R E----------------------------');
    Writeln('Este programa foi escrito um grupo de alunos ');
    Writeln('da FATEC São Paulo do curso Análise e Desenvolvimento');
    Writeln('de Sistemas, para a entrega do primeiro trabalho da ');
    Writeln('disciplina de Algoritmo e Lógica de Programação, ministrada ');
    Writeln('pelo Mestre Sérgio Luiz Banin.');
    Writeln('Todo o código fonte deste programa, tal como o registro de ');
    Writeln('commits, e documentação (toda em inglês), estão disponíveis ');
    Writeln('no seguinte endereço: https://github.com/ricardovsilva/fatecsp-alp ');
    Writeln('Os alunos participantes deste trabalho foram: ');
    Writeln('- Izaac Silva');
    Writeln('- Patricia Stankuna Reis');
    Writeln('- Renan Tiago dos Santos Silva');
    Writeln('- Rodolpho Pinho');
    Writeln('- Ricardo da Verdade Silva');

    Writeln('');
    Writeln('');
    Writeln('');

    Writeln('Pressione qualquer tecla para voltar ao menu principal...');
    ReadKey;
  end;
end.
