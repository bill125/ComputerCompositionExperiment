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
        -- o_clock : std_logic;  -- CPU clock

        o_Led : out word_t;

        i_sysBusRequest : in bus_request_t;   
        o_sysBusResponse : out bus_response_t; 
        i_IM_extBusRequest : in bus_request_t;
        o_IM_extBusResponse : out bus_response_t;
        i_DM_extBusRequest : in bus_request_t;
        o_DM_extBusResponse : out bus_response_t;

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
            o_TEST_EN : out std_logic
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
            i_UART_data : in word_t;
            o_UART_data : out word_t;
            o_UART_readBegin : out std_logic;
            o_UART_writeBegin : out std_logic;
    
            o_nOE : out std_logic;
            o_nWE : out std_logic;
            o_nCE : out std_logic;
            io_bus_data : inout word_t;
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
    
            io_bus_data : inout word_t;
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
    end component;

    signal CPUCore_sysBusRequest : bus_request_t;
    signal CPUCore_IM_extBusRequest : bus_request_t;
    signal CPUCore_DM_extBusRequest : bus_request_t;
	signal CPUCore_o_TEST_word : word_t;
    signal CPUCore_o_TEST_addr : bus_addr_t;
    signal CPUCore_o_TEST_EN : std_logic;
    signal SystemBusController_busResponse : bus_response_t;
    signal SystemBusController_UART_data : word_t;
    signal SystemBusController_UART_readBegin : std_logic;
    signal SystemBusController_UART_writeBegin : std_logic;
    signal SystemBusController_nOE : std_logic;
    signal SystemBusController_nWE : std_logic;
    signal SystemBusController_nCE : std_logic;
    signal SystemBusController_bus_addr : bus_addr_t;
    signal ExtBusController_IM_busResponse : bus_response_t;
    signal ExtBusController_DM_busResponse : bus_response_t;
    signal ExtBusController_bus_addr : bus_addr_t;
    signal ExtBusController_nCE : std_logic;
    signal ExtBusController_nOE : std_logic;
    signal ExtBusController_nWE : std_logic;
    signal UART_writeReady   : std_logic;
    signal UART_writeDone    : std_logic;
    signal UART_data         : word_t;
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
    o_Led <= CPUCore_o_TEST_word;

    CPUCore_inst: CPUCore port map (
        i_clock => clock_50m,
        i_nReset => i_nReset,

        o_sysBusRequest => CPUCore_sysBusRequest,  
        i_sysBusResponse => SystemBusController_busResponse, 
        o_IM_extBusRequest => CPUCore_IM_extBusRequest,  
        i_IM_extBusResponse => ExtBusController_IM_busResponse,  
        o_DM_extBusRequest => CPUCore_DM_extBusRequest,
        i_DM_extBusResponse => ExtBusController_DM_busResponse,
		
        o_TEST_word => CPUCore_o_TEST_word,
		  o_TEST_addr => CPUCore_o_TEST_addr,
        o_TEST_EN => CPUCore_o_TEST_EN
    );

    SystemBusController_inst: SystemBusController port map (
        i_clock => clock_50m,
        i_busRequest => CPUCore_sysBusRequest,
        o_busResponse => SystemBusController_busResponse,
        i_UART_readReady => UART_readReady,
        i_UART_readDone => UART_readDone,
        i_UART_writeReady => UART_writeReady,
        i_UART_writeDone => UART_writeDone,
        i_UART_data => UART_data,
        o_UART_data => SystemBusController_UART_data,
        o_UART_readBegin => SystemBusController_UART_readBegin,
        o_UART_writeBegin => SystemBusController_UART_writeBegin,
        o_nOE => SystemBusController_nOE,
        o_nWE => SystemBusController_nWE,
        o_nCE => SystemBusController_nCE,
        io_bus_data => io_sysBus_data,
        o_bus_addr => SystemBusController_bus_addr
    );
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
        io_bus_data => io_extBus_data,
        o_bus_addr => ExtBusController_bus_addr,
        o_nCE => ExtBusController_nCE,
        o_nOE => ExtBusController_nOE,
        o_nWE => ExtBusController_nWE
    );
    o_extBus_addr <= ExtBusController_bus_addr;
    o_RAM2_nCE <= ExtBusController_nCE;
    o_RAM2_nWE <= ExtBusController_nWE;
    o_RAM2_nOE <= ExtBusController_nOE;

    UART_inst: UART port map (
        i_clock => clock_50m,
        io_sysBus_data => io_sysBus_data,
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