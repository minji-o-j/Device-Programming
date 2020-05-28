LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY lab_2 IS
	PORT( clock		:IN STD_LOGIC;
			reset		:IN STD_LOGIC;
			X			:IN STD_LOGIC;
			Z			:OUT STD_LOGIC);
END lab_2;
ARCHITECTURE Behavior OF lab_2 IS
	TYPE state IS (S0,S1,S2,S3);
	SIGNAL Moore_state : state;	
BEGIN
	PROCESS(reset,clock)
	BEGIN
		IF reset='1' THEN
			Moore_State <=S0;
		
		ELSIF(clock='1' AND clock'EVENT) THEN
			CASE Moore_state IS
				WHEN S0 =>
					IF X ='1' THEN
						Moore_state <=S1;
					ELSE
						Moore_state <=S0;
					END IF;
				-----------------------
				WHEN S1 =>
					IF X ='0' THEN
						Moore_state <=S2;
					ELSE
						Moore_state <=S1;
					END IF;
				-----------------------	
				WHEN S2 =>
					IF X ='1' THEN
						Moore_state <=S3;
					ELSE
						Moore_state <=S0;
					END IF;
				-----------------------	
				WHEN S3 =>
					IF X ='0' THEN
						Moore_state <=S2;
					ELSE
						Moore_state <=S1;
					END IF;
			END CASE;
		END IF;
	END PROCESS;

Z <='1' WHEN Moore_state=S3 ELSE '0';
END Behavior;
			