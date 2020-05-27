LIBRARY ieee;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

ENTITY lab_03 IS --interface define, in/out port declare
   PORT (clock,resetn : IN STD_LOGIC ;
         load,start : IN STD_LOGIC ;
         A              : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         B              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
         A_out           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         state          : buffer STD_LOGIC_VECTOR(1 DOWNTO 0);
         done           : OUT STD_LOGIC ) ;
END lab_03 ;
-----------------------------------------------------------------
ARCHITECTURE behavior OF lab_03 IS -- entity explane
   SIGNAL A_in : STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL B_out : STD_LOGIC_VECTOR (3 DOWNTO 0);
   SIGNAL state_out : std_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN PROCESS (resetn, clock)
      BEGIN
         IF (resetn = '0') then   --resetn is 0 -> state is '00'  --(IF 5 close)
            state <= "00"; 
         ELSIF rising_edge(clock) then -- resetn is 1, at rising_edge
            state_out <= state_out +1;
            IF load = '1' then  --If ‘Load’ is ‘true’ then receive 8 bit data input A  (IF 4 open)
               A_in <= A; --in A and signal A_in connect
               IF (start='1') then     --(IF 3 open)
                  state <= "10";
                  A_in <= A;                         --Start is ‘1’then count ‘1’s in A’s bitstream
                  B_out <="0000";                   --B Initialization
                  IF A_in /= "00000000" then       --if A_in is not 0 (IF 2 open)
                     IF A_in(0)= '1' then           --if A_in(0)is 1    (IF 1 open)
                        B_out <= B_out +1;           --B_out is B_out +1
                        --B <= B_out; 
                     END IF;      --if A_in(0) is 0  -- (IF 1 close)
                        A_in(7)<=A_in(6); --right shift
                        A_in(6)<=A_in(5);
                        A_in(5)<=A_in(4);
                        A_in(4)<=A_in(3);
                        A_in(3)<=A_in(2);
                        A_in(2)<=A_in(1);
                        A_in(1)<=A_in(0);
                        A_in(0)<='0';
                  END IF; -- if A_in is 0 -> escape    (IF 2 close)1
                  case(state) is 
                     when "00" => state_out <= "01";   
                     when "01" => state_out <= "10";
                     when "10" => state_out <= "11";
                     when "11" => state_out <= "11";
                  END CASE;
                  --END IF; -- if A_in is 0 -> escape    (IF 2 close)2
                ELSE
                  state_out <= "01";
               END IF;               --(IF 3 close)
               END IF;               --(IF 4 close)
         END IF;                 --(IF 5 close) 
      B<=B_out;
      A_out <= A_in;
      state <= state_out; --seems like output
      END PROCESS;
      --B<=B_out;
      done <= '1' when state ="11" ELSE '0';
END behavior;