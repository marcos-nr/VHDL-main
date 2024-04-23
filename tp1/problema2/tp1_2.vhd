library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp1_2 is
    port (
        clk_50 : in std_logic;
        led : out std_logic
    );
end tp1_2;

ARCHITECTURE logic of tp1_2 is
    COMPONENT conta
        generic	(
            MIN_COUNT : natural := 0;
            MAX_COUNT : natural := 256	);

        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT);
    END COMPONENT;

begin
    A1: conta GENERIC MAP (0, 12) PORT MAP (clk_50,'0','1',led,OPEN);
end architecture;