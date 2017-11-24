----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:04 11/24/2017 
-- Design Name: 
-- Module Name:    ForwardUnit - Behavioral 
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

entity ForwardUnit is
	port(
        i_OP0Data : in std_logic_vector(15 downto 0);
        i_OP1Data : in std_logic_vector(15 downto 0);
        i_OP0Addr : in std_logic_vector(3 downto 0);
        i_OP1Addr : in std_logic_vector(3 downto 0);

        i_ALU1Res : in std_logic_vector(15 downto 0);
        i_ALU1Addr : in std_logic_vector(3 downto 0);
        i_ALU1EN : in std_logic;
        i_ALU2Res : in std_logic_vector(15 downto 0);
        i_ALU2Addr : in std_logic_vector(3 downto 0);
        i_ALU2EN : in std_logic;
        i_DMRes : in std_logic_vector(15 downto 0);
        i_DMAddr : in std_logic_vector(3 downto 0);
        i_DMEN : in std_logic;
        
        o_OP0 : out std_logic_vector(15 downto 0);
        o_OP1 : out std_logic_vector(15 downto 0)
    );
end ForwardUnit;

architecture Behavioral of ForwardUnit is

begin
    if i_ALU1EN = '1' and i_OP0Addr = i_ALU1Addr then
        o_OP0 <= i_ALU1Res;
    elsif i_ALU2EN = '1' and i_OP0Addr = i_ALU2Addr then
        o_OP0 <= i_ALU2Res;
    elsif i_DMEN = '1' and i_OP0Addr = i_DMAddr then
        o_OP0 <= i_DMRes;
    else
        o_OP0 <= i_OP0Data;
    end if;
    
    if i_ALU1EN = '1' and i_OP1Addr = i_ALU1Addr then
        o_OP1 <= i_ALU1Res;
    elsif i_ALU2EN = '1' and i_OP1Addr = i_ALU2Addr then
        o_OP1 <= i_ALU2Res;
    elsif i_DMEN = '1' and i_OP1Addr = i_DMAddr then
        o_OP1 <= i_DMRes;
    else
        o_OP1 <= i_OP1Data;
    end if;
end Behavioral;

