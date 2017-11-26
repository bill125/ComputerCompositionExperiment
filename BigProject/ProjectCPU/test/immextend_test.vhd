--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:01:23 11/26/2017
-- Design Name:   
-- Module Name:   D:/ComputerCompositionExperiment/BigProject/ProjectCPU/test/immextend_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ImmExtend
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
 
ENTITY immextend_test IS
END immextend_test;
 
ARCHITECTURE behavior OF immextend_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ImmExtend
    PORT(
         i_inst : IN  std_logic_vector(15 downto 0);
         o_immExtend : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_inst : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal o_immExtend : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
   signal clock : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ImmExtend PORT MAP (
          i_inst => i_inst,
          o_immExtend => o_immExtend
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

      i_inst <= "01001XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E1"
        severity ERROR;

      i_inst <= "01000XXXXXX01111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E2"
        severity ERROR;
      
      i_inst <= "0001011111111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E3"
        severity ERROR;

      i_inst <= "00100XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E4"
        severity ERROR;

      i_inst <= "00101XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E5"
        severity ERROR;

      i_inst <= "0110000011111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E6"
        severity ERROR;

      i_inst <= "0110001111111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E7"
        severity ERROR;

      i_inst <= "10011XXXXXX11111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E8"
        severity ERROR;

      i_inst <= "10010XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E9"
        severity ERROR;

      i_inst <= "11011XXXXXX11111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E10"
        severity ERROR;

      i_inst <= "11010XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "1111111111111111")
        report "E11"
        severity ERROR;
      
      i_inst <= "01101XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "0000000011111111")
        report "E12"
        severity ERROR;

      i_inst <= "00110XXXXXX11100";
      wait for clock_period*10;
      assert (o_immExtend = "0000000000000111")
        report "E13"
        severity ERROR;

      i_inst <= "01011XXX11111111";
      wait for clock_period*10;
      assert (o_immExtend = "0000000011111111")
        report "E14"
        severity ERROR;

      i_inst <= "00110XXXXXX11111";
      wait for clock_period*10;
      assert (o_immExtend = "0000000000000111")
        report "E15"
        severity ERROR;
      wait;
   end process;

END;
