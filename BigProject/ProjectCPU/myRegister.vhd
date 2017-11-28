----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:16:04 11/24/2017 
-- Design Name: 
-- Module Name:    myRegister - Behavioral 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.reg_addr.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity myRegister is
	Port (
        i_clock : in std_logic;
        i_rxAddr : in std_logic_vector(2 downto 0);
        i_ryAddr : in std_logic_vector(2 downto 0);
        i_wbData : in std_logic_vector(15 downto 0);
        i_wbAddr : in std_logic_vector(3 downto 0); 
        o_rxData : out std_logic_vector(15 downto 0);
        o_ryData : out std_logic_vector(15 downto 0);
        o_T : out std_logic_vector(15 downto 0);
        o_SP : out std_logic_vector(15 downto 0);
        o_IH : out std_logic_vector(15 downto 0)
	);
end myRegister;

architecture Behavioral of myRegister is
	type Reg is array(0 to 15) of std_logic_vector(15 downto 0);
    signal regs : Reg:=(others => (others => '0'));
begin
    o_rxData <= regs(conv_integer(i_rxAddr));
    o_ryData <= regs(conv_integer(i_ryAddr));
    o_T <= regs(conv_integer(T));
    o_IH <= regs(conv_integer(IH));
    o_SP <= regs(conv_integer(SP));
    
    process(i_clock)
    begin
        if rising_edge(i_clock) and i_wbAddr /= invalid then
            case i_wbAddr is
                when "0000" => regs(0) <= i_wbData;
                when "0001" => regs(1) <= i_wbData;
                when "0010" => regs(2) <= i_wbData;
                when "0011" => regs(3) <= i_wbData;
                when "0100" => regs(4) <= i_wbData;
                when "0101" => regs(5) <= i_wbData;
                when "0110" => regs(6) <= i_wbData;
                when "0111" => regs(7) <= i_wbData;
                when T => regs(8) <= i_wbData;
                when IH => regs(11) <= i_wbData;
                when SP => regs(13) <= i_wbData;
                when others =>
            end case;
            -- regs(to_integer(unsigned(i_wbAddr))) <= i_wbData;
        end if;
    end process;
end Behavioral;

