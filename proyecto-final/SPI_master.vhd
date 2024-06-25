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
     Led_out :   OUT STD_LOGIC_VECTOR(7 downto 0));
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

       clk_adc: out std_logic := '0' 
       );
end component;

signal ADC_Data : STD_LOGIC_VECTOR(11 downto 0);
signal iCH : std_LOGIC_VECTOR (2 downto 0):= "000";

signal clk_adc, clk_read: std_logic:='0';
signal duty1, duty2, duty3, duty0: integer;
signal iGO: std_logic := '0';
signal data1, data2, data3, data0: std_logic_vector (11 downto 0) := '000000000000';
signal aux: integer;

constant resolucion: integer := 1221 --cada escalon son 12,21 pulsos del reloj de 50MGhz

begin

ADC1 : ADCModule port map(Clk, iGO, oDIN, oCS_n, oSCLK, iDOUT, iCH, ADC_Data, clk_adc);
INST_PWM0: pwm generic map (0, 50E3, 1E6) port map (Clk, '0', '1', pwm0, open, duty0);
INST_PWM1: pwm generic map (0, 50E3, 1E6) port map (Clk, '0', '1', pwm1, open, duty1);
INST_PWM2: pwm generic map (0, 50E3, 1E6) port map (Clk, '0', '1', pwm2, open, duty2);
INST_PWM3: pwm generic map (0, 50E3, 1E6) port map (Clk, '0', '1', pwm3, open, duty3);

-- agregar lógica para led acá el dato viene en ADC_Data y es de 12 bit
led_out <= ADC_Data (11 DOWNTO 4);

process(clk_adc)
     variable canal: integer range 0 to 3 := 0;
     variable cuenta: integer range 0 to 17 := 0;
     begin
     
          with canal select iCH <=
               "000" when 0,
               "001" when 1,
               "010" when 2,
               "011" when 3;
     
     if(rising_edge(clk_adc)) then
          if (cuenta < 16) then
               iGO <= '1';
               cuenta := cuenta + 1;
          elsif (cuenta = 16) then
               case iCH is
                    when "000" =>
                         data0 <= ADC_Data;
                    when "001" =>
                         data1 <= ADC_Data;
                    when "010" =>
                         data2 <= ADC_Data;
                    when "011" =>
                         data3 <= ADC_Data;
               end case;
               cuenta := cuenta + 1

          elsif (cuenta = 17) then
               cuenta := 0;
               iGO <= '0';
               if (canal = 3) then
                    canal <= 0;
               else
                    canal <= canal + 1;
               end if;
          end if;
     end if;

     aux <= to_integer(unsigned(data0));
     duty0 <= (aux * resolucion) / 100;
     aux <= to_integer(unsigned(data1));
     duty1 <= (aux * resolucion) / 100;
     aux <= to_integer(unsigned(data2));
     duty2 <= (aux * resolucion) / 100;
     aux <= to_integer(unsigned(data3));
     duty3 <= (aux * resolucion) / 100;
end process;


end architecture a_SPI_master;