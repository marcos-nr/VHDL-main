library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmisor_uart2 is
    port (
        clk : in std_logic;
        key: in std_logic; --boton para comenzar a enviar el mensaje
        reset: in std_logic
        --tx, done: out std_logic:='0'
    );   
end transmisor_uart2;

architecture rtl of transmisor_uart2 is
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

    TYPE mef IS (start, idle);
    signal state: mef := idle;

    TYPE array_data IS ARRAY (0 TO 11) OF STD_LOGIC_VECTOR (7 DOWNTO 0); --mensaje a enviar
    CONSTANT comando: array_data := (x"77", x"65", x"82", x"67", x"79", x"83", x"32", x"82", x"79", x"74", x"65", x"83");
    --77 65 82 67 79 83 32 82 79 74 65 83

    SIGNAL cadena: std_logic_vector (7 downto 0);
    SIGNAL clk_tx, clk_11tx, tx, done: std_logic;
    SIGNAL send: std_logic := '1';


begin

    A: conta GENERIC MAP (0, 5208) PORT MAP (clk, reset,'1',clk_tx,open);
    B: conta GENERIC MAP (0, 11*5208) PORT MAP (clk, reset,'1',clk_11tx,open);
    C: tx_uart PORT MAP (clk_tx, reset, '1', send, cadena, tx, done);

    PROCESS (clk_11tx)
    variable i: integer;
    BEGIN
        if (reset = '1') then
            state <= idle;
        elsif (rising_edge(clk_11tx)) then
            case state is
                when idle =>
                    if (key = '1') then
                        state <= start;
                    end if;

                when start =>
                    if i<comando'length then
                        cadena <= comando(i);
                    end if;
                    state <= idle;
            end case;
        end if;


    END PROCESS;

    PROCESS (state, cadena)
    BEGIN
        case state is
            when idle => 
                send <= '1';

            when start =>
                send <= '0';
        end case;
    END PROCESS;

end architecture;