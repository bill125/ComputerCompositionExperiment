--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:50:07 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_DM.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DM
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
 
ENTITY test_DM IS
END test_DM;
 
ARCHITECTURE behavior OF test_DM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DM
    PORT(
         i_data : IN  std_logic_vector(15 downto 0);
         i_addr : IN  std_logic_vector(15 downto 0);
         i_ALURes : IN  std_logic_vector(15 downto 0);
         o_DMRes : OUT  std_logic_vector(15 downto 0);
         o_wbData : OUT  std_logic_vector(15 downto 0);
         i_DMRE : IN  std_logic;
         i_DMWR : IN  std_logic;
         o_stallRequest : OUT  std_logic;
         o_busRequest : OUT  std_logic;
         i_busResponse : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_data : std_logic_vector(15 downto 0) := (others => '0');
   signal i_addr : std_logic_vector(15 downto 0) := (others => '0');
   signal i_ALURes : std_logic_vector(15 downto 0) := (others => '0');
   signal i_DMRE : std_logic := '0';
   signal i_DMWR : std_logic := '0';
   signal i_busResponse : std_logic := '0';

 	--Outputs
   signal o_DMRes : std_logic_vector(15 downto 0);
   signal o_wbData : std_logic_vector(15 downto 0);
   signal o_stallRequest : std_logic;
   signal o_busRequest : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  --  constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DM PORT MAP (
          i_data => i_data,
          i_addr => i_addr,
          i_ALURes => i_ALURes,
          o_DMRes => o_DMRes,
          o_wbData => o_wbData,
          i_DMRE => i_DMRE,
          i_DMWR => i_DMWR,
          o_stallRequest => o_stallRequest,
          o_busRequest => o_busRequest,
          i_busResponse => i_busResponse
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
