unit RealUtils;
interface
  function RealToStr ( r : Real ; d : Integer) : String;
implementation
  uses
    sysutils;
  
  (*This function converts real variable to it's string
   * representation and returns this string.
   * The parameters are:
   *  r : Real - This is the number to be converted.
   *  d : Integer - Length of number after decimal point. *)
  function RealToStr ( r : Real ; d : Integer) : String;
  begin
    RealToStr := FloatToStrF(r, ffCurrency, 12, d);
  end;
end.