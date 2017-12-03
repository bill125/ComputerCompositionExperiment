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

entity BreakController is
    port (
        i_IH : in std_logic_vector(15 downto 0);
        i_clock : in std_logic;
        i_IF_FD_PC : in word_t;
        -- i_PC_stalled : in std_logic;
        o_key : out std_logic_vector(7 downto 0);

		o_keyNDataReceive : out std_logic := '1';
		i_keyDataReady : in std_logic; 
		i_keyData : in std_logic_vector(7 downto 0);
		o_clockNDataReceive : out std_logic := '1';
		i_clockDataReady : in std_logic;
        o_breakEN : out std_logic := '0';
        o_breakPC : out word_t;
        o_EPC : out word_t
    );
end BreakController;

architecture Behavioral of BreakController is
    signal wait_turns : std_logic_vector(3 downto 0) := "0000";
begin
    process (i_IH, i_clockDataReady, i_keyDataReady, wait_turns, i_keyData)
    begin
        if wait_turns = "0000" then
            o_keyNDataReceive <= '1';
            o_clockNDataReceive <= '1';
        else
            o_keyNDataReceive <= '0';
            o_clockNDataReceive <= '0';
        end if;
        o_breakEN <= '0';
        if i_IH(0) = '0' then -- can break
            if i_clockDataReady = '1' then
                o_clockNDataReceive <= '0';
                o_breakEN <= '1';
                o_breakPC <= clock_break_PC;
            elsif i_keyDataReady = '1' then
                o_keyNDataReceive <= '0';
                o_breakEN <= '1';
                o_breakPC <= key_break_PC;
                o_key <= i_keyData;
            end if;
        end if;
    end process;

    process (i_clock)
    begin
        if rising_edge(i_clock) then
            if wait_turns /= "0000" then
                wait_turns <= wait_turns - 1;
            elsif i_IH(0) = '0' and (i_clockDataReady = '1' or i_keyDataReady = '1') then
                wait_turns <= break_wait_turns;
                o_EPC <= i_IF_FD_PC;
            end if;
        end if;
    end process;

end Behavioral;

