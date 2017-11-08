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
			  o_Led				: out		STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
           
			  o_SysBus_Addr	: out  	STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           o_SysBus_Data	: inout 	STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
           o_Ram1_nOE		: out  	STD_LOGIC;
           o_Ram1_nWE		: out  	STD_LOGIC;
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
	type t_State is (s_Init, s1, s2, s3, s4);
	type t_SubState is (s_R1_Read_Setup, s_R1_Read_Datain);
	signal clock : STD_LOGIC;
	
	component FreqDiv is
		generic
		(
			div : integer := 50;
			half : integer := 25 
		);
		port
		(
			CLK: in std_logic;
			RST: in std_logic;
			O: out std_logic
		);
	end component FreqDiv;
begin
	 FD_Inst : FreqDiv
    generic map
    (
        div => 1000,
        half => 500
    )
    port map
    (
        CLK => i_Clock,
        RST => '0', 
        O => clock
    );

	process (i_clk, i_rst)
		variable t_addr : STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		variable t_data : STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
		variable r_i    : integer range 0 to 31; 
		variable l_Click : STD_LOGIC;
	begin
		if i_nReset = '0' then
			-- reset
			t_State <= s_Init;
		elsif falling_edge(clock) then
			case t_State is
				-- r_i := 0;
				-- t_SubState <= s_R1_Write
				when s2 =>
					case t_SubState <= s_R1_Read_Setup
					o_SysBus_Data <= t_data;
					o_SysBus_Addr <= t_addr;
					o_Ram1_nCE <= '1';
					o_Ram1_nWE <= '0';
					o_Ram1_nOE <= '1';
					o_Led(15 downto 8) <= t_addr(7 downto 0);
					o_Led(7 downto 0) <= t_data(7 downto 0);
					if r_i < 10 then
						if r_i > 0 then
							t_data := t_data + 1;
							t_addr := t_addr + 1;
						end if;
						r_i := r_i + 1;
						t_SubState <= s_R1_Write;
						t_State <= s2;
					end if;
						when s_R1_
					end case;
				when s3 =>
					t_State <= s_R
			end case;
			l_Click := i_Click;
		end if;
	end process;
end Behavioral;