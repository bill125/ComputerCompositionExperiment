----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:35 11/24/2017 
-- Design Name: 
-- Module Name:    JumpAndBranch - Behavioral 
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
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
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

entity JumpAndBranch is
    port (
        i_OP0 : in word_t; -- T or rx
        i_OP1 : in word_t; -- PC
        i_imm : in word_t;
        i_OP : in op_t;

        o_jumpEN : out std_logic := '0';
        o_jumpTarget : out word_t
    );
end JumpAndBranch;

architecture Behavioral of JumpAndBranch is
begin
    process (i_OP0, i_OP1, i_imm, i_OP)
    begin
        case i_OP is
            when op_B => -- PC = PC + imm
                o_jumpEN <= '1';
                o_jumpTarget <= i_OP1 + i_imm;
            when op_BEQZ | op_BTEQZ => -- if rx = 0 then PC = PC + imm | if T = 0 then PC = PC + imm
                if i_OP0 = x"0000" then
                    o_jumpEN <= '1';
                    o_jumpTarget <= i_OP1 + i_imm;
                else
                    o_jumpEN <= '0';
                    o_jumpTarget <= i_OP1;
                end if;
            when op_BNEZ => -- if rx /= 0 then PC = PC + imm
                if i_OP0 /= x"0000" then
                    o_jumpEN <= '1';
                    o_jumpTarget <= i_OP1 + i_imm;
                else
                    o_jumpEN <= '0';
                    o_jumpTarget <= i_OP1;
                end if;
            when op_JR =>
                o_jumpEN <= '1';
                o_jumpTarget <= i_OP0;
            when others =>
                o_jumpEN <= '0';
                o_jumpTarget <= i_OP1;
        end case;
    end process;

end Behavioral;

