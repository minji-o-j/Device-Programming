LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY decrement IS
GENERIC(size: INTEGER :=8);	-- default number of bits
PORT(
	A:	IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
	F:	OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));
END decrement;

ARCHITECTURE Dataflow OF decrement IS
BEGIN
	F <= A - 1;
END Dataflow;

