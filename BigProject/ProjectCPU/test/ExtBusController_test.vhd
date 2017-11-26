--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:56:32 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_ExtBusController.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ExtBusController
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
 
ENTITY test_ExtBusController IS
END test_ExtBusController;
 
ARCHITECTURE behavior OF test_ExtBusController IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ExtBusController
    PORT(
         i_clock : IN  std_logic;
         i_IM_busRequest : IN  bus_request_t;
         i_DM_busRequest : IN  bus_request_t;
         o_IM_busResponse : OUT  bus_response_t;
         o_DM_busResponse : OUT  bus_response_t;
         io_bus_data : INOUT  std_logic_vector(15 downto 0);
         o_bus_addr : OUT  std_logic_vector(17 downto 0);
         o_nCE : OUT  std_logic;
         o_nOE : OUT  std_logic;
         o_nWE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_IM_busRequest : bus_request_t;
   signal i_DM_busRequest : bus_request_t;

	--BiDirs
   signal io_bus_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal o_IM_busResponse : bus_response_t;
   signal o_DM_busResponse : bus_response_t;
   signal o_bus_addr : std_logic_vector(17 downto 0);
   signal o_nCE : std_logic;
   signal o_nOE : std_logic;
   signal o_nWE : std_logic;

   -- Clock period definitions
   constant i_clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ExtBusController PORT MAP (
          i_clock => i_clock,
          i_IM_busRequest => i_IM_busRequest,
          i_DM_busRequest => i_DM_busRequest,
          o_IM_busResponse => o_IM_busResponse,
          o_DM_busResponse => o_DM_busResponse,
          io_bus_data => io_bus_data,
          o_bus_addr => o_bus_addr,
          o_nCE => o_nCE,
          o_nOE => o_nOE,
          o_nWE => o_nWE
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


      -- IM Read
      i_IM_busRequest.addr <= "000000000001000100";
      i_IM_busRequest.writeRequest <= '0';
      i_IM_busRequest.readRequest <= '1';
      i_DM_busRequest.writeRequest <= '0';
      i_DM_busRequest.readRequest <= '0';
      wait for i_clock_period/2;
      io_bus_data <= "0010001000000000";
      wait for i_clock_period/2;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '0' and
             o_bus_addr = "000000000001000100" and
             o_IM_busResponse.data = "0010001000000000" and 
             o_IM_busResponse.stallRequest = '0' and
             o_DM_busResponse.stallRequest = '0' 
          report "E1"
          severity ERROR;
      wait for i_clock_period;
      

      -- IM Write
      i_IM_busRequest.addr <= "000000000001000101";
      i_IM_busRequest.data <= "0010001000011000";
      i_IM_busRequest.writeRequest <= '1';
      i_IM_busRequest.readRequest <= '0';
      i_DM_busRequest.writeRequest <= '0';
      i_DM_busRequest.readRequest <= '0';
      io_bus_data <= (others => 'Z');
      wait for i_clock_period/4*3;
      assert o_nCE = '0' and o_nWE = '0' and o_nOE = '1' and
             io_bus_data = "0010001000011000" and
             o_bus_addr = "000000000001000101"
        report "E2"
        severity ERROR;
      wait for i_clock_period/4*2;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '1' and
             o_IM_busResponse.stallRequest = '0' and
             o_DM_busResponse.stallRequest = '0'
          report "E3"
          severity ERROR;
      wait for i_clock_period/4*3;
      
      -- DM Read
      i_DM_busRequest.addr <= "000000000101000101";
      i_DM_busRequest.writeRequest <= '0';
      i_DM_busRequest.readRequest <= '1';
      i_IM_busRequest.writeRequest <= '0';
      i_IM_busRequest.readRequest <= '0';
      wait for i_clock_period/2;
      io_bus_data <= "0010001001110000";
      wait for i_clock_period/2;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '0' and
             o_bus_addr = "000000000101000101" and
             o_DM_busResponse.data = "0010001001110000" and 
             o_DM_busResponse.stallRequest = '0' and
             o_IM_busResponse.stallRequest = '0' 
          report "E4"
          severity ERROR;
      wait for i_clock_period;
      
      -- DM Write
      i_DM_busRequest.addr <= "010001110001000101";
      i_DM_busRequest.data <= "0010000001111000";
      i_IM_busRequest.writeRequest <= '0';
      i_IM_busRequest.readRequest <= '1';
      i_DM_busRequest.writeRequest <= '1';
      i_DM_busRequest.readRequest <= '0';
      io_bus_data <= (others => 'Z');
      wait for i_clock_period/4*3;
      assert o_nCE = '0' and o_nWE = '0' and o_nOE = '1' and
             io_bus_data = "0010000001111000" and
             o_bus_addr = "010001110001000101"
        report "E5"
        severity ERROR;
      wait for i_clock_period/4*2;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '1' and
             o_IM_busResponse.stallRequest = '1' and
             o_DM_busResponse.stallRequest = '0'
          report "E6"
          severity ERROR;

      wait;
   end process;

END;
