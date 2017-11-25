----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:19:41 11/24/2017 
-- Design Name: 
-- Module Name:    ALU_MUX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_MUX is
    Port(
        i_ALURes : in word_t;
        i_OP0 : in word_t;
        i_OP1 : in word_t;
        i_OP : in op_t;
        o_addr : out addr_t;
        o_data : out word_t;
        o_ALURes : out word_t
    );
end ALU_MUX;

architecture Behavioral of ALU_MUX is

begin
    o_addr <= i_ALURes;
    o_ALURes <= i_ALURes;
    o_data <= i_OP1;
end Behavioral;

