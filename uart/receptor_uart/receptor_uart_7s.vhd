library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity receptor_uart_7s is
    port (
        clk, reset, rx: IN STD_LOGIC;
        segmentos: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		enable_disp: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
end receptor_uart_7s;

architecture rtl of receptor_uart_7s is
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

    COMPONENT full_display4
        generic(
            max_clk : integer := 50E6
        );
    
        port(
            clk		    : in	std_logic;
            reset       : in	std_logic;
            dig3, dig2, dig1, dig0 		: in	std_logic_vector(3 DOWNTO 0) := "0000";
            enable_disp : out   std_logic_vector(3 downto 0);
            segmentos   : out	std_logic_vector(6 downto 0)
        );
    
    END COMPONENT; 

    COMPONENT rx_uart
    port 
        (	
            rx : 			in std_logic;
            reset,clk: 	in std_logic:='1';
            rx_done:		out std_logic:='1';
            dato:	     out std_logic_vector (7 downto 0):=x"00"
        );
    END COMPONENT;

    TYPE array_data IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL temp: array_data:= (x"30", x"30", x"30", x"30");

    SIGNAL rx_done, clk_rx: STD_LOGIC;
    SIGNAL dato: STD_LOGIC_VECTOR (7 DOWNTO 0);
   -- SIGNAL flag: STD_LOGIC := '0';
    SIGNAL i: INTEGER RANGE 0 TO 4;
    SIGNAL dig0, dig1, dig2, dig3: STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL clk_receptor: STD_LOGIC;
    SIGNAL bandera: STD_LOGIC:='0';


begin
    inst_conta: conta GENERIC MAP(0, 325) PORT MAP (clk, '0', '1', clk_rx, open);
    inst_conta2: conta GENERIC MAP(0, 5028) PORT MAP (clk, reset, '1', clk_receptor, open);
    inst_rx: rx_uart PORT MAP(rx, '0', clk_rx, rx_done, dato);
    inst_display: full_display4 generic map (50E3) port map (clk, '0', dig3, dig2, dig1, dig0, enable_disp, segmentos);

    dig0 <= temp(0) (3 DOWNTO 0);
    dig1 <= temp(1) (3 DOWNTO 0);
    dig2 <= temp(2) (3 DOWNTO 0);
    dig3 <= temp(3) (3 DOWNTO 0);

    PROCESS (clk_receptor)

    VARIABLE cuenta: integer range 0 to 4; 

    BEGIN
        if (rising_edge(rx_done)) then
				if i = 4 then i <= 0; end if;
				temp(i) <= dato;
            i <= i+1;
		  end if;
    END PROCESS;
end architecture;