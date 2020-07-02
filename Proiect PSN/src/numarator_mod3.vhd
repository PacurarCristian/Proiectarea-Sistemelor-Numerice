library	IEEE;
use ieee.std_logic_1164.all;

entity numarator_mod3 is
	port(enable, reset: in std_logic :='0'; 
	carry: out std_logic := '0';
	clk: in std_logic;
	q: inout std_logic_vector(3 downto 0) :="0000");
end;

architecture numarator of numarator_mod3 is	 
begin
	process(clk)
	begin
		if(enable='1' and reset='1')then   
			if(rising_edge(clk))then  
				case q is
					when "0000" => q <= "0001"; 
					when "0001" => 
						q <= "0010";
						carry <= '1';
					when "0010" =>
						q <= "0000";
						carry <= '0';
					when others => q <= "0000";
				end case;
			end if;
		elsif(reset='0')then q <= "0000";
		end if;
	end process;
end;
	