library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_cyclone4 is
    port (
        segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
        bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end display_cyclone4;

architecture logic of display_cyclone4 is
    TYPE rom_deco IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(6 DOWNTO 0);
    CONSTANT mem_deco: rom_deco:= ("0000001", "1001111", "0010010", "0000110", "1001100", "0100100", "0100000", "0001111",
    "0000000", "0000100", "0001000", "1100000", "0110001", "1000010", "0110000", "0111000");
begin

    WITH bcd SELECT
        segmentos <= mem_deco(15) WHEN "0000",
                     mem_deco(14) WHEN "0001",
                     mem_deco(13) WHEN "0010",
                     mem_deco(12) WHEN "0011",
                     mem_deco(11) WHEN "0100",
                     mem_deco(10) WHEN "0101",
                     mem_deco(9) WHEN "0110",
                     mem_deco(8) WHEN "0111",
                     mem_deco(7) WHEN "1000",
                     mem_deco(6) WHEN "1001",
                     mem_deco(5) WHEN "1010",
                     mem_deco(4) WHEN "1011",
                     mem_deco(3) WHEN "1100",
                     mem_deco(2) WHEN "1101",
                     mem_deco(1) WHEN "1110",
                     mem_deco(0) WHEN OTHERS;

end architecture;