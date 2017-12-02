----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:03:43 12/01/2017 
-- Design Name: 
-- Module Name:    VGAAdapter - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD;
use work.constants.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAAdapter is
    port
    (
        i_cnt : in std_logic_vector(17 downto 0);
        -- i_vectorX : in std_logic_vector(9 downto 0);
        -- i_vectorY : in std_logic_vector(8 downto 0);
        i_read_EN : in std_logic;
        o_data : out word_t;

        i_busResponse : in bus_response_t;
        o_busRequest : out bus_request_t
    );
end VGAAdapter;

architecture Behavioral of VGAAdapter is
    -- signal x : std_logic_vector(9 downto 0);
    -- signal y : std_logic_vector(9 downto 0);
    -- -- signal x : integer range 0 to 1023 := 0;
    -- -- signal y : integer range 0 to 1023 := 0;
    -- signal x1 : integer range 0 to 1023 := 0;
    -- signal y1 : integer range 0 to 1023 := 0;
begin
    o_busRequest.writeRequest <= '0';
    o_busRequest.readRequest <= i_read_EN;
    o_busRequest.data <= (others => '-');

    o_data <= i_busResponse.data;
    -- x <= to_stdlogicvector(to_bitvector(i_vectorX - screenW) SRL 1);
    -- y <= to_stdlogicvector(to_bitvector(i_vectorY) SRL 1);
    -- x1 <= NUMERIC_STD.to_integer(unsigned(x));
    -- y1 <= NUMERIC_STD.to_integer(unsigned(y));

    o_busRequest.addr <= i_cnt + x"8000";
end Behavioral;

