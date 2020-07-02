library	IEEE;
use ieee.std_logic_1164.all;

--entity numarator_mod3_v2 is
	--port(btn: inout std_logic :='0';
	--q: inout std_logic_vector(1 downto 0) :="00");
--end;

--architecture numarator of numarator_mod3_v2 is	 
--begin 
	--process(btn)
	--begin
		--if(btn'event and btn='1')then  
			--case q is
				--when "00" => q <= "01"; 
				--when "01" => q <= "10";
				--when "10" => q <= "00";
				--when others => q <= "00";
			--end case;
		--end if;
		
		--btn <= '0';
	--end process;
--end;

entity numarator_mod3_v2 is
	port(btn: in std_logic :='0';  
	clk: in std_logic;
	q: inout std_logic_vector(1 downto 0) :="00");
end;

architecture numarator of numarator_mod3_v2 is	 
begin 
	process(clk)
	begin
		if(clk'event and clk='1' and btn='1')then  
			case q is
				when "00" => q <= "01"; 
				when "01" => q <= "10";
				when "10" => q <= "00";
				when others => q <= "00";
			end case;
		end if;
	end process;
end;
	