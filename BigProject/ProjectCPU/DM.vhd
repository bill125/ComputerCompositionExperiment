----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:25 11/24/2017 
-- Design Name: 
-- Module Name:    DM - Behavioral 
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

entity DM is
    port 
    (
        i_data         : in word_t;
        i_addr         : in addr_t;
        o_DMRes        : out word_t;

        i_DMRE         : in std_logic;
        i_DMWR         : in std_logic;
        o_stallRequest : out std_logic;

        o_busRequest   : out bus_request_t;
        i_busResponse  : in bus_response_t        
    );
end DM;

architecture Behavioral of DM is

begin
    o_busRequest.addr <= "00" & i_addr;
    o_busRequest.data <= i_data;
    o_busRequest.writeRequest <= i_DMWR;
    o_busRequest.readRequest <= i_DMRE;

    o_stallRequest <= i_busResponse.stallRequest;
    o_DMRes <= i_busResponse.data;
end Behavioral;

