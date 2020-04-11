LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cu IS PORT (
	clock, reset : IN STD_LOGIC;
	-- control signals
	IRload, PCload, INmux, Aload, JNZmux: OUT STD_LOGIC;
	-- status signals
	IR: IN STD_LOGIC_VECTOR(7 DOWNTO 5);
	Aneq0: IN STD_LOGIC;
	-- control outputs
	halt: OUT STD_LOGIC);
END cu;

ARCHITECTURE FSM OF cu IS
	SIGNAL state: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	next_state_logic: PROCESS(reset, clock)
	BEGIN
		IF(reset = '1') THEN
			state <= "000";
		ELSIF(clock'EVENT AND clock = '1') THEN
			CASE state IS
			WHEN "000" => -- reset, start
				state <= "001";
			WHEN "001" => -- fetch
				state <= "010";
			WHEN "010" => -- s_decode
				CASE IR IS
					WHEN "011" => state <= "011"; --s_input;
					WHEN "100" => state <= "100"; --s_output;
					WHEN "101" => state <= "101"; --s_dec;
					WHEN "110" => state <= "110"; --s_jnz;
					WHEN "111" => state <= "111"; --s_halt;
					WHEN OTHERS => state <= "000"; --s_start;
				END CASE;
			WHEN "011" => -- s_input
				state <= "000";
			WHEN "100" => -- s_output =>
				state <= "000";
			WHEN "101" => -- s_dec =>
				state <= "000";
			WHEN "110" => -- s_jnz =>
				state <= "000";
			WHEN "111" => -- s_halt =>
				state <= "111";
			WHEN OTHERS =>
				state <= "000";
			END CASE;
		END IF;
	END PROCESS;

	output_logic: PROCESS(state)
	BEGIN
		CASE state IS
		WHEN "001" => --s_fetch =>
			IRload <= '1';
			PCload <= '1';
			INmux <= '0';
			Aload <= '0';
			JNZmux <= '0';
			halt <= '0';
		WHEN "011" => --s_input =>
			IRload <= '0';
			PCload <= '0';
			INmux <= '1';
			Aload <= '1';
			JNZmux <= '0';
			halt <= '0';
		WHEN "101" => --s_dec =>
			IRload <= '0';
			PCload <= '0';
			INmux <= '0';
			Aload <= '1';
			JNZmux <= '0';
			halt <= '0';
		WHEN "110" => --s_jnz =>
			IRload <= '0';
			IF (Aneq0 = '1') THEN
				PCload <= '1';
			ELSE
				PCload <= '0';
			END IF;
			INmux <= '0';
			Aload <= '0';
			JNZmux <= '1';
			halt <= '0';
		WHEN "111" => --s_halt =>
			IRload <= '0';
			PCload <= '0';
			INmux <= '0';
			Aload <= '0';
			JNZmux <= '0';
			halt <= '1';
		WHEN OTHERS =>
			IRload <= '0';
			PCload <= '0';
			INmux <= '0';
			Aload <= '0';
			JNZmux <= '0';
			halt <= '0';
		END CASE;
	END PROCESS;
END FSM;

