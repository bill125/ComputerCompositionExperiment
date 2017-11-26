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
use work.constants.all;

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
         o_busRequest : OUT  bus_request_t;
         i_busResponse : IN  bus_response_t
        );
    END COMPONENT;
    

   --Inputs
   signal i_data : std_logic_vector(15 downto 0) := (others => '0');
   signal i_addr : std_logic_vector(15 downto 0) := (others => '0');
   signal i_ALURes : std_logic_vector(15 downto 0) := (others => '0');
   signal i_DMRE : std_logic := '0';
   signal i_DMWR : std_logic := '0';
   signal i_busResponse : bus_response_t;

 	--Outputs
   signal o_DMRes : std_logic_vector(15 downto 0);
   signal o_wbData : std_logic_vector(15 downto 0);
   signal o_stallRequest : std_logic;
   signal o_busRequest : bus_request_t;
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

      -- READ
      i_DMRE <= '1';
      i_DMWR <= '0';
      i_addr <= "0000101001000001";
      i_ALURes <= (others => '1');

      wait for 10 ns;
      assert o_busRequest.writeRequest = '0' and
             o_busRequest.readRequest = '1' and
             o_busRequest.addr = "000000101001000001"
          report "E1"
          severity ERROR;
      i_busResponse.stallRequest <= '0';
      i_busResponse.data <= "0001000100010000";
      wait for 10 ns;
      assert o_DMRes = "0001000100010000" and
             o_wbData = "0001000100010000" and
             o_stallRequest = '0'
          report "E2"
          severity ERROR;

      -- WRITE 
      i_DMRE <= '0';
      i_DMWR <= '1';
      i_addr <= "0000101001000101";
      i_data <= "0000000100000100";
      
      wait for 10 ns;
      assert o_busRequest.writeRequest = '1' and
             o_busRequest.readRequest = '0' and
             o_busRequest.addr = "000000101001000101" and
             o_busRequest.data = "0000000100000100"
          report "E3"
          severity ERROR;
      i_busResponse.stallRequest <= '0';
      wait for 10 ns;
      assert o_wbData = "1111111111111111" and
             o_stallRequest = '0'
          report "E4"
          severity ERROR;

      wait;
   end process;

END;
