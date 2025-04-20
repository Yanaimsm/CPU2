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
	signal fast_done_r    : boolean; -- signal to show that a cycle has completed
	signal enable_r       : boolean; -- signal that allows count to proceed.
 
begin
	----------------------------------------------------------------
	----------------------- fast counter process -------------------
	----------------------------------------------------------------
	proc1 : process(clk_i,rst_i)
	begin
	----------------------- asynchronous part ----------------------
		if rst_i = '1' then
			cnt_fast_q <= (others => '0');
	----------------------------------------------------------------
	----------------------- synchronous part -----------------------
	
	elsif rising_edge(clk_i) then
			if fast_done_r and enable_r then  -- If the fast counter has reached the current limit set by control_r and process is enabled
				cnt_fast_q <= (others => '0');  -- Reset the fast counter to zero
			elsif enable_r then
				cnt_fast_q <= cnt_fast_q + 1;  -- Otherwise, increment the fast counter
			else cnt_fast_q <= cnt_fast_q; --hold final value
			end if;
		end if;
	end process;
	
	----------------------------------------------------------------
	---------------------- slow counter process --------------------
	----------------------------------------------------------------
	
	proc2 : process(clk_i, rst_i)
	begin
	
	----------------------- asynchronous part ----------------------
		if rst_i = '1' then
			cnt_slow_q <= (others => '0');
	----------------------------------------------------------------
	----------------------- synchronous part -----------------------			
		elsif rising_edge(clk_i) then  
			if fast_done_r then  -- Only proceed if the fast counter has finished its current cycle
				if cnt_slow_q < upperBound_i then  -- If the slow counter hasn't reached the upper bound yet
					cnt_slow_q <= cnt_slow_q + 1;  -- Increment the slow counter
				elsif repeat_i = '1' then  -- Else, if repeat is requested
					cnt_slow_q <= (others => '0');  -- Reset the slow counter to zero
				else enable_r = 0; -- signal flag to stop fast count process when done
				end if;
			else
				cnt_slow_q <= cnt_slow_q;  -- Otherwise, hold the current value (do nothing)
				
			end if;  
		end if;  
	end process;  


	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
	fast_done_r <= (cnt_fast_q = control_r);
	control_r <= cnt_slow_q;
	count_o <= cnt_fast_q;
	busy_o <= '1' when (cnt_slow_q < upperBound_i or repeat_i = '1') and rst_i = '0' else '0'; -- turn off only when not repeating and finished counting

	----------------------------------------------------------------
end arc_sys;







