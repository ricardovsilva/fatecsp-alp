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
    Writeln('da FATEC S�o Paulo do curso An�lise e Desenvolvimento');
    Writeln('de Sistemas, para a entrega do primeiro trabalho da ');
    Writeln('disciplina de Algoritmo e L�gica de Programa��o, ministrada ');
    Writeln('pelo Mestre S�rgio Luiz Banin.');
    Writeln('Todo o c�digo fonte deste programa, tal como o registro de ');
    Writeln('commits, e documenta��o (toda em ingl�s), est�o dispon�veis ');
    Writeln('no seguinte endere�o: https://github.com/ricardovsilva/fatecsp-alp ');
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
