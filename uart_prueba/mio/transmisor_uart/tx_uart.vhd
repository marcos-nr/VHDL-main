library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity tx_uart is
	port
	(
		clk,reset: in  std_logic:='0';
		send : in std_logic;
		cadena : in std_LOGIC_VECTOR(7 downto 0);
		tx, done: out std_logic:='1'
	);
end tx_uart;
architecture a_t_uart of tx_uart is

type mef is (idle, start, d0,d1,d2,d3,d4,d5,d6,d7,stop);
signal estado:mef;

signal ds: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal done_aux: std_logic := '1';

Begin
done <= done_aux;

	process(clk,reset)
	begin
		
		if (reset = '1') then 
			estado <= idle;
			done_aux <= '1';
		elsif (rising_edge(clk)) then
			if (send='1' and done_aux='1') then--done=1 para que no se vuelva a ejecutar hasta terminar el envio 
			ds <= cadena;
			estado <= start;
			--done_aux <= '0';
			else	
			case estado is 
				when idle => 
					estado <= idle;
					done_aux <= '1';
				when start => 
					estado <= d0;
					done_aux <= '0';
				when d0 => 
					estado <= d1;
					done_aux <= '0';
				when d1 => 
					estado <= d2;
					done_aux <= '0';
				when d2 => 
					estado <= d3;
					done_aux <= '0';
				when d3 => 
					estado <= d4;
					done_aux <= '0';
				when d4 => 
					estado <= d5;
					done_aux <= '0';
				when d5 => 
					estado <= d6;
					done_aux <= '0';
				when d6 => 
					estado <= d7;
					done_aux <= '0';
				when d7 => 
					estado <= stop;
					done_aux <= '0'; 
				when stop => 
					estado <= idle;					
			end case;
			end if;
		end if;
	end process;
	
	
	process (estado,ds)
	Begin
			case estado is 
				when idle => tx<='1'; 
				when start => tx<='0';
				when d0 => tx<=ds(0);
				when d1 => tx<=ds(1);
				when d2 => tx<=ds(2);
				when d3 => tx<=ds(3);
				when d4 => tx<=ds(4);
				when d5 => tx<=ds(5);
				when d6 => tx<=ds(6);
				when d7 => tx<=ds(7);
				when stop => tx<='0'; 
			end case;
	end process;
end a_t_uart;