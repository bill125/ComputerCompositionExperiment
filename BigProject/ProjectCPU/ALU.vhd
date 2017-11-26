----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:19:19 11/24/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all; 
use work.constants.all;
use work.inst_const;
use work.op_type_constants;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port(
        i_OP0 : in word_t;
        i_OP1 : in word_t;
        i_imm : in word_t;
        i_OP0Src : in opSrc_t;
        i_OP1Src : in opSrc_t;
        i_ALUOP : in alu_op_t;
        o_ALURes : out word_t
    );
end ALU;

architecture Behavioral of ALU is
signal op0 : word_t;
signal op1 : word_t;
signal SllTmp : std_logic_vector (15 downto 0);
signal SraTmp : std_logic_vector (15 downto 0);
begin
    op0 <= i_OP0 when i_OP0Src = opSrc_op0 else
           i_OP1 when i_OP0Src = opSrc_op1 else
           i_imm when i_OP0Src = opSrc_imm else
           (others => '0');
    op1 <= i_OP0 when i_OP1Src = opSrc_op0 else
           i_OP1 when i_OP1Src = opSrc_op1 else
           i_imm when i_OP1Src = opSrc_imm else
           (others => '0');
    
	SllTmp <= op0(14 downto 0) & '0' when op1 (2 downto 0) = "001" else
			op0(13 downto 0) & "00" when op1 (2 downto 0) = "010" else
			op0(12 downto 0) & "000" when op1 (2 downto 0) = "011" else
			op0(11 downto 0) & "0000" when op1 (2 downto 0) = "100" else
			op0(10 downto 0) & "00000" when op1 (2 downto 0) = "101" else
			op0(9 downto 0) & "000000" when op1 (2 downto 0) = "110" else
			op0(8 downto 0) & "0000000" when op1 (2 downto 0) = "111" else
			op0(7 downto 0) & "00000000" when op1 (2 downto 0) = "000";
	SraTmp <= '0' & op0(15 downto 1) when op1 (2 downto 0) = "001" else
			"00" & op0(15 downto 2) when op1 (2 downto 0) = "010" else
			"000" & op0(15 downto 3) when op1 (2 downto 0) = "011" else
			"0000" & op0(15 downto 4) when op1 (2 downto 0) = "100" else
			"00000" & op0(15 downto 5) when op1 (2 downto 0) = "101" else
			"000000" & op0(15 downto 6) when op1 (2 downto 0) = "110" else
			"0000000" & op0(15 downto 7) when op1 (2 downto 0) = "111" else
			"00000000" & op0(15 downto 8) when op1 (2 downto 0) = "000";
    
    o_ALURes <= op0+op1 when i_ALUOP = alu_addu else
                op0-op1 when i_ALUOP = alu_subu else
                not op0 when i_ALUOP = alu_not else
                op0 or op1 when i_ALUOP = alu_or else
                op0 and op1 when i_ALUOP = alu_and else
                op0 xor op1 when i_ALUOP = alu_xor else
                SllTmp when i_ALUOP = alu_sll else
                SraTmp when i_ALUOP = alu_sra else
                "0000000000000001" when op0/=op1 and i_ALUOP = alu_cmp else
                (others => '0') when op0=op1 and i_ALUOP = alu_cmp else
                "0000000000000001" when SIGNED(op0) < SIGNED(op1) and i_ALUOP = alu_less else
                (others => '0') when SIGNED(op0) >= SIGNED(op1) and i_ALUOP = alu_less else
                "0000000000000001" when UNSIGNED(op0) < UNSIGNED(op1) and i_ALUOP = alu_uless else
                (others => '0') when UNSIGNED(op0) >= UNSIGNED(op1) and i_ALUOP = alu_uless else
                (others => '0');
end Behavioral;

