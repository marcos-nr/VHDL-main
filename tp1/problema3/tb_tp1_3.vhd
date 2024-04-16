library ieee;
use ieee.std_logic_1164.all;


entity tb_tp1_3 is
end tb_tp1_3;

architecture logic of tb_tp1_3 is

component tp1_3 is	  -- declaro componente de paridades.vhdl
    port (
        votos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        display: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
end component;
signal vot : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal disp : STD_LOGIC_VECTOR(6 DOWNTO 0);

begin

	uut: tp1_3 port map (vot, disp); -- instancio paridades
	Process 
	begin
        vot <= "0000";
        wait for 10 ns;
        vot <= "0001";
        wait for 10 ns;
        vot <= "0010";
        wait for 10 ns;
        vot <= "0011";
        wait for 10 ns;
        vot <= "0100";
        wait for 10 ns;
        vot <= "0101";
        wait for 10 ns;
        vot <= "0110";
        wait for 10 ns;
        vot <= "0111";
        wait for 10 ns;
        vot <= "1000";
        wait for 10 ns;
        vot <= "1001";
        wait for 10 ns;
        vot <= "1010";
        wait for 10 ns;
        vot <= "1011";
        wait for 10 ns;
        vot <= "1100";
        wait for 10 ns;
        vot <= "1101";
        wait for 10 ns;
        vot <= "1110";
        wait for 10 ns;
        vot <= "1111";
        wait for 10 ns;
	End process;	
end logic;