----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:23:14 11/27/2017 
-- Design Name: 
-- Module Name:    CPUOverall - Behavioral 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPUOverall is
    port
    (
        i_clock : in std_logic;  -- high clock (100MHz?)
        i_nReset : in std_logic;
        i_sw   : in  STD_LOGIC_VECTOR (15 downto 0);
        -- o_clock : std_logic;  -- CPU clock

        o_Led : out word_t;
        o_Dig1 : out std_logic_vector(6 downto 0);
        o_Dig2 : out std_logic_vector(6 downto 0);

        -- i_sysBusRequest : in bus_request_t;   
        -- o_sysBusResponse : out bus_response_t; 
        -- i_IM_extBusRequest : in bus_request_t;
        -- o_IM_extBusResponse : out bus_response_t;
        -- i_DM_extBusRequest : in bus_request_t;
        -- o_DM_extBusResponse : out bus_response_t;

        -- SysBus Interface
        io_sysBus_data : inout word_t;
        o_sysBus_addr : out bus_addr_t;
        o_RAM1_nWE : out std_logic;
        o_RAM1_nOE : out std_logic;
        o_RAM1_nCE : out std_logic;

        -- ExtBus Interface
        io_extBus_data : inout word_t;
        o_extBus_addr : out bus_addr_t;
        o_RAM2_nWE : out std_logic;
        o_RAM2_nOE : out std_logic;
        o_RAM2_nCE : out std_logic;

        -- UART Interface
        i_UART_tbre         : in std_logic;
        i_UART_tsre         : in std_logic;
        o_UART_wrn          : out std_logic;
        i_UART_data_ready   : in std_logic;
        o_UART_rdn          : out std_logic

        -- TODO: VGA Interface

        -- TODO: PS/2 Interface
    );
end CPUOverall;

