library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp2_2 is
    generic (
        min_count : INTEGER := 0;
        max_count : INTEGER := 9;
        max_clk: integer := 50000000 --cuenta maxima que tendra el reloj
    );
    port (
        clk: in STD_LOGIC;
        start: IN STD_LOGIC;
        reset: IN STD_LOGIC;
        led_uv: OUT STD_LOGIC := '0';
        led_rojo: OUT STD_LOGIC := '0';
        led_conta: OUT STD_LOGIC := '0';
        segmentos: OUT STD_LOGIC_VECTOR (6 DOWNTO 0) := "1111110"
    );
end tp2_2;

architecture rtl of tp2_2 is

    COMPONENT conta
        generic	(
            MIN_COUNT : natural;
            MAX_COUNT : natural);
        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT);
    END COMPONENT;

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

    SIGNAL debounced_start, debounced_recet: STD_LOGIC;
    SIGNAL enable_conta, reset_conta: STD_LOGIC;
    SIGNAL bcd: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; --codigo bcd que se usa en el 7 segmentos
    SIGNAL cuenta: INTEGER RANGE 0 TO max_clk; --cuenta que devuelve el contador divisor de frecuencia
    SIGNAL enable_display: STD_LOGIC;
    SIGNAL segundos: INTEGER RANGE min_count TO max_count := 0;

begin
    A: Antirrebote2 PORT MAP (clk, start, debounced_start);
    B: Antirrebote2 PORT MAP (clk, reset, debounced_recet);

    PROCESS (clk, debounced_start, debounced_recet)
    BEGIN
        if (falling_edge(debounced_recet) or segundos = max_count) then
            enable_conta <= '0';
            reset_conta <= '1';
            segundos <= 0;
        end if;

        if (falling_edge(debounced_start)) then
            enable_conta <= '1';
            reset_conta <= '0';
        end if;

        if (rising_edge(clk)) then
            if(cuenta = max_clk-1) then
                segundos <= segundos + 1;
            end if;
        end if;

        led_rojo <= not enable_conta;
        led_uv <= enable_conta;
    END PROCESS;
    
    C: conta GENERIC MAP(0, max_clk) PORT MAP (clk,reset_conta,enable_conta,led_conta,cuenta);
    bcd <= std_logic_vector(to_unsigned(segundos,bcd'length));
    D: display_cyclone2 PORT MAP (segmentos, bcd, enable_display);

end architecture;