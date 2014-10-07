Program TestGenerator ;
  Type
    Product = Record
      Code : String[4];
      Name : String[30];
      Price : Real;
  End;
  
  var  
    teste : Product;
Begin 
  teste.Code := '1234';
  teste.Name := 'Any product';
  teste.Price := 2.45;
  
  Writeln(teste.Code);
  WriteLn(teste.Name);
  WriteLn(teste.Price);
  
  read() ; 
End.