----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:20:42 11/25/2017 
-- Design Name: 
-- Module Name:    SystemBusController - Behavioral 
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

entity SystemBusController is
    port
    (
        i_clock : in std_logic;

        i_busRequest : in bus_request_t;
        o_busResponse : out bus_response_t;
        
        i_UART_readReady : in std_logic;
        i_UART_readDone : in std_logic;
        i_UART_writeReady : in std_logic;
        i_UART_writeDone : in std_logic;
        i_UART_data : in word_t;
        o_UART_data : out word_t;
        o_UART_readBegin : out std_logic;
        o_UART_writeBegin : out std_logic;

        o_nOE : out std_logic;
        o_nWE : out std_logic;
        o_nCE : out std_logic;
        io_bus_data : inout word_t;
        o_bus_addr : out bus_addr_t
    );
end SystemBusController;

architecture Behavioral of SystemBusController is

begin
    process (i_clock, i_busRequest)
    begin
        o_busResponse.stallRequest <= '0';
        o_UART_writeBegin <= '0';
        o_UART_readBegin <= '0';
        if i_busRequest.readRequest = '0' and i_busRequest.writeRequest = '0' then
            o_nCE <= '0';
            o_nOE <= '1';
            o_nWE <= '1';
            
        elsif i_busRequest.addr = x"BF01" then -- UART control
            if i_busRequest.readRequest = '1' then
                o_busResponse.data <= (0 => i_UART_readReady, 
                                       1 => i_UART_writeReady, 
                                       others => '0');
            else
                -- ???
            end if;

        elsif i_busRequest.addr = x"BF00" then -- UART data
            if i_busRequest.readRequest = '1' then
                o_nCE <= '1';
                if i_UART_readReady = '0' then
                    o_busResponse.stallRequest <= '1';
                else
                    o_UART_readBegin <= '1';
                    o_busResponse.data <= i_UART_data;
                    o_busResponse.stallRequest <= not i_UART_readDone;
                end if;
            elsif i_busRequest.writeRequest = '1' then
                o_nCE <= '1';
                if i_UART_writeReady = '0' then
                    o_busResponse.stallRequest <= '1';
                else
                    o_UART_writeBegin <= '1';
                    o_UART_data <= i_busRequest.data;
                    o_busResponse.stallRequest <= not i_UART_writeDone;
                end if;
            end if;
            
        else -- SRAM
            if i_busRequest.readRequest = '1' then
                o_nOE <= '0';
                o_nWE <= '1';
                o_bus_addr <= i_busRequest.addr;
                o_busResponse.data <= io_bus_data;
                o_busResponse.stallRequest <= '0';
            elsif i_busRequest.writeRequest = '1' then
                o_nOE <= '1';
                o_nWE <= not i_clock;
                o_bus_addr <= i_busRequest.addr;
                io_bus_data <= i_busRequest.data;
                o_busResponse.stallRequest <= '0';
            end if; 
        end if;
    end process;
end Behavioral;

