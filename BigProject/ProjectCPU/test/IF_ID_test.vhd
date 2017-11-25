--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:46:19 11/25/2017
-- Design Name:   
-- Module Name:   Y:/workspace/course/3.1/computer-organzation/final-project/ComputerCompositionExperiment/BigProject/ProjectCPU/test/ifid.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IF_ID
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
 
ENTITY ifid IS
END ifid;
 
ARCHITECTURE behavior OF ifid IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IF_ID
    PORT(
         i_clock : IN  std_logic;
         i_inst : IN  std_logic_vector(15 downto 0);
         i_PC : IN  std_logic_vector(15 downto 0);
         i_stall : IN  std_logic;
         i_clear : IN  std_logic;
         o_PC : OUT  std_logic_vector(15 downto 0);
         o_inst : OUT  std_logic_vector(15 downto 0);
         o_rxAddr : OUT  std_logic_vector(3 downto 0);
         o_ryAddr : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_inst : std_logic_vector(15 downto 0) := (others => '0');
   signal i_PC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_stall : std_logic := '0';
   signal i_clear : std_logic := '0';

 	--Outputs
   signal o_PC : std_logic_vector(15 downto 0);
   signal o_inst : std_logic_vector(15 downto 0);
   signal o_rxAddr : std_logic_vector(3 downto 0);
   signal o_ryAddr : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant i_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IF_ID PORT MAP (
          i_clock => i_clock,
          i_inst => i_inst,
          i_PC => i_PC,
          i_stall => i_stall,
          i_clear => i_clear,
          o_PC => o_PC,
          o_inst => o_inst,
          o_rxAddr => o_rxAddr,
          o_ryAddr => o_ryAddr
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

      i_inst <= "01000XXXZZZ0UUUU";
      i_PC <= x"fff0";
      
      wait for i_clock_period*10;

      i_stall <= '1';

      wait for i_clock_period*10;
      
      i_inst <= "01000XXXZZZ0UUUU";
      i_PC <= x"0ff0";

      wait for i_clock_period*30;

      i_stall <= '0';

      wait for i_clock_period*10;

      i_clear <= '1';

      wait for i_clock_period*30;


      wait;
   end process;

END;
