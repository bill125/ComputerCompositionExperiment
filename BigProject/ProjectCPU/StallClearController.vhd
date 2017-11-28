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
        i_nReset : in std_logic;
        -- clear
        i_breakEN : in std_logic;
        i_breakPC : in addr_t;
        i_jumpTarget : in addr_t;
        i_predPC : in addr_t;
        i_predSucc : in std_logic;
        o_nextPC : out addr_t := (others => '0');
        o_clear : out std_logic_vector(0 to 4) := (others => '0');
        
        -- stall
        i_wbAddr : in reg_addr_t;
        i_DMStallReq : in std_logic;
        i_IFStallReq : in std_logic;
        i_DMRE : in std_logic;
        i_OP0Addr : in reg_addr_t;
        i_OP1Addr : in reg_addr_t;
        o_stall : out std_logic_vector(0 to 4) := (others => '0')
    );
end StallClearController;

architecture Behavioral of StallClearController is
    signal clear, stall, EX_MEM_stall, IF_ID_stall, PC_stall : std_logic_vector(0 to 4) := "00000";
begin
    -- clear
    o_clear(0) <= clear(0);
    o_clear(1 to 4) <= clear(1 to 4) or ((not stall(1 to 4)) and stall(0 to 3)); -- clear when needing stall
    o_nextPC <= i_breakPC when i_breakEN = '1' else 
                i_predPC when i_predSucc = '1' else
                i_jumpTarget;
    clear(1) <= ((not i_nReset) or (not i_predSucc));
    clear(0) <= not i_nReset;
    clear(2 to 4) <= (others => not i_nReset);

    -- stall
    PC_stall     <= (0 to stage_PC     => '1', others => '0')  -- IF stall request
        when i_IFStallReq = '1' else (others => '0'); 

    IF_ID_stall  <= (0 to stage_IF_ID  => '1', others => '0')  -- Read register after LW
        when (i_DMRE = '1' and (i_OP0Addr = i_wbAddr or i_OP1Addr = i_wbAddr) and i_wbAddr /= ("1111")) else (others => '0');

    EX_MEM_stall <= (0 to stage_EX_MEM => '1', others => '0')  -- DM Stall request
        when i_DMStallReq = '1' else (others => '0');

    stall <= PC_stall or IF_ID_stall or EX_MEM_stall;
    o_stall <= PC_stall or IF_ID_stall or EX_MEM_stall;

end Behavioral;

