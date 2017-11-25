----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:31:35 11/24/2017 
-- Design Name: 
-- Module Name:    BusDispatcher - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BusDispatcher is
    port
    (
        i_busRequest : in bus_request_t;
        o_busResponse : out bus_response_t;

        o_sysBusRequest : out bus_request_t;
        i_sysBusResponse : in bus_response_t;
        o_extBusRequest : out bus_request_t;
        i_extBusResponse : in bus_response_t;

        o_stallRequest : out std_logic
    );
end BusDispatcher;

architecture Behavioral of BusDispatcher is
    signal sel : std_logic := '0';
begin
    sel <= i_busRequest.addr(15);

    process (sel)
    begin
        o_sysBusRequest <= i_busRequest;
        o_extBusRequest <= i_busRequest;
        if sel = '1' then -- Extbus
            o_busResponse <= i_extBusResponse;
            o_sysBusRequest.writeRequest <= '0';
            o_sysBusRequest.readRequest <= '0';
        else -- Sysbus
            o_busResponse <= i_sysBusResponse;
            o_extBusRequest.writeRequest <= '0';
            o_extBusRequest.readRequest <= '0';
        end if;
    end process
end Behavioral;

