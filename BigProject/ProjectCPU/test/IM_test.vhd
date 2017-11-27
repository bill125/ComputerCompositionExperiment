--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:46:50 11/26/2017
-- Design Name:   
-- Module Name:   Y:/Desktop/MyDocument/3.1/ComputerComposition/ComputerCompositionExperiment/BigProject/ProjectCPU/test_IM.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IM
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
 
ENTITY test_IM IS
END test_IM;
 
ARCHITECTURE behavior OF test_IM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IM
    PORT(
         i_PC : IN addr_t;
         o_inst : OUT inst_t;
         i_busResponse : IN  bus_response_t;
         o_busRequest : OUT  bus_request_t;
         o_stallRequest : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_PC : addr_t := (others => '0');
   signal i_busResponse : bus_response_t;

 	--Outputs
   signal o_inst : inst_t;
   signal o_busRequest : bus_request_t;
   signal o_stallRequest : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
  --  constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IM PORT MAP (
          i_PC => i_PC,
          o_inst => o_inst,
          i_busResponse => i_busResponse,
          o_busRequest => o_busRequest,
          o_stallRequest => o_stallRequest
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

      -- Send Request
      i_PC <= "0001000100100101";
      wait for 50 ns;
      assert o_busRequest.addr = "000001000100100101" and 
             o_busRequest.readRequest = '1' and
             o_busRequest.writeRequest = '0'
          report "E1"
          severity ERROR;

      -- Receive Response
      i_busResponse.data <= "1111000100000000";
      i_busResponse.stallRequest <= '1';
      wait for 50 ns;
      assert o_inst = "1111000100000000" and 
             o_stallRequest = '1'
          report "E2"
          severity ERROR;

      wait;
   end process;

END;
