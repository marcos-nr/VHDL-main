library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_transmisor_uart is
end tb_transmisor_uart;

architecture rtl of tb_transmisor_uart is
    component transmisor_uart
    generic (
        baudios: integer:=5208
    );
    port (
        clk, reset, key: in std_logic;
        tx: out std_logic
    );
    end component;

    signal clk, reset, key, tx: std_logic;
begin

    uut: transmisor_uart generic map(4) port map (clk, reset, key, tx);

    process
    begin
        clk <='0';
        reset <= '0';
        key <= '0';
      
        wait for 10 ns;
    end process;

end architecture;