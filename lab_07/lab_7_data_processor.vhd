LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY lab_7_data_processor IS
 PORT (	clk:			IN		STD_LOGIC;
			input:		IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			input_sel:	IN		STD_LOGIC;
			ac_load:		IN		STD_LOGIC;
			alu_sel:		IN		STD_LOGIC_VECTOR(2 DOWNTO 0);
			mar_in:		IN		STD_LOGIC_VECTOR(2 DOWNTO 0);
			mar_load:	IN		STD_LOGIC;
			ram_load:	IN		STD_LOGIC;
			mux_out_chk:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);--ac out
			data_chk:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);--alu out
			mar_out_chk:		OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			m1_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);--ram out
			m2_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)--ram out2
		);
END lab_7_data_processor;
----------------------------------------------------------------
ARCHITECTURE structual OF lab_7_data_processor IS
	SIGNAL ac			:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL mux_out		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL mar			:	STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL ram_out		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL alu_out		:	STD_LOGIC_VECTOR(3 DOWNTO 0);


----------------------------------------------------------------
COMPONENT lab_7_asyncRAM
	PORT (	data_in: 	IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
				address: 	IN 	STD_LOGIC_VECTOR (2 DOWNTO 0);
				wr: 			IN 	STD_LOGIC;
				data_out:	OUT 	STD_LOGIC_VECTOR (3 DOWNTO 0);
				m1_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
				m2_out:		OUT	STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT lab_7_simple_alu
	PORT (	op1, op2 : 	IN		STD_LOGIC_VECTOR (3 DOWNTO 0);
				sel:			IN 	STD_LOGIC_VECTOR (2 DOWNTO 0);
				alu_out: 	OUT 	STD_LOGIC_VECTOR (3 DOWNTO 0) );
END COMPONENT;
----------------------------------------------------------------
BEGIN
	RAM:	lab_7_asyncRAM		PORT MAP(data_in=>alu_out,address=>mar,wr=>ram_load,data_out=>ram_out,m1_out=>m1_out,m2_out=>m2_out);
	ALU:	lab_7_simple_alu	PORT MAP(op1=>ac,op2=>ram_out,sel=>alu_sel,alu_out=>alu_out);
----------------------------------------------------------------
--MUX
	mux_out<=input WHEN input_sel='1' ELSE alu_out;
----------------------------------------------------------------
--AC
	PROCESS(clk,ac_load)
	BEGIN
		IF clk'EVENT AND clk='1' THEN --load
			IF ac_load='1' THEN
				ac<=mux_out;
			END IF;
		END IF;
	END PROCESS;
----------------------------------------------------------------
--MAR
	PROCESS(clk,mar_load)
	BEGIN
		IF clk'EVENT AND clk='1' THEN --load
			IF mar_load='1' THEN
				mar<=mar_in;
			END IF;
		END IF;
	END PROCESS;
----------------------------------------------------------------
	output<=ac;
	data_chk<=alu_out;
	mux_out_chk<=mux_out;
	mar_out_chk<=mar;
END structual;