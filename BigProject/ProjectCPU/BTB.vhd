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
use ieee.numeric_std.to_integer;
use ieee.numeric_std.unsigned;
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
        i_clock : in std_logic;
        i_OP : in op_t;
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
    signal idx : std_logic_vector(3 downto 0) := "0000";
    signal key, val : Reg:=(others => (others => '0'));
    signal jumpTarget : word_t := (others => '0');
begin
    o_predPC <= val(0) when i_IMPC = key(0) else 
        val(1) when i_IMPC = key(1) else 
        val(2) when i_IMPC = key(2) else 
        val(3) when i_IMPC = key(3) else 
        val(4) when i_IMPC = key(4) else 
        val(5) when i_IMPC = key(5) else 
        val(6) when i_IMPC = key(6) else 
        val(7) when i_IMPC = key(7) else 
        val(8) when i_IMPC = key(8) else 
        val(9) when i_IMPC = key(9) else 
        val(10) when i_IMPC = key(10) else 
        val(11) when i_IMPC = key(11) else 
        val(12) when i_IMPC = key(12) else 
        val(13) when i_IMPC = key(13) else 
        val(14) when i_IMPC = key(14) else 
        val(15) when i_IMPC = key(15) else 
        i_IMPC + '1';
    -- o_predPC <= i_IMPC + '1'; -- TODO: BTBR
    o_predSucc <= '1' when (i_jumpEN = '0' or (i_jumpTarget = i_predPC)) else '0';
    jumpTarget <= i_jumpTarget when i_jumpEN = '1' 
        else i_REGPC + '1';
    process (i_clock)
    begin
        if rising_edge(i_clock) and (i_OP = op_BEQZ or i_OP = op_BTEQZ or i_OP = op_BNEZ) then
            if i_REGPC = key(0) then val(0) <= jumpTarget;
            elsif i_REGPC = key(1) then val(1) <= jumpTarget;
            elsif i_REGPC = key(2) then val(2) <= jumpTarget;
            elsif i_REGPC = key(3) then val(3) <= jumpTarget;
            elsif i_REGPC = key(4) then val(4) <= jumpTarget;
            elsif i_REGPC = key(5) then val(5) <= jumpTarget;
            elsif i_REGPC = key(6) then val(6) <= jumpTarget;
            elsif i_REGPC = key(7) then val(7) <= jumpTarget;
            elsif i_REGPC = key(8) then val(8) <= jumpTarget;
            elsif i_REGPC = key(9) then val(9) <= jumpTarget;
            elsif i_REGPC = key(10) then val(10) <= jumpTarget;
            elsif i_REGPC = key(11) then val(11) <= jumpTarget;
            elsif i_REGPC = key(12) then val(12) <= jumpTarget;
            elsif i_REGPC = key(13) then val(13) <= jumpTarget;
            elsif i_REGPC = key(14) then val(14) <= jumpTarget;
            elsif i_REGPC = key(15) then val(15) <= jumpTarget;
            else
                idx <= idx + '1';
                key(ieee.numeric_std.to_integer(ieee.numeric_std.unsigned(idx))) <= i_REGPC;
                val(ieee.numeric_std.to_integer(ieee.numeric_std.unsigned(idx))) <= jumpTarget;
            end if;
        end if;
    end process;
end Behavioral;

