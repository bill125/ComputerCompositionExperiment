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
    constant uart_wait_turns: integer := 15;
    constant uart_control_addr: std_logic_vector (17 downto 0) := "001011111100000001";
    constant uart_data_addr: std_logic_vector (17 downto 0) := "001011111100000000";

    constant word_length: integer := 16;
    constant addr_length: integer := 16;
    constant bus_addr_length: integer := 18;
    constant reg_addr_length: integer := 4;
    constant inst_length: integer := 16;
    constant pc_length: integer := 16;
    constant stage_length: integer := 4;
    constant stage_PC: integer := 0;
    constant stage_IF_ID: integer := 1;
    constant stage_ID_EX: integer := 2;
    constant stage_EX_MEM: integer := 3;
    constant stage_MEM_WB: integer := 4;

    type op_t is (op_B, op_BEQZ, op_BNEZ, op_BTEQZ,
                  op_ADDIU, op_ADDIU3, op_ADDSP,
                  op_LI, op_LW, op_LW_SP, op_SW, op_SW_SP,
                  op_JR, op_NOP, op_ADDU, op_AND,
                  op_CMP, op_MFIH, op_MFPC, op_MOVE,
                  op_MTIH, op_MTSP, op_NEG, op_NOT, op_OR,
                  op_SLL, op_SLT, op_SLTUI, op_SRA, op_SUBU);
    type alu_op_t is (alu_nop, alu_cmp, alu_less, alu_uless,
                  alu_addu, alu_subu,
                  alu_or, alu_and, alu_xor, alu_nor, alu_not,
                  alu_sll, alu_sra, alu_srl);
    type opSrc_t is(opSrc_op0, opSrc_op1, opSrc_imm, opSrc_zero);

    subtype word_t is std_logic_vector (word_length - 1 downto 0);
    subtype addr_t is std_logic_vector (addr_length - 1 downto 0);
    subtype bus_addr_t is std_logic_vector (bus_addr_length - 1 downto 0);
    subtype reg_addr_t is std_logic_vector (reg_addr_length - 1 downto 0);
    subtype inst_t is std_logic_vector (inst_length - 1 downto 0);
    subtype pc_t is std_logic_vector (pc_length - 1 downto 0);
    type Reg is array(0 to 15) of std_logic_vector(15 downto 0);

    type bus_request_t is record
        data: word_t;
        addr: bus_addr_t;
        writeRequest: std_logic;
        readRequest: std_logic;
    end record;

    type bus_response_t is record
        data: word_t;
        stallRequest: std_logic;
    end record;

end constants;
