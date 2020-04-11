LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY dp IS PORT (
	Clock, Clear: IN STD_LOGIC;
	Input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	IRload, PCload, INmux, Aload, JNZmux: IN STD_LOGIC;
	IR: OUT STD_LOGIC_VECTOR(7 DOWNTO 5);
	Xneq0: OUT STD_LOGIC;
	Output: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END dp;

ARCHITECTURE Structural OF dp IS
	COMPONENT reg
	GENERIC (size: INTEGER := 4);	-- the actual size is defined in the instantiation GENERIC MAP
	PORT (
		Clock, Clear, Load: IN STD_LOGIC;
		D: IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
		Q: OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT increment
	GENERIC (size: INTEGER := 8);	-- default number of bits
	PORT (
		A:	IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
		F:	OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT decrement
	GENERIC (size: INTEGER := 8);	-- default number of bits
	PORT (
		A:	IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
		F:	OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux2
	GENERIC (size: INTEGER := 8);					-- default size
	PORT (
		S: IN STD_LOGIC;							-- select line
		D1, D0: IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);	-- data bus input
	    Y: OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0));		-- data bus output
	END COMPONENT;

	SIGNAL dp_IR, dp_ROMQ: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dp_JNZmux, dp_PC, dp_increment: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL dp_INmux, dp_decrement, dp_A: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    -- doing structural modeling for the datapath here
	U0_IR: reg GENERIC MAP (8) PORT MAP(Clock, Clear, IRLoad, dp_ROMQ, dp_IR);
	U1_JNZmux: mux2 GENERIC MAP (4) PORT MAP(JNZmux,dp_IR(3 DOWNTO 0),dp_increment,dp_JNZmux);
	U2_PC: reg GENERIC MAP (4) PORT MAP(Clock, Clear, PCLoad, dp_JNZmux, dp_PC);
	U3_inc: increment GENERIC MAP (4) PORT MAP(dp_PC,dp_increment);

	U4_ROM: lpm_rom
		GENERIC MAP (
			lpm_widthad	=> 4,
			lpm_outdata	=> "UNREGISTERED",
			lpm_file	=> "program.mif",	-- fill rom with content of file program.mif
			lpm_width	=> 8)
		PORT MAP (address => dp_PC, inclock => Clock, q => dp_ROMQ);

	U5_INmux: mux2 GENERIC MAP (8) PORT MAP(INmux,Input,dp_decrement,dp_INmux);
	U6_A: reg GENERIC MAP (8) PORT MAP(Clock, Clear, ALoad, dp_INmux, dp_A);
	U7_dec: decrement PORT MAP(dp_A,dp_decrement);

	Xneq0 <= '1' WHEN dp_A /= "00000000" ELSE '0';
	IR <= dp_IR(7 DOWNTO 5);
	Output <= dp_A;
END Structural;

