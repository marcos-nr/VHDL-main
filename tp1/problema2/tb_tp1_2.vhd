library ieee;
use ieee.std_logic_1164.all;


entity tb_tp1_2 is
end tb_tp1_2;

architecture logic of tb_tp1_2 is

component tp1_2 is	  -- declaro componente de paridades.vhdl
	port
	(
        clk_50 : in std_logic;
        led : out std_logic
	);
end component;
signal clock : std_logic;
signal salida : std_logic;

begin

	uut: tp1_2 port map (clock, salida); -- instancio paridades
	Process 
	begin
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
	End process;	
end logic;