library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pwm is
end tb_pwm;

architecture rtl of tb_pwm is

component pwm is
    generic	(
		MIN_COUNT : natural := 0;
        init_pulse: natural := 5;
		MAX_COUNT : natural := 256);
	port	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		cout: out std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT;
        duty      : in integer
        );
end component;

signal clk,reset,enable,cout: std_logic:= '0';
signal q: integer range 0 to 10;
signal duty: integer;

begin

    uud: pwm generic map (0, 3, 10) port map (clk,reset,enable,cout,q,duty);

    process
    begin
    reset <= '0';
    enable <= '1';
    duty <= 2;
    clk <= '0';

    for i in 0 to 20 loop
        clk <= not clk;
        wait for 10 ns;
    end loop;

    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    duty <= 4;

    for i in 0 to 20 loop
        clk <= not clk;
        wait for 10 ns;

    end loop;

    end process;

end architecture;