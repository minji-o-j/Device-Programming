LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
ENTITY lab_3 IS
	PORT(		clock		:		IN 	STD_LOGIC;
				RESET		:		IN 	STD_LOGIC;
				A			:		IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
				Load_A	:		IN 	STD_LOGIC;
				S			:		IN 	STD_LOGIC;
				done		:		BUFFER	STD_LOGIC;
				B			:		BUFFER	STD_LOGIC_VECTOR(3 DOWNTO 0);
				state_out:		BUFFER	STD_LOGIC_VECTOR(1 DOWNTO 0));
				--outCA		:		BUFFER		STD_LOGIC_VECTOR(7 DOWNTO 0));
END lab_3;
-----------------------------------------------------------------------------
ARCHITECTURE Behavior OF lab_3 IS 
SIGNAL	CA		:	STD_LOGIC_VECTOR(7 DOWNTO 0);	-->load A into CA, shift CA
-----------------------------------------------------------------------------
BEGIN
	PROCESS(RESET,clock)
	BEGIN
		IF RESET='1' THEN
			B <=(others=>'0');
			state_out <= (others=>'0');
			CA<=(others=>'0');
			done<='0';
			--outCA<=(others=>'0');

		ELSIF (clock'EVENT AND clock='1') THEN
			state_out <= state_out + 1;
			
			CASE (state_out) IS
				when "00" =>
					IF (Load_A='0') THEN
						state_out <= "00";
					ELSE
						CA(7)<=A(7);
						CA(6)<=A(6);
						CA(5)<=A(5);
						CA(4)<=A(4);
						CA(3)<=A(3);
						CA(2)<=A(2);
						CA(1)<=A(1);
						CA(0)<=A(0);	
					END IF;
					
				when "01" =>
					IF (S='0') THEN
						state_out <= "01";
					END IF;
				
				when "10" =>
					IF (CA/="00000000") THEN
						state_out<="10";
						IF (CA(0)='1') THEN
							B <= B+1;
						END IF;
						CA(0)<=CA(1);
						CA(1)<=CA(2);
						CA(2)<=CA(3);
						CA(3)<=CA(4);
						CA(4)<=CA(5);
						CA(5)<=CA(6);
						CA(6)<=CA(7);
						CA(7)<='0';
						---test
						--outCA(7)<=CA(7);
						--outCA(6)<=CA(6);
						--outCA(5)<=CA(5);
						--outCA(4)<=CA(4);
						--outCA(3)<=CA(3);
						--outCA(2)<=CA(2);
						--outCA(1)<=CA(1);
						--outCA(0)<=CA(0);	
					ELSE
						DONE<='1';
					END IF;
				when "11" =>
					state_out<="11";
					
			END CASE;
		END IF;
	END PROCESS;
END Behavior;
	