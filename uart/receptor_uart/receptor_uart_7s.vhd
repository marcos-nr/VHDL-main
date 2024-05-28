library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity receptor_uart_7s is
    port (
        clk, reset, rx: IN STD_LOGIC;
        segmentos: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        dig0, dig1, dig2, dig3, enable_disp: OUT STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"
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

    SIGNAL rx_done, clk_rx: STD_LOGIC;
    SIGNAL dato: STD_LOGIC_VECTOR (7 DOWNTO 0); 

begin
    inst_conta: conta GENERIC MAP(0, 325) PORT MAP (clk, reset, '1', clk_rx, open);
    inst_rx: rx_uart PORT MAP(rx, reset, clk_rx, rx_done, dato);
    inst_display: full_display4 generic map (50E3) port map (clk, reset, dig3, dig2, dig1, dig0, enable_disp, segmentos);

end architecture;