architecture Behavioral of CPUOverall is
    component CPUCore
        port
        (
            i_clock : std_logic; 
            i_nReset : std_logic;

            o_sysBusRequest : bus_request_t;  
            i_sysBusResponse : bus_response_t; 
            o_IM_extBusRequest : bus_request_t;  
            i_IM_extBusResponse : bus_response_t;
            o_DM_extBusRequest : bus_request_t;
            i_DM_extBusResponse : bus_response_t;
            o_TEST_word : out word_t;
            o_TEST_addr : out bus_addr_t;
            o_TEST_EN : out std_logic;
            o_registers : out Reg;
            o_PC_o_PC : out word_t;
            o_StallClearController_o_nextPC : out word_t;
            o_IM_o_inst : out inst_t;
            o_Dig1 : out std_logic_vector(6 downto 0);
            o_Dig2 : out std_logic_vector(6 downto 0)
        );
    end component;
    component SystemBusController 
        port
        (
            i_clock : in std_logic;

            i_busRequest : in bus_request_t;
            o_busResponse : out bus_response_t;
            
            i_UART_readReady : in std_logic;
            i_UART_readDone : in std_logic;
            i_UART_writeReady : in std_logic;
            i_UART_writeDone : in std_logic;
            i_UART_bus_EN : in std_logic;
            i_UART_bus_data : in word_t;
            o_UART_bus_data : out word_t;
            i_UART_data : in word_t;
            o_UART_data : out word_t;
            o_UART_readBegin : out std_logic;
            o_UART_writeBegin : out std_logic;

            o_nOE : out std_logic;
            o_nWE : out std_logic;
            o_nCE : out std_logic;
            o_bus_EN : out std_logic;
            i_bus_data : in word_t;
            o_bus_data : out word_t; 
            o_bus_addr : out bus_addr_t
        );
    end component;
    component ExtBusController 
        port 
        (
            i_clock : in std_logic;
    
            i_IM_busRequest : in bus_request_t;
            i_DM_busRequest : in bus_request_t;
            o_IM_busResponse : out bus_response_t;
            o_DM_busResponse : out bus_response_t;

            o_bus_en : out std_logic;
            i_bus_data : in word_t;
            o_bus_data : out word_t;
            o_bus_addr : out bus_addr_t;
            o_nCE : out std_logic;
            o_nOE : out std_logic;
            o_nWE : out std_logic
        );
    end component;
    component UART 
        port
        (
            i_clock        : in std_logic; -- fast clock

            i_bus_data  : in word_t;
            o_bus_data  : out word_t;
            o_bus_EN    : out std_logic;

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
    end component;

    signal CPUCore_sysBusRequest : bus_request_t;
    signal CPUCore_IM_extBusRequest : bus_request_t;
    signal CPUCore_DM_extBusRequest : bus_request_t;
	signal CPUCore_o_TEST_word : word_t;
    signal CPUCore_o_TEST_addr : bus_addr_t;
    signal CPUCore_o_TEST_EN : std_logic;
    signal CPUCore_o_registers : Reg;
    signal CPUCore_o_PC_o_PC : word_t;
    signal CPUCore_o_IM_o_inst : inst_t;
    signal CPUCore_o_i_StallClearController_o_nextPC : word_t;

    signal SystemBusController_busResponse : bus_response_t;
    signal SystemBusController_UART_bus_data : word_t;
    signal SystemBusController_UART_data : word_t;
    signal SystemBusController_UART_readBegin : std_logic;
    signal SystemBusController_UART_writeBegin : std_logic;
    signal SystemBusController_nOE : std_logic;
    signal SystemBusController_nWE : std_logic;
    signal SystemBusController_nCE : std_logic;
    signal SystemBusController_bus_EN : std_logic;
    signal SystemBusController_bus_data : word_t;
    signal SystemBusController_bus_addr : bus_addr_t;
    signal ExtBusController_IM_busResponse : bus_response_t;
    signal ExtBusController_DM_busResponse : bus_response_t;
    signal ExtBusController_bus_EN : std_logic;
    signal ExtBusController_bus_data : word_t;
    signal ExtBusController_bus_addr : bus_addr_t;
    signal ExtBusController_nCE : std_logic;
    signal ExtBusController_nOE : std_logic;
    signal ExtBusController_nWE : std_logic;
    signal UART_writeReady   : std_logic;
    signal UART_writeDone    : std_logic;
    signal UART_data         : word_t;
    signal UART_bus_data     : word_t;
    signal UART_bus_EN       : std_logic;
    signal UART_readReady    : std_logic;
    signal UART_readDone     : std_logic;
    signal UART_wrn          : std_logic;
    signal UART_rdn          : std_logic;
    signal clock_50m : std_logic;
    signal clock_25m : std_logic;

begin
    -- TODO: Add clock Frequency Divider
    clock_50m <= i_clock;
    clock_25m <= i_clock;
    process (i_sw)
    begin
        if i_sw(15 downto 4) = "100000000000" then
            o_Led <= CPUCore_o_registers(to_integer(unsigned(i_sw(3 downto 0))));
        elsif i_sw(15 downto 4) = "110000000000" then
            case i_sw(3 downto 0) is
                when "0000" => o_Led <= CPUCore_o_PC_o_PC;
                when "0001" => o_Led <= CPUCore_o_i_StallClearController_o_nextPC;
                when "0010" => o_Led <= CPUCore_o_IM_o_inst;
                when others => o_Led <= (others => '0');
            end case;
        else
            o_Led <= CPUCore_o_TEST_word; 
        end if;
    end process;

    CPUCore_inst: CPUCore port map (
        i_clock => not clock_50m,
        i_nReset => i_nReset,

        o_sysBusRequest => CPUCore_sysBusRequest,  
        i_sysBusResponse => SystemBusController_busResponse, 
        o_IM_extBusRequest => CPUCore_IM_extBusRequest,  
        i_IM_extBusResponse => ExtBusController_IM_busResponse,  
        o_DM_extBusRequest => CPUCore_DM_extBusRequest,
        i_DM_extBusResponse => ExtBusController_DM_busResponse,
		
        o_TEST_word => CPUCore_o_TEST_word,
		o_TEST_addr => CPUCore_o_TEST_addr,
        o_TEST_EN => CPUCore_o_TEST_EN,
        o_Dig1 => o_Dig1,
        o_Dig2 => o_Dig2,
        o_registers => CPUCore_o_registers,
        o_PC_o_PC => CPUCore_o_PC_o_PC,
        o_StallClearController_o_nextPC => CPUCore_o_i_StallClearController_o_nextPC,
        o_IM_o_inst => CPUCore_o_IM_o_inst
    );

    SystemBusController_inst: SystemBusController port map (
        i_clock => clock_50m,
        i_busRequest => CPUCore_sysBusRequest,
        o_busResponse => SystemBusController_busResponse,
        i_UART_readReady => UART_readReady,
        i_UART_readDone => UART_readDone,
        i_UART_writeReady => UART_writeReady,
        i_UART_writeDone => UART_writeDone,
        i_UART_bus_EN => UART_bus_EN,
        i_UART_bus_data => UART_bus_data,
        o_UART_bus_data => SystemBusController_UART_bus_data,
        i_UART_data => UART_data,
        o_UART_data => SystemBusController_UART_data,
        o_UART_readBegin => SystemBusController_UART_readBegin,
        o_UART_writeBegin => SystemBusController_UART_writeBegin,
        o_nOE => SystemBusController_nOE,
        o_nWE => SystemBusController_nWE,
        o_nCE => SystemBusController_nCE,
        o_bus_EN => SystemBusController_bus_EN,
        i_bus_data => io_sysBus_data,
        o_bus_data => SystemBusController_bus_data,
        o_bus_addr => SystemBusController_bus_addr
    );
    io_sysBus_data <= SystemBusController_bus_data when SystemBusController_bus_EN = '1' else
                      (others => 'Z');
    o_sysBus_addr <= SystemBusController_bus_addr;
    o_RAM1_nCE <= SystemBusController_nCE;
    o_RAM1_nWE <= SystemBusController_nWE;
    o_RAM1_nOE <= SystemBusController_nOE;

    ExtBusController_inst: ExtBusController port map (
        i_clock => clock_50m,
        i_IM_busRequest => CPUCore_IM_extBusRequest,
        i_DM_busRequest => CPUCore_DM_extBusRequest,
        o_IM_busResponse => ExtBusController_IM_busResponse,
        o_DM_busResponse => ExtBusController_DM_busResponse,
        i_bus_data => io_extBus_data,
        o_bus_data => ExtBusController_bus_data,
        o_bus_addr => ExtBusController_bus_addr,
        o_bus_EN => ExtBusController_bus_EN,
        o_nCE => ExtBusController_nCE,
        o_nOE => ExtBusController_nOE,
        o_nWE => ExtBusController_nWE
    );
    io_extBus_data <= ExtBusController_bus_data when ExtBusController_bus_EN = '1' else
                      (others => 'Z');
    o_extBus_addr <= ExtBusController_bus_addr;
    o_RAM2_nCE <= ExtBusController_nCE;
    o_RAM2_nWE <= ExtBusController_nWE;
    o_RAM2_nOE <= ExtBusController_nOE;

    UART_inst: UART port map (
        i_clock => clock_50m,
        i_bus_data => SystemBusController_UART_bus_data,
        o_bus_data => UART_bus_data,
        o_bus_EN => UART_bus_EN,
        i_data => SystemBusController_UART_data,
        i_writeBegin => SystemBusController_UART_writeBegin,
        o_writeReady => UART_writeReady,
        o_writeDone => UART_writeDone,
        o_data => UART_data,
        i_readBegin => SystemBusController_UART_readBegin,
        o_readReady => UART_readReady,
        o_readDone => UART_readDone,
        i_tbre => i_UART_tbre,
        i_tsre => i_UART_tsre,
        o_wrn => UART_wrn,
        i_data_ready => i_UART_data_ready,
        o_rdn => UART_rdn
    );
    o_UART_rdn <= UART_rdn;
    o_UART_wrn <= UART_wrn;

end;