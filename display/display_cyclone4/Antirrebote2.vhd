library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Antirrebote2 is
    Port (
        clk : in STD_LOGIC;          -- Entrada del reloj
        key : in STD_LOGIC;          -- Entrada de la tecla
        debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
    );
end Antirrebote2;

architecture Behavioral of Antirrebote2 is
    signal key_stable, last_key : std_logic;
begin
    -- Proceso para establecer la tecla sin rebotes
    process(clk)
    begin
        if rising_edge(clk) then
            -- Algoritmo de antirrebote utilizando XOR
            if key /= last_key then
                key_stable <= key;
            else
                key_stable <= key_stable;
            end if;
            -- Actualiza el estado anterior de la tecla
            last_key <= key;
        end if;
    end process;

    -- Asignación de la tecla estable al resultado
    debounced_key <= key_stable;
end Behavioral;
