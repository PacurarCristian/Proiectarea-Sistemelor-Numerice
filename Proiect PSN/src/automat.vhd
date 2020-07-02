library	IEEE;
use ieee.std_logic_1164.all;

entity automat is
	port(clk: in std_logic;
	btn_ore, btn_min, btn_oprire_alarma, btn_oprire_radio, btn_oprire_ceas: in std_logic :='0'; 
	btn_stare: in std_logic :='0';
	reset_ceas: in std_logic :='1'; 
	bec_alarma, bec_radio, bec_stare_ceas, bec_stare_alarma, bec_stare_radio: out std_logic :='0';
	ore_z, ore_u, min_z, min_u: out std_logic_vector(6 downto 0) := "0000000");
end;

architecture auto of automat is

component ceas
	port(btn_ore, btn_min: in std_logic :='0';
	reset: in std_logic := '1';
	clk: in std_logic;
	ore_z: out std_logic_vector(3 downto 0) := "0000";
	ore_u: out std_logic_vector(3 downto 0) := "0000";
	min_z: out std_logic_vector(3 downto 0) := "0000";
	min_u: out std_logic_vector(3 downto 0) := "0000");
end component;

component alarma
	port(btn_ore, btn_min: in std_logic :='0';
	clk: in std_logic;
	ore_z: out std_logic_vector(3 downto 0) := "0000";
	ore_u: out std_logic_vector(3 downto 0) := "0000";
	min_z: out std_logic_vector(3 downto 0) := "0000";
	min_u: out std_logic_vector(3 downto 0) := "0000");
end component;

component radio
	port(btn_ore, btn_min: in std_logic :='0';
	clk: in std_logic;
	ore_z: out std_logic_vector(3 downto 0) := "0000";
	ore_u: out std_logic_vector(3 downto 0) := "0000";
	min_z: out std_logic_vector(3 downto 0) := "0000";
	min_u: out std_logic_vector(3 downto 0) := "0000");
end component; 

component numarator_mod3_v2
	port(btn: in std_logic :='0';
	clk: in std_logic;
	q: inout std_logic_vector(1 downto 0) :="00");
end component;

component afisor_7seg
	port(enable: in std_logic :='1';
	x: in std_logic_vector(3 downto 0) :="0000";
	q: out std_logic_vector(6 downto 0) :="0000000");
end component;

component demux_1_3
	port(s: in std_logic_vector(1 downto 0);
	x: in std_logic;
	a,b,c: out std_logic);
end component;

component mux_16_4
	port(ceas: in std_logic_vector(3 downto 0);
	alarma: in std_logic_vector(3 downto 0);
	radio: in std_logic_vector(3 downto 0);
	s: in std_logic_vector(1 downto 0);
	q: out std_logic_vector(3 downto 0) :="0000");
end component;

signal btn_min_ceas, btn_min_alarma, btn_min_radio: std_logic :='0';
signal btn_ore_ceas, btn_ore_alarma, btn_ore_radio: std_logic :='0';

signal ore_z_ceas, ore_u_ceas, min_z_ceas, min_u_ceas: std_logic_vector(3 downto 0) := "0000";
signal ore_z_alarma, ore_u_alarma, min_z_alarma, min_u_alarma: std_logic_vector(3 downto 0) := "0000";
signal ore_z_radio, ore_u_radio, min_z_radio, min_u_radio: std_logic_vector(3 downto 0) := "0000";

signal afis_min_u, afis_min_z, afis_ore_u, afis_ore_z: std_logic_vector(3 downto 0) :="0000";
signal enable_afis: std_logic :='1';
signal s: std_logic_vector(1 downto 0) :="00";

begin
	stare: numarator_mod3_v2 port map(btn_stare, clk, s);
	demux_min_ceas_1: demux_1_3 port map(s, btn_min, btn_min_ceas, btn_min_alarma, btn_min_radio);
	demux_min_ceas_2: demux_1_3 port map(s, btn_ore, btn_ore_ceas, btn_ore_alarma, btn_ore_radio);
	
	ceass: ceas port map(btn_ore_ceas, btn_min_ceas, reset_ceas, clk, ore_z_ceas, ore_u_ceas, min_z_ceas, min_u_ceas);
	alarmaa: alarma port map(btn_ore_alarma, btn_min_alarma, clk, ore_z_alarma, ore_u_alarma, min_z_alarma, min_u_alarma);
	radioo: radio port map(btn_ore_radio, btn_min_radio, clk, ore_z_radio, ore_u_radio, min_z_radio, min_u_radio);
	
	nxor_si: process(clk)
	begin 
		if(ore_z_ceas=ore_z_alarma and ore_u_ceas=ore_u_alarma and min_z_ceas=min_z_alarma and min_u_ceas=min_u_alarma and btn_oprire_alarma='0')then
			bec_alarma <= '1';
		else bec_alarma <= '0';
		end if;
		
		if(ore_z_ceas=ore_z_radio and ore_u_ceas=ore_u_radio and min_z_ceas=min_z_radio and min_u_ceas=min_u_radio and btn_oprire_radio='0')then 
			bec_radio <= '1';
		elsif(btn_oprire_radio='1')then bec_radio <= '0';
		end if;
	end process;
	
	mux_afis_min_u: mux_16_4 port map(min_u_ceas, min_u_alarma, min_u_radio, s, afis_min_u);
	mux_afis_min_z: mux_16_4 port map(min_z_ceas, min_z_alarma, min_z_radio, s, afis_min_z);
	mux_afis_ore_u: mux_16_4 port map(ore_u_ceas, ore_u_alarma, ore_u_radio, s, afis_ore_u);
	mux_afis_ore_z: mux_16_4 port map(ore_z_ceas, ore_z_alarma, ore_z_radio, s, afis_ore_z);
	
	afisor_min_u: afisor_7seg port map(enable_afis, afis_min_u, min_u);
	afisor_min_z: afisor_7seg port map(enable_afis, afis_min_z, min_z);
	afisor_ore_u: afisor_7seg port map(enable_afis, afis_ore_u, ore_u);
	afisor_ore_z: afisor_7seg port map(enable_afis, afis_ore_z, ore_z);
	
	process(btn_oprire_ceas)
	begin
		if(btn_oprire_ceas='1')then enable_afis <= '0';
		else enable_afis <= '1';
		end if;
	end process; 
	
	demux: process(s)
	begin 
		if(s="00")then 
			bec_stare_ceas <= '1';
			bec_stare_alarma <= '0';
			bec_stare_radio <= '0';
		elsif(s="01")then
			bec_stare_ceas <= '0';
			bec_stare_alarma <= '1';
			bec_stare_radio <= '0';
		else  
			bec_stare_ceas <= '0';
			bec_stare_alarma <= '0';
			bec_stare_radio <= '1';
		end if;
	end process;
end;