----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:37 11/24/2017 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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

entity EX_MEM is
    port (
        i_clock : in std_logic;
        i_ALURes : in word_t;
        i_DMRE : in std_logic;
        i_DMWR : in std_logic;
        -- i_OP1 : in std_logic;
        i_addr : in word_t;
        i_clear : in std_logic;
        i_data : in word_t;
        i_stall : in std_logic;
        i_wbAddr : in reg_addr_t;

        o_ALURes : out word_t;
        o_DMRE : out std_logic;
        o_DMWR : out std_logic;
        o_addr : out word_t;
        o_data : out word_t;
        o_wbAddr : out reg_addr_t
    );
end EX_MEM;

architecture Behavioral of EX_MEM is

begin
    process (i_clock)
    begin
        if rising_edge(i_clock) and i_stall = '0' then
            if i_clear = '1' then
                o_DMRE <= '0';
                o_DMWR <= '0';
                o_wbAddr <= work.reg_addr.invalid;
            else
                o_ALURes <= i_ALURes;
                o_DMRE <= i_DMRE;
                o_DMWR <= i_DMWR;
                o_addr <= i_addr;
                o_data <= i_data;
                o_wbAddr <= i_wbAddr;
            end if;
        end if;
    end process;

end Behavioral;

