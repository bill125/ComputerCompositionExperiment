----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:13 11/24/2017 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
	port (
        i_clock : in std_logic;
		i_stall : in std_logic;
		i_clear : in std_logic;
		i_nextPC : in std_logic_vector(15 downto 0);
		o_PC : out std_logic_vector(15 downto 0)
	);
end PC;

architecture Behavioral of PC is
    -- signal PCReg : std_logic_vector(15 downto 0);
begin
    process(i_clock)
    begin
        if rising_edge(i_clock) then
            if i_stall = '0' then
                o_PC <= i_nextPC;
            end if;
        end if;
    end process
end Behavioral;

