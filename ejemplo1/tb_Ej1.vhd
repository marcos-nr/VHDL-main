library ieee;
use ieee.std_logic_1164.all;


entity tb_Ej1 is
end tb_Ej1;

architecture a of tb_Ej1 is

component Ej1 is	  -- declaro componente de paridades.vhdl
	port
	(
	
		W	: out std_logic;
		A    : in std_logic;
		B 	: in std_logic
		
	);
end component;
signal In1, In2 : std_logic;
signal salida : std_logic;
begin

	uut: Ej1  port map (salida,In1, In2); -- instancio paridades
	Process 
	begin
		In1 <= '0'; wait for 10 ns;
		In2 <= '0'; wait for 10 ns;
		In1 <= '1'; wait for 10 ns;
		In2 <= '1'; wait for 10 ns;
		

		
	End process;	
end a;