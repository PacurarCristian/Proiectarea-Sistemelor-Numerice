library	IEEE;
use ieee.std_logic_1164.all;

entity radio is
	port(btn_ore, btn_min: in std_logic :='0';
	clk: in std_logic;
	ore_z: out std_logic_vector(3 downto 0) := "0000";
	ore_u: out std_logic_vector(3 downto 0) := "0000";
	min_z: out std_logic_vector(3 downto 0) := "0000";
	min_u: out std_logic_vector(3 downto 0) := "0000");
end;

architecture r of radio is

component numarator_mod10
	port(enable, reset: in std_logic :='0'; 
	carry: out std_logic := '0';
	clk: in std_logic;
	q: inout std_logic_vector(3 downto 0) :="0000");
end component;
								
component numarator_mod6
	port(enable, reset: in std_logic :='0'; 
	carry: out std_logic := '0';
	clk: in std_logic;
	q: inout std_logic_vector(3 downto 0) :="0000");
end component;  

component numarator_mod3
	port(enable, reset: in std_logic :='0'; 
	carry: out std_logic := '0';
	clk: in std_logic;
	q: inout std_logic_vector(3 downto 0) :="0000");
end component;	

component afisor_7seg
	port(enable: in std_logic :='1';
	x: in std_logic_vector(3 downto 0) :="0000";
	q: out std_logic_vector(6 downto 0) :="0000000");
end component;

component poarta_si2
	port(a,b: in std_logic;
	f: out std_logic);
end component;

signal carry_min_u, carry_min_z, carry_min_u2: std_logic :='0'; 	
signal out_min_u, out_min_z: std_logic_vector(3 downto 0) := "0000";  
signal afisor_min_u, afisor_min_z: std_logic_vector(6 downto 0) :="0000000";

signal carry_ore_u, carry_ore_z, carry_ore_u2: std_logic :='0';
signal reset_ore: std_logic :='1';	
signal out_ore_u, out_ore_z: std_logic_vector(3 downto 0) := "0000";  
signal afisor_ore_u, afisor_ore_z: std_logic_vector(6 downto 0) :="0000000";   

begin	
	--minute	    59min = 354000ns => 59min:59s = 359900ns
	minute_u: numarator_mod10 port map(btn_min, '1', carry_min_u, clk, out_min_u);
	si_2_1: poarta_si2 port map(btn_min, carry_min_u, carry_min_u2);
	minute_z: numarator_mod6 port map(carry_min_u2, '1', carry_min_z, clk, out_min_z);
	afis_min_u: afisor_7seg port map('1', out_min_u, afisor_min_u);
	afis_min_z: afisor_7seg port map('1', out_min_z, afisor_min_z);
	
	min_u <= out_min_u;
	min_z <= out_min_z;
	
	--ore			1ora = 360000ns => 23ore:59min:59s = 8639900ns
	oree_u: numarator_mod10 port map(btn_ore, reset_ore, carry_ore_u, clk, out_ore_u);
	si_2_2: poarta_si2 port map(btn_ore, carry_ore_u, carry_ore_u2);
	oree_z: numarator_mod3 port map(carry_ore_u2, reset_ore, carry_ore_z, clk, out_ore_z);	
	afis_ore_u: afisor_7seg port map('1', out_ore_u, afisor_ore_u);
	afis_ore_z: afisor_7seg port map('1', out_ore_z, afisor_ore_z);
	
	sinu: process(clk)
	begin
		if(rising_edge(clk) and out_ore_u(1)='1' and out_ore_u(0)='1' and out_ore_z(1)='1'  and btn_ore='1')then reset_ore <= '0';	
		else reset_ore <= '1';
		end if;
	end process;
	
	ore_u <= out_ore_u;
	ore_z <= out_ore_z;
end;