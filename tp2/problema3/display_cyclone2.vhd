library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_cyclone2 is
    port (
        segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
        bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
        enable: out STD_LOGIC
    );
end display_cyclone2;

architecture logic of display_cyclone2 is
    TYPE rom_deco IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(6 DOWNTO 0);
    CONSTANT mem_deco: rom_deco:= ("1111110", "0110000", "1101101", "1111001", "0110011", "1011011", "1011111", "1110000",
    "1111111", "1111011", "1110111", "0011111", "1001110", "0111101", "1001111", "1000111");
begin
    enable <= '1';
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