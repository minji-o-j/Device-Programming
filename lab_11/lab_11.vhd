LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY lab_11 IS PORT (
	clock, reset: IN STD_LOGIC;
	enter: IN STD_LOGIC;
	input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	output: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END lab_11;

ARCHITECTURE FSMD OF lab_11 IS
	TYPE state_type IS (s_start,s_start2,s_start3,s_fetch,s_decode,s_decode2,s_decode3,s_load,s_store,s_store2,s_add,s_dec,s_input,s_out,s_jmp);
	SIGNAL state: state_type;		
	SIGNAL IR: STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Instruction register
	SIGNAL PC: STD_LOGIC_VECTOR(4 DOWNTO 0);	-- Program counter
	SIGNAL A:  STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Accumulator
	SIGNAL memory_address:  STD_LOGIC_VECTOR(4 DOWNTO 0);	-- memory address
	SIGNAL memory_data:  STD_LOGIC_VECTOR(7 DOWNTO 0);	-- memory data input
	SIGNAL MemWr: STD_LOGIC;

BEGIN
	memory: lpm_ram_dq	-- 32 locations x 8 bits wide asynchronous memory
		GENERIC MAP (
			lpm_widthad	=> 5,
			lpm_outdata	=> "REGISTERED", -- jj
			lpm_indata	=> "REGISTERED", -- jj
			lpm_numwords => 32,  -- jj
			lpm_address_control => "REGISTERED", -- jj
			lpm_file	=> "lab11_program.mif", -- fill ram with content of file program.mif
			lpm_width	=> 8)
		PORT MAP (
			data		=> A,
			address		=> memory_address,
			inclock => clock,  -- added jj
			outclock => clock, -- jj
			we			=> MemWr,
			q			=> memory_data);

	PROCESS(clock,reset)
	BEGIN
		IF(reset = '1') THEN
			PC <= "00000";
			IR <= "00000000";
			A  <= "00000000";
			MemWr <= '0';
			state <= s_start;
		ELSIF(clock'EVENT AND clock = '1') THEN
			CASE state IS
			WHEN s_start => -- reset, start
				memory_address <= PC;
				state <= s_start2;
			WHEN s_start2 =>
				state <= s_start3; 
			WHEN s_start3 =>
				state <= s_fetch;
			WHEN s_fetch => -- fetch
				IR <= memory_data;
				PC <= PC + 1;
				state <= s_decode;
			WHEN s_decode => -- decode
				memory_address <= IR(4 DOWNTO 0);	-- memory access using last 5 bits of IR
				state <= s_decode2;  -- jj
			WHEN s_decode2 =>
				state <= s_decode3;
			WHEN s_decode3 =>  -- jj
				CASE IR(7 DOWNTO 5) IS
					WHEN "000" => state <= s_load;
					WHEN "001" => state <= s_store;
					WHEN "010" => state <= s_add;
					WHEN "011" => state <= s_dec;
					WHEN "100" => state <= s_input;
					WHEN "101" => state <= s_out;
					WHEN "110" => state <= s_jmp;
					WHEN OTHERS => state <= s_start;
				END CASE;
				
			WHEN s_load =>				-- load A from memory
				A <= memory_data;
				state <= s_start;
			WHEN s_store =>				-- store A to memory
				MemWr <= '1';
				state <= s_store2;
			WHEN s_store2 =>			-- need an extra state to de-assert MemWr before changing the memory address
				MemWr <= '0';
				state <= s_start;
			WHEN s_add =>				-- add
				A <= A + memory_data;
				state <= s_start;
			WHEN s_dec =>				-- decrement 1
				--A <= A - memory_data;
				A<=A-1;
				state <= s_start;
			WHEN s_input =>
				A <= input;
				IF (Enter = '0') THEN	-- wait for Enter key
					state <= s_input;
				ELSE
					state <= s_start;
				END IF;
			WHEN s_out=>
				output<=A;
				state<=s_start;
			WHEN s_jmp=>
				PC <= IR(4 DOWNTO 0);
				state<=s_start;
			WHEN OTHERS =>
				state <= s_start;
			END CASE;
		END IF;
	END PROCESS;
END FSMD;
