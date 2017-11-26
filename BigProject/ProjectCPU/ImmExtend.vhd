----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:16:31 11/24/2017 
-- Design Name: 
-- Module Name:    ImmExtend - Behavioral 
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
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ImmExtend is
    port (
        i_inst : in  std_logic_vector (15 downto 0);
        o_immExtend : out std_logic_vector (15 downto 0)
    );
end ImmExtend;

architecture Behavioral of ImmExtend is
	signal from7to0: std_logic_vector(7 downto 0);
	signal from3to0: std_logic_vector(3 downto 0);
	signal from10to0: std_logic_vector(10 downto 0);
	signal from4to0: std_logic_vector(4 downto 0);
	signal from4to2: std_logic_vector(2 downto 0);
	signal first5 : std_logic_vector(4 downto 0);
	signal first8 : std_logic_vector(7 downto 0);
begin
	first5   <= i_inst(15 downto 11);
	first8	 <= i_inst(15 downto  8);
	from7to0 <= i_inst(7  downto  0);
	from3to0 <= i_inst(3  downto  0);
	from10to0<= i_inst(10 downto  0);
	from4to0 <= i_inst(4  downto  0);
	from4to2 <= i_inst(4  downto  2);
	o_immExtend	<=	EXT(from7to0, o_immExtend'length)when first5 = "01101" -- LI
											or first5 = "01011" -- SLUUI
											else
				EXT(from4to2, o_immExtend'length)when first5 = "00110" -- SLL+SRA
											else
				SXT(from7to0, o_immExtend'length)when first5 = "01001" -- ADDIU
											or first8 = "01100011" --ADDSP
											or first8 = "01100000" -- BTEQZ
											or first5 = "10010" -- LW_SP
											or first5 = "11010" -- SW_SP
											or first5 = "00100" -- BEQZ
											or first5 = "00101" -- BNEZ
											else
				SXT(from3to0, o_immExtend'length)when first5 = "01000" -- ADDIU3
											else
				SXT(from10to0, o_immExtend'length)when first5 = "00010" -- B
											else
				SXT(from4to0, o_immExtend'length)when first5 = "10011" -- LW
											or first5 = "11011" -- SW
											else
				(others=>'0');
end Behavioral;

