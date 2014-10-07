// -------------------------------------------------------------
// Este programa implementa o jogo PONG :~
// Revisado por Luiz Reginaldo - Desenvolvedor do Pzim
// Autores: Mateus Riva, Caio Augusto Faria, 
//          Denis Miura, Tobias Furtado
// -------------------------------------------------------------
Program PONG;

// Constantes que definem os limites da quadra
const cantoCima = 2 ;
      cantoBaixo = 10 ;
      cantoEsquerda = 2 ;
      cantoDireita = 38 ;

var bolaX, bolaY: integer; // posicao x, y da bola 
    raquete1X, raquete1Y: integer; // posicao x, y da raquete 1
    raquete2X, raquete2Y: integer; // posicao x, y da raquete 2
    moveBolaDireita, moveBolaBaixo: boolean ; // controla direcao da bola  
    pontos: integer;
    acabouJogo: boolean ; 


 //---------------------------------------------------------------- 
 // Desenha o campo do pong 
 //---------------------------------------------------------------- 
 procedure DesenhaCampo;
 begin    
  	textcolor(white);
 	gotoxy(1,1); 	
	writeln(#201,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#203,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#187);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#186,'                  ',#176,'                  ',#186);
     writeln(#200,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#202,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#205,#188);
	writeln(''); 
	writeln('------------------------'); 	
     writeln('Pascalzim PONG');
	writeln('------------------------'); 	     
     writeln('- Mateus Riva');
     writeln('- Caio Augusto Faria');
     writeln('- Denis Miura');
     writeln('- Tobias Furtado');
     writeln('');
	writeln('Controles Jogador 1 => seta para cima, seta para baixo.');     
     writeln('Controles Jogador 2 => 8 para cima, 2 para baixo');	
     writeln('');	
     if(pontos <> 0) then writeln('Pontos: ', pontos);			     
 end;
    
    
      
 //---------------------------------------------------------------- 
 // Move a bola pelo campo
 //----------------------------------------------------------------     
 procedure moveBola ;
 Begin
    // Move a bola na horizontal
    if (moveBolaDireita) then 
      bolaX:= bolaX + 1
    else
      bolaX:= bolaX - 1;
                                 
    // Move a bola na vertical
    if (moveBolaBaixo) then 
      bolaY:= bolaY + 1
    else 
      bolaY:= bolaY - 1;	
     	
    // Se a bola bateu em cima ou embaixo do campo inverte sua direcao
    if (bolaY = cantoBaixo) or (bolaY = cantoCima) then 
       moveBolaBaixo := not moveBolaBaixo ;
    
    // Desenha a bola na sua nova posicao 
    gotoxy(bolaX,bolaY);
    write(#219);  
 End ;
  
  
  
 //---------------------------------------------------------------- 
 // Move as raquetes
 //----------------------------------------------------------------       
 procedure moveRaquetes ;
 var moveuRaquete : boolean ;
 Begin
     // Verifica se alguma raquete se moveu
    	while keypressed do
	begin
	   case readkey of
		// Seta para cima: move a raquete 1 para cima					      		
	     #72: if (raquete1Y > cantoCima+1) then
		      raquete1Y:= raquete1Y - 1;    			
		      
		// Seta para baixo: move a raquete 1 para baixo
		#80:	if (raquete1Y < cantoBaixo) then
			  raquete1Y:= raquete1Y + 1;
			  
		// Numero 8: move a raquete 2 para cima
		'8': if (raquete2Y > cantoCima+1) then
		   raquete2Y:= raquete2Y - 1;
			
		// Numero 2: move a raquete 2 para baixo			
		'2':	if (raquete2Y < cantoBaixo) then
		   raquete2Y:= raquete2Y + 1;	   
	   end;
	end ; 
	
  	// Desenha a raquete 1
     textcolor (lightred);
     gotoxy(raquete1X,raquete1Y);
     write(#219);
     gotoxy(raquete1X,raquete1Y -1);
     write(#219); 	
	
  	// Desenha a raquete 2
     textcolor(lightblue);
     gotoxy(raquete2X,raquete2Y);
     write(#219);
     gotoxy(raquete2X,raquete2Y -1);
     write(#219) ; 		  
 End;  
    
  
 //---------------------------------------------------------------- 
 // Verifica se a bola bateu em alguma raquete
 //----------------------------------------------------------------   
 procedure VerificaChoqueRaquete ;
 Begin
   // Se a bola bateu na raquete 1 joga ela para direita
   if (bolaX = raquete1X+1) then
    if (bolaY = raquete1Y) or (bolaY = raquete1Y-1) then   
    begin 
	  moveBolaDireita := true ;
	  pontos:= pontos + 1;
    end;

   // Se a bola bateu na raquete 2 joga ela para esquerda
   if (bolaX = raquete2X-1) then
    if (bolaY = raquete2Y) or (bolaY = raquete2Y-1) then   
    begin 
	  moveBolaDireita := false ;
	  pontos := pontos + 1;
    end;       
 End;
 
 
 //---------------------------------------------------------------- 
 // Inicia o jogo
 //----------------------------------------------------------------   
 procedure iniciaJogo ;
 Begin
   randomize;
   
   // Determina posicao inicial da bola   
   bolaX:= 20;
   bolaY:= random(cantoBaixo-2) + 2;   
             
   // Determina para que lado a começa a se mover
   moveBolaBaixo := true ;
   if(random(2) = 1) then
     moveBolaDireita := true 
   else
     moveBolaDireita := false ;  
   
   // Determina posicao inicial da raquete 1
   raquete1X:= cantoEsquerda;
   raquete1Y:= (cantoCima+cantoBaixo) div 2 ;
   
   // Determina posicao inicial da raquete 2   
   raquete2X:= cantoDireita;
   raquete2Y:= (cantoCima+cantoBaixo) div 2 ;
   pontos := 0;

   // inicializacao do jogo
   acabouJogo := false ; 
   clrscr;
 End;
 
 
  
 //---------------------------------------------------------------- 
 // Fim do jogo: a bola passou por uma das raquetes
 //----------------------------------------------------------------   
 procedure VerificaFimJogo ; 
 var resp : char ;
 Begin
   // Se a bola nao bateu no canto do tabuleiro sai do procedure 
   if(bolaX <> cantoEsquerda-1) and (bolaX <> cantoDireita+1) then
      exit ;
    
   // Mostra qual jogador venceu o jogo 
   textcolor(white);
   gotoxy(41,3);
   if (bolaX < cantoEsquerda) then
     writeln('Vencedor: Jogador 2') 
   else 
  	writeln('Vencedor: Jogador 1');               	 
 
   // Pergunta se quer continuar jogando
   gotoxy(41,5);
   write('Digite <ENTER> para parar...');   
   gotoxy(41,7);
   write('Pressione outra tecla para jogar...');   
   resp := upcase(readkey);
 		
   // Se a resposta é não, termina o programa		
   if (resp= #13) then
   Begin
     acabouJogo := true ;
     exit ;
   End ; 
   
   // Se a resposta é sim, reinicia o jogo   
   iniciaJogo ;    
 End ;  
                  
  
 //----------------------------------------------------------------
 // Inicio do programa
 //---------------------------------------------------------------- 
 Begin  
     // Desenha o campo de jogo, de fundo verde
     textbackground(green);  	
     clrscr;
     DesenhaCampo;
     writeln('=> Pressione uma tecla para iniciar o jogo');     
  	readkey ;

	// Roda o jogo
     iniciaJogo ;
     while not acabouJogo do
     begin
  	    delay(150);     
         DesenhaCampo;
  	    moveBola ;
  	    moveRaquetes ;
	    VerificaChoqueRaquete ;    
  	    VerificaFimJogo ;  	
 	end;
 End.

