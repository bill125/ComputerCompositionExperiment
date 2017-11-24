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
        i_data : in word_t;
        i_addr : in bus_addr_t;
        o_DMRes : out word_t;

        i_DMRE : in std_logic;
        i_DMWR : out std_logic;

        i_busReadReady : in std_logic;
        i_busWriteReady : in std_logic;
        o_readRequest : out std_logic;
        o_writeRequest : out std_logic;
        io_busData : inout word_t;
        o_busAddr : out bus_addr_t;
        
        o_stallRequest : out std_logic
    );
end DM;

architecture Behavioral of DM is

begin

    o_busAddr <= i_addr;
    -- io_busData <= i_data;
    -- o_readRequest <= i_DMRE;
    -- o_writeRequest <= o_writeRequest;
    -- o_stallRequest <= (o_readRequest and not i_busReadReady) ans
    --                   (o_writeRequest and not i_busWriteReady)
    -- o_DMRes <= io_busData;                

    if i_DMRE = '1' then
        o_stallRequest <= not i_busReadReady;
        o_readRequest <= '1';
        o_writeRequest <= '0'; 
        io_busData <= (others => 'Z');
        o_DMRes <= io_busData;
    elsif i_DMWR = '1' then
        o_stallRequest <= not i_busWriteReady;
        o_readRequest <= '0';
        o_writeRequest <= '1';
        io_busData <= i_data;
    else
        o_stallRequest <= '0';
        o_readRequest <= '0';
        o_writeRequest <= '0';
    end if;

end Behavioral;

