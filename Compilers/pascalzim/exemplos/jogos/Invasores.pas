// ----------------------------------------------------------------------
// Este programa implementa um jogo espacial. :~
// Desenvolvido por João Lucas de O. Torres
// Curso de Eng. Elétrica, Universidade Federal do Ceará, campus Sobral
// Complementado por Luiz Reginaldo - Desenvolvedor do Pzim
// ----------------------------------------------------------------------
Program Invasores_Alienigenas ;
  const numLinhas = 5 ;
        numColunas = 40 ;


 //---------------------------------------------
 // Declaracao de tipos
 //--------------------------------------------- 
 Type // Tipo que define a posição de um tiro
      Ttiro = record  
                 x, y: integer;
                 disparado: boolean;
  		     end;

      // Tipo que define a matriz com as naves invasoras, sua posição na tela
      // a direcao de movimento das naves e um timer para velocidade do tiro
      TInvasores = record
       	       area: array[1..numLinhas,1..numColunas] of boolean;
      	       xo, yo: integer ;
      		  movimento: (esquerda, direita);
      		  contadorTiro: integer ;      		     
      	     end;
      		  
      // Tipo que contem a posição da nave na tela e sua energia      		  
      Tnave = record
                 x, y: integer;
                 energia: integer ;
              end; 


 //---------------------------------------------
 // Declaracao de variaveis
 //--------------------------------------------- 
 Var nave : Tnave; 
     invasores : TInvasores ; 
     tiroNave, tiroInvasores : Ttiro; 
     Key : Char; 
     AuxTempMon, TempEsp : integer;                    


 //--------------------------------------------- 
 // Desenha o cenário de fundo do jogo
 //--------------------------------------------- 
 Procedure DesenhaFundo ;
  begin
    TextColor(white);
    GoToXY(1,2);
    write('  .   :        :    ..         :    .          .          .  ..      .   .  .  .');
    GoToXY(1,4);
    write('     . ..      .  .    .   . ..      .       .    .       .  ..      . .      ..');
    GoToXY(1,6);
    write('     .       .        . . .        :    .     .          .      :      .   .    ');
    GoToXY(1,8);
    write('  .        . .            .      .   ..   .     .     .   .          .   .  .  .');
    GoToXY(1,10);
    write('     .       .        . . .        :    .     .          .      :      .   .    ');
    GoToXY(1,12);
    write('     . ..      .  .    .   . ..      .       .    .       .  ..      . .      ..');
    GoToXY(1,14);
    write('     .       .        . . .        :    .     .          .      :      .   .    ');
    GoToXY(1,16);
    write('  .   :     .          .    . .           . .        :       .      ..    .    .');
    GoToXY(1,18);
    write('  .        . .            .      .   ..   .     .     .   .          .   .  .  .');
    GoToXY(1,20);
    write('  .   :        :    ..         :    .          .          .  ..      .   .  .  .');
    TextColor(Cyan);
    GoToXY(1,21);
    write('   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -');
    TextColor(white);
    GoToXY(1,22);
    write('  .        . .            .      .   ..   .     .     .   .          .   .  .  .');
   GoToXY(1,24);  
   write(' PASCALZIM INVASORES DO ESPAÇO' );       
    
  end;


 //--------------------------------------------- 
 // Desenha as naves invasoras
 //--------------------------------------------- 
 Procedure DesenhaNavesInvasoras;  
  var i, j : integer;  
  begin
   textColor(lightred);
   for i:=1 to numLinhas do
     for j:=1 to numColunas do
       if invasores.area[i,j] = True then 
        begin
          gotoxy(invasores.Xo+j-1,invasores.Yo+i-1); 
          write(#190);
        end;
  end;
 
 
 //---------------------------------------------  
 // Define a posicao das naves invasoras
 //---------------------------------------------  
 Procedure DefinePosicaoNavesInvasoras ; 
 var i, j: integer ;
  begin
  for i:= 1 to numLinhas do
    for j:= 1 to numColunas do
    Begin
      // Nas linhas impares desenha as naves a cada 4 colunas começando da coluna 0 
      if ((i mod 2) = 1) and ((j mod 4) = 0) then   
         invasores.area[i,j] := true ;
      // Nas linhas pares desenha as naves a cada 4 colunas começando da coluna 2          
      if ((i mod 2) = 0) and ((j mod 4) = 2) then   
         invasores.area[i,j] := true ;         
    End ;
  end;
 
 
 //-----------------------------------------------------
 // Move as naves invasoras pela tela
 //-----------------------------------------------------
 Procedure MoveNavesInvasoras ;
  begin 
   // Move as naves na direcao atual
   if (invasores.movimento = direita) then 
     invasores.Xo:= invasores.Xo+1  
   else    
     invasores.Xo:= invasores.Xo-1 ; 
   
   // Se chegou no canto direito da tela, desce as naves e retorna para a esquerda
   If (invasores.movimento = direita) and (invasores.Xo+numColunas-1 > 78) then  
    begin     
      invasores.Yo:= invasores.Yo+1 ; 
      invasores.movimento := esquerda ;
    end;

   // Se chegou ao canto esquerdo da tela, desce as naves e retorna para a direita    
   If (invasores.movimento = esquerda) and (invasores.Xo < 3) then  
   begin     
      invasores.Yo:= invasores.Yo+1 ; 
      invasores.movimento := direita ;
   end;     
    
   // Se as naves chegaram na linha limite, fim de jogo
   If (invasores.Yo+numLinhas-1)>20 then 
       Nave.energia:= 0;    
  end;
 
 
 //--------------------------------------------------------------------  
 // Se as naves podem disparar, então dispara de uma posição aleatória
 //--------------------------------------------------------------------  
 Procedure DisparaNavesInvasoras;
  begin
   If not tiroInvasores.disparado then
    begin
      tiroInvasores.X:= invasores.Xo+ random(numColunas) ;  
      tiroInvasores.Y:= invasores.Yo+5;
      tiroInvasores.Disparado:= True;
    end;
  end;


 //---------------------------------------------------------------
 // Desenha o tiro das naves invasoras
 //--------------------------------------------------------------- 
 Procedure DesenhaTiroNavesInvasoras;
  begin
   // Desenha o tiro
   TextColor(yellow);     
   GoToXY(tiroInvasores.X,tiroInvasores.Y);
   Write(#207);
  
   // Diminui o contador de tiro das naves invasoras
   dec(invasores.contadorTiro) ;
  
   // Se o contador do tiro chegou em zero, move ele para baixo
   if (invasores.contadorTiro <= 0) and tiroInvasores.disparado then
    begin
     invasores.contadorTiro := 2 ;
    
     // Move o tiro uma unidade para baixo
     tiroInvasores.Y := tiroInvasores.Y + 1; 
     
     // Se o tiro atingiu a nave, então diminui a energia dela
     If (abs(Nave.X - tiroInvasores.X) < 2) and (tiroInvasores.Y = Nave.Y) then
	Begin 
       dec(nave.energia) ;
       tiroInvasores.Disparado := False ;
     End;  
     
     // Se o tiro chegou no fim da tela, prepara para lançar um novo tiro
     If tiroInvasores.Y >= 24 then 
        tiroInvasores.Disparado := False;
    end;
  end;


 //--------------------------------------------------------------- 
 // Verifica se a nave pode disparar, se puder, então dispara
 //--------------------------------------------------------------- 
 Procedure DisparaNave;
  begin
   If tiroNave.Disparado = False then
    begin
     tiroNave.X:= Nave.X;
     tiroNave.Y:= Nave.Y;
     tiroNave.Disparado:= True;
    end;
  end;


 //--------------------------------------------------------------- 
 // Desenha o tiro da nave
 //---------------------------------------------------------------  
 Procedure DesenhaTiroNave; 
  var linha, coluna: integer ;
  begin
   if tiroNave.Disparado=True then
    begin
     // Desenha o tiro 
     textColor(lightgreen);    
     goToXY(tiroNave.X,tiroNave.Y);
     write(#176);

     linha := tiroNave.Y-invasores.Yo+1 ;
     coluna := tiroNave.X-invasores.Xo+1 ;

     // Verifica se o tiro da nave está dentro da área ocupada pelas naves
     if (linha >= 1) and (linha <= numLinhas) and (coluna >= 1) and (coluna <= numColunas) then
     begin
       // Nesse caso, se o local onde está o tiro é uma nave invasora, então
       // destroi esse invasor e rehabilita a nave a disparar
       If invasores.area[linha,coluna] = True then
        begin
          invasores.area[linha,coluna]:=False;
          tiroNave.Disparado:=False; 
        end;
     end;
      
     // Desloca o tiro da nave uma unidade para cima 
     tiroNave.Y := tiroNave.Y-1; 
     
     // Se o tiro chegou ao fim da tela, rehabilita a nave a disparar
     If tiroNave.Y <= 0 then 
       tiroNave.Disparado:=False; 
    end;
  end;


 //---------------------------------------------------------------  
 // Captura a tecla pressionada e move a nave
 //---------------------------------------------------------------  
 Procedure MoveNave; 
 Begin
  If keypressed then 
    begin
     key:=readkey;
     Case key of
       #72 : Nave.Y:= Nave.Y-1; //move uma unidade para cima
       #80 : Nave.Y:= Nave.Y+1; //move uma unidade para baixo
       #75 : Nave.X:= Nave.X-1; //move uma unidade para esquerda
       #77 : Nave.X:= Nave.X+1; //move uma unidade para direita
       ' ' : DisparaNave; //Dispara
     end;
     
     // Mantem a nave fora do espaço dos invasores
     If Nave.Y > 23 then Nave.Y:= 23 ;
     If Nave.Y < (invasores.Yo+numLinhas) then Nave.y:=(invasores.Yo+numLinhas);
     If Nave.X > 79 then Nave.X :=79;
     If Nave.X < 2 then Nave.X :=2;
    end;
 end;


 //---------------------------------------------------------------
 // Desenha a nave na tela 
 //--------------------------------------------------------------- 
 Procedure DesenhaNave; 
  begin
   TextColor(LightCyan);
   gotoxy(Nave.X-1,Nave.Y);
   Write(#192,#127,#217);
   GoToXY(1,24);  
   write(' PASCALZIM INVASORES DO ESPAÇO                                   Energia: ', nave.energia );       
  end;

 //---------------------------------------------------------------
 // Desenha o menu do jogo
 //---------------------------------------------------------------
 Procedure Menu; 
  begin
   TextColor(lightgreen);
   GoToXY(1,3);
   writeln(' ----------------------------------------------------------------------');         
   writeln(' Pascalzim - Invasores do Espaço ');            
   writeln(' Desenvolvido por Joao Lucas de O. Torres (joao.lucas.torres@gmail.com)');
   writeln(' Complementado por Luiz Reginaldo (desenvolvedor do Pascalzim)');   
   writeln(' ----------------------------------------------------------------------');      
   GotoXY(1,9);
   Writeln(' Selecione o nivel de dificuldade:');
   writeln ;
   Writeln(' 1 => Facil') ;
   Writeln(' 2 => Medio');
   Writeln(' 3 => Dificil');
   
   // Define tempo para movimentação e disparo das naves invasoras (520ms, 360ms 160ms)
   while((key <> '1') and (key <> '2') and (key <> '3')) do
   Begin
      key:=readkey;
      case key of    
        '1' : TempEsp:=13;
        '2' : TempEsp:=9;
        '3' : TempEsp:=5;
      end;
   End;  
  end;


 //---------------------------------------------------------------
 // Desenha tela da vitória
 //--------------------------------------------------------------- 
 Procedure Venceu; 
  begin
    GotoXY(10,5);
    write('Parabens, Voce venceu');
    textcolor(yellow);
    GoToXY(20,7);
    write(#186,'   ',#186);
    GoToXY(19,8);
    write(#195,#186,'   ',#186,#180);
    GoToXY(20,9);
    write(#200,#205,#203,#205,#188);
    GoToXY(21,10);
    write(#205,#202,#205);
    GoToXY(20,11);
    write('TROFEU');
    GoToXY(22,12);
    write('AO');
    GoToXY(19,13);
    write('VENCEDOR');
  end;


 //---------------------------------------------------------------
 // Verifica se todas as naves invasoras foram destruidas  
 //---------------------------------------------------------------
  function isFimJogo: boolean ;
  var i, j: integer;
  Begin
    isFimJogo:= true ;        
    for i:=1 to 5 do
      for j:=1 to 5 do      
	   if invasores.area[i][j] = true then
          isFimJogo:= false ;	   
  End;


 //---------------------------------------------------------------
 // Inicio do programa
 //---------------------------------------------------------------
 Begin
  // Desenha o menu inicial     
  DesenhaFundo ;
  Menu;

  // Define a posicao inicial da nave
  nave.X:= 40; 
  nave.Y:= 23;
  nave.energia:= 5 ;
  
  // Define a posicao inicial das naves invasoras
  invasores.Xo:= 1;
  invasores.Yo:= 1;
  invasores.movimento := direita ;
  invasores.contadorTiro := 0 ;
  
  // Habilita os invasores e a nave para disparar  
  tiroInvasores.Disparado:= false;
  tiroNave.Disparado:= false;
  
  // Define a matriz de naves invasoras
  DefinePosicaoNavesInvasoras ;
  
  AuxTempMon:=0;  
  repeat
    // Desenha objetos na tela    
    clrScr;    
    DesenhaFundo;
    DesenhaTiroNave;  
    DesenhaTiroNavesInvasoras;  
    DesenhaNavesInvasoras; 
    DesenhaNave;
    MoveNave;   
    
    // Temporizador para mover as naves invasoras
    If auxTempMon >= tempEsp then 
    begin
      moveNavesInvasoras ;
      disparaNavesInvasoras;
      auxTempMon:=0;
    end;

    delay(40); 
    auxTempMon:= auxTempMon+1 ;  
  until (key=#27) or (nave.energia <= 0) or isFimJogo ;

  ClrScr;
  GoToXY(15,10);
  TextColor(white);
  
  // Verifica se o jogador venceu ou perdeu
  if nave.energia > 0 then
     Venceu
  else
     write('Que pena, voce perdeu...');

  // Sai do programa
  Delay(2000);
  writeln;
  writeln;
  writeln;
  GoToXY(15,15);  
  write('Pressione qualquer tecla para sair');
  Readkey;

 End. 
