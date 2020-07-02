library	IEEE;
use ieee.std_logic_1164.all;

entity numarator_mod10 is
	port(enable, reset: in std_logic :='0'; 
	carry: out std_logic := '0';
	clk: in std_logic;
	q: inout std_logic_vector(3 downto 0) :="0000");
end;

architecture numarator of numarator_mod10 is 
begin
	process(clk) 
	begin 
		if(enable='1' and reset='1')then   
			if(rising_edge(clk))then
				case q is
					when "0000" => q <= "0001";		
					when "0001" => q <= "0010";	
					when "0010" => q <= "0011";
					when "0011" => q <= "0100";
					when "0100" => q <= "0101";
					when "0101" => q <= "0110";
					when "0110" => q <= "0111";
					when "0111" => q <= "1000";
					when "1000" => 
						q <= "1001";
						carry <= '1';
					when "1001" => 
						q <= "0000";
						carry <= '0';
					when others => q <= "0000";
				end case;
			end if;
		elsif(reset='0')then q <= "0000";
		end if;
	end process;
end;
	