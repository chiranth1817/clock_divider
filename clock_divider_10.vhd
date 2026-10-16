-- Ten successive divide-by-two outputs from one input clock.
-- Synthesizable VHDL-93. For simulation, use tb_clock_divider_10.vhd.
-- reset = '1' clears every output; reset = '0' enables counting.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider_10 is
    port (
        clk_in  : in  std_logic;
        reset   : in  std_logic;
        clk_div : out std_logic_vector(9 downto 0)
    );
end entity clock_divider_10;

architecture rtl of clock_divider_10 is
    signal count : unsigned(9 downto 0);
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
        elsif rising_edge(clk_in) then
            count <= count + 1;
        end if;
    end process;

    clk_div <= std_logic_vector(count);
end architecture rtl;
