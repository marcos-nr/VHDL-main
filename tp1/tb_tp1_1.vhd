library ieee;
use ieee.std_logic_1164.all;


entity tb_tp1_1 is
end tb_tp1_1;

architecture logic of tb_tp1_1 is

component tp1_1 is	  -- declaro componente de paridades.vhdl
	port
	(
        z: out std_logic;
        a, b, c: in std_logic
	);
end component;
signal In1, In2, In3 : std_logic;
signal salida : std_logic;
begin

	uut: tp1_1 port map (salida, In1, In2, In3); -- instancio paridades
	Process 
	begin
		In1 <= '0'; wait for 10 ns;
		In2 <= '0'; wait for 10 ns;
        In3 <= '0'; wait for 10 ns;

		In3 <= '1'; wait for 10 ns;

		In2 <= '1'; wait for 10 ns;
        In3 <= '0'; wait for 10 ns;

        In2 <= '1'; wait for 10 ns;
		In3 <= '1'; wait for 10 ns;
		
        In1 <= '1'; wait for 10 ns;
		In2 <= '0'; wait for 10 ns;
        In3 <= '0'; wait for 10 ns;

        In3 <= '1'; wait for 10 ns;

		In2 <= '1'; wait for 10 ns;
        In3 <= '0'; wait for 10 ns;

        In2 <= '1'; wait for 10 ns;
		In3 <= '1'; wait for 10 ns;

	End process;	
end logic;