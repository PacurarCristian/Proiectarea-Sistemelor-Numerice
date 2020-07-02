library	IEEE;
use ieee.std_logic_1164.all;

entity afisor_7seg is
	port(enable: in std_logic :='1';
	x: in std_logic_vector(3 downto 0) :="0000";
	q: out std_logic_vector(6 downto 0) :="0000000");
end;

architecture afisor of afisor_7seg is
begin
	process(enable, x)
	begin
		if(enable='1')then
			case x is			   --0123456						 --      0
				when "0000" => q <= "1111110"; -- 0 = 7E			 --		---
				when "0001" => q <= "0110000"; -- 1 = 30			 --  5 |   | 1
				when "0010" => q <= "1101101"; -- 2 = 6D			 --		-6-		
				when "0011" => q <= "1111001"; -- 3 = 79			 --	 4 |   | 2
				when "0100" => q <= "0110011"; -- 4 = 33			 --		---
				when "0101" => q <= "1011011"; -- 5 = 5B			 --      3
				when "0110" => q <= "1011111"; -- 6 = 5F
				when "0111" => q <= "1110000"; -- 7 = 70
				when "1000" => q <= "1111111"; -- 8 = 7F
				when "1001" => q <= "1111011"; -- 9 = 7B
				when others => q <= "1111110";
			end case;
		else q <= "0000000";
		end if;
	end process;
end;