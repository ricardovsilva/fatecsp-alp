unit InputUtils;
interface
  function GetsInteger(message : string; min, max : integer) : integer;
  function GetsIntegerAsString(message : string; min, max : integer) : string;
implementation
  (* This function asks user to input an integer value. And only returns the product code when it was between
   * min and max. Parameters are: * 
   * message - Is the message that will be displayed to user asking for product code.
   * min - minimum value of code.
   * max - maximum value of code. *)
  function GetsInteger(message : string; min, max : integer) : integer;
  var 
    input : integer;
  begin
    repeat
      Writeln(message);
      Readln(input);
    until (input > min) and (input < max);
    
    GetsInteger := input;
  end;
  
  (* This function asks user to input an integer value. And only returns the product code when it was between
   * min and max. But return type is string. Parameters are: * 
   * message - Is the message that will be displayed to user asking for product code.
   * min - minimum value of code.
   * max - maximum value of code. *)
  function GetsIntegerAsString(message : string; min, max : integer) : string;
  var
    input : integer;
    output : string;
  begin
    input := GetsInteger(message, min, max);
    str(input, output);
    GetsIntegerAsString := output;
  end;
end.
  