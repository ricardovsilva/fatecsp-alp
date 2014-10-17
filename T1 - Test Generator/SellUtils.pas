unit SellUtils ;

interface
  Type
    Sell = Record
    Datetime : String[10];
    ProductCode : String[4];
    Quantity: integer;
    Price: Real;
  End;
  
  Type
    Sells = array[1..65532] of Sell;

implementation

end.