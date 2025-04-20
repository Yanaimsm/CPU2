LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
------------------------------------------------------------------
entity top is
	generic ( n : positive := 8 ); 
	port( rst_i, clk_i, repeat_i : in std_logic;
		  upperBound_i : in std_logic_vector(n-1 downto 0);
		  count_o : out std_logic_vector(n-1 downto 0);
		  busy_o : out std_logic);
end top;
------------------------------------------------------------------
architecture arc_sys of top is
	SIGNAL cnt_fast_q : std_logic_vector(n-1 DOWNTO 0); -- synchronous register to store fast counter process output
	SIGNAL cnt_slow_q : std_logic_vector(n-1 DOWNTO 0); -- synchronous register to store slow counter process output
	SIGNAL control_r : std_logic_vector(n-1 DOWNTO 0); -- control register used for updating current counter bound
	signal control_next_r : std_logic_vector(n-1 downto 0);

begin
	----------------------------------------------------------------
	----------------------- fast counter process -------------------
	----------------------------------------------------------------
	proc1 : process(clk_i,rst_i)
	begin
		if rst_i = '1' then
			cnt_fast_q <= (others => '0'); -- reset to zero
			control_r <= (others => '0'); -- reset to zero
		elsif rising_edge(clk_i) then
			if cnt_fast_q = control_r then
				cnt_fast_q <= (others => '0'); -- reset fast counter
				-- increment control_r only if it's below upperBound

			else cnt_fast_q <= cnt_fast_q + 1;
			end if;
			
		end if;
		
		
		
		
		
		
		
		
		
		
		
	end process;
	----------------------------------------------------------------
	---------------------- slow counter process --------------------
	----------------------------------------------------------------
	proc2 : process(clk_i,rst_i)
	begin
		if rst_i = '1' then
			cnt_slow_q <= (others => '0') -- reset to zero
		
		
		
		
		
		
		
		
		
		
	end process;
	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
	-- Default assignment (handles all cases unless overridden)
	control_next <= control_r;

	-- When fast counter hits the limit
	control_next <= control_r + 1
		when (cnt_fast_q = control_r and control_r < upperBound_i) else
		(others => '0')
		when (cnt_fast_q = control_r and control_r = upperBound_i and repeat_i = '0') else
		control_r;

	
	
	
	
	
	----------------------------------------------------------------
end arc_sys;







