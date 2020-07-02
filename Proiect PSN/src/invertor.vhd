library	IEEE;
use ieee.std_logic_1164.all;

entity invertor is
	port(x: in std_logic;
	y: inout std_logic);
end;

architecture inv of invertor is
begin
	y <= not x;
end;
	
	