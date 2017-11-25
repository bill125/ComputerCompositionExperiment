----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:44:02 11/25/2017 
-- Design Name: 
-- Module Name:    DM_MUX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DM_MUX is
    Port ( i_DMRE : in  std_logic;
           i_DMRes : in  word_t;
           i_ALURes : in  word_t;
           o_wbData : out  word_t);
end DM_MUX;

architecture Behavioral of DM_MUX is

begin
    o_wbData <= i_DMRes when i_DMRE = '1' else i_ALURes;

end Behavioral;

