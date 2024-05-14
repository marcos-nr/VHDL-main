-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity mef is
    generic (
        max_clock: integer := 50E6
    );

	port(
		clk		 : in	std_logic;
        reset : in std_logic;
		key_asc, key_desc	 : in	std_logic;
        enable_disp: out std_logic;
		segmentos: out std_logic_vector (6 downto 0)
	);

end entity;

architecture rtl of mef is
    component conta
        generic	(
            MIN_COUNT : natural := 0;
            MAX_COUNT : natural := 256	);

        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT	);
    end component;

    component display_cyclone4
        port (
            segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
            bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
            enable: out STD_LOGIC
        );
    end component;

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);
    type ciclo is (asc, desc);

	-- Register to hold the current state
	signal state   : state_type := s0;
    signal secuencia : ciclo := asc;
    signal cuenta: integer range 0 to max_clock;
    signal bcd: std_logic_vector (3 downto 0);

begin

    A: conta GENERIC MAP (0, max_clock) PORT MAP (clk, '0', '1', open, cuenta);
    B: display_cyclone4 PORT MAP (segmentos, bcd, enable_disp);

	-- Logic to advance to the next state
	process (clk, reset)
	begin
        if (key_asc = '1') then
            secuencia <= asc;
			end if;
        
		  if (key_desc = '1') then
            secuencia <= desc;
        end if;

		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk) and (cuenta = max_clock-1)) then
			case state is
				when s0=>
                    if secuencia = asc then
                        state <= s1;
                    else
                        state <= s3;
                    end if;
				when s1=>
					if secuencia = asc then
						state <= s2;
					else
						state <= s0;
					end if;
				when s2=>
					if secuencia = asc then
						state <= s3;
					else
						state <= s1;
					end if;
				when s3 =>
					if secuencia = asc then
						state <= s0;
					else
						state <= s2;
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				bcd <= "0001";
			when s1 =>
				bcd <= "0010";
			when s2 =>
				bcd <= "0011";
			when s3 =>
				bcd <= "0100";
		end case;
	end process;

end rtl;