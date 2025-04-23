library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal rst, clk, repeat : std_logic;
	signal upperBound : std_logic_vector(n-1 downto 0);
	signal count : std_logic_vector(n-1 downto 0);
	signal busy	: std_logic;
begin
	L0 : top generic map (n) port map(rst, clk, repeat, upperBound, count, busy);
    
	--------- start of stimulus section ------------------	
	gen_clk : process
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= not clk;
		wait for 50 ns;
	end process;

	gen_upperBound : process
	begin
		upperBound <= (2 => '0', 0 => '1', others => '0');  -- changed starting pattern
		for i in 0 to 1 loop
			wait for 900 ns;  -- slightly changed delay
			upperBound <= upperBound + 2;  -- changed increment
		end loop;
		
		wait for 700 ns;  -- single delay instead of loop
		upperBound <= upperBound - 3;  -- changed decrement value
		
		for i in 0 to 2 loop
			wait for 750 ns;  -- slightly changed delay
			upperBound <= upperBound + 1;
		end loop;
	end process;

	gen_rst : process
	begin
		rst <= '1'; wait for 120 ns;  -- modified timing
		rst <= '0'; wait for 900 ns; -- modified timing
		rst <= '1'; wait for 180 ns; -- modified timing
		rst <= '0'; wait;
	end process;

	gen_repeat : process
	begin
		repeat <= '1';
		wait for 2200 ns;  -- changed duration
		repeat <= '0';
		wait;
	end process;

end architecture rtb;
