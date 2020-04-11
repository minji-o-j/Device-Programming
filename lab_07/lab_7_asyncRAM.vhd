LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY lab_7_asyncRAM IS
 PORT (	data_in: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
 	address: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
 	wr: IN STD_LOGIC;
 	data_out: OUT STD_LOGIC_VECTOR (3 DOWNTO 0); 
	m1_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);--ram out
	m2_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)--ram out2
	);
END lab_7_asyncRAM;

ARCHITECTURE rtl OF lab_7_asyncRAM IS
 TYPE MEM IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL ram_block: MEM;
BEGIN
 PROCESS (wr, data_in, address)
 BEGIN
   IF (wr = '1') THEN ram_block(to_integer(unsigned(address))) <= data_in;
  	   data_out <= (others => 'Z');
   else  data_out <= ram_block(to_integer(unsigned(address))); 
  END IF;
 END PROCESS;
 m1_out<=ram_block(000); 
 m2_out<=ram_block(001); 
END rtl;
