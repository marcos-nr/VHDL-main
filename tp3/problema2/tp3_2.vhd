library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp3_2 is
    generic (
        min_cuenta: integer := 0;
        max_cuenta: integer := 1000
    );
    port (
        clk     :   in std_logic;
        reset   :   in std_logic;
        up, down:   in std_logic;
        enable_disp: out std_logic_vector(3 downto 0);
        segmentos:  out std_logic_vector (6 DOWNTO 0)
    );
end tp3_2;

architecture rtl of tp3_2 is

    COMPONENT conta
        generic	(
            MIN_COUNT : natural := 0;
            MAX_COUNT : natural := 256	);

        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT	);
    END COMPONENT;

    COMPONENT display_cyclone2
        port (
            segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
            bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT full_display2
        generic(
            max_clk : integer := 50E6
        );

        port(
            clk		    : in	std_logic;
            reset       : in	std_logic;
            dig3, dig2, dig1, dig0 		: in	std_logic_vector(3 DOWNTO 0) := "0000";
            enable_disp : out   std_logic_vector (3 downto 0);
            segmentos   : out	std_logic_vector (6 downto 0)
        );
    END COMPONENT;

    COMPONENT Antirrebote2
        Port (
            clk : in STD_LOGIC;          -- Entrada del reloj
            key : in STD_LOGIC;          -- Entrada de la tecla
            debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
        );
    END COMPONENT;

    SIGNAL debounced_reset, debounced_up, debounced_down: std_logic;
    SIGNAL dig3,dig2,dig1,dig0: std_logic_vector (3 DOWNTO 0);

begin

    A: Antirrebote2 port map (clk, reset, debounced_reset);
    B: Antirrebote2 port map (clk, up, debounced_up);
    C: Antirrebote2 port map (clk, down, debounced_down);
    D: full_display2 generic map (6) port map (clk, debounced_reset, dig3, dig2, dig1, dig0, enable_disp, segmentos);
    

    process(clk, debounced_down, debounced_up, debounced_reset)
        variable cuenta: integer range 0 to max_cuenta;
        variable temp: integer range 0 to 9;
        variable up_reg, down_reg, reset_reg: std_logic:='1'; --guardan el valor anterior en cada ciclo del proceso
    begin
		if (rising_edge(clk)) then
			  if (debounced_reset = '0' and reset_reg = '1') then
					cuenta := min_cuenta;
			  end if;

			  if(debounced_up = '0' and up_reg = '1') then
					if (cuenta /= max_cuenta) then
						 cuenta:= cuenta + 1;
					end if;
			  end if;

			  if(debounced_down = '0' and down_reg = '1') then
					if (cuenta /= min_cuenta) then
						 cuenta:= cuenta - 1;
					end if;
			  end if;
              up_reg := debounced_up;
              down_reg := debounced_down;
              reset_reg := debounced_reset;
		end if;

        temp := cuenta / 1000;
        dig3 <= std_logic_vector(to_unsigned(temp,dig3'length));
        temp := (cuenta mod 1000) / 100;
        dig2 <= std_logic_vector(to_unsigned(temp,dig3'length));
        temp := (cuenta mod 100) / 10;
        dig1 <= std_logic_vector(to_unsigned(temp,dig3'length));
        temp := (cuenta mod 10);
        dig0 <= std_logic_vector(to_unsigned(temp,dig3'length));

    end process;

end architecture;