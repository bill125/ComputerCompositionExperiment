--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:07:27 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_UART.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
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
use work.constants.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_UART IS
END test_UART;
 
ARCHITECTURE behavior OF test_UART IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
    PORT(
         i_clock : IN  std_logic;
         io_sysBus_data : INOUT  std_logic_vector(15 downto 0);
         i_data : IN  std_logic_vector(15 downto 0);
         i_writeBegin : IN  std_logic;
         o_writeReady : OUT  std_logic;
         o_writeDone : OUT  std_logic;
         o_data : OUT  std_logic_vector(15 downto 0);
         i_readBegin : IN  std_logic;
         o_readReady : OUT  std_logic;
         o_readDone : OUT  std_logic;
         i_tbre : IN  std_logic;
         i_tsre : IN  std_logic;
         o_wrn : OUT  std_logic;
         i_data_ready : IN  std_logic;
         o_rdn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_data : std_logic_vector(15 downto 0) := (others => '0');
   signal i_writeBegin : std_logic := '0';
   signal i_readBegin : std_logic := '0';
   signal i_tbre : std_logic := '0';
   signal i_tsre : std_logic := '0';
   signal i_data_ready : std_logic := '0';

	--BiDirs
   signal io_sysBus_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal o_writeReady : std_logic;
   signal o_writeDone : std_logic;
   signal o_data : std_logic_vector(15 downto 0);
   signal o_readReady : std_logic;
   signal o_readDone : std_logic;
   signal o_wrn : std_logic;
   signal o_rdn : std_logic;

   -- Clock period definitions
   constant i_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          i_clock => i_clock,
          io_sysBus_data => io_sysBus_data,
          i_data => i_data,
          i_writeBegin => i_writeBegin,
          o_writeReady => o_writeReady,
          o_writeDone => o_writeDone,
          o_data => o_data,
          i_readBegin => i_readBegin,
          o_readReady => o_readReady,
          o_readDone => o_readDone,
          i_tbre => i_tbre,
          i_tsre => i_tsre,
          o_wrn => o_wrn,
          i_data_ready => i_data_ready,
          o_rdn => o_rdn
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

      -- insert stimulus here 

      -- Read 
      io_sysBus_data <= (others => 'Z');
      wait for i_clock_period * 3;
      i_data_ready <= '1';
      wait for i_clock_period;
      i_readBegin <= '1';
      io_sysBus_data <= "0000010000000100";
      wait for i_clock_period;
      assert o_rdn = '0'
          report "E1"
          severity ERROR;
      i_data_ready <= '0';
      wait for i_clock_period * 31;
      assert o_data = "0000010000000100" and
             o_readDone = '1'
          report "E2"
          severity ERROR;

      -- Send
      io_sysBus_data <= (others => 'Z');
      wait for i_clock_period * 3;
      i_data <= "0000000001110100";
      i_writeBegin <= '1';
      wait for i_clock_period * 2;
      assert o_writeReady = '0' and
             o_writeDone = '0' and 
             io_sysBus_data = "0000000001110100"
          report "E3"
          severity ERROR;
      
      wait for i_clock_period * 33;
      i_writeBegin <= '0';
      i_tbre <= '1';
      wait for i_clock_period;
      i_tsre <= '1';
      wait for i_clock_period;
      assert o_writeDone = '1' and
             o_writeReady = '1'
          report "E4"
          severity ERROR;

      wait;
   end process;

END;
