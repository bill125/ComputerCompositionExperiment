----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:21:00 11/25/2017 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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
use work.constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    port
    (
        i_clock        : in std_logic; -- fast clock

        io_sysBus_data : inout word_t;

        i_data         : in word_t;
        i_writeBegin   : in std_logic;
        o_writeReady   : out std_logic;
        o_writeDone    : out std_logic;

        o_data         : out word_t;
        i_readBegin    : in std_logic;
        o_readReady    : out std_logic;
        o_readDone     : out std_logic;
        
        i_tbre         : in std_logic;
        i_tsre         : in std_logic;
        o_wrn          : out std_logic;
        i_data_ready   : in std_logic;
        o_rdn          : out std_logic
    );
end UART;

architecture Behavioral of UART is
    type type_RX_State is (t_RX_0, t_RX_1, t_RX_2);
    type type_TX_State is (t_TX_0, t_TX_1, t_TX_2, t_TX_3, t_TX_4);
    signal r_RX_State : type_RX_State := t_RX_0;
    signal r_TX_State : type_TX_State := t_TX_0;
begin

    -- Read UART
    Receive_Data : process(i_clock)
        variable wait_turns : integer range 0 to 31 := 0;
    begin
        if rising_edge(i_clock) then
            if wait_turns /= 0 then
                wait_turns := wait_turns - 1;
            else
                io_sysBus_data <= (others => 'Z');
                case r_RX_State is
                    when t_RX_0 => -- wait for data
                        o_readReady <= '0';
                        o_readDone <= '1';
                        o_rdn <= '1';
                        if i_data_ready = '1' then
                            o_readReady <= '1';
                            o_readDone <= '0';
                            r_RX_State <= t_RX_1;
                        else
                            r_RX_State <= t_RX_0;
                        end if;

                    when t_RX_1 => -- receive data
                        if i_readBegin = '1' then
                            o_rdn <= '0';
                            o_data <= io_sysBus_data;
                            o_readReady <= '0';
                            wait_turns := uart_wait_turns;
                            r_RX_State <= t_RX_2;
                        else
                            r_RX_State <= t_RX_1;
                        end if;

                    when t_RX_2 =>
                        o_readDone <= '1';
                        r_RX_State <= t_RX_0;
                end case;
            end if;
        end if;
    end process;

    -- Send UART
    Send_Data : process(i_clock)
        variable wait_turns : integer range 0 to 31 := 0;
    begin
        if rising_edge(i_clock) then
            if wait_turns /= 0 then
                wait_turns := wait_turns - 1;
            else 
                io_sysBus_data <= (others => 'Z');
                case r_TX_State is
                    when t_TX_0 =>
                        o_wrn <= '1';
                        o_writeReady <= '1';
                        if i_writeBegin = '1' then
                            o_writeReady <= '0';
                            o_writeDone <= '0';
                            r_TX_State <= t_TX_1;
                        else
                            r_TX_State <= t_TX_0;
                        end if;

                    when t_TX_1 =>
                        io_sysBus_data <= i_data;
                        o_wrn <= '0';
                        wait_turns := uart_wait_turns;
                        r_TX_State <= t_TX_2;

                    when t_TX_2 =>
                        o_wrn <= '1';
                        o_writeDone <= '1';
                        wait_turns := uart_wait_turns;
                        r_TX_State <= t_TX_3;

                    when t_TX_3 =>
                        if i_tbre = '1' then
                            r_TX_State <= t_TX_4;
                        else
                            r_TX_State <= t_TX_3;
                        end if;
                    
                    when t_TX_4 =>
                        if i_tsre = '1' then
                            o_writeReady <= '1';
                            r_TX_State <= t_TX_0;
                        else
                            r_TX_State <= t_TX_4;
                        end if;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
