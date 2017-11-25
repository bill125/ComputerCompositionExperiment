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

package op_type_constants is

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
    constant rx: std_logic_vector(2 downto 0) := "000";
    constant ry: std_logic_vector(2 downto 0) := "001";
    constant T: std_logic_vector(2 downto 0) := "010";
    constant PC: std_logic_vector(2 downto 0) := "011";
    constant IH: std_logic_vector(2 downto 0) := "100";
    constant rz: std_logic_vector(2 downto 0) := "101";
    constant SP: std_logic_vector(2 downto 0) := "110";
    constant invalid: std_logic_vector(2 downto 0) := "111";
end op_type_constants;
