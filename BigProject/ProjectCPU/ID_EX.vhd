----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:54 11/24/2017 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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
use work.constants.all;
use work.inst_const;
use work.op_type_constants;
use work.reg_addr;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_EX is
    port (
        i_clock : in std_logic;
        i_ALUOP : in alu_op_t;
        i_DMRE : in std_logic;
        i_DMWR : in std_logic;
        i_OP : in op_t;
        i_OP0 : in word_t;
        i_OP1 : in word_t;
        i_OP0Src : in opSrc_t;
        i_OP1Src : in opSrc_t;
        i_clear : in std_logic;
        i_imm : in word_t;
        i_stall : in std_logic;
        i_wbAddr : in reg_addr_t;

        o_ALUOP : out alu_op_t;
        o_DMRE : out std_logic := '0';
        o_DMWR : out std_logic := '0';
        o_OP : out op_t := op_NOP;
        o_OP0 : out word_t;
        o_OP1 : out word_t;
        o_OP0Src : out opSrc_t;
        o_OP1Src : out opSrc_t;
        o_imm : out word_t;
        o_wbAddr : out reg_addr_t := work.reg_addr.invalid
    );
end ID_EX;

architecture Behavioral of ID_EX is

begin
    process(i_clock)
    begin
        if rising_edge(i_clock) and i_stall = '0' then
            if i_clear = '1' then
                o_ALUOP <= alu_nop;
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_OP <= op_NOP;
                o_OP0 <= (others => '-');
                o_OP1 <= (others => '-');
                o_OP0Src <= opSrc_zero;
                o_OP1Src <= opSrc_zero;
                o_wbAddr <= work.reg_addr.invalid;
            else
                o_ALUOP <= i_ALUOP;
                o_DMRE <= i_DMRE;
                o_DMWR <= i_DMWR;
                o_OP <= i_OP;
                o_OP0 <= i_OP0;
                o_OP1 <= i_OP1;
                o_OP0Src <= i_OP0Src;
                o_OP1Src <= i_OP1Src;
                o_imm <= i_imm;
                o_wbAddr <= i_wbAddr;
            end if;
        end if;
    end process;

end Behavioral;

