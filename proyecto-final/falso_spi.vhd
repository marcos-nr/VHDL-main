library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity falso_spi is
    port (
        clk : in std_logic;
        in1, in2, in3: in std_logic := '0';
        --rst : in std_logic;
        pwm_o: out std_logic := '0'
    );
end entity;

architecture rtl of falso_spi is
    component pwm is
        generic	(
            MIN_COUNT : natural := 0;
            init_pulse: natural := 50000; --50E3 pulsos es 1 ms
            MAX_COUNT : natural := 1000000); --1E6 pulsos es 20 ms
        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT;
            duty      : in integer
            );
    end component;

    signal duty: integer; --range 0 to 50E3;
    
begin

    INST_PWM0: pwm generic map (0, 50E3, 1E6) port map (clk, '0', '1', pwm_o, open, duty);


    process(in1, in2, in3)
    begin
        if (in1 = '1') then duty <= 0;
        elsif (in2 = '1') then duty <= 2000 * 1221 / 100;
        elsif (in3 = '1') then duty <= 4094 * 1221 / 100;
        end if;
    end process;

end architecture;