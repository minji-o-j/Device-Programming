LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg IS
	GENERIC (size: INTEGER := 4); -- default size of the register
	PORT (
	Clock, Clear, Load: IN STD_LOGIC;
	D: IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
	Q: OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));
END reg;

ARCHITECTURE Behavior OF reg IS
BEGIN
	PROCESS(Clock, Clear)
	BEGIN
		IF Clear = '1' THEN
			Q <= (OTHERS => '0');
		ELSIF Clock'EVENT AND Clock = '1' THEN
			IF Load = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;
END Behavior;
