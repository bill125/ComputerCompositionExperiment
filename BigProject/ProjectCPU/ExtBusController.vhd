----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:57 11/25/2017 
-- Design Name: 
-- Module Name:    ExtBusController - Behavioral 
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

entity ExtBusController is
    port 
    (
        i_clock : in std_logic;

        i_IM_busRequest : in bus_request_t;
        i_DM_busRequest : in bus_request_t;
        o_IM_busResponse : out bus_response_t;
        o_DM_busResponse : out bus_response_t;

        io_bus_data : inout word_t;
        o_bus_addr : out bus_addr_t;
        o_nCE : out std_logic;
        o_nOE : out std_logic;
        o_nWE : out std_logic
    );
end ExtBusController;

architecture Behavioral of ExtBusController is
    signal busRequest : bus_request_t;
    signal busResponse : bus_response_t;
begin

    process (i_IM_busRequest, i_DM_busRequest, busResponse)
    begin
        if i_DM_busRequest.readRequest = '1' or i_DM_busRequest.writeRequest = '1' then
            busRequest <= i_DM_busRequest;
            o_IM_busResponse.stallRequest <= '1';
            o_DM_busResponse <= busResponse;
        else
            busRequest <= i_IM_busRequest;
            o_IM_busResponse <= busResponse;
        end if ;
    end process;

    process (busRequest, io_bus_data, i_clock)
    begin      
        if busRequest.writeRequest = '1' or busRequest.readRequest = '1' then
            o_nCE <= '0';
            if busRequest.readRequest = '1' then
                o_bus_addr <= busRequest.addr;
                busResponse.data <= io_bus_data;
                busResponse.stallRequest <= '0';
                o_nOE <= '0';
                o_nWE <= '1';
            else
                o_bus_addr <= busRequest.addr;
                io_bus_data <= busRequest.data;
                busResponse.stallRequest <= '0';
                o_nOE <= '1';
                o_nWE <= not i_clock;
            end if;
        else
            o_nCE <= '0';
            o_nOE <= '1';
            o_nWE <= '1';
        end if;
    end process;

end Behavioral;

