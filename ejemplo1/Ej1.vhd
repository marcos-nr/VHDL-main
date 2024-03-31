-- Quartus II VHDL Template
-- Signed Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ej1 is



	port 
	(
		W	: out std_logic;
		A    : in std_logic;
		B 	: in std_logic
		
	);

end entity;

architecture rtl of Ej1 is
begin

W <= A and B;


end rtl;
