library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp2_1 is
    port (
        -- Antirrebote
        clk : in STD_LOGIC;          
        key : in STD_LOGIC;          
       --debounced_key : out STD_LOGIC;
        -- 7 Segmentos
        segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
        --bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
        enable: out STD_LOGIC;
        -- Contador de botellas
        reset : in std_logic;
        led : out std_logic := '0'
    );
end tp2_1;

architecture logic of tp2_1 is
    COMPONENT Antirrebote2
        Port (
            clk : in STD_LOGIC;          -- Entrada del reloj
            key : in STD_LOGIC;          -- Entrada de la tecla
            debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
        );
    END COMPONENT;

    COMPONENT display_cyclone2
        port (
            segmentos: out STD_LOGIC_VECTOR(6 DOWNTO 0);
            bcd: in STD_LOGIC_VECTOR(3 DOWNTO 0);
            enable: out STD_LOGIC
        );
    END COMPONENT;

    SIGNAL debounced_key: STD_LOGIC;
    SIGNAL aux: std_logic_vector(3 DOWNTO 0) := "0000";

begin
A: Antirrebote2 PORT MAP (clk, key, debounced_key);
    PROCESS (debounced_key)
    variable count: natural range 0 to 6 := 0;
    BEGIN
        if (rising_edge(debounced_key)) then
            if (reset = '1' or count = 6) then
                count := 0;
            else
                count := count + 1;
            end if;

            if (count = 6) then
               led <= '1';
            else
                led <= '0';
            end if;

            aux <= std_logic_vector(to_unsigned(count,aux'length));
        end if;
    END PROCESS;

B: display_cyclone2 PORT MAP(segmentos, aux, enable);

end architecture;