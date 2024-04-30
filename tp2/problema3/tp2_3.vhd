-- Quartus II VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp2_3 is
    generic(
        max_clk : integer := 50E6
    );

	port(
		clk		    : in	std_logic;
		reset       : in	std_logic;
        enable_disp : out   std_logic_vector(3 downto 0);
		segmentos   : out	std_logic_vector(6 downto 0)
	);

end entity;

architecture rtl of tp2_3 is
    component conta
        generic	(
            MIN_COUNT : natural := 0;
            MAX_COUNT : natural := 256
        );

        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout      : out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT
        );
    end component;

    COMPONENT display_cyclone2
        port (
            segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
            bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
            enable: out STD_LOGIC
        );
    END COMPONENT;

    COMPONENT Antirrebote2
        Port (
            clk : in STD_LOGIC;          -- Entrada del reloj
            key : in STD_LOGIC;          -- Entrada de la tecla
            debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
        );
    END COMPONENT;

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);

	-- Register to hold the current state
	signal state : state_type := s0;
    signal bcd: std_logic_vector(3 DOWNTO 0) := "0000";
    signal cuenta: integer range 0 to max_clk;
    signal debounced_reset: STD_LOGIC;
    signal enable_conta: std_logic :='1';

begin
    A: Antirrebote2 PORT MAP (clk, reset, debounced_reset);
    B: conta GENERIC MAP(0, max_clk) PORT MAP (clk,debounced_reset,enable_conta,open,cuenta);

    D0: display_cyclone2 PORT MAP (segmentos, bcd, enable_disp(0));
    D1: display_cyclone2 PORT MAP (segmentos, bcd, enable_disp(1));
    D2: display_cyclone2 PORT MAP (segmentos, bcd, enable_disp(2));
    D3: display_cyclone2 PORT MAP (segmentos, bcd, enable_disp(3));

	process (clk, debounced_reset)
	begin

		if debounced_reset = '1' then
			state <= s0;

		elsif (rising_edge(clk)) then
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>
					if cuenta = (max_clk-1) then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if cuenta = (max_clk-1) then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if cuenta = (max_clk-1) then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3=>
					if cuenta = (max_clk-1) then
						state <= s0;
					else
						state <= s3;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state)
	begin
			case state is
				when s0=>
					bcd <= "0001";
                    enable_disp <= "1000";
				when s1=>
                    bcd <= "0010";
                    enable_disp <= "0100";
				when s2=>
                    bcd <= "0011";
                    enable_disp <= "0010";
				when s3=>
                    bcd <= "0100";
                    enable_disp <= "0001";
			end case;
	end process;

end rtl;
