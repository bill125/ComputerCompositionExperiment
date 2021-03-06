----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:12 11/24/2017 
-- Design Name: 
-- Module Name:    IF_ID - Behavioral 
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
use work.op_type_constants;
use work.reg_addr;
use work.inst_const;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IF_ID is
    port (
        i_clock : in std_logic;
        i_inst : in word_t;
        i_PC : in word_t;
        i_stall : in std_logic;
        i_clear : in std_logic;
        i_forceClear : in std_logic;
        o_PC : out word_t := (others => '0');
        o_inst : out word_t := work.inst_const.INST_NOP;
        o_rxAddr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid;
        o_ryAddr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid;
        o_rzAddr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid;
        o_cleared : out std_logic
    );
end IF_ID;

architecture Behavioral of IF_ID is
begin
    process(i_clock)
    begin
        if rising_edge(i_clock) and (i_stall = '0' or i_forceClear = '1') then
            if i_clear = '1' or i_forceClear = '1' then
                o_cleared <= '1';
                -- o_OP <= work.inst_const.OP_NOP;
                o_PC <= i_PC;
                o_inst <= work.inst_const.INST_NOP;
                o_rxAddr <= work.reg_addr.invalid;
                o_ryAddr <= work.reg_addr.invalid;
                o_rzAddr <= work.reg_addr.invalid;
            else
                o_cleared <= '0';
                -- o_OP <= i_inst(15 downto 11);
                o_PC <= i_PC;
                o_inst <= i_inst;
                o_rxAddr <= '0' & i_inst(10 downto 8);
                o_ryAddr <= '0' & i_inst(7 downto 5);
                o_rzAddr <= '0' & i_inst(4 downto 2);
            end if;
        end if;
    end process;
end Behavioral;

