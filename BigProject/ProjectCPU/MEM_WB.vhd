----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:37 11/24/2017 
-- Design Name: 
-- Module Name:    MEM_WB - Behavioral 
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

entity MEM_WB is
    port (
        i_clock : in std_logic;
        i_clear : in std_logic;
        i_forceClear : in std_logic;
        i_stall : in std_logic;
        i_wbAddr : in reg_addr_t;
        i_wbData : in word_t;

        o_wbAddr : out reg_addr_t := work.reg_addr.invalid;
        o_wbData : out word_t
    );
end MEM_WB;

architecture Behavioral of MEM_WB is

begin
    process (i_clock)
    begin
        if rising_edge(i_clock) and (i_stall = '0' or i_forceClear = '1') then
            if i_clear = '1' or i_forceClear = '1' then
                o_wbData <= (others => '-');
                o_wbAddr <= work.reg_addr.invalid;
            else
                o_wbData <= i_wbData;
                o_wbAddr <= i_wbAddr;
            end if;
        end if;
    end process;

end Behavioral;

