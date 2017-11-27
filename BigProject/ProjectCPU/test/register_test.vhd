--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:19:58 11/27/2017
-- Design Name:   
-- Module Name:   D:/ComputerCompositionExperiment/BigProject/ProjectCPU/test/register_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: myRegister
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
use work.reg_addr.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY register_test IS
END register_test;
 
ARCHITECTURE behavior OF register_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT myRegister
    PORT(
         i_rxAddr : IN  std_logic_vector(2 downto 0);
         i_ryAddr : IN  std_logic_vector(2 downto 0);
         i_wbData : IN  std_logic_vector(15 downto 0);
         i_wbAddr : IN  std_logic_vector(3 downto 0);
         o_rxData : OUT  std_logic_vector(15 downto 0);
         o_ryData : OUT  std_logic_vector(15 downto 0);
         o_T : OUT  std_logic_vector(15 downto 0);
         o_SP : OUT  std_logic_vector(15 downto 0);
         o_IH : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_rxAddr : std_logic_vector(2 downto 0) := (others => '0');
   signal i_ryAddr : std_logic_vector(2 downto 0) := (others => '0');
   signal i_wbData : std_logic_vector(15 downto 0) := (others => '0');
   signal i_wbAddr : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal o_rxData : std_logic_vector(15 downto 0);
   signal o_ryData : std_logic_vector(15 downto 0);
   signal o_T : std_logic_vector(15 downto 0);
   signal o_SP : std_logic_vector(15 downto 0);
   signal o_IH : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
   signal clock : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: myRegister PORT MAP (
          i_rxAddr => i_rxAddr,
          i_ryAddr => i_ryAddr,
          i_wbData => i_wbData,
          i_wbAddr => i_wbAddr,
          o_rxData => o_rxData,
          o_ryData => o_ryData,
          o_T => o_T,
          o_SP => o_SP,
          o_IH => o_IH
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      i_rxAddr <= "111";
      i_ryAddr <= "000";
      i_wbData <= "1110101110100101";
      i_wbAddr <= "0000";
      wait for clock_period*10;
      assert (o_ryData = "1110101110100101")
        report "E1"
        severity ERROR;
        
      i_wbData <= "1110101100100101";
      i_wbAddr <= "0111";
      wait for clock_period*10;
      assert (o_rxData = "1110101100100101" and 
              o_ryData = "1110101110100101")
        report "E2"
        severity ERROR;
        
      i_wbData <= "0000001100100101";
      i_wbAddr <= T;
      wait for clock_period*10;
      assert (o_rxData = "1110101100100101" and 
              o_ryData = "1110101110100101" and 
              o_T = "0000001100100101")
        report "E3"
        severity ERROR;
        
      i_wbData <= "1111101100100101";
      i_wbAddr <= SP;
      wait for clock_period*10;
      assert (o_rxData = "1110101100100101" and 
              o_ryData = "1110101110100101" and 
              o_T = "0000001100100101" and 
              o_SP = "1111101100100101")
        report "E4"
        severity ERROR;
        
      i_wbData <= "1111101111100101";
      i_wbAddr <= IH;
      wait for clock_period*10;
      assert (o_rxData = "1110101100100101" and 
              o_ryData = "1110101110100101" and 
              o_T = "0000001100100101" and 
              o_SP = "1111101100100101" and 
              o_IH = "1111101111100101")
        report "E5"
        severity ERROR;
        
      i_wbData <= "1111000111100101";
      i_wbAddr <= T;
      wait for clock_period*10;
      assert (o_rxData = "1110101100100101" and 
              o_ryData = "1110101110100101" and 
              o_T = "1111000111100101" and 
              o_SP = "1111101100100101" and 
              o_IH = "1111101111100101")
        report "E6"
        severity ERROR;
        
      i_wbData <= "1111000111100101";
      i_wbAddr <= "0001";
      i_rxAddr <= "001";
      i_ryAddr <= "010";
      wait for clock_period*10;
      assert (o_rxData = "1111000111100101" and 
              o_T = "1111000111100101" and 
              o_SP = "1111101100100101" and 
              o_IH = "1111101111100101")
        report "E7"
        severity ERROR;
      wait;
   end process;

END;
