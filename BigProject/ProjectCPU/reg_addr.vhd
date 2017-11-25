--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package reg_addr is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
    constant T: std_logic_vector(3 downto 0) := "1000";
    constant PC: std_logic_vector(3 downto 0) := "1010";
    constant IH: std_logic_vector(3 downto 0) := "1011";
    constant KB: std_logic_vector(3 downto 0) := "1100";
    constant SP: std_logic_vector(3 downto 0) := "1101";
    constant invalid: std_logic_vector(3 downto 0) := "1111";
end reg_addr;
