unit RealUtils;
interface
  function RealToStr ( r : Real ; d : Integer) : String;
implementation
  
  (*This function converts real variable to it's string
   * representation and returns this string.
   * The parameters are:
   *  r : Real - This is the number to be converted.
   *  d : Integer - Length of number after decimal point.
   * This code was copied from http://professorwellingtontelles.blogspot.com.br/2014/07/converte-real-para-string-no-pascalzim.html
   * at 2014-10-19, and written by Professor Wellington Telles *)    
  function RealToStr ( r : Real ; d : Integer) : String;
  Var
    i,j : Integer ;
    aux : String ;
    s   : String ;
  Begin
    // Parte Inteira
    i := trunc (r) ;
    str (i,s) ;
    r := r - i ; // Remove a parte inteira
    s := s + '.' ; // Ponto da casa decimal
    // Casas Decimais
    j := 0 ;
    While r < 1 Do
    Begin
      r := r * 10 ;
      i := trunc (r) ;
      str (i,aux) ;
      s := s + aux ;
      r := r - i ;
      j := j + 1 ;
      if j = d Then break ; // Sai do Looping
    End ;   
    RealToStr := s 
  end;
end.