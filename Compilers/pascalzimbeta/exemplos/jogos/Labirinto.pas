// -------------------------------------------------------------
// Este programa mostra como criar um game de labirinto :~
// Autor : Luiz Reginaldo - Desenvolvedor do Pzim
// -------------------------------------------------------------
Program Pzim ;

var maze: array[1..25,1..80] of char;
    i, j: integer ;
    xDestino, yDestino: integer ;
    x,y: integer;
    flag:boolean;

//----------------------------------------------------------------
// Funcao usada para saber se a posicao está dentro do labirinto
//----------------------------------------------------------------
Function isDentroLabirinto( i, j: integer ): boolean ;
Begin
  if (i <=0) or (i >= 25) or (j <= 1) or (j >= 80) then
     isDentroLabirinto := false 
  else
     isDentroLabirinto := true ;   	 
End;       

//--------------------------------------------------------------------
// Funcao usada para saber se a posicao denota uma borda do labirinto
//--------------------------------------------------------------------
Function isBorda( i, j: integer ): boolean ;
Begin
  if (i <=0) or (i >= 25) or (j <=0) or (j >= 80) then
     isBorda := true 
  else
     isBorda := false ;   	 
End;   
	   
//--------------------------------------------------------------------
// Funcao usada para saber o número de parede ao redor de uma posição
//--------------------------------------------------------------------	   
Function numParedes( i, j: integer ): integer ;
var x: integer;
Begin
  if not isDentroLabirinto(i,j) then
    numParedes := 0 
  else
  Begin
    x:= 4; 
    if not isDentroLabirinto(i+1,j) or (maze[i+1,j] <> 'P' ) then x:= x-1;
    if not isDentroLabirinto(i-1,j) or (maze[i-1,j] <> 'P' ) then x:= x-1;
    if not isDentroLabirinto(i,j-1) or (maze[i,j-1] <> 'P' ) then x:= x-1;
    if not isDentroLabirinto(i,j+1) or (maze[i,j+1] <> 'P' ) then x:= x-1;        
    numParedes := x;
  End;     
End;  	   

//--------------------------------------------------------------------
// Procedimento que monta o labirinto, a partir de uma heurística.
//--------------------------------------------------------------------
Procedure NovoLabirinto;
Const BAIXO = 0; 
      DIREITA=1;
      CIMA=2;
      ESQUERDA=3;
Var direcoesValidas: array[0..3] of integer;
    podeConstruir:boolean; 
    visited, posPilha, numPosCandidatas, direcaoEscolhida,x {linha},y {coluna} : integer;    
    pilhaCaminhoSeguido: array[0..2000] of integer;        
Begin   
   // Define todas as posicoes do labirinto como parede
   for i:=1 to 25 do
      for j:=1 to 80 do
        Begin 
          maze[i][j] := 'P' ;	     
        End;     
      
   // Define a posicao de onde o labirinto irá comecar a ser construido
   randomize;
   x := 3 ;
   y := 3 ;

   // Variáveis usadas na construcao do labirinto
   posPilha := 0 ;
   podeConstruir:= true;
   
   // Enquanto o labirinto ainda puder ser construido, repete...
   while (podeConstruir) do 
   Begin      
	 numPosCandidatas := 0;
	 
      // Heuristica: as posicoes candidatas para próxima posicao
      // na construcao do labirinto possuem uma parede entre a 
      // posicao atual e tem 4 paredes ao seu redor.
      if (not isBorda(x,y)) and (numParedes(x,y-2)=4) then 
      Begin
         direcoesValidas[numPosCandidatas] := BAIXO ;
         numPosCandidatas:= numPosCandidatas+1;
      End;   
      if (not isBorda(x,y)) and (numParedes(x+2,y)=4) then    
      Begin      
         direcoesValidas[numPosCandidatas] := DIREITA ;
         numPosCandidatas:= numPosCandidatas+1;
      End;            
      if (not isBorda(x,y)) and (numParedes(x,y+2)=4) then             
      Begin      
         direcoesValidas[numPosCandidatas] := CIMA ;
         numPosCandidatas:= numPosCandidatas+1;
      End;            
      if (not isBorda(x,y)) and (numParedes(x-2,y)=4) then                      
      Begin      
         direcoesValidas[numPosCandidatas] := ESQUERDA ;
         numPosCandidatas:= numPosCandidatas+1;
      End; 
      
      // Se foi encontrada pelo menos uma posicao candidata,
      // escolhe aleatoriamente uma dessas posicoes e move para lá.
	 if (numPosCandidatas <> 0) then
      Begin
         direcaoEscolhida := direcoesValidas[ random(numPosCandidatas) ] ;
         
         case (direcaoEscolhida) of
	       // knock down walls and make new cell the current cell
            BAIXO: Begin
		            maze[x][y-2] := 'B' ;
		            maze[x][y-1] := 'B' ;
                      y:= y-2 ;
			    End;
            DIREITA:  Begin
		            maze[x+2][y] := 'B' ;
                      maze[x+1][y] := 'B' ;		            
                      x:= x+2 ;
                    End;
            CIMA: Begin
		           maze[x][y+2] := 'B' ;
		           maze[x][y+1] := 'B' ;		           
                     y:= y+2 ;
                    End;
            ESQUERDA:  Begin 
		           maze[x-2][y] := 'B' ;
		           maze[x-1][y] := 'B' ;		           
                     x:= x-2 ;
                    End;
         end;  

         // Agora, empilha a direcao escolhida
         pilhaCaminhoSeguido[posPilha] := direcaoEscolhida ;
         posPilha := posPilha + 1;
                            
      end  // fim do if
      
      // Agora, se não foi encontrada nenhuma posicao candidata,
      // Atualiza a posicao atual a partir da direcao armazenada
      // no topo da pilha que contem o caminho seguido
      else 
	 Begin
          posPilha:= posPilha-1;
          // Se a pilha está vazia, a construcao deve parar...
          if( posPilha < 0 ) then
            podeConstruir:= false
          // Senão, atualiza a posicao atual, voltando...
          else Begin
             case (pilhaCaminhoSeguido[posPilha]) of              
                BAIXO: Begin y:= y+2 ; End; 
                DIREITA:  Begin x:= x-2 ; End;
                CIMA: Begin y:= y-2 ; End;
                ESQUERDA:  Begin x:= x+2 ; End;
             end; 
	     End; 
      End;              
    End;    
