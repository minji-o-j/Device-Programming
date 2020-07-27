LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2 IS
GENERIC (size: INTEGER := 8);	-- default size
PORT (
	S: IN STD_LOGIC;							-- select line
	D1, D0: IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);	-- data bus input
    Y: OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));		-- data bus output
END mux2;

ARCHITECTURE Behavioral OF mux2 IS
BEGIN
    PROCESS(S, D1, D0)
    BEGIN
	IF(S = '0' )THEN
	    Y <= D0;
	ELSE
	    Y <= D1;
	END IF;
    END PROCESS;
END Behavioral;

