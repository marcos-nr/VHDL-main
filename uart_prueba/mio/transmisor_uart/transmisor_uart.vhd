library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmisor_uart is
    generic (
        baudios: integer:=5208
    );
    port (
        clk, reset, key: in std_logic;
        tx: out std_logic
    );
end transmisor_uart;

architecture rtl of transmisor_uart is
    COMPONENT conta
        generic	(
            MIN_COUNT : natural := 0;
            MAX_COUNT : natural := 256);

        port	(
            clk		  : in std_logic;
            reset	  : in std_logic;
            enable	  : in std_logic;
            cout: out std_logic;
            q		  : out integer range MIN_COUNT to MAX_COUNT);
    END COMPONENT;

    COMPONENT tx_uart
        port
        (
            clk,reset: in  std_logic:='0';
            send : in std_logic;
            cadena : in std_LOGIC_VECTOR(7 downto 0);
            tx, done: out std_logic:='1'
        );
    END COMPONENT;

    TYPE array_data IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mensaje: array_data:=
    --(x"77", x"65", x"82", x"67", x"79", x"83", x"32", x"82", x"79", x"74", x"65", x"83"); --"MARCOS ROJAS"
    (x"77", x"78", x"82");
    SIGNAL cadena: STD_LOGIC_VECTOR(7 DOWNTO 0) := mensaje(0);

    SIGNAL clk_tx, clk_12tx, send, bandera, reset_tx: STD_LOGIC := '0';
    SIGNAL done: STD_LOGIC := '1';
	 
begin
    inst_conta: conta GENERIC MAP(0,baudios) PORT MAP(clk, reset, '1', clk_tx, OPEN);
   -- inst_conta2: conta GENERIC MAP(0,12) PORT MAP(clk_tx, reset, '1', clk_12tx, OPEN);
    inst_tx: tx_uart PORT MAP (clk_tx, reset, send, cadena, tx, done);

    PROCESS (clk_tx, reset, key)
    VARIABLE i: integer range 0 to mensaje'length:=0;
    BEGIN
        if (reset = '1') then
            send <= '0';
            bandera <= '0';
        elsif (key = '1' and bandera = '0') then
            bandera <= '1';
        elsif (rising_edge(clk_tx)) then
            if (bandera = '1' and i < mensaje'length) then
                if (done = '1') then
                    cadena <= mensaje(i);
                    i := i+1;
                    send <= '1';
                else
                    send <= '0';
                end if;
            else
                bandera <= '0';
                send <= '0';
                i := 0;
            end if;
        end if;

    END PROCESS;

end architecture;