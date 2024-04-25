library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_tp2_1 is
end tb_tp2_1;

architecture rtl of tb_tp2_1 is

    COMPONENT tp2_1
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
        led : out std_logic
    );
    END COMPONENT;

    SIGNAL clock, key, enable, reset, led: STD_LOGIC;
    SIGNAL segmentos: STD_LOGIC_VECTOR(6 DOWNTO 0);

begin

    uut: tp2_1 PORT MAP (clock, key, segmentos, enable, reset, led);
    process
    begin
        reset <='0';
        key <='0';
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        key <='1';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        key <='0';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        key <='1';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        reset <= '1';
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        reset <='0';
        clock <='1';
        key <='0';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        key <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        key <='0';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        key <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        key <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        key <='0';
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        clock <='1';
        wait for 10 ns;
        clock <='0';
        wait for 10 ns;
        key <='1';
        

    end process;

end architecture;