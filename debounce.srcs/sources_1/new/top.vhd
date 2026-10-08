--------------------------------------------------------------------------------
-- LIBRARY and PACKAGE DECLARATIONS
--------------------------------------------------------------------------------
-- standard package
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity top is
generic(
c_clkfreq 		: integer 	:= 100_000_000;
c_debtime_ms 	: integer 	:= 10;
c_initval 		: std_logic := '0'
);
port(
CLK : in std_logic;  
RST : in std_logic;
SW : in std_logic_vector(1 downto 0);
LED : out std_logic_vector(15 downto 0)
);
end top;

--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of top is

--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- COMPONENT DECLARATIONS
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------------
signal counter_sw0 : std_logic_vector (7 downto 0) := (others => '0');
signal counter_sw15 : std_logic_vector (7 downto 0) := (others => '0');

signal sw15_prev 	: std_logic := '0';
signal sw0_prev 	: std_logic := '0';
signal sw0_deb 		: std_logic := '0';

--------------------------------------------------------------------------------
-- BEGIN
--------------------------------------------------------------------------------	
begin

--------------------------------------------------------------------------------
-- COMPONENT INSTANTIATIONS
--------------------------------------------------------------------------------
debounce_i: debounce 
generic map(
c_clkfreq 		=> c_clkfreq,
c_debtime_ms 	=> c_debtime_ms,
c_initval 		=> c_initval
)
port map(
CLK          => CLK,
signal_i     => sw(0),
signal_o     => sw0_deb
);

--------------------------------------------------------------------------------
-- CONCURRENT STATEMENTS
--------------------------------------------------------------------------------
LED(7 downto 0) 	<= counter_sw0; 
LED(15 downto 8) 	<= counter_sw15;

--------------------------------------------------------------------------------
-- PROCESS STATEMENTS 
-- NOTE: Process blocks work concurrently with each other
--------------------------------------------------------------------------------
-- COMBINATIONAL PROCESS


-- SEQUENTIAL PROCESS
process(clk) begin
if(rising_edge(clk)) then

    sw0_prev <= sw0_deb;
    sw15_prev <= sw(1);
    
    if(sw0_deb = '1' and sw0_prev = '0') then
        counter_sw0 <= counter_sw0 + 1;
    end if;
    
    if(sw(1) = '1' and sw15_prev = '0') then
        counter_sw15 <= counter_sw15 + 1;
    end if;

    if(RST = '1') then
        counter_sw0 <= (others => '0');
        counter_sw15 <= (others => '0');
    end if;
    
end if; 
end process;


end Behavioral;
