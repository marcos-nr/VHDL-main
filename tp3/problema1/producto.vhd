library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity producto is
    port (
        a, b: in integer range 0 to 100;
        s: out integer range 0 to 10000
    );
end producto;

architecture rtl of producto is
begin
    s <= a * b ;
end architecture;