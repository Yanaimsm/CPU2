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
	signal fast_done_r       : boolean; -- signal to show that a cycle has completed

 
begin
	----------------------------------------------------------------
	----------------------- fast counter process -------------------
	----------------------------------------------------------------
	proc1 : process(clk_i,rst_i)
	begin
		if rst_i = '1' then
			cnt_fast_q <= (others => '0');
		elsif rising_edge(clk_i) then
			if cnt_fast_q = control_r then
				cnt_fast_q <= (others => '0');
			else
				cnt_fast_q <= cnt_fast_q + 1;
			end if;
		end if;
	end process;
	----------------------------------------------------------------
	---------------------- slow counter process --------------------
	----------------------------------------------------------------
	proc2 : process(clk_i, rst_i)
	begin
		if rst_i = '1' then
			control_r  <= (others => '0');
			cnt_slow_q <= (others => '0');
		elsif rising_edge(clk_i) then
			if fast_done_r then
				if control_r < upperBound_i then
					control_r <= control_r + 1;
				elsif repeat_i = '1' then
					control_r <= (others => '0');
				else
					control_r <= control_r; -- Hold
				end if;

				cnt_slow_q <= control_r;  -- Mirror (assigned previous value here, optionally delay by one cycle)
			end if;
		end if;
	end process;

	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
	fast_done_r <= (cnt_fast_q = control_r);
	count_o <= cnt_fast_q;
	busy_o <= '1' when control_r < upperBound_i or repeat_i = '1' else '0';

	
	----------------------------------------------------------------
end arc_sys;







