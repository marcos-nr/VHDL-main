library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp1_3 is
    port (
        votos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        display: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  enable: out std_logic
    );
end tp1_3;

architecture logic of tp1_3 is
begin
enable <= '1';
    WITH votos SELECT
    display <= "1110111" WHEN "0011" | "0101" | "0111" | "1001" | "1011" | "1101" | "1110" | "1111",
                "0111101" WHEN OTHERS;

end architecture;