library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prueba is
    port (
        clk         :   in std_logic;
        reset       :   in std_logic;
        dig3, dig2, dig1, dig0 		: in	std_logic_vector(3 DOWNTO 0) := "0000";
        enable_disp :   out std_logic_vector(3 DOWNTO 0);
        segmentos   :   out std_logic_vector(6 DOWNTO 0)
    );
end prueba;

architecture rtl of prueba is
    COMPONENT tp2_3
        generic(
            max_clk : integer := 50E6
        );

        port(
            clk		    : in	std_logic;
            reset       : in	std_logic;
            dig3, dig2, dig1, dig0 		: in	std_logic_vector(3 DOWNTO 0) := "0000";
            enable_disp : out   std_logic_vector(3 downto 0);
            segmentos   : out	std_logic_vector(6 downto 0)
        );
    END COMPONENT;

    COMPONENT Antirrebote2
        Port (
            clk : in STD_LOGIC;          -- Entrada del reloj
            key : in STD_LOGIC;          -- Entrada de la tecla
            debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
        );
    END COMPONENT;

    SIGNAL debounced_reset: std_logic :='0';
    --SIGNAL d3, d2, d1, d0: std_logic_vector (3 DOWNTO 0) := "0000";

begin

    D: Antirrebote2 port map (clk, reset, debounced_reset);
    A: tp2_3 generic map (8) port map (clk, '0', dig3, dig2, dig1, dig0, enable_disp, segmentos);

end architecture;