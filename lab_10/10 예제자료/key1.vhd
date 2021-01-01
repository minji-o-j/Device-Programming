library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity key1 is
  port( clk, reset : in std_logic;
        key : in std_logic_vector(7 downto 0);
		  ld_inc_out : out std_logic;
		  condition_sel_out : out std_logic_vector(2 downto 0);
		  next_address_out : out std_logic_vector(4 downto 0); 
		  q_out : out std_logic_vector(10 downto 0);
		  beep, door : out std_logic);
end key1;

architecture rtl of key1 is
  signal address: std_logic_vector(4 downto 0);
  signal next_address: std_logic_vector(4 downto 0); 
  signal condition_sel: std_logic_vector(2 downto 0);
  
  signal ld_inc: std_logic;
  signal key_sw : std_logic_vector(7 downto 0);
  signal key_en, key_en1, key_reset : std_logic;
  signal no_key, nkey3, nkey7, nkey2, nkey5 : std_logic;
  signal q : std_logic_vector(10 downto 0);
  
  type ROM is array(0 to 17) of std_logic_vector(10 downto 0);
  constant rom_11x18: ROM := (
  "00000000000",
  "01010001001",
  "00010000000",
  "01100010001",
  "00100000000",
  "01110011001",
  "00110000000",
  "10000100001",
  "01000000100",
  "00000101001",
  "01010000000",
  "01100101001",
  "01100000000",
  "01110101001",
  "01110000000",
  "10000101001",
  "10000000010",
  "00000101001"
  );

begin
 
  key_en <= key(7) or key(6) or key(5) or key(4) or key(3) or key(2) or key(1) or key(0); 
  key_latch : process (clk)
  begin
   if clk'event and clk = '1' then
	  key_en1 <= key_en; -- (q<=d)
	  if key_reset = '1' then
	    key_sw <= "00000000";
	  elsif (key_en ='1' and key_en1 = '0') then -- (d=‘1’ and q=’0’)
	    key_sw <= key;
	  end if;
	end if;
  end process;
  
  no_key <= not (key_sw(7) or key_sw(6) or key_sw(5) or key_sw(4) or key_sw(3) or key_sw(2) or key_sw(1) or key_sw(0)); 
  nkey2 <= key_sw(7) or key_sw(6) or key_sw(5) or key_sw(4) or key_sw(3) or not key_sw(2) or key_sw(1) or key_sw(0); 
  nkey3 <= key_sw (7) or key_sw (6) or key_sw (5) or key_sw (4) or not key_sw (3) or key_sw (2) or key_sw (1) or key_sw (0); 
  nkey5 <= key_sw (7) or key_sw (6) or not key_sw (5) or key_sw (4) or key_sw (3) or key_sw (2) or key_sw (1) or key_sw (0); 
  nkey7 <= not key_sw (7) or key_sw (6) or key_sw (5) or key_sw (4) or key_sw (3) or key_sw (2) or key_sw (1) or key_sw (0); 
  
  reg : process (clk, reset)
  begin
    if reset = '1' then
	   address <= "00000";
	 elsif clk'event and clk='1' then
	   if ld_inc ='1' then
		  address <= next_address;
		else
		  address <= address + 1;
		end if;
    end if;
  end process;
	
  con_mux: process(condition_sel, no_key, nkey2, nkey3, nkey5, nkey7)
	begin
	  case condition_sel is
	    when "000" => ld_inc <= no_key;
		 when "001" => ld_inc <= nkey3;
		 when "010" => ld_inc <= nkey7;
		 when "011" => ld_inc <= nkey2;
		 when "100" => ld_inc <= nkey5;
		 when others => ld_inc <= '1';
		end case;
  end process;
		 
  q <= rom_11x18(to_integer(unsigned(address)));
	
  ld_inc_out <= ld_inc;
  condition_sel_out <= condition_sel;
  next_address_out <= next_address; 
  next_address <= q(10 downto 6);
  condition_sel <= q(5 downto 3);
  door <= q(2);
  beep <= q(1);
  key_reset<= q(0);
  q_out <= q;
end rtl;
