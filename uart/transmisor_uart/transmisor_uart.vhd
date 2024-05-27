library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmisor_uart is
    port (
        clk : in std_logic;
        key: in std_logic; --boton para comenzar a enviar el mensaje
        reset: in std_logic;
        tx: out std_logic:='0'
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
	 
	 COMPONENT Antirrebote2
	     Port (
        clk : in STD_LOGIC;          -- Entrada del reloj
        key : in STD_LOGIC;          -- Entrada de la tecla
        debounced_key : out STD_LOGIC -- Salida de la tecla sin rebotes
    );
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

    TYPE array_data IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (7 DOWNTO 0); --mensaje a enviar
    CONSTANT comando: array_data := (x"52", x"4F", x"4A", x"41", x"53", x"20", x"4D", x"41",
    x"52", x"43", x"4F", x"53", x"20", x"4E", x"49", x"43", x"4F", x"4C", x"41", x"53", x"0A",
    x"32", x"36", x"2F", x"31", x"31", x"2F", x"31", x"39", x"39", x"34", x"0A");
    --ROJAS MARCOS NICOLAS
    --26/11/1994

    SIGNAL send: std_logic := '1';
    SIGNAL clk_tx, clk_11tx, debounced_key: std_logic:='0';
    SIGNAL cadena: std_logic_vector (7 downto 0);
    SIGNAL bandera: std_logic := '0';
	 SIGNAL i: integer:=0;

begin

	 inst_antirebote: Antirrebote2 PORT MAP (clk, key, debounced_key);
    inst_conta: conta GENERIC MAP (0, 5208) PORT MAP (clk, reset,'1',clk_tx,open);
    inst_conta2: conta GENERIC MAP (0, 11*5208) PORT MAP (clk, reset,'1',clk_11tx,open);
    inst_tx: tx_uart PORT MAP (clk_tx, reset, '1', send, cadena, tx, open);

    PROCESS (clk_11tx)
    BEGIN

        if (reset = '1') then
            send <= '1';
        elsif (key = '1') then
            bandera <= '1';
        elsif( rising_edge(clk_11tx)) then
            if (bandera = '1') then
                if (i<comando'length) then
						  cadena <= comando(i);
                    send <= '0';
                    i <= i+1;
                else
                    send <= '1';
                    i<=0;
                    bandera <= '0';
                end if;
            end if;
        end if;

    END PROCESS;

end architecture;