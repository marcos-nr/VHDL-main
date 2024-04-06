library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp1_1 is
    port (
        z: out std_logic;
        a, b, c: in std_logic
    );
end tp1_1;

architecture logic of tp1_1 is
begin
    z <= (a and b) or (a and c);
end architecture;