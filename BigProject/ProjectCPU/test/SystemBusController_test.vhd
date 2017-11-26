--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:54:28 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_SystemBusController.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SystemBusController
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
 
ENTITY test_SystemBusController IS
END test_SystemBusController;
 
ARCHITECTURE behavior OF test_SystemBusController IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SystemBusController
    PORT(
         i_clock : IN  std_logic;
         i_busRequest : IN  bus_request_t;
         o_busResponse : OUT  bus_response_t;
         i_UART_readReady : IN  std_logic;
         i_UART_readDone : IN  std_logic;
         i_UART_writeReady : IN  std_logic;
         i_UART_writeDone : IN  std_logic;
         i_UART_data : IN  std_logic_vector(15 downto 0);
         o_UART_data : OUT  std_logic_vector(15 downto 0);
         o_UART_readBegin : OUT  std_logic;
         o_UART_writeBegin : OUT  std_logic;
         o_nOE : OUT  std_logic;
         o_nWE : OUT  std_logic;
         o_nCE : OUT  std_logic;
         io_bus_data : INOUT  std_logic_vector(15 downto 0);
         o_bus_addr : OUT  std_logic_vector(17 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clock : std_logic := '0';
   signal i_busRequest : bus_request_t;
   signal i_UART_readReady : std_logic := '0';
   signal i_UART_readDone : std_logic := '0';
   signal i_UART_writeReady : std_logic := '0';
   signal i_UART_writeDone : std_logic := '0';
   signal i_UART_data : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal io_bus_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal o_busResponse : bus_response_t;
   signal o_UART_data : std_logic_vector(15 downto 0);
   signal o_UART_readBegin : std_logic;
   signal o_UART_writeBegin : std_logic;
   signal o_nOE : std_logic;
   signal o_nWE : std_logic;
   signal o_nCE : std_logic;
   signal o_bus_addr : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant i_clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SystemBusController PORT MAP (
          i_clock => i_clock,
          i_busRequest => i_busRequest,
          o_busResponse => o_busResponse,
          i_UART_readReady => i_UART_readReady,
          i_UART_readDone => i_UART_readDone,
          i_UART_writeReady => i_UART_writeReady,
          i_UART_writeDone => i_UART_writeDone,
          i_UART_data => i_UART_data,
          o_UART_data => o_UART_data,
          o_UART_readBegin => o_UART_readBegin,
          o_UART_writeBegin => o_UART_writeBegin,
          o_nOE => o_nOE,
          o_nWE => o_nWE,
          o_nCE => o_nCE,
          io_bus_data => io_bus_data,
          o_bus_addr => o_bus_addr
        );

   -- Clock process definitions
   i_clock_process :process
   begin
		i_clock <= '1';
		wait for i_clock_period/2;
		i_clock <= '0';
		wait for i_clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
      wait for 100 ns;
      -- insert stimulus here 


      -- Read UART control
      i_busRequest.addr <= "001011111100000001";
      i_busRequest.readRequest <= '1';
      i_busRequest.writeRequest <= '0';
      i_UART_readReady <= '0';
      i_UART_readDone <= '0';
      i_UART_writeReady <= '1';
      i_UART_writeDone <= '0';
      wait for i_clock_period;
      assert o_busResponse.data = "0000000000000001" and
             o_busResponse.stallRequest = '0'
          report "E1"
          severity ERROR;

      -- Write UART Data
      i_busRequest.addr <= "001011111100000000";
      i_busRequest.data <= "0100100010011100";
      i_busRequest.writeRequest <= '1';
      i_busRequest.readRequest <= '0';
      i_UART_writeReady <= '0';
      i_UART_writeDone <= '0';
      wait for i_clock_period;
      assert o_busResponse.stallRequest = '1' and
             o_UART_data = "0100100010011100" and
             o_UART_writeBegin = '1' and
             o_nCE = '1'
        report "E2"
        severity ERROR;
      wait for i_clock_period * 31;
      i_UART_writeDone <= '1';
      i_UART_readReady <= '1';
      wait for i_clock_period;
      assert o_busResponse.stallRequest = '0' and 
             o_UART_data = "0100100010011100"
        report "E3"
        severity ERROR;
      i_UART_writeDone <= '0';

      -- Read UART Data
      i_busRequest.addr <= "001011111100000000";
      i_busRequest.writeRequest <= '0';
      i_busRequest.readRequest <= '1';
      i_UART_readReady <= '0';
      i_UART_readDone <= '0';
      wait for i_clock_period;
      assert o_busResponse.stallRequest = '1' and
             o_UART_readBegin = '1' and
             o_nCE = '1'
        report "E4"
        severity ERROR;
      wait for i_clock_period * 15;
      i_UART_readDone <= '1';
      i_UART_data <= "1100110101110001";
      wait for i_clock_period;
      assert o_busResponse.stallRequest = '0' and
             o_busResponse.data = "1100110101110001"
          report "E5"
          severity ERROR;
      i_UART_readDone <= '0';

      -- Write SRAM
      i_busRequest.addr <= "001000011110110100";
      i_busRequest.data <= "1100110101100101";
      i_busRequest.writeRequest <= '1';
      i_busRequest.readRequest <= '0';
      io_bus_data <= (others => 'Z');
      wait for i_clock_period/4;
      assert o_nCE = '0' and o_nWE = '0' and o_nOE = '1' and
             io_bus_data = "1100110101100101" and
             o_bus_addr = "001000011110110100"
        report "E6"
        severity ERROR;
      wait for i_clock_period/2;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '1' and
             o_busResponse.stallRequest = '0'
        report "E7"
        severity ERROR;
      wait for i_clock_period/4;

      -- Read SRAM
      i_busRequest.addr <= "001000011110110100";
      i_busRequest.writeRequest <= '0';
      i_busRequest.readRequest <= '1';
      wait for i_clock_period/4;
      assert o_nCE = '0' and o_nWE = '1' and o_nOE = '0'
        report "E8"
        severity ERROR;
      io_bus_data <= "1100110100000111";
      wait for i_clock_period/2;
      assert o_busResponse.data = "1100110100000111" and
             o_busResponse.stallRequest = '0'
          report "E9"
          severity ERROR;
      wait for i_clock_period/4;

      wait;
   end process;

END;
