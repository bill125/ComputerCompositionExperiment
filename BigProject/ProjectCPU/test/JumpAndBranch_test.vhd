--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:05:07 11/26/2017
-- Design Name:   
-- Module Name:   Y:/workspace/course/3.1/computer-organzation/final-project/ComputerCompositionExperiment/BigProject/ProjectCPU/test/JumpAndBranch_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: JumpAndBranch
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
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;
use work.inst_const;
use work.op_type_constants;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY JumpAndBranch_test IS
END JumpAndBranch_test;
 
ARCHITECTURE behavior OF JumpAndBranch_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT JumpAndBranch
    PORT(
         i_OP0 : IN  std_logic_vector(15 downto 0);
         i_OP1 : IN  std_logic_vector(15 downto 0);
         i_imm : IN  std_logic_vector(15 downto 0);
         i_OP : IN  op_t;
         o_jumpEN : OUT  std_logic;
         o_jumpTarget : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_OP0 : std_logic_vector(15 downto 0) := (others => '0');
   signal i_OP1 : std_logic_vector(15 downto 0) := (others => '0');
   signal i_imm : std_logic_vector(15 downto 0) := (others => '0');
   signal i_OP : op_t;

 	--Outputs
   signal o_jumpEN : std_logic;
   signal o_jumpTarget : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
 
   signal clk : std_logic;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: JumpAndBranch PORT MAP (
          i_OP0 => i_OP0,
          i_OP1 => i_OP1,
          i_imm => i_imm,
          i_OP => i_OP,
          o_jumpEN => o_jumpEN,
          o_jumpTarget => o_jumpTarget
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

      -- B imm
      i_OP0 <= (others => 'X');
      i_OP1 <= x"FFF0";
      i_imm <= x"FFFF";
      i_OP <= op_B;
      wait for 10 ns;
      assert o_jumpEN = '1' and o_jumpTarget = i_OP1 + i_imm
        report "E1"
        severity ERROR;

      -- BEQZ
      i_OP0 <= (others => '1');
      i_OP1 <= x"FFF0";
      i_imm <= (others => '1');
      i_OP <= op_BEQZ;
      wait for 10 ns;
      assert o_jumpEN = '0'-- and o_jumpTarget = i_OP1 + i_imm
        report "E2"
        severity ERROR;
      i_OP0 <= (others => '0');
      i_OP1 <= x"FFF0";
      i_imm <= (others => 'X');
      i_OP <= op_BEQZ;
      wait for 10 ns;
      assert o_jumpEN = '1' and o_jumpTarget = i_OP1 + i_imm
        report "E3"
        severity ERROR;

      -- op_BTEQZ
      i_OP0 <= (others => '1');
      i_OP1 <= x"FFF0";
      i_imm <= (others => '1');
      i_OP <= op_BTEQZ;
      wait for 10 ns;
      assert o_jumpEN = '0'-- and o_jumpTarget = i_OP1 + i_imm
        report "E4"
        severity ERROR;
      i_OP0 <= (others => '0');
      i_OP1 <= x"FFF0";
      i_imm <= (others => 'X');
      i_OP <= op_BTEQZ;
      wait for 10 ns;
      assert o_jumpEN = '1' and o_jumpTarget = i_OP1 + i_imm
        report "E5"
        severity ERROR;

      -- op_BNEZ
      i_OP0 <= (others => '1');
      i_OP1 <= x"FFF0";
      i_imm <= (others => '1');
      i_OP <= op_BNEZ;
      wait for 10 ns;
      assert o_jumpEN = '1' and o_jumpTarget = i_OP1 + i_imm
        report "E6"
        severity ERROR;
      i_OP0 <= (others => '0');
      i_OP1 <= x"FFF0";
      i_imm <= (others => 'X');
      i_OP <= op_BNEZ;
      wait for 10 ns;
      assert o_jumpEN = '0'-- and o_jumpTarget = i_OP1 + i_imm
        report "E7"
        severity ERROR;
        
      -- JR
      i_OP0 <= (others => '1');
      i_OP1 <= (others => 'X');
      i_imm <= (others => '0');
      i_OP <= op_JR;
      wait for 10 ns;
      assert o_jumpEN = '1' and o_jumpTarget = i_OP0
        report "E8"
        severity ERROR;

      wait;
   end process;

END;
