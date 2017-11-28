--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:20:03 10/18/2017
-- Design Name:   
-- Module Name:   C:/Users/bill125/Desktop/HW/Exp1/test.vhd
-- Project Name:  Exp1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         i_clk : IN  std_logic;
         i_rst : IN  std_logic;
         i_sw : IN  std_logic_vector(15 downto 0);
         o_led : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_rst : std_logic := '0';
   signal i_sw : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal o_led : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          i_clk => i_clk,
          i_rst => i_rst,
          i_sw => i_sw,
          o_led => o_led
        );

   -- Clock process definitions
--   i_clk_process :process
--   begin
--		i_clk <= '0';
--		wait for i_clk_period/2;
--		i_clk <= '1';
--		wait for i_clk_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. 
		i_rst <= '0';
		i_clk <= '1';
      wait for 100 ns;
		i_rst <= '1';
		wait for 10 ns;
      -- insert stimulus here 
		
		i_sw <= "0001010111001000";
		wait for 10 ns;
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for 20 ns;
		
		i_sw <= "0001010101001000";
		wait for 10 ns;
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for 20 ns;
		
		i_sw <= "0000000000000001";
		wait for 10 ns;
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for 20 ns;
		
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for 20 ns;

      wait;
   end process;

END;
