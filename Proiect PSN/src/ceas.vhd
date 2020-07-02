library	IEEE;
use ieee.std_logic_1164.all;

entity ceas is
	port(btn_ore, btn_min: in std_logic :='0';
	reset: in std_logic := '1';
	clk: in std_logic;
	ore_z: out std_logic_vector(3 downto 0) := "0000";
	ore_u: out std_logic_vector(3 downto 0) := "0000";
	min_z: out std_logic_vector(3 downto 0) := "0000";
	min_u: out std_logic_vector(3 downto 0) := "0000");
end;

architecture c of ceas is

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

component invertor
	port(x: in std_logic;
	y: inout std_logic);
end component;

component poarta_si2
	port(a,b: in std_logic;
	f: out std_logic);
end component;	

component poarta_si4
	port(a,b,c,d: in std_logic;
	f: inout std_logic);
end component;

component poarta_si5
	port(a,b,c,d,e: in std_logic;
	f: inout std_logic);
end component;

component poarta_sau2
	port(a,b: in std_logic;
	f: out std_logic);
end component;

component afisor_7seg
	port(enable: in std_logic :='1';
	x: in std_logic_vector(3 downto 0) :="0000";
	q: out std_logic_vector(6 downto 0) :="0000000");
end component; 

signal carry_sec_u, carry_sec_z, enable_min_u: std_logic :='0';	
signal reset_sec1, reset_sec2: std_logic :='1';
signal out_sec_u, out_sec_z: std_logic_vector(3 downto 0) := "0000";
signal afisor_sec_u, afisor_sec_z: std_logic_vector(6 downto 0) :="0000000";

signal carry_min_u, carry_min_z, carry_min_u2, enable_ore_u: std_logic :='0';
signal reset_min1, reset_min2: std_logic :='1';	
signal out_min_u, out_min_z: std_logic_vector(3 downto 0) := "0000";  
signal afisor_min_u, afisor_min_z: std_logic_vector(6 downto 0) :="0000000";

signal carry_ore_u, carry_ore_z, carry_ore_u2: std_logic :='0';
signal reset_ore: std_logic :='1';	
signal out_ore_u, out_ore_z: std_logic_vector(3 downto 0) := "0000";  
signal afisor_ore_u, afisor_ore_z: std_logic_vector(6 downto 0) :="0000000";   

begin	
	--secunde		1s = 100ns => 59s = 5900ns
	sec_u: numarator_mod10 port map('1', reset, carry_sec_u, clk, out_sec_u);
	sec_z: numarator_mod6 port map(carry_sec_u, reset, carry_sec_z, clk, out_sec_z);
	si_4: poarta_si4 port map(out_sec_u(3), out_sec_u(0), out_sec_z(2), out_sec_z(0), reset_sec1);    
	sau_2_1: poarta_sau2 port map(reset_sec1, btn_min, enable_min_u);
	afis_sec_u: afisor_7seg port map('1', out_sec_u, afisor_sec_u);
	afis_sec_z: afisor_7seg port map('1', out_sec_z, afisor_sec_z);
	
	--minute	    59min = 354000ns => 59min:59s = 359900ns
	minute_u: numarator_mod10 port map(enable_min_u, reset, carry_min_u, clk, out_min_u);
	si_2_1: poarta_si2 port map(enable_min_u, carry_min_u, carry_min_u2);
	minute_z: numarator_mod6 port map(carry_min_u2, reset, carry_min_z, clk, out_min_z);
	si_5_1: poarta_si5 port map(out_min_u(3), out_min_u(0), out_min_z(2), out_min_z(0), enable_min_u, reset_min1);
	sau_2_2: poarta_sau2 port map(reset_min1, btn_ore, enable_ore_u);
	afis_min_u: afisor_7seg port map('1', out_min_u, afisor_min_u);
	afis_min_z: afisor_7seg port map('1', out_min_z, afisor_min_z);
	
	min_u <= out_min_u;
	min_z <= out_min_z;
	
	--ore			1ora = 360000ns => 23ore:59min:59s = 8639900ns
	oree_u: numarator_mod10 port map(enable_ore_u, reset_ore, carry_ore_u, clk, out_ore_u);		
	si_2_2: poarta_si2 port map(enable_ore_u, carry_ore_u, carry_ore_u2);
	oree_z: numarator_mod3 port map(carry_ore_u2, reset_ore, carry_ore_z, clk, out_ore_z);	
	afis_ore_u: afisor_7seg port map('1', out_ore_u, afisor_ore_u);
	afis_ore_z: afisor_7seg port map('1', out_ore_z, afisor_ore_z);
	
	sinu_si: process(clk)
	begin
		if((rising_edge(clk) and out_ore_u(1)='1' and out_ore_u(0)='1' and out_ore_z(1)='1' and enable_ore_u='1') or reset='0')then 
			reset_ore <= '0';
		else reset_ore <= '1';
		end if;
	end process;
	
	ore_u <= out_ore_u;
	ore_z <= out_ore_z;
end;