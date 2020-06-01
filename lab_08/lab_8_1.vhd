LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity lab_8_1 is

	port(
			clk    : IN STD_LOGIC ;
			load    : IN STD_LOGIC ;
			clear    : IN STD_LOGIC ;
			out_sel	: IN std_logic ;
			
			iNOT10 	: out std_logic; --status signal
			dp_out	: out std_logic_vector(3 downto 0)--display out
			
			);

END lab_8_1;

Architecture dataflow of lab_8_1 is
	signal iNOT10S: std_logic :='1';
	signal data : std_logic_vector(3 downto 0) := "0000";
	begin
		
		process(clear, clk) is
			begin 
			
			if (clear = '1') then
           			 data <= "0000";
			
			elsif (clk'EVENT AND clk = '1') then
					if (load = '1' and iNOT10S/='0') then
						data <= data + '1';
						if(out_sel='1') then
							dp_out<=data;
						else
							dp_out <= "ZZZZ";
						end if;
						if data="1010" then
							iNOT10S<='0';
						end if;
						
					elsif (out_sel='0') then
						dp_out<="ZZZZ";
					end if;		
			end if;	
		end process;
			
		iNOT10<=iNOT10S;
		
end dataflow;