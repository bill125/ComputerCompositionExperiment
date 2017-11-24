--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:14:26 11/24/2017
-- Design Name:   
-- Module Name:   Y:/workspace/course/3.1/computer-organzation/final-project/ComputerCompositionExperiment/BigProject/ProjectCPU/test/PC_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PC
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
 
ENTITY PC_test IS
END PC_test;
 
ARCHITECTURE behavior OF PC_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PC
    PORT(
         i_clock : IN  std_logic;
         i_stall : IN  std_logic;
         i_nextPC : IN  std_logic_vector(15 downto 0);
         o_PC : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_stall : std_logic := '0';
   signal i_nextPC : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal o_PC : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant i_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PC PORT MAP (
          i_clock => i_clock,
          i_stall => i_stall,
          i_nextPC => i_nextPC,
          o_PC => o_PC
        );

   -- Clock process definitions
   i_clock_process :process
   begin
		i_clock <= '0';
		wait for i_clock_period/2;
		i_clock <= '1';
		wait for i_clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for i_clock_period*10;

      -- insert stimulus here 
      i_nextPC <= "1010101010101010";
      i_stall <= '0';
      wait for i_clock_period*5;

      i_stall <= '1';
      i_nextPC <= (others => '1');    
      wait for i_clock_period*5;

      i_stall <= '0';
      wait for i_clock_period*5;


      wait;
   end process;

END;
