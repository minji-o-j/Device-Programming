LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY lab_6_1_asyncRAM IS
 PORT (	data_in: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
 	address: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
 	wr: IN STD_LOGIC;
 	data_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0) );
END lab_6_1_asyncRAM;

ARCHITECTURE rtl OF lab_6_1_asyncRAM IS
 TYPE MEM IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
 SIGNAL ram_block: MEM;
BEGIN
 PROCESS (wr, data_in, address)
 BEGIN
   IF (wr = '1') THEN ram_block(to_integer(unsigned(address))) <= data_in;
  	   data_out <= (others => 'Z');
   else  data_out <= ram_block(to_integer(unsigned(address))); 
  END IF;
 END PROCESS;
END rtl;
