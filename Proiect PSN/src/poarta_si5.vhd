library	IEEE;
use ieee.std_logic_1164.all;

entity poarta_si5 is
	port(a,b,c,d,e: in std_logic;
	f: inout std_logic);
end;

architecture poarta of poarta_si5 is
begin
    f <= a and b and c and d and e;
end;