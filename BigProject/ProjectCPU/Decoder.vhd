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
        i_rxAddr : in std_logic_vector(3 downto 0);
        i_rxData : in std_logic_vector(15 downto 0);
        i_ryAddr : in std_logic_vector(3 downto 0);
        i_ryData : in std_logic_vector(15 downto 0);
        i_IH : in std_logic_vector(15 downto 0);
        i_KB : in std_logic_vector(15 downto 0);
        i_SP : in std_logic_vector(15 downto 0);
        i_PC : in std_logic_vector(15 downto 0);
        i_T : in std_logic_vector(15 downto 0);
        i_wbType : in std_logic_vector(3 downto 0);

        o_OP0Addr : out std_logic_vector(3 downto 0);
        o_OP0Data : out std_logic_vector(15 downto 0);
        o_OP1Addr : out std_logic_vector(3 downto 0);
        o_OP1Data : out std_logic_vector(15 downto 0);
        o_wbAddr : out std_logic_vector(3 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is

begin
    case i_OP0Type is
        when '000' =>
            o_OP0Addr <= i_rxAddr;
            o_OP0Data <= i_rxData;
        when '001' =>
            o_OP0Addr <= i_ryAddr;
            o_OP0Data <= i_ryData;
        when '010' =>
            o_OP0Addr <= '1000';
            o_OP0Data <= i_T;
        when '011' =>
            o_OP0Addr <= '1010';
            o_OP0Data <= i_PC;
        when '100' =>
            o_OP0Addr <= '1011';
            o_OP0Data <= i_IH;
        when '101' =>
            o_OP0Addr <= '1100';
            o_OP0Data <= i_KB;
        when '110' =>
            o_OP0Addr <= '1101';
            o_OP0Data <= i_SP;
        when '111' =>
            o_OP0Addr <= (others => '1');
            o_OP0Data <= (others => '0');

    case i_OP1Type is
        when '000' =>
            o_OP1Addr <= i_rxAddr;
            o_OP1Data <= i_rxData;
        when '001' =>
            o_OP1Addr <= i_ryAddr;
            o_OP1Data <= i_ryData;
        when '010' =>
            o_OP1Addr <= '1000';
            o_OP1Data <= i_T;
        when '011' =>
            o_OP1Addr <= '1010';
            o_OP1Data <= i_PC;
        when '100' =>
            o_OP1Addr <= '1011';
            o_OP1Data <= i_IH;
        when '101' =>
            o_OP1Addr <= '1100';
            o_OP1Data <= i_KB;
        when '110' =>
            o_OP1Addr <= '1101';
            o_OP1Data <= i_SP;
        when '111' =>
            o_OP1Addr <= (others => '1');
            o_OP1Data <= (others => '0');
            
    case i_wbType is
        when '000' =>
            o_wbAddr <= i_rxAddr;
        when '001' =>
            o_wbAddr <= i_ryAddr;
        when '010' =>
            o_wbAddr <= '1000';
        when '011' =>
            o_wbAddr <= '1010';
        when '100' =>
            o_wbAddr <= '1011';
        when '101' =>
            o_wbAddr <= '1100';
        when '110' =>
            o_wbAddr <= '1101';
        when '111' =>
            o_wbAddr <= (others => '1');
end Behavioral;

