library IEEE;
use work.constants.op_t;
use IEEE.std_logic_1164.all;

package inst_const is
    constant OP_ADDIU: std_logic_vector(4 downto 0) := "01001";
    constant OP_ADDIU3: std_logic_vector(4 downto 0) := "01000";
    constant OP_ADDSP: std_logic_vector(4 downto 0) := "01100";
    constant OP_ADDU: std_logic_vector(4 downto 0) := "11100";
    constant OP_AND: std_logic_vector(4 downto 0) := "11101";
    constant OP_B: std_logic_vector(4 downto 0) := "00010";
    constant OP_BEQZ: std_logic_vector(4 downto 0) := "00100";
    constant OP_BNEZ: std_logic_vector(4 downto 0) := "00101";
    constant OP_BTEQZ: std_logic_vector(4 downto 0) := "01100";
    constant OP_CMP: std_logic_vector(4 downto 0) := "11101";
    constant OP_JR: std_logic_vector(4 downto 0) := "11101";
    constant OP_LI: std_logic_vector(4 downto 0) := "01101";
    constant OP_LW: std_logic_vector(4 downto 0) := "10011";
    constant OP_LW_SP: std_logic_vector(4 downto 0) := "10010";
    constant OP_MFIH: std_logic_vector(4 downto 0) := "11110";
    constant OP_MFPC: std_logic_vector(4 downto 0) := "11101";
    constant OP_MOVE: std_logic_vector(4 downto 0) := "01111";
    constant OP_MTIH: std_logic_vector(4 downto 0) := "11110";
    constant OP_MTSP: std_logic_vector(4 downto 0) := "01100";
    constant OP_NEG: std_logic_vector(4 downto 0) := "11101";
    constant OP_NOP: std_logic_vector(4 downto 0) := "00001";
    constant INST_NOP: std_logic_vector(15 downto 0) := "0000100000000000";
    constant OP_NOT: std_logic_vector(4 downto 0) := "11101";
    constant OP_OR: std_logic_vector(4 downto 0) := "11101";
    constant OP_SLL: std_logic_vector(4 downto 0) := "00110";
    constant OP_SLT: std_logic_vector(4 downto 0) := "11101";
    constant OP_SLTUI: std_logic_vector(4 downto 0) := "01011";
    constant OP_SRA: std_logic_vector(4 downto 0) := "00110";
    constant OP_SUBU: std_logic_vector(4 downto 0) := "11100";
    constant OP_SW: std_logic_vector(4 downto 0) := "11011";
    constant OP_SW_SP: std_logic_vector(4 downto 0) := "11010";

end;