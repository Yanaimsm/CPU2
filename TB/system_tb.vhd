library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity tb is
end tb;

architecture rtb of tb is
    -- Signals for n=8
    signal rst8, clk8, repeat8 : std_logic := '0';
    signal upperBound8 : std_logic_vector(7 downto 0);
    signal count8 : std_logic_vector(7 downto 0);
    signal busy8 : std_logic;

    -- Signals for n=16
    signal rst16, clk16, repeat16 : std_logic := '0';
    signal upperBound16 : std_logic_vector(15 downto 0);
    signal count16 : std_logic_vector(15 downto 0);
    signal busy16 : std_logic;

    -- Signals for n=32
    signal rst32, clk32, repeat32 : std_logic := '0';
    signal upperBound32 : std_logic_vector(31 downto 0);
    signal count32 : std_logic_vector(31 downto 0);
    signal busy32 : std_logic;

begin
    ----------------------------------------------------------------
    -- Instantiate the top module for n = 8
    ----------------------------------------------------------------
    UUT_8 : entity work.top
        generic map (n => 8)
        port map (
            rst_i => rst8,
            clk_i => clk8,
            repeat_i => repeat8,
            upperBound_i => upperBound8,
            count_o => count8,
            busy_o => busy8
        );

    clk_proc_8 : process
    begin
        while now < 5000 ns loop
            clk8 <= '0'; wait for 50 ns;
            clk8 <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc_8 : process
    begin
        rst8 <= '1'; wait for 100 ns; rst8 <= '0';
        upperBound8 <= "00000110"; -- 6
        repeat8 <= '1'; wait for 2000 ns;
        upperBound8 <= "00001010"; -- 10
        repeat8 <= '0'; wait;
    end process;

    ----------------------------------------------------------------
    -- Instantiate the top module for n = 16
    ----------------------------------------------------------------
    UUT_16 : entity work.top
        generic map (n => 16)
        port map (
            rst_i => rst16,
            clk_i => clk16,
            repeat_i => repeat16,
            upperBound_i => upperBound16,
            count_o => count16,
            busy_o => busy16
        );

    clk_proc_16 : process
    begin
        while now < 5000 ns loop
            clk16 <= '0'; wait for 50 ns;
            clk16 <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc_16 : process
    begin
        rst16 <= '1'; wait for 100 ns; rst16 <= '0';
        upperBound16 <= x"0006";  -- 6
        repeat16 <= '1'; wait for 3000 ns;
        upperBound16 <= x"0010";  -- 16
        repeat16 <= '0'; wait;
    end process;

    ----------------------------------------------------------------
    -- Instantiate the top module for n = 32
    ----------------------------------------------------------------
    UUT_32 : entity work.top
        generic map (n => 32)
        port map (
            rst_i => rst32,
            clk_i => clk32,
            repeat_i => repeat32,
            upperBound_i => upperBound32,
            count_o => count32,
            busy_o => busy32
        );

    clk_proc_32 : process
    begin
        while now < 5000 ns loop
            clk32 <= '0'; wait for 50 ns;
            clk32 <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc_32 : process
    begin
        rst32 <= '1'; wait for 100 ns; rst32 <= '0';
        upperBound32 <= x"00000010";  -- 16
        repeat32 <= '1'; wait for 3000 ns;
        upperBound32 <= x"00000020";  -- 32
        repeat32 <= '0'; wait;
    end process;

end architecture rtb;
