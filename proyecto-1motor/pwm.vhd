library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
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
end entity;
architecture rtl of pwm is
begin
	process (clk)
		variable   cnt: integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then
			if reset = '1' then
				cnt := 0;
			elsif enable = '1' then cnt := cnt + 1;
				if cnt <= duty + init_pulse then cout<='1'; --50000 = 1ms , 0 < duty < 50000
				else cout<='0';
				end iF;
				if cnt=MAX_COUNT then cnt:=0; end if;
			end if;
		end if;
		q <= cnt;
		--if cnt=MAX_COUNT then cnt:=0; end if;
	end process;
end rtl;


