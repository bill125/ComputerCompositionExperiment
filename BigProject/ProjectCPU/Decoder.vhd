----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:22 11/24/2017 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
USE ieee.std_logic_signed.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
	port (
        i_OP0Type : in std_logic_vector(2 downto 0);
        i_OP1Type : in std_logic_vector(2 downto 0);
        i_wbType : in std_logic_vector(2 downto 0);
        i_rxAddr : in std_logic_vector(3 downto 0);
        i_rxData : in std_logic_vector(15 downto 0);
        i_ryAddr : in std_logic_vector(3 downto 0);
        i_ryData : in std_logic_vector(15 downto 0);
        i_rzAddr : in std_logic_vector(3 downto 0);
        i_IH : in std_logic_vector(15 downto 0);
        i_SP : in std_logic_vector(15 downto 0);
        i_PC : in std_logic_vector(15 downto 0);
        i_T : in std_logic_vector(15 downto 0);

        o_OP0Addr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid;
        o_OP0Data : out std_logic_vector(15 downto 0);
        o_OP1Addr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid;
        o_OP1Data : out std_logic_vector(15 downto 0);
        o_wbAddr : out std_logic_vector(3 downto 0) := work.reg_addr.invalid
    );
end Decoder;

architecture Behavioral of Decoder is

begin
    with i_OP0Type select
        o_OP0Addr <= i_rxAddr when "000",
                     i_ryAddr when "001",
                     "1000" when "010",
                     "1010" when "011",
                     "1011" when "100",
                     "1101" when "110",
                     "1111" when others;
    with i_OP0Type select
        o_OP0Data <= i_rxData when "000",
                     i_ryData when "001",
                     i_T when "010",
                     i_PC + "1" when "011",
                     i_IH when "100",
                     i_SP when "110",
                     (others => '0') when others;
                     
    with i_OP1Type select
        o_OP1Addr <= i_rxAddr when "000",
                     i_ryAddr when "001",
                     "1000" when "010",
                     "1010" when "011",
                     "1011" when "100",
                     "1101" when "110",
                     "1111" when others;
    with i_OP1Type select
        o_OP1Data <= i_rxData when "000",
                     i_ryData when "001",
                     i_T when "010",
                     i_PC + "1" when "011",
                     i_IH when "100",
                     i_SP when "110",
                     (others => '0') when others;

    with i_wbType select
        o_wbAddr <=  i_rxAddr when "000",
                     i_ryAddr when "001",
                     i_rzAddr when "101",
                     "1000" when "010",
                     "1010" when "011",
                     "1011" when "100",
                     "1101" when "110",
                     "1111" when others;
end Behavioral;

