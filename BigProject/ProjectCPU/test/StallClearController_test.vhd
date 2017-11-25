--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:17:57 11/25/2017
-- Design Name:   
-- Module Name:   Y:/workspace/course/3.1/computer-organzation/final-project/ComputerCompositionExperiment/BigProject/ProjectCPU/test/StallClearController_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: StallClearController
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
 
ENTITY StallClearController_test IS
END StallClearController_test;
 
ARCHITECTURE behavior OF StallClearController_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT StallClearController
    PORT(
         i_breakEN : IN  std_logic;
         i_breakPC : IN  std_logic_vector(15 downto 0);
         i_jumpTarget : IN  std_logic_vector(15 downto 0);
         i_predPC : IN  std_logic_vector(15 downto 0);
         i_predSucc : IN  std_logic;
         o_nextPC : OUT  std_logic_vector(15 downto 0);
         o_clear : OUT  std_logic_vector(0 to 4);
         i_wbAddr : IN  std_logic_vector(3 downto 0);
         i_DMStallReq : IN  std_logic;
         i_IFStallReq : IN  std_logic;
         i_DMRE : IN  std_logic;
         i_OP0Addr : IN  std_logic_vector(3 downto 0);
         i_OP1Addr : IN  std_logic_vector(3 downto 0);
         o_stall : OUT  std_logic_vector(0 to 4)
        );
    END COMPONENT;
    

   --Inputs
   signal i_breakEN : std_logic := '0';
   signal i_breakPC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_jumpTarget : std_logic_vector(15 downto 0) := (others => '0');
   signal i_predPC : std_logic_vector(15 downto 0) := (others => '0');
   signal i_predSucc : std_logic := '0';
   signal i_wbAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal i_DMStallReq : std_logic := '0';
   signal i_IFStallReq : std_logic := '0';
   signal i_DMRE : std_logic := '0';
   signal i_OP0Addr : std_logic_vector(3 downto 0) := (others => '0');
   signal i_OP1Addr : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal o_nextPC : std_logic_vector(15 downto 0);
   signal o_clear : std_logic_vector(0 to 4);
   signal o_stall : std_logic_vector(0 to 4);
   signal clk : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: StallClearController PORT MAP (
          i_breakEN => i_breakEN,
          i_breakPC => i_breakPC,
          i_jumpTarget => i_jumpTarget,
          i_predPC => i_predPC,
          i_predSucc => i_predSucc,
          o_nextPC => o_nextPC,
          o_clear => o_clear,
          i_wbAddr => i_wbAddr,
          i_DMStallReq => i_DMStallReq,
          i_IFStallReq => i_IFStallReq,
          i_DMRE => i_DMRE,
          i_OP0Addr => i_OP0Addr,
          i_OP1Addr => i_OP1Addr,
          o_stall => o_stall
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

      -- RAW
      i_predSucc <= '1';

      i_DMRE <= '1';
      wait for clk_period*10;
      assert (o_stall = "11000" and o_clear = "U0100")
        report "E1"
        severity ERROR;
      i_wbAddr <= "1111";
      i_DMRE <= '0';

      -- IFStallReq
      i_DMStallReq <= '0';
      i_IFStallReq <= '1';
      wait for clk_period*10;
      assert (o_stall = "10000" and o_clear = "U1000")
        report "E2"
        severity ERROR;

      -- DMStallReq
      i_DMStallReq <= '1';
      i_IFStallReq <= '0';
      wait for clk_period*10;
      assert (o_stall = "11110" and o_clear = "U0001")
        report "E3"
        severity ERROR;

      -- IFStallReq DMStallReq
      i_DMStallReq <= '1';
      i_IFStallReq <= '1';
      wait for clk_period*10;
      assert (o_stall = "11110" and o_clear = "U0001")
        report "E4"
        severity ERROR;
      

      -- wrong prediction
      i_predSucc <= '0';
      i_DMStallReq <= '0';
      i_IFStallReq <= '0';
      i_jumpTarget <= x"0F0F";
      i_predPC <= x"F0F0";
      i_wbAddr <= "1111";
      wait for clk_period*10;
      assert (o_stall = "00000" and o_clear = "U1000")
        report "E5"
        severity ERROR;

      -- wrong prediction + RAW
      i_DMRE <= '1';
      i_wbAddr <= "0000";
      wait for clk_period*10;
      assert (o_stall = "11000" and o_clear = "U1100")
        report "E6"
        severity ERROR;
      i_DMRE <= '0';
      i_wbAddr <= "1111";

      -- wrong prediction + IFStallReq
      i_DMStallReq <= '0';
      i_IFStallReq <= '1';
      wait for clk_period*10;
      assert (o_stall = "10000" and o_clear = "U1000")
        report "E7"
        severity ERROR;

      -- wrong prediction + DMStallReq
      i_DMStallReq <= '1';
      i_IFStallReq <= '0';
      wait for clk_period*10;
      assert (o_stall = "11110" and o_clear = "U1001")
        report "E8"
        severity ERROR;

      -- wrong prediction + IFStallReq DMStallReq
      i_DMStallReq <= '1';
      i_IFStallReq <= '1';
      wait for clk_period*10;
      assert (o_stall = "11110" and o_clear = "U1001")
        report "E9"
        severity ERROR;

      -- break
      i_breakEN <= '1';
      i_breakPC <= x"8888";
      wait for clk_period*10;
      assert (o_stall = "11110" and o_clear = "U1001" and o_nextPC = i_breakPC)
        report "E10"
        severity ERROR;

      wait;
   end process;

END;
