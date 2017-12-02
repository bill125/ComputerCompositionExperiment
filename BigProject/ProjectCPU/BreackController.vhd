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

entity BreackController is
    port (
        i_IH : in std_logic_vector(15 downto 0);
        i_PC_stalled : in std_logic;
        o_key : out std_logic_vector(7 downto 0);

		o_keyNDataReceive : out std_logic := '1';
		i_keyDataReady : in std_logic; 
		i_keyData : in std_logic_vector(7 downto 0);
		o_clockNDataReceive : out std_logic := '1';
		i_clockDataReady : in std_logic;
        o_breakEN : out std_logic := '0';
        o_breakPC : out word_t
    );
end BreackController;

architecture Behavioral of BreackController is
begin
    process (i_PC_stalled, i_IH, i_clockDataReady, i_keyDataReady)
    begin
        o_keyNDataReceive <= '1';
        o_clockNDataReceive <= '1';
        o_breakEN <= '0';
        if i_PC_stalled = '0' and i_IH(0) = '0' then -- can break
            if i_clockDataReady = '1' then
                o_clockNDataReceive <= '0';
                o_breakEN <= '1';
            elsif i_keyDataReady = '1' then
                o_keyNDataReceive <= '0';
                o_breakEN <= '1';
                o_key <= i_keyData;
            end if;
        end if;
    end process;
end Behavioral;

