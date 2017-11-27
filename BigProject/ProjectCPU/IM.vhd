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
        i_PC           : in word_t;
        o_inst         : out inst_t;

        i_busResponse  : in bus_response_t;
        o_busRequest   : out bus_request_t;

        o_stallRequest : out std_logic := '0'
    );   
end IM;

architecture Behavioral of IM is

begin
    o_busRequest.addr <= "00" & i_PC;
    o_busRequest.data <= (others => 'X');
    o_busRequest.writeRequest <= '0';
    o_busRequest.readRequest <= '1';

    o_inst <= i_busResponse.data;

    o_stallRequest <= not i_busResponse.stallRequest;
end Behavioral;

