----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:18:51 12/01/2017 
-- Design Name: 
-- Module Name:    BusArbiter - Behavioral 
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

entity BusArbiter is -- 1 > 0
    port
    (
        i_busRequest_0 : in bus_request_t; 
        i_busRequest_1 : in bus_request_t; 
        o_busResponse_0 : out bus_response_t;
        o_busResponse_1 : out bus_response_t;

        o_busRequest : out bus_request_t;
        i_busResponse : in bus_response_t
    );
end BusArbiter;

architecture Behavioral of BusArbiter is
    signal busEN_0 : std_logic := '0';
    signal busEN_1 : std_logic := '0';
begin
    busEN_0 <= '1' when i_busRequest_0.writeRequest = '1' or i_busRequest_0.readRequest = '1'
          else '0';
    busEN_1 <= '1' when i_busRequest_1.writeRequest = '1' or i_busRequest_1.readRequest = '1'
          else '0';

    process (busEN_0, busEN_1,
            i_busRequest_0,
            i_busRequest_1,
            i_busResponse)
    begin
        o_busResponse_0 <= i_busResponse;
        o_busResponse_1 <= i_busResponse;
        if busEN_0 = '1' and (i_busRequest_0.addr = uart_control_addr or i_busRequest_0.addr = uart_data_addr or i_busRequest_0.addr = key_data_addr) then
            o_busRequest <= i_busRequest_0;
            o_busResponse_1.stallRequest <= busEN_1;
        elsif busEN_1 = '1' then
            o_busRequest <= i_busRequest_1;
            o_busResponse_0.stallRequest <= busEN_0;
        elsif busEN_0 = '1' then
            o_busRequest <= i_busRequest_0;
            o_busResponse_1.stallRequest <= busEN_1;
        else
            o_busRequest.writeRequest <= '0';
            o_busRequest.readRequest <= '0';
            o_busResponse_0.stallRequest <= '0';
            o_busResponse_1.stallRequest <= '0';
        end if;
    end process;
end Behavioral;

