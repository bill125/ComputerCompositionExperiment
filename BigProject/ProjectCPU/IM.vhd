----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:14:02 11/24/2017 
-- Design Name: 
-- Module Name:    IM - Behavioral 
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

entity IM is
    port
    (
        i_PC           : in bus_addr_t;
        o_inst         : out inst_t;

        i_busReadReady : in std_logic;
        i_busData      : in word_t;
        o_busAddr      : out bus_addr_t;

        o_StallRequest : out std_logic
    );   
end IM;

architecture Behavioral of IM is

begin
    o_inst <= i_busData;
    o_StallRequest <= not i_busReadReady;
    o_busAddr <= i_PC;
end Behavioral;

