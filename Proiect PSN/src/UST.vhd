library	IEEE;
use ieee.std_logic_1164.all;

entity UST is
end;

architecture arh of UST is

component automat_final
	port(clk: in std_logic;
	btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas: in std_logic :='0'; 
	btn_stare: inout std_logic :='0';
	reset_ceas: in std_logic :='1'; 
	bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio: out std_logic :='0';
	ore_z, ore_u, min_z, min_u: out std_logic_vector(6 downto 0) := "0000000");
end component;

signal clk: std_logic:='0';
signal btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas: std_logic :='0'; 
signal btn_stare: std_logic :='0';
signal reset_ceas: std_logic :='1'; 
signal bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio: std_logic :='0';
signal ore_z, ore_u, min_z, min_u: std_logic_vector(6 downto 0) := "0000000";

begin
	auto: automat_final port map(clk, btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas, btn_stare, reset_ceas, bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio, ore_z, ore_u, min_z, min_u);
	
	process
	begin
		wait for 50ns;
		clk <= '1'; wait for 50ns;
		clk <= '0';
	end process;
	
	process
	begin
		reset_ceas <= '1'; --pornire ceas
		wait for 366000 ns; --ceas: 01:01
		
		btn_stare <= '1'; wait for 100 ns;
		btn_stare <= '0'; btn_ore <= '1'; btn_min <= '1'; wait for 100 ns; --alarma: 01:01 => bec_alarma='1'
		btn_ore <= '0'; btn_min <= '0'; wait for 100 ns; 
		btn_oprire_alarma <= '1'; wait for 100 ns;--bec_alarma='0'; 
		
		btn_oprire_alarma <= '0'; btn_stare <= '1'; wait for 100 ns;	
		btn_stare <= '0'; btn_ore <= '1'; btn_min <= '1'; wait for 100 ns; --radio: 01:01 => bec_radio='1'
		btn_ore <= '0';	btn_min <= '0'; wait for 100 ns; 
		btn_oprire_radio <= '1'; wait for 100 ns; --bec_radio='0'
		
		btn_oprire_radio <= '0'; btn_ore <= '1'; btn_min <= '1'; wait for 2200 ns; --radio: 23:23
		btn_ore <= '0'; wait for 3600 ns; --radio: 23:59
		btn_min <= '0'; wait for 100 ns;
		--372700ns
		btn_ore <= '1'; wait for 100 ns; --radio: 00:59
		wait;
	end process;
end;