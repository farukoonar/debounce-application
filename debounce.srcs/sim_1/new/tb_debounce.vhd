--------------------------------------------------------------------------------
-- LIBRARY and PACKAGE DECLARATIONS
--------------------------------------------------------------------------------
-- standard package
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--------------------------------------------------------------------------------
-- TESTBENCH ENTITY
--------------------------------------------------------------------------------
entity tb_debounce is
generic(
c_clkfreq 		: integer 	:= 100_000_000;
c_debtime_ms 	: integer 	:= 10;
c_initval 		: std_logic := '0'
);
end tb_debounce;

--------------------------------------------------------------------------------
-- TESTBENCH ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of tb_debounce is

----------------------------------------------------------------------------
--  COMPONENT INSTANTIATION
----------------------------------------------------------------------------
component debounce is
generic(
c_clkfreq 		: integer 	:= 100_000_000;
c_debtime_ms 	: integer 	:= 10;
c_initval 		: std_logic := '0'
);
port(
CLK 		: in std_logic;
signal_i 	: in std_logic;
signal_o 	: out std_logic
);
end component debounce;

----------------------------------------------------------------------------
-- CONSTANTS
----------------------------------------------------------------------------
constant c_clkperiod : time := 10 ns;

----------------------------------------------------------------------------
-- SIGNALS
----------------------------------------------------------------------------
signal CLK 		: std_logic := '0';
signal signal_i : std_logic := '0';
signal signal_o : std_logic;

----------------------------------------------------------------------------
-- BEGIN
----------------------------------------------------------------------------
begin

----------------------------------------------------------------------------
-- UUT (Unit Under Test) 
----------------------------------------------------------------------------
UUT : debounce
generic map(
c_clkfreq 		=> c_clkfreq,
c_debtime_ms	=> c_debtime_ms,
c_initval 		=> c_initval
)
port map(
CLK 		=> CLK,
signal_i 	=> signal_i,
signal_o 	=> signal_o
);

----------------------------------------------------------------------------
-- CLOCK GENERATOR PROCESS
----------------------------------------------------------------------------
P_CLKGEN : process begin
CLK <= '0';
wait for c_clkperiod/2;
CLK <= '1';
wait for c_clkperiod/2;
end process;

----------------------------------------------------------------------------
-- STIMULUS PROCESS
----------------------------------------------------------------------------
P_STIMULI: process begin
signal_i <= '0';
wait for 2 ms;

signal_i <= '1';
wait for 2 ms;
signal_i <= '0';
wait for 9 ms;
signal_i <= '1';
wait for 9 ms;
signal_i <= '0';
wait for 4 ms;
signal_i <= '1';
wait for 1 ms;
signal_i <= '0';
wait for 6 ms;
signal_i <= '1';
wait for 13ms;

signal_i <= '0';
wait for 2 ms;
signal_i <= '1';
wait for 9 ms;
signal_i <= '0';
wait for 9 ms;
signal_i <= '1';
wait for 4 ms;
signal_i <= '0';
wait for 1 ms;
signal_i <= '1';
wait for 6 ms;
signal_i <= '0';
wait for 13ms;

assert false
report "SIM DONE"
severity failure;

end process;

end Behavioral;
