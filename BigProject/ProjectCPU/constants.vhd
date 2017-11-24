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

package constants is

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

    type op_t is (op_B, op_BEQZ, op_BNEZ, op_BTEQZ,
                  op_ADDIU, op_ADDDIU3, op_ADDSP,
                  op_LI, op_LW, op_LW_SP, op_SW, op_SW_SP,
                  op_JR, op_NOP, op_ADDU, op_AND,
                  op_CMP, op_MFIH, op_MFPC, op_MOVE,
                  op_MTIH, op_MTSP, op_NEG, op_NOT, op_OR,
                  op_SLL, op_SLT, op_SLTUI, op_SRA, op_SUBU);

end constants;
