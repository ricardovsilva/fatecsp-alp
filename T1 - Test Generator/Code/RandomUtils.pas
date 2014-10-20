unit RandomUtils;

interface
  function AddRandomPercentage(value : real; maxPercentage : integer) : real;
implementation
  (*Receives one real value and applies a random percentage to this value.
   *The parameters are:
   *  - value : The value to apply percentage.
   *  - maxPercentage: The maximum percentage that will be added or removed*)
  function AddRandomPercentage(value : real; maxPercentage : integer) : real;
  const
    negative = 0;
    positive = 1;
  var
    randomNumber : integer;
    randomPercentage : real;
    randomizedValue : real;
    signal : integer;
  begin
    Randomize;
    randomNumber := random(maxPercentage) + 1;
    randomPercentage := randomNumber / 100;
    
    Randomize;
    signal := random(100);
    signal := signal mod 2;
    
    if signal = negative then
      signal := -1
    else
      signal := 1;
      
    randomPercentage := randomPercentage * signal;
        
    randomizedValue := value + value * randomPercentage;
    AddRandomPercentage := randomizedValue;
  end;
end.