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
library IEEE;use IEEE.STD_LOGIC_1164.ALL;use IEEE.NUMERIC_STD.ALL;use IEEE.STD_LOGIC_ARITH.ALL;use IEEE.std_logic_unsigned.all;use work.constants.ALL;

entity main is
    Port ( i_Click 			: in  	STD_LOGIC;
			  i_Clock         : in  	STD_LOGIC;
           i_nReset 			: in  	STD_LOGIC;
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
	type type_State is (s_Init, s1, s2, s3, s4);
	type type_SubState is (s_R1_Read_Setup, s_R1_Read_Datain);
	type type_SubState4 is (s_40, s_41, s_42, s_43, s_44);
   signal t_State: type_State;
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

	process (clock, i_nReset)
		variable t_addr : STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		variable t_data : STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
		variable r_i    : integer range 0 to 31;
		variable st_ygw : integer range 0 to 31;
		variable cnt_ygw : integer range 0 to 31;
		variable l_Click : STD_LOGIC;
	begin
		if i_nReset = '0' then
			-- reset
			t_State <= s_Init;
			
		elsif falling_edge(clock) then
			case t_State is
				-- r_i := 0;
				-- t_SubState <= s_R1_Write
				when s_Init =>
					if l_Click='0' and i_Click='1' then
						t_State <= s1;
						cnt_ygw := 0;
						st_ygw := 0;
					end if;
					
				when s1 =>
					case st_ygw is
						when 0 =>
							if l_Click='0' and i_Click='1' then
								st_ygw := 1;
								cnt_ygw := cnt_ygw+1;
							end if;
						when 1 =>
							st_ygw := 2;
							i_UART_nRE <= '1';
							o_SysBus_Data <= (others => 'Z');
						when 2 =>
							if i_UART_Ready='1' then
								st_ygw := 3;
							else
								st_ygw := 1;
							end if;
						when 3 =>
							st_ygw := 0;
							case cnt_ygw is
								when 1 =>
									t_addr(15 downto 8) := o_SysBus_Data(7 downto 0);
									o_Led(7 downto 0) <= o_SysBus_Data(7 downto 0);
								when 2 =>
									t_addr(7 downto 0) := o_SysBus_Data(7 downto 0);
									o_Led(7 downto 0) <= o_SysBus_Data(7 downto 0);
								when 3 =>
									t_data(15 downto 8) := o_SysBus_Data(7 downto 0);
									o_Led(7 downto 0) <= o_SysBus_Data(7 downto 0);
								when 4 =>
									t_data(7 downto 0) := o_SysBus_Data(7 downto 0);
									o_Led(7 downto 0) <= o_SysBus_Data(7 downto 0);
									t_State <= s2;
									i_UART_nRE <= '1';
								when others =>
									st_ygw := 0;						
							end case;
						when others =>
							st_ygw := 0;
					end case;
				when others =>
					st_ygw := 0;
			end case;
			l_Click := i_Click;
		end if;
	end process;
end Behavioral;