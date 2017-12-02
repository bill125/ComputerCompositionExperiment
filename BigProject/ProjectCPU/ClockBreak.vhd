library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;
use work.inst_const;
use ieee.numeric_std.to_integer;
use ieee.numeric_std.unsigned;
use work.op_type_constants;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockBreak is
    port (
        i_clock : in std_logic;
		i_nReceive : in std_logic;
		o_dataReady : out std_logic := '0'
    );
end ClockBreak;

architecture Behavioral of ClockBreak is
    type type_RX_State is (t_RX_0, t_RX_1, t_RX_2);
    signal r_RX_State : type_RX_State := t_RX_0;
begin
    process (i_clock)
        variable wait_turns : integer range 0 to fps := 0;
    begin
        if rising_edge(i_clock) then
            if wait_turns /= 0 then
                wait_turns := wait_turns - 1;
            else
                case r_RX_State is
                    when t_RX_0 => -- counting
                        wait_turns := fps;
                        r_RX_State <= t_RX_1;
                    when t_RX_1 => -- data ready
                        o_dataReady <= '1';
                        r_RX_State <= t_RX_2;
                    when t_RX_2 => -- wait
                        if i_nReceive = '0' then
                            o_dataReady <= '0';
                            r_RX_State <= t_RX_0;
                        end if;
                    when others => 
                        r_RX_State <= t_RX_0;
                end case;
            end if;
        end if;
    end process;
end Behavioral;

