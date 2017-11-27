----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:16:56 11/24/2017 
-- Design Name: 
-- Module Name:    Control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.op_type_constants;
use work.constants.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
    Port(
        i_inst : in inst_t;
        o_ALUOP : out alu_op_t;
        o_OP0Type : out std_logic_vector (2 downto 0);
        o_OP1Type : out std_logic_vector (2 downto 0);
        o_wbType : out std_logic_vector (2 downto 0);
        o_OP0Src : out opSrc_t;
        o_OP1Src : out opSrc_t;
        o_DMRE : out std_logic := '0';
        o_DMWR : out std_logic := '0';
        o_OP : out op_t := op_NOP
    );
end Control;

architecture Behavioral of Control is
begin
    process (i_inst)
    begin
        case i_inst(15 downto 11) is
            when "00001" => -- nop
                o_ALUOP <= alu_nop;
                o_OP0Type <= work.op_type_constants.invalid;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_zero;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_NOP;
            when "00010" => -- b
                o_ALUOP <= alu_nop;
                o_OP0Type <= work.op_type_constants.invalid;
                o_OP1Type <= work.op_type_constants.PC;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_zero;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_B;
            when "00100" => -- beqz
                o_ALUOP <= alu_nop;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.PC;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_zero;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_BEQZ;
            when "00101" => -- bnez
                o_ALUOP <= alu_nop;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.PC;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_zero;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_BNEZ;
            when "01100" => 
                case i_inst(10 downto 8) is
                    when "000" => -- bteqz
                        o_ALUOP <= alu_nop;
                        o_OP0Type <= work.op_type_constants.T;
                        o_OP1Type <= work.op_type_constants.PC;
                        o_wbType <= work.op_type_constants.invalid;
                        o_OP0Src <= opSrc_zero;
                        o_OP1Src <= opSrc_zero;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_BTEQZ;
                    when "011" => -- addsp
                        o_ALUOP <= alu_addu;
                        o_OP0Type <= work.op_type_constants.SP;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.SP;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_imm;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_ADDSP;
                    when "100" => -- mtsp
                        o_ALUOP <= alu_addu;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.SP;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_zero;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_MTSP;
                    when others =>
                end case;
            when "01001" => -- addiu
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.rx;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_ADDIU;
            when "01000" => -- addiu3
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.ry;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_ADDIU3;
            when "11100" =>
                case i_inst(1 downto 0) is
                    when "01" => -- addu
                        o_ALUOP <= alu_addu;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.rz;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_ADDU;
                    when "11" => -- subu
                        o_ALUOP <= alu_subu;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.rz;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_SUBU;
                    when others =>
                end case;
            when "01101" => -- li
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.invalid;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.rx;
                o_OP0Src <= opSrc_imm;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_LI;
            when "01111" => -- move
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.ry;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.rx;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_zero;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_MOVE;
            when "00110" =>
                case i_inst(1 downto 0) is
                    when "00" => -- sll
                        o_ALUOP <= alu_sll;
                        o_OP0Type <= work.op_type_constants.ry;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_imm;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_SLL;
                    when "11" => -- sra
                        o_ALUOP <= alu_sra;
                        o_OP0Type <= work.op_type_constants.ry;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_imm;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_SRA;
                    when others =>
                end case;
            when "11101" =>
                case i_inst(4 downto 0) is
                    when "01111" => -- not
                        o_ALUOP <= alu_not;
                        o_OP0Type <= work.op_type_constants.ry;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_zero;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_NOT;
                    when "01100" => -- and
                        o_ALUOP <= alu_and;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_AND;
                    when "01101" => -- or
                        o_ALUOP <= alu_or;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_OR;
                    when "01010" => -- cmp
                        o_ALUOP <= alu_cmp;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.T;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_CMP;
                    when "01011" => -- neg
                        o_ALUOP <= alu_subu;
                        o_OP0Type <= work.op_type_constants.ry;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_zero;
                        o_OP1Src <= opSrc_op0;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_NEG;
                    when "00010" => -- slt
                        o_ALUOP <= alu_less;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.ry;
                        o_wbType <= work.op_type_constants.T;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_op1;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_SLT;
                    when "00000" =>
                        case i_inst(7 downto 5) is
                            when "000" => -- jr
                                o_ALUOP <= alu_nop;
                                o_OP0Type <= work.op_type_constants.rx;
                                o_OP1Type <= work.op_type_constants.PC;
                                o_wbType <= work.op_type_constants.invalid;
                                o_OP0Src <= opSrc_zero;
                                o_OP1Src <= opSrc_zero;
                                o_DMRE <= '0';
                                o_DMWR <= '0';
                                o_OP <= op_JR;
                            when "010" => -- mfpc
                                o_ALUOP <= alu_addu;
                                o_OP0Type <= work.op_type_constants.PC;
                                o_OP1Type <= work.op_type_constants.invalid;
                                o_wbType <= work.op_type_constants.rx;
                                o_OP0Src <= opSrc_op0;
                                o_OP1Src <= opSrc_zero;
                                o_DMRE <= '0';
                                o_DMWR <= '0';
                                o_OP <= op_MFPC;
                            when others =>
                        end case;                        
                    when others =>
                end case;
            when "01011" => -- sltui
                o_ALUOP <= alu_uless;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.T;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_SLTUI;
            when "11110" =>
                case i_inst(4 downto 0) is
                    when "00000" => -- mfih
                        o_ALUOP <= alu_addu;
                        o_OP0Type <= work.op_type_constants.IH;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.rx;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_zero;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_MFIH;
                    when "00001" => -- mtih
                        o_ALUOP <= alu_addu;
                        o_OP0Type <= work.op_type_constants.rx;
                        o_OP1Type <= work.op_type_constants.invalid;
                        o_wbType <= work.op_type_constants.IH;
                        o_OP0Src <= opSrc_op0;
                        o_OP1Src <= opSrc_zero;
                        o_DMRE <= '0';
                        o_DMWR <= '0';
                        o_OP <= op_MTIH;
                    when others =>
                end case;
            when "10011" => -- lw
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.ry;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '1';
                o_DMWR <= '0';
                o_OP <= op_LW;
            when "10010" => -- lwsp
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.SP;
                o_OP1Type <= work.op_type_constants.invalid;
                o_wbType <= work.op_type_constants.rx;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '1';
                o_DMWR <= '0';
                o_OP <= op_LW_SP;
            when "11011" => -- sw
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.rx;
                o_OP1Type <= work.op_type_constants.ry;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '0';
                o_DMWR <= '1';
                o_OP <= op_SW;
            when "11010" => -- swsp
                o_ALUOP <= alu_addu;
                o_OP0Type <= work.op_type_constants.SP;
                o_OP1Type <= work.op_type_constants.rx;
                o_wbType <= work.op_type_constants.invalid;
                o_OP0Src <= opSrc_op0;
                o_OP1Src <= opSrc_imm;
                o_DMRE <= '0';
                o_DMWR <= '1';
                o_OP <= op_SW_SP;
            when others =>
        end case;                
    end process;
end Behavioral;

