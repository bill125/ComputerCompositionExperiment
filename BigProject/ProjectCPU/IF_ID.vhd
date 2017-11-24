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
use workspace.inst_constants;
use workspace.op_type_constants;

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
        i_inst : in std_logic_vector(15 downto 0);
        i_PC : in std_logic_vector(15 downto 0);
        i_stall : in std_logic;
        i_clear : in std_logic;
        o_OP : out std_logic_vector(4 downto 0);
        o_inst : out std_logic_vector(15 downto 0);
        o_rxAddr : out std_logic_vector(2 downto 0);
        o_ryAddr : out std_logic_vector(2 downto 0)
    );
end IF_ID;

architecture Behavioral of IF_ID is
begin
    process(i_clock)
    begin
        if rising_edge(i_clock) then
            if i_clear = '1' then
                o_OP <= workspace.inst_constants.OP_NOP;
                o_inst <= workspace.inst_constants.INST_NOP;
                o_rxAddr <= '1' & workspace.op_type_constants.invalid;
                o_ryAddr <= '1' & workspace.op_type_constants.invalid;
            elsif i_stall = '0' then
                o_OP <= i_inst(15 downto 11);
                o_inst <= i_inst;
                o_rxAddr <= '0' & i_inst(10 downto 8);
                o_ryAddr <= '0' & i_inst(10 downto 8);
            end if;
        end if;
    end process
end Behavioral;

