library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmisor_uart is
    port (
        clk : in std_logic;
        key: in std_logic; --boton para comenzar a enviar el mensaje
        reset: in std_logic;
        tx, done: out std_logic:='0'
    );   
end transmisor_uart;

architecture rtl of transmisor_uart is
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

    COMPONENT tx_uart
        port
        (
            clk,reset,enable: in  std_logic:='0';
            send : in std_logic;
            cadena : in std_LOGIC_VECTOR(7 dowNTO 0);		
            tx, done : out std_logic:='0'
        );
    END COMPONENT;

    TYPE array_data IS ARRAY (0 TO 2) OF STD_LOGIC_VECTOR (7 DOWNTO 0); --mensaje a enviar
    CONSTANT comando: array_data := (x"77", x"78", x"82");
    --77 78 82
    --CONSTANT comando: array_data := (x"77", x"65", x"82", x"67", x"79", x"83", x"32", x"82", x"79", x"74", x"65", x"83");
    --77 65 82 67 79 83 32 82 79 74 65 83

    SIGNAL send: std_logic := '1';
    SIGNAL clk_tx, clk_11tx: std_logic;
    SIGNAL cadena: std_logic_vector (7 downto 0);

begin

    A: conta GENERIC MAP (0, 4) PORT MAP (clk, reset,'1',clk_tx,open);
    B: conta GENERIC MAP (0, 11*4) PORT MAP (clk, reset,'1',clk_11tx,open);
    C: tx_uart PORT MAP (clk_tx, reset, '1', send, cadena, tx, done);

    PROCESS (clk_11tx)
    variable i: integer:=0;
    BEGIN

        if (reset = '1') then
            send <= '1';
        elsif( rising_edge(clk_11tx)) then
            if (key = '1') then
                if (i<comando'length) then
                    send <= '0';
                    cadena <= comando(i);
                    i := i+1;
                end if;
                send <= '1';
            end if;
        end if;
    END PROCESS;

end architecture;