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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use work.constants.ALL;

entity main is
Port(   i_Click         : in        STD_LOGIC;
        i_Clock         : in        STD_LOGIC;
        i_nReset        : in        STD_LOGIC;
        o_Led           : out       STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);

        o_SysBus_Addr   : out       STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
        o_SysBus_Data   : inout     STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
        o_Ram1_nOE      : out       STD_LOGIC;
        o_Ram1_nWE      : out       STD_LOGIC;
        o_Ram1_nCE      : out       STD_LOGIC;

        o_ExtBus_Addr   : out       STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
        o_ExtBus_Data   : inout     STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
        o_Ram2_nOE      : out       STD_LOGIC;
        o_Ram2_nWE      : out       STD_LOGIC;
        o_Ram2_nCE      : out       STD_LOGIC; 

        o_Dig           : out       STD_LOGIC_VECTOR (6 downto 0);

        i_UART_Ready    : in        STD_LOGIC;
        i_UART_nRE      : out       STD_LOGIC;

        UART_nWE        : out       STD_LOGIC;
        UART_TBRE       : in        STD_LOGIC;
        UART_TSRE       : in        STD_LOGIC  
        );
 end main;

architecture Behavioral of main is
    type type_State is (s_Init, s1, s2, s3, s4);
    type type_SubState is (s_Init, s_Read_Setup, s_Read_Datain, s_Write_Setup, s_Write_Datain, s_Idle);
    type type_SubState4 is (s_40, s_41, s_42, s_43, s_44);
    signal t_State : type_State := s_Init;
    signal t_SubState : type_SubState;
    signal is_high8_ljk: std_logic := '0';
    signal stx_ljk: type_SubState4 := s_40;
    signal st_ygw : integer range 0 to 31;
    signal clock : STD_LOGIC;
    signal stage_num : std_logic_vector(3 downto 0);
    
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
    
    component seg7 is
        port(
            code: in std_logic_vector(3 downto 0);
            seg_out : out std_logic_vector(6 downto 0)
        );
    end component seg7;
