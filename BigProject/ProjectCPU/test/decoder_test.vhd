--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:22:12 11/26/2017
-- Design Name:   
-- Module Name:   D:/ComputerCompositionExperiment/BigProject/ProjectCPU/test/decoder_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decoder
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
 
ENTITY decoder_test IS
END decoder_test;
 
ARCHITECTURE behavior OF decoder_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decoder
    PORT(
         i_OP0Type : IN  std_logic_vector(2 downto 0);
         i_OP1Type : IN  std_logic_vector(2 downto 0);
         i_wbType : IN  std_logic_vector(2 downto 0);
         i_rxAddr : IN  std_logic_vector(3 downto 0);
         i_rxData : IN  std_logic_vector(15 downto 0);
         i_ryAddr : IN  std_logic_vector(3 downto 0);
         i_ryData : IN  std_logic_vector(15 downto 0);
         i_rzAddr : IN  std_logic_vector(3 downto 0);
         i_IH : IN  std_logic_vector(15 downto 0);
         i_SP : IN  std_logic_vector(15 downto 0);
         i_PC : IN  std_logic_vector(15 downto 0);
         i_T : IN  std_logic_vector(15 downto 0);
         o_OP0Addr : OUT  std_logic_vector(3 downto 0);
         o_OP0Data : OUT  std_logic_vector(15 downto 0);
         o_OP1Addr : OUT  std_logic_vector(3 downto 0);
         o_OP1Data : OUT  std_logic_vector(15 downto 0);
         o_wbAddr : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_OP0Type : std_logic_vector(2 downto 0) := (others => '0');
   signal i_OP1Type : std_logic_vector(2 downto 0) := (others => '0');
   signal i_wbType : std_logic_vector(2 downto 0) := (others => '0');
   signal i_rxAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal i_rxData : std_logic_vector(15 downto 0) := (others => '0');
   signal i_ryAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal i_ryData : std_logic_vector(15 downto 0) := (others => '0');
   signal i_rzAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal i_IH : std_logic_vector(15 downto 0) := (others => '0');
   signal i_SP : std_logic_vector(15 downto 0) := (others => '0');
   signal i_PC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_T : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal o_OP0Addr : std_logic_vector(3 downto 0);
   signal o_OP0Data : std_logic_vector(15 downto 0);
   signal o_OP1Addr : std_logic_vector(3 downto 0);
   signal o_OP1Data : std_logic_vector(15 downto 0);
   signal o_wbAddr : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
   signal clock : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decoder PORT MAP (
          i_OP0Type => i_OP0Type,
          i_OP1Type => i_OP1Type,
          i_wbType => i_wbType,
          i_rxAddr => i_rxAddr,
          i_rxData => i_rxData,
          i_ryAddr => i_ryAddr,
          i_ryData => i_ryData,
          i_rzAddr => i_rzAddr,
          i_IH => i_IH,
          i_SP => i_SP,
          i_PC => i_PC,
          i_T => i_T,
          o_OP0Addr => o_OP0Addr,
          o_OP0Data => o_OP0Data,
          o_OP1Addr => o_OP1Addr,
          o_OP1Data => o_OP1Data,
          o_wbAddr => o_wbAddr
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

      i_OP0Type <= "000";
      i_OP1Type <= "001";
      i_wbType <= "010";
      i_rxAddr <= "0000";
      i_rxData <= "0000000000000000";
      i_ryAddr <= "0001";
      i_ryData <= "0000000000000001";
      i_rzAddr <= "0010";
      i_IH <= "0000000000000010";
      i_SP <= "0000000000000011";
      i_PC <= "0000000000000100";
      i_T <= "0000000000000101";
      wait for clock_period*10;
      assert (o_OP0Addr = "0000" and
              o_OP0Data = "0000000000000000" and
              o_OP1Addr = "0001" and
              o_OP1Data = "0000000000000001" and
              o_wbAddr = "1000")
        report "E1"
        severity ERROR;

      i_OP0Type <= "011";
      i_OP1Type <= "100";
      i_wbType <= "101";
      wait for clock_period*10;
      assert (o_OP0Addr = "1010" and
              o_OP0Data = "0000000000000100" and
              o_OP1Addr = "1011" and
              o_OP1Data = "0000000000000010" and
              o_wbAddr = "0010")
        report "E2"
        severity ERROR;

      i_OP0Type <= "110";
      i_OP1Type <= "111";
      wait for clock_period*10;
      assert (o_OP0Addr = "1101" and
              o_OP0Data = "0000000000000011" and
              o_OP1Addr = "1111" and
              o_OP1Data = "0000000000000000")
        report "E3"
        severity ERROR;
      wait;
   end process;

END;
