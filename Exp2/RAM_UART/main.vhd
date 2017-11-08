----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:42:52 11/07/2017 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constant.ALL;

entity main is
    Port ( i_Click 			: in  	STD_LOGIC;
           i_nReset 			: in  	STD_LOGIC;
           i_Key0				: in  	STD_LOGIC;
           
			  o_SysBus_Addr	: out  	STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           o_SysBus_Data	: inout 	STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
           o_Ram1_nOE		: out  	STD_LOGIC;
           o_Ram1_nWe		: out  	STD_LOGIC;
           o_Ram1_nCE		: out 	STD_LOGIC;
           
			  o_ExtBus_Addr	: out  	STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           o_ExtBus_Data	: inout  STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
           o_Ram2_nOE		: out  	STD_LOGIC;
           o_Ram2_nWE		: out  	STD_LOGIC;
           o_Ram2_nCE		: out  	STD_LOGIC;
			  
			  i_UART_Ready		: in		STD_LOGIC;
			  i_UART_nRE		: out 	STD_LOGIC;
			  
			  UART_nWE			: out		STD_LOGIC;
			  UART_TBRE			: in		STD_LOGIC;
			  UART_TSRE			: in		STD_LOGIC  
			);
 end main;

architecture Behavioral of main is
	type t_State is (s_Init, s_R1_Read, s_R2_Read, s_R1_Write, s_R2_Write);
begin
	process (i_clk, i_rst)
		variable addr: STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
	begin
		if i_nReset = '0' then
			-- reset
			t_SM_Main <= s_Init;
		elsif falling_edge(i_Click) then
			case t_State is
				when s_Init =>
					s_State <= s_R1_Read;
			end case;
		end if
	end process;
end Behavioral;