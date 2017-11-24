----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:16:04 11/24/2017 
-- Design Name: 
-- Module Name:    Register - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register is
	port (
        i_rxAddr : in std_logic_vector(2 downto 0);
        i_ryAddr : in std_logic_vector(2 downto 0);
        i_WE : in std_logic;
        i_wbData : in std_logic_vector(15 downto 0);
        i_wbAddr : in std_logic_vector(3 downto 0); 
        o_rxData : out std_logic_vector(15 downto 0);
        o_ryData : out std_logic_vector(15 downto 0);
        o_T : out std_logic_vector(15 downto 0);
        o_SP : out std_logic_vector(15 downto 0);
        o_IH : out std_logic_vector(15 downto 0);
        o_KB : out std_logic_vector(15 downto 0)
	);
end Register;

architecture Behavioral of Register is
	type Reg is array(0 to 15) of std_logic_vector(15 downto 0);
    signal regs : RegFile;
begin
    o_rxData <= regs(to_integer(unsigned(i_rxAddr)));
    o_rxData <= regs(to_integer(unsigned(i_ryAddr)));
    o_T <= regs(8);
    o_SP <= regs(13);
    o_IH <= regs(11);
    o_KB <= regs(12);

    if i_WE = '1' then
        regs(to_integer(unsigned(i_wbAddr))) <= i_wbData;
    end if;
end Behavioral;

