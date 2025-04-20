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
    signal enable_r : std_logic := '1';  -- Enable flag, initially enabled
 
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
			if enable_r  = '1' then
				if cnt_fast_q = control_r then  -- If the fast counter has reached the current limit set by control_r
					cnt_fast_q <= (others => '0');  -- Reset the fast counter to zero
				else
					cnt_fast_q <= cnt_fast_q + 1;  -- Otherwise, increment the fast counter
				end if;
			else 
				cnt_fast_q <= cnt_fast_q; --hold
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
            if fast_done_r then  -- Proceed only if fast counter cycle is done
                if cnt_slow_q < upperBound_i then  -- Slow counter not yet at upper bound
                    cnt_slow_q <= cnt_slow_q + 1;
                elsif repeat_i = '1' then  -- If repeat is requested
                    cnt_slow_q <= (others => '0');  -- Reset the slow counter to zero
				
                end if;
            end if;
        end if;
    end process;

	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
    fast_done_r <= (cnt_fast_q = control_r);  -- Fast counter done when equal to control_r
    control_r <= cnt_slow_q;  -- Set the control register to the slow counter value
    count_o <= cnt_fast_q;  -- Output the current fast counter value
    busy_o <= '1' when (enable_r  = '1') else '0';  -- Busy if not finished or repeat is active
	enable_r <= '0' when (cnt_slow_q >= upperBound_i and repeat_i = '0' and fast_done_r) else '1'; -- concurrent conditioning for enable_r flag
	----------------------------------------------------------------
end arc_sys;