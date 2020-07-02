library	IEEE;
use ieee.std_logic_1164.all;

entity poarta_si2 is
	port(a,b: in std_logic;
	f: out std_logic);
end;

architecture poarta of poarta_si2 is
begin
    f <= a and b;
end;