----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:04 11/24/2017 
-- Design Name: 
-- Module Name:    BTB - Behavioral 
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

entity BTB is
    port (
        -- BTBRead
        i_IMPC : in word_t;
        o_predPC : out word_t;

        -- BTBWrite
        i_REGPC : in word_t; -- for BTBWrite
        i_jumpEN : in std_logic;
        i_jumpTarget : in word_t;
        i_predPC : in word_t;
        o_predSucc : out std_logic
    );
end BTB;

architecture Behavioral of BTB is

begin
    o_predPC <= i_IMPC + '1'; -- TODO: BTBR
    o_predSucc <= '1' when (i_jumpEN = '0' or (i_jumpTarget = i_predPC)) else '0';
    -- TODO: BTBW. Such as: reg(i_REGPC) <= i_jumpTarget.
end Behavioral;

