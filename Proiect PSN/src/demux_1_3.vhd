library	IEEE;
use ieee.std_logic_1164.all;

entity demux_1_3 is
	port(s: in std_logic_vector(1 downto 0);
	x: in std_logic;
	a,b,c: out std_logic);
end;

architecture demux of demux_1_3 is
begin
	process(s, x)
	begin 
		case s is
			when "00" => 
				a <= x;
				b <= '0';
				c <= '0';
			when "01" =>
				a <= '0';
				b <= x;
				c <= '0';
			when "10" =>
				a <= '0';
				b <= '0';
				c <= x;
			when others => 
				a <= '0';
				b <= '0';
				c <= '0';
		end case;
	end process;
end;
		