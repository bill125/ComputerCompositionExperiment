----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:15 11/24/2017 
-- Design Name: 
-- Module Name:    StallClearController - Behavioral 
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
use work.op_type_constants;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity StallClearController is
    port (
        -- clear
        i_breakEN : in std_logic;
        i_breakPC : in addr_t;
        i_jumpTarget : in addr_t;
        i_predPC : in addr_t;
        i_predSucc : in std_logic;
        o_nextPC : out addr_t;
        o_clear : out std_logic_vector(0 to 4);
        
        -- stall
        i_wbAddr : in reg_addr_t;
        i_DMStallReq : in std_logic;
        i_IFStallReq : in std_logic;
        i_DMRE : in std_logic;
        i_OP0Addr : in reg_addr_t;
        i_OP1Addr : in reg_addr_t;
        o_stall : out std_logic_vector(0 to 4)
    );
end StallClearController;

architecture Behavioral of StallClearController is
    signal clear, stall : std_logic_vector(0 to 4) := "00000";
begin
    -- clear
    -- o_clear(0) <= '0';
    o_clear(1 to 4) <= clear(1 to 4) or ((not stall(1 to 4)) and stall(0 to 3)); -- clear when needing stall
    o_nextPC <= i_breakPC when i_breakEN = '1' else i_jumpTarget;
    clear(1) <= not i_predSucc;

    -- stall
    process (i_wbAddr, i_DMStallReq, i_IFStallReq, i_DMRE, i_OP0Addr, i_OP1Addr)
    begin
        if (i_DMStallReq = '1') then -- DM Stall request
            stall(stage_PC to stage_EX_MEM) <= (others => '1');
            stall(stage_MEM_WB) <= '0';
        elsif (i_DMRE = '1' and (i_OP0Addr = i_wbAddr or i_OP1Addr = i_wbAddr) -- Read register after LW
            and i_wbAddr /= ("1111")) then
            stall(stage_PC to stage_IF_ID) <= (others => '1');
            stall(stage_ID_EX to stage_MEM_WB) <= (others => '0');
        elsif (i_IFStallReq = '1') then -- IF stall request
            stall(stage_PC) <= '1';
            stall(stage_IF_ID to stage_MEM_WB) <= (others => '0');
        else -- No conflicts
            o_stall <= (others => '0');
        end if;
    end process;
    o_stall <= stall;

end Behavioral;

