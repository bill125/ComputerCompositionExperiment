----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:46 10/18/2017 
-- Design Name: 
-- Module Name:    main - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( i_clk  : in  STD_LOGIC;
           i_rst  : in  STD_LOGIC;
           i_sw   : in  STD_LOGIC_VECTOR (15 downto 0);
           o_led  : out STD_LOGIC_VECTOR (15 downto 0);
			  o_sign : out STD_LOGIC );
end main;

architecture Behavioral of main is

	type t_SM_Main is (s_R_A, s_R_B, s_R_op, s_P_sign, s_Idle);
	signal r_SM_Main : t_SM_Main := s_R_A;

begin
	process (i_clk, i_rst)
		variable r_A : bit_vector (15 downto 0) := (others => '0');
		variable r_B : bit_vector (15 downto 0) := (others => '0');
		variable r_intA, r_intB : integer range -65535 to 65535 := 0;
		variable p_C : bit_vector (15 downto 0) := (others => '0');
	begin
		if i_rst = '0' then
			r_A := (others => '0');
			r_B := (others => '0');
			r_intA := 0;
			r_intB := 0;
			r_SM_Main <= s_R_A;
			o_led <= (others => '0');
			o_sign <= '0';
		elsif falling_edge(i_clk) then
			case r_SM_Main is
				when s_R_A =>
					r_SM_Main <= s_R_B;
					r_A    := to_bitvector(i_sw);
					r_intA := conv_integer(i_sw);
					o_led <= i_sw;
					
				when s_R_B =>
					r_SM_Main <= s_R_op;
					r_B    := to_bitvector(i_sw);
					r_intB := conv_integer(i_sw);
					o_led <= i_sw;
					
				when s_R_op =>
					r_SM_Main <= s_P_sign;
					o_led <= i_sw;
					o_sign <= '0';
					case conv_integer(i_sw(3 downto 0)) is
						when 0 => 
							p_C := to_bitvector(conv_std_logic_vector(r_intA + r_intB, 16));
							if r_intA + r_intB >= 65536 then
								o_sign <= '1';
							else
								o_sign <= '0';
							end if;
						when 1 => 
							p_C := to_bitvector(conv_std_logic_vector(r_intA - r_intB, 16));
							if r_intA < r_intB then
								o_sign <= '1';
							else
								o_sign <= '0';
							end if;
						when 2 => p_C := r_A and r_B;
						when 3 => p_C := r_A or r_B;
						when 4 => p_C := r_A xor r_B;
						when 5 => p_C := not r_A;
						when 6 => p_C := r_A sll r_intB;
						when 7 => p_C := r_A srl r_intB;
						when 8 => p_C := r_A sra r_intB;
						when 9 => p_C := r_A rol r_intB;
						when others => p_C := (others => '0');
					end case;

				when s_P_sign =>
					r_SM_Main <= s_R_A;
					o_led <= to_stdlogicvector(p_C);
					
				when others =>
					r_SM_Main <= s_Idle;
					o_led <= "0000000000000000";
			end case;
		end if;
	end process;
end Behavioral;

