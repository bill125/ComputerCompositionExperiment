----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:15:55 12/01/2017 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
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

entity VGA is
    port 
    (
        i_busResponse : in bus_response_t;
        o_busRequest : out bus_request_t;
        
        i_clock : in std_logic;
        o_hs : out std_logic;
        o_vs : out std_logic;
        o_r : out std_logic_vector(2 downto 0);
        o_g : out std_logic_vector(2 downto 0);
        o_b : out std_logic_vector(2 downto 0)
    );
end VGA;

architecture Behavioral of VGA is
    component VGAAdapter is
        generic
        (
            screenX : integer := 0;
            screenY : integer := 0;
            screenW : integer := 480
        );
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
    end component;
    component VGACore is
        port (
            clk : in std_logic;
            i_data : in std_logic_vector(15 downto 0); --读到的数据
            hs,vs : out std_logic;
            r,g,b : out std_logic_vector(2 downto 0);
            o_cnt : out std_logic_vector(17 downto 0);
            -- o_vectorX : out std_logic_vector(9 downto 0);  --需要获取颜色的x
            -- o_vectorY : out std_logic_vector(8 downto 0);  --需要获取颜色的y
            o_read_EN : out std_logic -- 是否需要读SRAM ‘1’-读 ; '0' - 不读
        );
    end component;

    signal VGAAdapter_data : word_t;

    -- signal VGACore_vectorX : std_logic_vector(9 downto 0);
    -- signal VGACore_vectorY : std_logic_vector(8 downto 0);
    signal VGACore_cnt : std_logic_vector(17 downto 0);
    signal VGACore_read_EN : std_logic;
begin
    VGACore_inst: VGACore 
    -- generic map
    -- (
    --     screenX => 160,
    --     screenY => 0,
    --     screenW => 240
    -- )
    port map (
        clk => i_clock,
        i_data => VGAAdapter_data,
        hs => o_hs,
        vs => o_vs,
        r => o_r,
        g => o_g,
        b => o_b,
        -- o_vectorX => VGACore_vectorX,
        -- o_vectorY => VGACore_vectorY,
        o_cnt => VGACore_cnt,
        o_read_EN => VGACore_read_EN
    );

    VGAAdapter_inst: VGAAdapter
    port map
    (
        i_cnt => VGACore_cnt,
        -- i_vectorX => VGACore_vectorX,
        -- i_vectorY => VGACore_vectorY,
        i_read_EN => VGACore_read_EN,
        o_data => VGAAdapter_data,
        i_busResponse => i_busResponse,
        o_busRequest => o_busRequest
    );

end Behavioral;

