library ieee;
use ieee.std_logic_1164.all;


entity tb_display_cyclone2 is
end tb_display_cyclone2;

architecture logic of tb_display_cyclone2 is

component display_cyclone2 is	  -- declaro componente de paridades.vhdl
    port (
        segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
        bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
        enable: out STD_LOGIC
    );
end component;
signal seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
signal bcd : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal en: STD_LOGIC;

begin

	uut: display_cyclone2 port map (seg, bcd, en); -- instancio paridades
	Process 
	begin
        bcd <= "0000";
        wait for 10 ns;
        bcd <= "0001";
        wait for 10 ns;
        bcd <= "0010";
        wait for 10 ns;
        bcd <= "0011";
        wait for 10 ns;
        bcd <= "0100";
        wait for 10 ns;
        bcd <= "0101";
        wait for 10 ns;
        bcd <= "0110";
        wait for 10 ns;
        bcd <= "0111";
        wait for 10 ns;
        bcd <= "1000";
        wait for 10 ns;
        bcd <= "1001";
        wait for 10 ns;
        bcd <= "1010";
        wait for 10 ns;
        bcd <= "1011";
        wait for 10 ns;
        bcd <= "1100";
        wait for 10 ns;
        bcd <= "1101";
        wait for 10 ns;
        bcd <= "1110";
        wait for 10 ns;
        bcd <= "1111";
        wait for 10 ns;
	End process;	
end logic;