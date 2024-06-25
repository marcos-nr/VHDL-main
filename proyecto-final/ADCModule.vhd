library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADCModule is
port ( Clk   : IN  STD_LOGIC;
       iGO   : IN  STD_LOGIC := '0'; --pulsador para recibir el dato
       oDIN  : OUT STD_LOGIC; --mosi
       oCS_n : OUT STD_LOGIC; --chip select
       oSCLK : OUT STD_LOGIC; --clock del adc
       iDOUT : IN  STD_LOGIC; --miso
       iCH   : IN  STD_LOGIC_VECTOR(2 downto 0);   -- aca elijo los canales
       OutCkt: OUT STD_LOGIC_VECTOR(11 downto 0)); --salida de 12 bit

	   clk_adc: out std_logic:='0'; --agrego salida extra
end entity;

architecture ADCModule_arc of ADCModule is 

component SPICLK  is 					  
port( inclk0 : IN STD_LOGIC  := '0';  -- 50Mhz --
      c0     : OUT STD_LOGIC ;        -- 0 grados (2 MHz) --
      c1     : OUT STD_LOGIC );       -- 180 grados de c0 (2MHz) --
end component;

signal go_en: STD_LOGIC;
signal cont, m_cont: INTEGER;
signal adc_data: STD_LOGIC_VECTOR(11 downto 0);
signal iCLK, iCLK_n: STD_LOGIC;
signal CH : std_LOGIC_VECTOR (2 downto 0) := "000";
begin

hz2: entity work.conta generic map (0,25) 
	port map( clk=>clk, reset=>'0', enable=>'1', cout=>iCLK, coutnegado => iCLK_n, q=>open);

	clk_adc <= iCLK; -- agrego como salida

oCS_n  <=  not go_en;

with go_en select
   oSCLK <= iCLK when '1',
            '1'  when '0',
	    '1'  when others;		  

Start_ADC_proc: process(iGO)
  begin
	  if (iGO = '1') then go_en <= '1';
	  else go_en <= '0';
	  end if;
end process Start_ADC_proc;

counter1_proc: process(iCLK, go_en)
begin
	 if(go_en = '0') then cont <= 0;
	 elsif (rising_edge(iCLK)) then 
	   if (cont = 15) then cont <= 0;
		else cont <= cont + 1;
		end if;
	 end if;
end process counter1_proc;

counter2_proc: process(iCLK_n)
begin
	 if(rising_edge(iCLK_n)) then m_cont <= cont;
	 end if;
end process Counter2_proc;

channel_ADC_proc: process(iCLK_n, go_en)
begin
	  if(go_en = '0') then oDIN <=	'0';
	  elsif(rising_edge(iCLK_n)) then
		if (cont = 1) then oDIN	    <=	CH(2);
		elsif (cont = 2) then oDIN  <=	CH(1);
		elsif (cont = 3) then oDIN  <=	CH(0);
		else oDIN <= '0';
		end if;
	  end if;
end process channel_ADC_proc;

output_ADC_proc: process(iCLK, iCLK_n, go_en)
begin
    if(go_en = '0') then adc_data <= "000000000000";
	 elsif(rising_edge(iCLK)) then 
		  if    (m_cont = 3)  then adc_data(11) <= iDOUT;
		  elsif (m_cont = 4)  then adc_data(10) <= iDOUT;
		  elsif (m_cont = 5)  then adc_data(9)  <= iDOUT;
		  elsif (m_cont = 6)  then adc_data(8)  <= iDOUT;
		  elsif (m_cont = 7)  then adc_data(7)  <= iDOUT;
		  elsif (m_cont = 8)  then adc_data(6)  <= iDOUT;
		  elsif (m_cont = 9)  then adc_data(5)  <= iDOUT;
		  elsif (m_cont = 10) then adc_data(4)  <= iDOUT;
		  elsif (m_cont = 11) then adc_data(3)  <= iDOUT;
		  elsif (m_cont = 12) then adc_data(2)  <= iDOUT;
		  elsif (m_cont = 13) then adc_data(1)  <= iDOUT;
		  elsif (m_cont = 14) then adc_data(0)  <= iDOUT;
		  elsif (m_cont = 1)  then OutCkt <= adc_data; 
		  end if;
	 end if;
end process output_ADC_proc;

end ADCModule_arc;