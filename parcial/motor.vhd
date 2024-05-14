-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity motor is
    generic (
        max_clock: integer := 500000
    );

	port(
		clk		 : in	std_logic;
        --reset : in std_logic;
		key_asc, key_desc, key_frec : in std_logic;
        enable_disp: out std_logic;
		segmentos: out std_logic_vector (6 downto 0);
        salida: out std_logic_vector (3 downto 0)
	);

end entity;

architecture rtl of motor is
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
	type state_type is (s1, s2, s3, s4, s5, s6, s7, s8);
    --type ciclo is (asc, desc);

	-- Register to hold the current state
	signal state   : state_type := s1;
    --signal secuencia : ciclo := asc;
    signal cuenta, cuenta_maxima, aux: integer range 0 to max_clock;
    signal cuenta2: integer range 0 to max_clock/5;
    signal bcd_disp: std_logic_vector (3 downto 0);

begin

    A: conta GENERIC MAP (0, max_clock) PORT MAP (clk, '0', '1', open, cuenta);
    A2: conta GENERIC MAP (0, (max_clock/5)) PORT MAP (clk, '0', '1', open, cuenta2);
    B: display_cyclone4 PORT MAP (segmentos, bcd_disp, enable_disp);

	-- Logic to advance to the next state
	process (clk, key_frec)
	begin
		if key_frec = '1' then
			cuenta_maxima <= max_clock/5;
            aux <= cuenta2;
        else
            cuenta_maxima <= max_clock;
            aux <= cuenta;
        end if;

        if key_asc = key_desc then bcd_disp <= "0000";
        elsif key_asc = '1' then bcd_disp <= "0001";
        elsif key_desc = '1' then bcd_disp <= "0010";
        end if;

		if (rising_edge(clk) and (aux = cuenta_maxima-1)) then
			case state is
				when s1=>
                    if (key_asc = key_desc) then
                        state <= s1; 
                    elsif key_asc = '1' then
						state <= s2;
					elsif key_desc = '1' then
						state <= s8;
					end if;
				when s2=>
                    if (key_asc = key_desc) then
                        state <= s2; 
                    elsif key_asc = '1' then
						state <= s3;
					elsif key_desc = '1' then
						state <= s1;
					end if;
				when s3 =>
               if (key_asc = key_desc) then
                  state <= s3; 
               elsif key_asc = '1' then
						state <= s4;
					elsif key_desc = '1' then
						state <= s2;
					end if;
            when s4=>
                    if (key_asc = key_desc) then
                        state <= s4;
                    elsif key_asc = '1' then
						state <= s5;
					elsif key_desc = '1' then
						state <= s3;
					end if;
				when s5=>
                    if (key_asc = key_desc) then
                        state <= s5; 
                    elsif key_asc = '1' then
						state <= s6;
					elsif key_desc = '1' then
						state <= s4;
					end if;
				when s6 =>
                    if (key_asc = key_desc) then
                        state <= s6; 
                    elsif key_asc = '1' then
						state <= s7;
					elsif key_desc = '1' then
						state <= s5;
					end if;
                when s7 =>
                     if (key_asc = key_desc) then
                        state <= s7; 
                    elsif key_asc = '1' then
                         state <= s8;
                     elsif key_desc = '1' then
                         state <= s6;
                    end if;
                 when s8 =>
                    if (key_asc = key_desc) then
                        state <= s8; 
                    elsif key_asc = '1' then
                        state <= s1;
                    elsif key_desc = '1' then
                        state <= s7;
                    end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s1 =>
				salida <= "1000";
			when s2 =>
				salida <= "1100";
			when s3 =>
				salida <= "0100";
			when s4 =>
				salida <= "0110";
            when s5 =>
                salida <= "0010";
            when s6 =>
                salida <= "0011";
            when s7 =>
                salida <= "0001";
            when s8 =>
                salida <= "1001";
		end case;
	end process;

end rtl;