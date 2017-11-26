--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:48:48 11/26/2017
-- Design Name:   
-- Module Name:   D:/ComputerCompositionExperiment/BigProject/ProjectCPU/test/alu_test.vhd
-- Project Name:  ProjectCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
USE work.constants.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         i_OP0 : IN  std_logic_vector(15 downto 0);
         i_OP1 : IN  std_logic_vector(15 downto 0);
         i_imm : IN  std_logic_vector(15 downto 0);
         i_OP0Src : IN  opSrc_t;
         i_OP1Src : IN  opSrc_t;
         i_ALUOP : IN  alu_op_t;
         o_ALURes : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_OP0 : std_logic_vector(15 downto 0) := (others => '0');
   signal i_OP1 : std_logic_vector(15 downto 0) := (others => '0');
   signal i_imm : std_logic_vector(15 downto 0) := (others => '0');
   signal i_OP0Src : opSrc_t;
   signal i_OP1Src : opSrc_t;
   signal i_ALUOP : alu_op_t;

 	--Outputs
   signal o_ALURes : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
   signal clock : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          i_OP0 => i_OP0,
          i_OP1 => i_OP1,
          i_imm => i_imm,
          i_OP0Src => i_OP0Src,
          i_OP1Src => i_OP1Src,
          i_ALUOP => i_ALUOP,
          o_ALURes => o_ALURes
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

      i_OP0 <= "1111111110000000";
      i_OP1 <= "0000000111111111";
      i_imm <= "0000011111100000";
      i_OP0Src <= opSrc_op1;
      i_OP1Src <= opSrc_imm;
      i_ALUOP <= alu_addu;
      wait for clock_period*10;
      assert (o_ALURes = "0000100111011111")
        report "E1"
        severity ERROR;

      i_OP0Src <= opSrc_imm;
      i_OP1Src <= opSrc_op1;
      i_ALUOP <= alu_addu;
      wait for clock_period*10;
      assert (o_ALURes = "0000100111011111")
        report "E2"
        severity ERROR;

      i_OP0Src <= opSrc_op0;
      i_OP1Src <= opSrc_op1;
      i_ALUOP <= alu_addu;
      wait for clock_period*10;
      assert (o_ALURes = "0000000101111111")
        report "E3"
        severity ERROR;

      i_ALUOP <= alu_subu;
      wait for clock_period*10;
      assert (o_ALURes = "1111110110000001")
        report "E4"
        severity ERROR;

      i_OP0Src <= opSrc_op1;
      i_OP1Src <= opSrc_imm;
      wait for clock_period*10;
      assert (o_ALURes = "1111101000011111")
        report "E5"
        severity ERROR;

      i_OP0Src <= opSrc_op0;
      i_OP1Src <= opSrc_op1;
      i_ALUOP <= alu_not;
      wait for clock_period*10;
      assert (o_ALURes = "0000000001111111")
        report "E6"
        severity ERROR;

      i_ALUOP <= alu_or;
      wait for clock_period*10;
      assert (o_ALURes = "1111111111111111")
        report "E7"
        severity ERROR;

      i_ALUOP <= alu_and;
      wait for clock_period*10;
      assert (o_ALURes = "0000000110000000")
        report "E8"
        severity ERROR;

      i_ALUOP <= alu_xor;
      wait for clock_period*10;
      assert (o_ALURes = "1111111001111111")
        report "E9"
        severity ERROR;

      i_OP0 <= "1111111110000000";
      i_OP1 <= "0000000000000011";
      i_ALUOP <= alu_sll;
      wait for clock_period*10;
      assert (o_ALURes = "1111110000000000")
        report "E10"
        severity ERROR;

      i_ALUOP <= alu_sra;
      wait for clock_period*10;
      assert (o_ALURes = "0001111111110000")
        report "E11"
        severity ERROR;

      i_ALUOP <= alu_cmp;
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000001")
        report "E12"
        severity ERROR;

      i_OP1 <= "1111111110000000";
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000000")
        report "E13"
        severity ERROR;

      i_OP0 <= "0000000000000011";
      i_OP1 <= "0111111110000000";
      i_ALUOP <= alu_less;
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000001")
        report "E14"
        severity ERROR;

      i_OP0 <= "0000000000000011";
      i_OP1 <= "1111111110000000";
      i_ALUOP <= alu_less;
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000000")
        report "E15"
        severity ERROR;

      i_OP0 <= "1000000000000011";
      i_OP1 <= "0111111110000000";
      i_ALUOP <= alu_uless;
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000000")
        report "E16"
        severity ERROR;

      i_OP0 <= "0000000000000011";
      i_OP1 <= "0111111110000000";
      i_ALUOP <= alu_uless;
      wait for clock_period*10;
      assert (o_ALURes = "0000000000000001")
        report "E17"
        severity ERROR;

      wait;
   end process;

END;
