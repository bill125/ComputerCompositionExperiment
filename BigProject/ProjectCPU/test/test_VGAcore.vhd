--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:17:08 12/02/2017
-- Design Name:   
-- Module Name:   D:/ComputerCompositionExperiment/BigProject/ProjectCPU/test/test_VGAcore.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGACore
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
 
ENTITY test_VGAcore IS
END test_VGAcore;
 
ARCHITECTURE behavior OF test_VGAcore IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGACore
    PORT(
         clk : IN  std_logic;
         i_data : IN  std_logic_vector(15 downto 0);
         hs : OUT  std_logic;
         vs : OUT  std_logic;
         r : OUT  std_logic_vector(2 downto 0);
         g : OUT  std_logic_vector(2 downto 0);
         b : OUT  std_logic_vector(2 downto 0);
         o_cnt : OUT  std_logic_vector(17 downto 0);
         o_read_EN : OUT  std_logic;
         o_readEnX : OUT  std_logic;
         o_readEnY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal i_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal hs : std_logic;
   signal vs : std_logic;
   signal r : std_logic_vector(2 downto 0);
   signal g : std_logic_vector(2 downto 0);
   signal b : std_logic_vector(2 downto 0);
   signal o_cnt : std_logic_vector(17 downto 0);
   signal o_read_EN : std_logic;
   signal o_readEnX : std_logic;
   signal o_readEnY : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGACore PORT MAP (
          clk => clk,
          i_data => i_data,
          hs => hs,
          vs => vs,
          r => r,
          g => g,
          b => b,
          o_cnt => o_cnt,
          o_read_EN => o_read_EN,
          o_readEnX => o_readEnX,
          o_readEnY => o_readEnY
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
