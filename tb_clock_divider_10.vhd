-- Simulation only: generates 32 MHz and checks all ten divided outputs.
-- VHDL-93; simulator time resolution must be 1 ps or finer.

library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_divider_10 is
end entity tb_clock_divider_10;

architecture sim of tb_clock_divider_10 is
    constant CLK_PERIOD : time := 31250 ps; -- 31.25 ns = 32 MHz
    constant SIM_TIME   : time := 200 us;

    signal clk_in  : std_logic := '0';
    signal reset   : std_logic := '1';
    signal clk_div : std_logic_vector(9 downto 0);
    signal checked : std_logic_vector(9 downto 0) := (others => '0');
begin
    uut : entity work.clock_divider_10(rtl)
        port map (
            clk_in  => clk_in,
            reset   => reset,
            clk_div => clk_div
        );

    -- 15.625 ns LOW + 15.625 ns HIGH = 31.25 ns per cycle.
    clock_process : process
    begin
        while now < SIM_TIME loop
            clk_in <= '0';
            wait for CLK_PERIOD / 2;
            clk_in <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        clk_in <= '0';
        wait;
    end process;

    -- Hold reset HIGH for the first 100 ns.
    reset_process : process
    begin
        wait for 1 ns;
        assert clk_div = "0000000000"
            report "FAIL: reset did not clear the outputs"
            severity failure;
        wait for 99 ns;
        reset <= '0';
        wait;
    end process;

    -- Check each output's HIGH time and full period independently.
    stage_checks : for i in 0 to 9 generate
        check_stage : process
            variable first_rise : time;
        begin
            wait until reset = '0';
            wait until rising_edge(clk_div(i));
            first_rise := now;

            wait until falling_edge(clk_div(i));
            assert now - first_rise = CLK_PERIOD * (2 ** i)
                report "FAIL: HIGH time at stage " & integer'image(i + 1)
                severity failure;

            wait until rising_edge(clk_div(i));
            assert now - first_rise = CLK_PERIOD * (2 ** (i + 1))
                report "FAIL: period at stage " & integer'image(i + 1)
                severity failure;

            checked(i) <= '1';
            wait;
        end process;
    end generate stage_checks;

    finish_process : process
    begin
        wait for SIM_TIME;
        assert checked = "1111111111"
            report "FAIL: one or more outputs did not complete the checks"
            severity failure;
        report "PASS: reset and all 10 output periods/duty cycles checked."
            severity note;
        wait;
    end process;
end architecture sim;
