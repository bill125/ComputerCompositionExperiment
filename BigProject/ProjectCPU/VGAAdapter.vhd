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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAAdapter is
    generic
    (
        screenX : integer := 0;
        screenY : integer := 0;
        screenW : integer := 480
    );
    port
    (
        i_vectorX : in std_logic_vector(9 downto 0);
        i_vectorY : in std_logic_vector(8 downto 0);
        i_read_EN : in std_logic;
        o_data : out word_t;

        i_busResponse : in bus_response_t;
        o_busRequest : out bus_request_t
    );
end VGAAdapter;

architecture Behavioral of VGAAdapter is
    signal x : integer range 0 to 1023 := 0;
    signal y : integer range 0 to 1023 := 0;
begin
    o_busRequest.writeRequest <= '0';
    o_busRequest.readRequest <= i_read_EN;
    o_busRequest.data <= (others => '-');

    o_data <= i_busResponse.data;
    x <= conv_integer(i_vectorX);
    y <= conv_integer(i_vectorY);

    process (x, y)
    begin
        o_busRequest.data <= conv_std_logic_vector(screenW * (y - screenY) + x - screenX, 16);
    end process;

end Behavioral;

