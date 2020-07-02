library	IEEE;
use ieee.std_logic_1164.all;

entity mux_16_4 is
	port(ceas: in std_logic_vector(3 downto 0);
	alarma: in std_logic_vector(3 downto 0);
	radio: in std_logic_vector(3 downto 0);
	s: in std_logic_vector(1 downto 0);
	q: out std_logic_vector(3 downto 0) :="0000");
end;

architecture mux of mux_16_4 is
begin
	process(s, ceas, alarma, radio)
	begin 
		case s is
			when "00" => q <= ceas;
			when "01" => q <= alarma;
			when "10" => q <= radio;
			when others => q <= "0000";
		end case;
	end process;
end;
		