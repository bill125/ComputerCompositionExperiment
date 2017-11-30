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
        i_UART_bus_EN : in std_logic;
        i_UART_bus_data : in word_t;
        o_UART_bus_data : out word_t;
        i_UART_data : in word_t;
        o_UART_data : out word_t;
        o_UART_readBegin : out std_logic;
        o_UART_writeBegin : out std_logic;

        o_nOE : out std_logic;
        o_nWE : out std_logic;
        o_nCE : out std_logic;
        o_bus_EN : out std_logic;
        i_bus_data : in word_t;
        o_bus_data : out word_t; 
        o_bus_addr : out bus_addr_t
    );
end SystemBusController;

architecture Behavioral of SystemBusController is
begin
    o_UART_bus_data <= i_bus_data;

    process (i_clock, i_busRequest, i_bus_data,
             i_UART_readReady, i_UART_readDone,
             i_UART_writeReady, i_UART_writeDone,
             i_UART_data, i_UART_bus_EN, i_UART_bus_data)
    begin
        if i_busRequest.addr = uart_control_addr then -- UART control
            o_nCE <= '1';
            o_nOE <= '1';
            o_nWE <= '1';
            o_bus_EN <= '0';
            o_bus_data <= (others => '-');
            o_bus_addr <= (others => '-');
            o_UART_data <= (others => '-');
            o_UART_readBegin <= '0';
            o_UART_writeBegin <= '0';
            o_busResponse.stallRequest <= '0';
            if i_busRequest.readRequest = '1' then
                o_busResponse.data <= (0 => i_UART_writeReady, 
                                       1 => i_UART_readReady, 
                                       others => '0');
            else
                o_busResponse.data <= (others => '-');
            end if;

        elsif i_busRequest.addr = uart_data_addr then -- UART data
            o_nCE <= '1';
            o_nOE <= '1';
            o_nWE <= '1';
            o_bus_EN <= i_UART_bus_EN;
            o_bus_data <= i_UART_bus_data;
            o_bus_addr <= (others => '-');
            if i_busRequest.readRequest = '1' then
                o_UART_readBegin <= '1';
                o_UART_writeBegin <= '0';
                o_UART_data <= (others => '-');
                o_busResponse.data <= i_UART_data;
                o_busResponse.stallRequest <= not i_UART_readDone;
            elsif i_busRequest.writeRequest = '1' then
                o_UART_readBegin <= '0';
                o_UART_writeBegin <= '1';
                o_UART_data <= i_busRequest.data;
                o_busResponse.data <= (others => '-');
                o_busResponse.stallRequest <= not i_UART_writeDone;
            else
                o_UART_readBegin <= '0';
                o_UART_writeBegin <= '0';
                o_UART_data <= (others => '-');
                o_busResponse.data <= (others => '-');
                o_busResponse.stallRequest <= '0';
            end if;
            
        else -- SRAM
            o_UART_data <= (others => '-');
            o_UART_readBegin <= '0';
            o_UART_writeBegin <= '0';
            if i_busRequest.readRequest = '1' then
                o_nCE <= '0';
                o_nOE <= '0';
                o_nWE <= '1';
                o_bus_addr <= i_busRequest.addr;
                o_bus_data <= (others => '-');
                o_bus_EN <= '0';
                o_busResponse.data <= i_bus_data;
                o_busResponse.stallRequest <= '0';
            elsif i_busRequest.writeRequest = '1' then
                o_nCE <= '0';
                o_nOE <= '1';
                o_nWE <= not i_clock;
                o_bus_addr <= i_busRequest.addr;
                o_bus_data <= i_busRequest.data;
                o_bus_EN <= '1';
                o_busResponse.data <= (others => '-');
                o_busResponse.stallRequest <= '0';
            else -- no request
                o_nCE <= '1';
                o_nOE <= '1';
                o_nWE <= '1';
                o_bus_data <= (others => '-');
                o_bus_addr <= (others => '-');
                o_bus_EN <= '0';
                o_UART_data <= (others => '-');
                o_busResponse.data <= (others => '-');
                o_busResponse.stallRequest <= '0';
            end if; 
        end if;
    end process;
end Behavioral;

