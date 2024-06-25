library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_falso_spi is
end tb_falso_spi;

architecture rtl of tb_falso_spi is
component falso_spi is
    port (
        clk : in std_logic;
        in1, in2, in3: in std_logic := '0';
        --rst : in std_logic;
        pwm_o: out std_logic := '0'
    );
end component;

signal clk, in1, in2, in3, pwm_o: std_logic;


begin

    uud: falso_spi port map(clk, in1, in2, in3, pwm_o);

    process
    begin
       in1 <= '1';
       wait for 50 ns;
       in1 <= '0';
       wait for 10 ns;
       in2 <= '1';
       wait for 50 ns;
       in2 <= '0';
       wait for 10 ns;
       in3 <= '1';
       wait for 50 ns;
       in3 <= '0';
       wait for 10 ns;
    end process;

end architecture;