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

        i_bus_data     : in word_t;
        o_bus_data     : out word_t;
        o_bus_EN       : out std_logic;

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
        o_wrn          : out std_logic := '1';
        i_data_ready   : in std_logic;
        o_rdn          : out std_logic := '1';

        o_read_state   : out std_logic_vector(1 downto 0);
        o_write_state   : out std_logic_vector(2 downto 0)
    );
end UART;

architecture Behavioral of UART is
    type type_RX_State is (t_RX_0, t_RX_1, t_RX_2, t_RX_3);
    type type_TX_State is (t_TX_0, t_TX_1, t_TX_2, t_TX_3, t_TX_4);
    signal r_RX_State : type_RX_State := t_RX_0;
    signal r_TX_State : type_TX_State := t_TX_0;
begin

    o_read_state <= "00" when r_RX_State = t_RX_0 else
                    "01" when r_RX_State = t_RX_1 else
                    "10" when r_RX_State = t_RX_2 else
                    "11" when r_RX_State = t_RX_3 else
                    "00";

    o_write_state <= "000" when r_TX_State = t_TX_0 else
                    "001" when r_TX_State = t_TX_1 else
                    "010" when r_TX_State = t_TX_2 else
                    "011" when r_TX_State = t_TX_3 else
                    "100" when r_TX_State = t_TX_4 else
                    "101";

    
    o_data <= i_bus_data;

    -- Read UART
    Receive_Data : process(i_clock)
        variable wait_turns : integer range 0 to 63 := 0;
    begin
        if rising_edge(i_clock) then
            if wait_turns /= 0 then
                wait_turns := wait_turns - 1;
            else
                case r_RX_State is
                    when t_RX_0 => -- wait for data
                        o_readDone <= '0';
                        o_rdn <= '1';
                        o_readReady <= '0';
                        if i_data_ready = '1' then
                            r_RX_State <= t_RX_1;
                        else
                            r_RX_State <= t_RX_0;
                        end if;

                    when t_RX_1 => -- receive data
                        o_readReady <= '1';
                        o_readDone <= '0';
                        if i_readBegin = '1' then
                            o_rdn <= '0';
                            o_readReady <= '0';
                            wait_turns := uart_wait_turns;
                            r_RX_State <= t_RX_2;
                        else
                            r_RX_State <= t_RX_1;
                        end if;

                    when t_RX_2 =>
                        r_RX_State <= t_RX_3;

                    when t_RX_3 =>
                        o_rdn <= '1';
                        o_readDone <= '1';
                        wait_turns := uart_wait_turns;
                        r_RX_State <= t_RX_0;

                    when others =>
                        r_RX_State <= t_RX_0;
                end case;
            end if;
        end if;
    end process;

    -- Send UART
    o_bus_data <= i_data;
    Send_Data : process(i_clock)
        variable wait_turns : integer range 0 to 63 := 0;
    begin
        if rising_edge(i_clock) then
            if wait_turns /= 0 then
                wait_turns := wait_turns - 1;
            else 
                case r_TX_State is
                    when t_TX_0 =>
                        o_bus_EN <= '0';
                        o_wrn <= '1';
                        o_writeDone <= '0';
                        o_writeReady <= '1';
                        if i_writeBegin = '1' then
                            r_TX_State <= t_TX_1;
                        else
                            r_TX_State <= t_TX_0;
                        end if;

                    when t_TX_1 =>
                        o_writeReady <= '0';
                        o_bus_EN <= '1';
                        o_wrn <= '0';
                        wait_turns := uart_wait_turns;
                        r_TX_State <= t_TX_2;

                    when t_TX_2 =>
                        o_wrn <= '1';
                        wait_turns := uart_wait_turns;
                        r_TX_State <= t_TX_3;

                    when t_TX_3 =>
                        if i_tbre = '1' then
                            r_TX_State <= t_TX_4;
                        else
                            r_TX_State <= t_TX_3;
                        end if;
                    
                    when t_TX_4 =>   
                        o_writeDone <= '1';
                        o_bus_EN <= '0';
                        if i_tsre = '1' then
                            r_TX_State <= t_TX_0;
					    else
                            r_TX_State <= t_TX_4;
                        end if;
                    when others =>
                        r_TX_State <= t_TX_0;
                        o_bus_EN <= '0';
                        o_wrn <= '1';
                        o_writeReady <= '1';
                        o_writeDone <= '0';
                end case;
            end if;
        end if;
    end process;

end Behavioral;

