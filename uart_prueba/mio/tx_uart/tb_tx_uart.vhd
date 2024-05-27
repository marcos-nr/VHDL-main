library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_tx_uart is
end tb_tx_uart;

architecture rtl of tb_tx_uart is
    component tx_uart
        port
        (
            clk,reset: in  std_logic:='0';
            send : in std_logic;
            cadena : in std_LOGIC_VECTOR(7 downto 0);
            tx, done : out std_logic:='0'
        );
    end component;

    SIGNAL clk, reset, send, tx, done: std_logic;
    SIGNAL cadena: std_logic_vector(7 downto 0);

begin

    uut: tx_uart PORT MAP (clk, reset, send, cadena, tx, done);

    PROCESS
    BEGIN
    clk <= '0';
    reset <= '0';
    send <= '1';
    cadena <= x"72";
    wait for 10 ns;
    for i in 0 to 25 loop
        clk <= not clk;
        wait for 10 ns;
    end loop;
    send <= '1';
    reset <= '0';
    for i in 0 to 50 loop
        clk <= not clk;
        wait for 10 ns;
    end loop;
    END PROCESS;

end architecture;