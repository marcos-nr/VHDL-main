library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_master is
port(Clk   	 :   IN  STD_LOGIC;  
	--iGO 		:	IN std_LOGIC; iGO no se hará con boton, se hará con signal.
     oDIN        :   OUT STD_LOGIC;
     oCS_n       :   OUT STD_LOGIC;
     oSCLK       :   OUT STD_LOGIC;
     iDOUT       :   IN  STD_LOGIC;     
     Led_out :   OUT STD_LOGIC_VECTOR(7 downto 0);

     pwm_o: out std_logic
     );
end entity;

architecture a_SPI_master of SPI_master is

component conta is
     generic	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 256	);

	port	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		cout: out std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT	);
end component;

component ADCModule is 
port ( Clk   : IN  STD_LOGIC;
       iGO   : IN  STD_LOGIC := '0';
       oDIN  : OUT STD_LOGIC;
       oCS_n : OUT STD_LOGIC;
       oSCLK : OUT STD_LOGIC;
       iDOUT : IN  STD_LOGIC;
       iCH   : IN  STD_LOGIC_VECTOR(2 downto 0);
       OutCkt: OUT STD_LOGIC_VECTOR(11 downto 0);

       clk_adc: out std_logic := '0';
       pwm_o: out std_logic := '0'
       );
end component;

component pwm is
     generic	(
		MIN_COUNT : natural := 0;
        init_pulse: natural := 50000; --50E3 pulsos es 1 ms
		MAX_COUNT : natural := 1000000); --1E6 pulsos es 20 ms
	port	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		cout: out std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT;
        duty      : in integer
        );
end component;

signal ADC_Data : STD_LOGIC_VECTOR(11 downto 0);
signal iCH : std_LOGIC_VECTOR (2 downto 0):= "000";

signal clk_adc, clk_read: std_logic:='0';
signal duty: integer;
signal iGO: std_logic := '0';
signal data: std_logic_vector (11 downto 0) := "000000000000";
signal aux: integer;

constant resolucion: integer := 50000/4095 * 10000; --cada escalon son 12,21 pulsos del reloj de 50MGhz

begin

ADC1 : ADCModule port map(Clk, iGO, oDIN, oCS_n, oSCLK, iDOUT, iCH, ADC_Data, clk_adc);
INST_PWM: pwm generic map (0, 50E3, 1E6) port map (Clk, '0', '1', pwm_o, open, duty);

-- agregar lógica para led acá el dato viene en ADC_Data y es de 12 bit
led_out <= ADC_Data (11 DOWNTO 4);

process(clk_adc)
     --variable canal: integer range 0 to 3 := 0;
     variable cuenta: integer range 0 to 35 := 0;
     begin
     
     if(rising_edge(clk_adc)) then
          if (cuenta < 16) then
               iGO <= '1';
               cuenta := cuenta + 1;

          elsif (cuenta = 16) then
               data <= ADC_Data;
               cuenta := cuenta + 1;

          elsif (cuenta = 17) then
               iGO <= '0';
               cuenta := cuenta + 1;

          elsif (cuenta = 35) then
               cuenta := 0;
          end if;
     end if;

     aux <= to_integer(unsigned(data)); --cantidad de "escalones" del adc
     duty <= (aux * resolucion) / 10000; --cantidad de pulsos del 50MHz necesarios para el pwm

end process;


end architecture a_SPI_master;