End;
  
	      
//---------------------------------------------------------
// Procedimento que desenha o Labirinto
//---------------------------------------------------------
Procedure DesenhaLabirinto;
Begin
   textcolor( lightgray );
   for i:= 1 to 25 do
    Begin       
       for j:= 1 to 80 do    
          if( maze[i,j] = 'P' ) then
          Begin
            gotoxy(j,i);
            write( #177 );        
          End;  
    End;	       
End;

//---------------------------------------------------------
// Método que desenha o personagem em uma nova posicao
//---------------------------------------------------------
Procedure MovePersonagem( posx, posy: integer) ;
begin
    // Apaga posicao anterior
    gotoxy(y, x);    
    textcolor(lightgray);    
    write( #219 ); 

    // Desenha na nova posicao
    gotoxy(posy, posx);    
    textcolor(lightgreen);
    write( #219 );  
    x:= posx;
    y:= posy;      
end;    

//---------------------------------------------------------
// Método que desenha a posicao de saida
//---------------------------------------------------------
Procedure DesenhaSaida ;
Begin
  // Desenha saida
  flag:= false;
  while( flag = false ) do
  Begin
     xDestino:= random(24)+1 ;
     yDestino:= 77;
     if( maze[xDestino,yDestino] = 'B' ) then
     Begin
        textcolor(white);
        gotoxy(yDestino, xDestino);
        write( 'S' );
        flag:= true ;	    
     End;   
  End;   
End;  

//---------------------------------------------------------
// Método que imprime mensagem de fim de jogo
//---------------------------------------------------------
Procedure FimJogo;
Begin
 delay(2000); 
 clrscr;
 gotoxy( 20, 10 );
 textcolor(WHITE);
 write('Muito bem! Você conseguiu encontrar a saída!');
 
 gotoxy( 25, 14 );
 textcolor(WHITE);
 write('Pressione [ENTER] para sair . . .');
End;

//---------------------------------------------------------
// Programa principal
//---------------------------------------------------------
 Begin
    clrscr;
    cursoroff;    
    NovoLabirinto;
    DesenhaLabirinto;
    DesenhaSaida;

    // Mostra mensagem...
    gotoxy(1,1);   
    textbackground(green);      
    write(' Pascalzim Maze - By Luiz Reginaldo - Pressione CTRL+C para sair              ');    
        
    // Move para a posicao inicial do personagem        
    gotoxy(1,1);    
    textbackground(black);
    MovePersonagem(3,3);    
    
    // Joga... Só pode mover para uma posicao com buraco!
    while not( (x=xDestino)and(y=yDestino) )  do
    Begin
      if (keypressed) then
	   case upcase(readkey) of
                #0: case (readkey) of
                       // seta para cima
                       #72: begin 
                               if( maze[x-1][y] = 'B' ) then
                               Begin                                   
                                 MovePersonagem(x-1,y); 
                               End;
                            end;
                       // seta para baixo     
                       #80: begin           
                               if( maze[x+1][y] = 'B' ) then
                               Begin                                   
                                 MovePersonagem(x+1,y); 
                               End;				
					   end;
   				   // seta para esquerda	   
                       #77: begin           
                               if( maze[x][y+1] = 'B' ) then
                               Begin                                   
                                 MovePersonagem(x,y+1); 
                               End;		
					   end ;
  				   // seta para direita	   
                       #75: begin           
                               if( maze[x][y-1] = 'B' ) then
                               Begin                                   
                                 MovePersonagem(x,y-1); 
                               End;
					   end;					   
                    end;       
        end;                
    End;    
    
    // Imprime tela de fim de jogo
    FimJogo;
    
 End.
