--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:05:54 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_BusDispatcher.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BusDispatcher
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
 
ENTITY test_BusDispatcher IS
END test_BusDispatcher;
 
ARCHITECTURE behavior OF test_BusDispatcher IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BusDispatcher
    PORT(
         i_busRequest : IN  bus_request_t;
         o_busResponse : OUT  bus_response_t;
         o_sysBusRequest : OUT  bus_request_t;
         i_sysBusResponse : IN  bus_response_t;
         o_extBusRequest : OUT  bus_request_t;
         i_extBusResponse : IN  bus_response_t
        );
    END COMPONENT;
    

   --Inputs
   signal i_busRequest : bus_request_t;
   signal i_sysBusResponse : bus_response_t;
   signal i_extBusResponse : bus_response_t;

 	--Outputs
   signal o_busResponse : bus_response_t;
   signal o_sysBusRequest : bus_request_t;
   signal o_extBusRequest : bus_request_t;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  --  constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BusDispatcher PORT MAP (
          i_busRequest => i_busRequest,
          o_busResponse => o_busResponse,
          o_sysBusRequest => o_sysBusRequest,
          i_sysBusResponse => i_sysBusResponse,
          o_extBusRequest => o_extBusRequest,
          i_extBusResponse => i_extBusResponse
        );

   -- Clock process definitions
  --  <clock>_process :process
  --  begin
	-- 	<clock> <= '0';
	-- 	wait for <clock>_period/2;
	-- 	<clock> <= '1';
	-- 	wait for <clock>_period/2;
  --  end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- wait for <clock>_period*10;

      -- insert stimulus here 

      -- SysBus

      i_busRequest.writeRequest <= '0';
      i_busRequest.readRequest <= '1';
      i_busRequest.addr <= "001000000000000000";
      wait for 10 ns;
      assert o_sysBusRequest.addr = "001000000000000000" and
             o_sysBusRequest.readRequest = '1' and 
             o_sysBusRequest.writeRequest = '0' and
             o_extBusRequest.writeRequest = '0' and
             o_extBusRequest.readRequest = '0'
          report "E1"
          severity ERROR;
      i_sysBusResponse.data <= (others => '1');
      i_extBusResponse.stallRequest <= '0';
      i_sysBusResponse.stallRequest <= '0';
      wait for 10 ns;

      assert o_busResponse.data = "1111111111111111" and
             o_busResponse.stallRequest = '0'
          report "E2"
          severity ERROR;

      -- ExtBus

      i_busRequest.writeRequest <= '1';
      i_busRequest.readRequest <= '0';
      i_busRequest.addr <= "000000000000000010";
      wait for 10 ns;
      assert o_extBusRequest.addr = "000000000000000010" and
             o_extBusRequest.readRequest = '0' and
             o_extBusRequest.writeRequest = '1' and
             o_sysBusRequest.writeRequest = '0' and
             o_sysBusRequest.readRequest = '0'
          report "E3"
          severity ERROR;
      i_extBusResponse.stallRequest <= '1';
      i_sysBusResponse.stallRequest <= '0';
      assert o_busResponse.stallRequest = '1'
          report "E4"
          severity ERROR;


      wait;
   end process;

END;
