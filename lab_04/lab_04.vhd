library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity lab_04 is
	port(clk: in std_logic;
		A: in std_logic;
		B: in std_logic;
		C: in std_logic;
		F: out std_logic_vector(2 downto 0)
		);
end lab_04;
architecture sample of lab_04 is
	signal abc: std_logic_vector(2 downto 0);
component rom_example
	PORT
			(
				address	: IN std_logic_vector(2 DOWNTO 0);
				clock		: IN std_logic :='1';
				q			: OUT std_logic_vector(2 DOWNTO 0)
			);
end component;
begin
		abc<=A&B&C;
		rom_example_inst: rom_example PORT MAP(
			address	=> abc,
			clock		=> clk,
			q			=> F
		);
end sample;
			
