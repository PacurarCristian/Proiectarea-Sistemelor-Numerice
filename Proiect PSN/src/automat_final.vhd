library	IEEE;
use ieee.std_logic_1164.all;

entity automat_final is
	port(clk: in std_logic;
	btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas: in std_logic :='0'; 
	btn_stare: in std_logic :='0';
	reset_ceas: in std_logic :='1'; 
	bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio: out std_logic :='0';
	ore_z, ore_u, min_z, min_u: out std_logic_vector(6 downto 0) := "0000000");
end;

architecture auto of automat_final is

component automat
	port(clk: in std_logic;
	btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas: in std_logic :='0'; 
	btn_stare: in std_logic :='0';
	reset_ceas: in std_logic :='1'; 
	bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio: out std_logic :='0';
	ore_z, ore_u, min_z, min_u: out std_logic_vector(6 downto 0) := "0000000");
end component;

begin
	auto: automat port map(clk, btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas, btn_stare, reset_ceas, bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio, ore_z, ore_u, min_z, min_u); 
end;