begin
     FD_Inst : FreqDiv
    generic map
    (
        div => 100000,
        half => 50000
    )
    port map
    (
        CLK => i_Clock,
        RST => '0', 
        O => clock
    );
     
     Seg7_Inst : Seg7
     port map
     (
            code => stage_num,
            seg_out => o_Dig
     );

    process (clock, i_nReset)
        variable t_addr : STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
        variable t_data : STD_LOGIC_VECTOR (WORD_WIDTH-1 downto 0);
        variable r_i    : integer range 0 to 31;
        variable l_Click : STD_LOGIC := '1';
        variable cnt_ljk : integer range 0 to 31 := 0;
      variable cnt_ygw : integer range 0 to 31;
    begin
        if i_nReset = '0' then
          -- reset
          t_State <= s_Init;
        elsif falling_edge(clock) then
          case t_State is
            when s_Init =>
              stage_num <= (others => '0');
              o_Led <= (others => '0');
              if l_Click='0' and i_Click='1' then
                t_State <= s1;
                cnt_ygw := 0;
                st_ygw <= 0;
                stx_ljk <= s_40;
                cnt_ljk := 0;
                is_high8_ljk <= '0';
                stage_num <= stage_num + 1;
              end if;
                
            when s1 =>
              case st_ygw is
                when 0 =>
                  if l_Click='0' and i_Click='1' then
                    st_ygw <= 1;
                    cnt_ygw := cnt_ygw+1;
                  end if;
                when 1 =>
                  st_ygw <= 2;
                  i_UART_nRE <= '1';
                  o_SysBus_Data <= (others => 'Z');
                when 2 =>
                  if i_UART_Ready = '1' then
                    st_ygw <= 3;
                    i_UART_nRE <= '0';
                  else
                    st_ygw <= 1;
                  end if;
                when 3 =>
                  st_ygw <= 0;
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
                      stage_num <= stage_num + 1;
                      t_State <= s2;
                      t_SubState <= s_Init;
                      i_UART_nRE <= '1';
                    when others =>
                      st_ygw <= 0;                        
                  end case;
                when others =>
                  st_ygw <= 0;
            end case;
            when s2 =>
              case t_SubState is
                when s_Init => -- Begin Stage II
                  r_i := 0;
                  o_Ram1_nCE <= '0';
                  t_State <= s2;
                  t_SubState <= s_Write_Setup;
               
                when s_Write_Setup => -- Write to RAM1: Setup data & addr
                  o_SysBus_Data <= t_data;
                  o_SysBus_Addr <= t_addr;
                  t_State <= s2;
                  t_SubState <= s_Write_Datain;
                
                when s_Write_Datain => -- Write to RAM1: Write
                  o_Ram1_nWE <= '0';
                  o_Ram1_nOE <= '1';
                  t_State <= s2;
                  t_SubState <= s_Idle;
                
                when s_Idle => -- Wait for click
                  if l_Click = '0' and i_Click = '1' then
                    if r_i < 10 then
                      t_data := t_data + 1;
                      t_addr := t_addr + 1;
                      r_i := r_i + 1;
                      t_State <= s2;
                      t_SubState <= s_Write_Setup;
                    else                            
                      stage_num <= stage_num + 1;
                      t_State <= s3;
                      t_SubState <= s_Init;
                    end if;
                  else
                    o_Led(15 downto 8) <= t_addr(7 downto 0);
                    o_Led(7 downto 0) <= t_data(7 downto 0);
                    t_State <= s2;
                    t_SubState <= s_Idle;
                  end if;
                    
                when others =>
                  t_State <= s2;
                  t_SubState <= s_Idle;

                end case;
                when s3 => 
                  case t_SubState is
                    when s_Init => -- Begin Stage III
                      o_Ram1_nCE <= '0';
                      o_Ram2_nCE <= '0';
                      r_i := 0;
                      t_addr := t_addr - 10;
                      t_State <= s3;
                      t_SubState <= s_Read_Setup;
                        
                    when s_Read_Setup => -- Read from RAM1: Setup data & addr
                      o_SysBus_Data <= (others => 'Z');
                      o_SysBus_Addr <= t_addr;
                      o_Ram1_nWE <= '1';
                      o_Ram1_nOE <= '0';
                      t_State <= s3;
                      t_SubState <= s_Read_Datain;
                
                    when s_Read_Datain => -- Read from RAM1: Read
                      t_data := o_SysBus_Data;
                      t_State <= s3;
                      t_SubState <= s_Write_Setup;
                        
                    when s_Write_Setup => -- Write to RAM2: Setup data & addr
                      o_ExtBus_Data <= t_data + 1;
                      o_ExtBus_Addr <= t_addr;
                      t_State <= s3;
                      t_SubState <= s_Write_Datain;
                    
                    when s_Write_Datain => -- Write to RAM2: Write
                      o_Ram2_nWE <= '0';
                      o_Ram2_nOE <= '1';
                      t_State <= s3;
                      t_SubState <= s_Idle;
                    
                    when s_Idle => -- Wait for Click
                      if l_Click = '0' and i_Click = '1' then
                        if r_i < 10 then
                          t_data := t_data + 1;
                          t_addr := t_addr + 1;
                          r_i := r_i + 1;
                          t_State <= s3;
                          t_SubState <= s_Read_Setup;
                        else
                          stage_num <= stage_num + 1;
                          t_addr := t_addr - 10;
                          t_State <= s4;
                          t_SubState <= s_Idle;
                        end if;
                      else
                        o_Led(15 downto 8) <= t_addr(7 downto 0);
                        o_Led(7 downto 0)  <= t_data(7 downto 0);
                        t_State <= s3;
                        t_SubState <= s_Idle;
                      end if;
                    
                    when others =>
                      t_State <= s3;
                      t_SubState <= s_Idle;
                end case;
            
                when s4 => 
                  case stx_ljk is
                    when s_40 =>
                      o_Ram1_nCE <= '1';
                      o_Ram1_nOE <= '1';
                      o_Ram1_nWE <= '1';
                      o_ExtBus_Addr <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(t_addr) + cnt_ljk, ADDR_WIDTH);
                      o_ExtBus_Data <= (others => 'Z');
                      o_Ram2_nCE <= '0';
                      o_Ram2_nOE <= '0';
                      o_Ram2_nWE <= '1';
                      UART_nWE <= '1'; 
                      if l_Click = '0' and i_Click = '1' then
                        stx_ljk <= s_41;
                      else
                        stx_ljk <= s_40;
                      end if;
                    when s_41 => -- loading data
                      UART_nWE <= '0';
                      if is_high8_ljk = '0' then o_SysBus_Data(7 downto 0) <= o_ExtBus_Data(7 downto 0);
                      else                       o_SysBus_Data(7 downto 0) <= o_ExtBus_Data(15 downto 8);
                      end if;
                      stx_ljk <= s_42;
                    when s_42 =>
                      UART_nWE <= '1';
                      stx_ljk <= s_43;
                    when s_43 =>
                      if UART_TBRE = '1' then
                        stx_ljk <= s_44;
                      else stx_ljk <= s_43;
                      end if;
                    when s_44 => -- sending
                      o_Led(15 downto 8) <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(t_addr) + cnt_ljk, WORD_WIDTH)(7 downto 0);
                             o_Led(7 downto 0) <= o_SysBus_Data(7 downto 0);
                      if UART_TSRE = '1' then -- sent
                        if is_high8_ljk = '1' then cnt_ljk := cnt_ljk + 1;
                        end if;
                        is_high8_ljk <= is_high8_ljk xor '1';
                        stx_ljk <= s_40;
                      else -- sending
                        stx_ljk <= s_44;
                      end if;
                    when others => 
                            stx_ljk <= s_40;
                        end case;
                when others =>
                    t_State <= s_Init;
            end case;
            l_Click := i_Click;
        end if;
    end process;
end Behavioral;