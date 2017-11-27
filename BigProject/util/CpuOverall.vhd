ARCHITECTURE behavior OF <name> IS
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

    signal SystemBusController_o_busResponse : bus_response_t;
    signal SystemBusController_o_UART_data : word_t;
    signal SystemBusController_o_UART_readBegin : std_logic;
    signal SystemBusController_o_UART_writeBegin : std_logic;
    signal SystemBusController_o_nOE : std_logic;
    signal SystemBusController_o_nWE : std_logic;
    signal SystemBusController_o_nCE : std_logic;
    signal SystemBusController_o_bus_addr : bus_addr_t;
    signal ExtBusController_o_IM_busResponse : bus_response_t;
    signal ExtBusController_o_DM_busResponse : bus_response_t;
    signal ExtBusController_o_bus_addr : bus_addr_t;
    signal ExtBusController_o_nCE : std_logic;
    signal ExtBusController_o_nOE : std_logic;
    signal ExtBusController_o_nWE : std_logic;
    signal UART_o_writeReady   : std_logic;
    signal UART_o_writeDone    : std_logic;
    signal UART_o_data         : word_t;
    signal UART_o_readReady    : std_logic;
    signal UART_o_readDone     : std_logic;
    signal UART_o_wrn          : std_logic;
    signal UART_o_rdn          : std_logic;

begin
    SystemBusController_inst: port map (
        i_clock => ,
        i_busRequest => ,
        o_busResponse => SystemBusController_o_busResponse,
        i_UART_readReady => ,
        i_UART_readDone => ,
        i_UART_writeReady => ,
        i_UART_writeDone => ,
        i_UART_data => ,
        o_UART_data => SystemBusController_o_UART_data,
        o_UART_readBegin => SystemBusController_o_UART_readBegin,
        o_UART_writeBegin => SystemBusController_o_UART_writeBegin,
        o_nOE => SystemBusController_o_nOE,
        o_nWE => SystemBusController_o_nWE,
        o_nCE => SystemBusController_o_nCE,
        io_bus_data => ,
        o_bus_addr => SystemBusController_o_bus_addr
    );
    ExtBusController_inst: port map (
        i_clock => ,
        i_IM_busRequest => ,
        i_DM_busRequest => ,
        o_IM_busResponse => ExtBusController_o_IM_busResponse,
        o_DM_busResponse => ExtBusController_o_DM_busResponse,
        io_bus_data => ,
        o_bus_addr => ExtBusController_o_bus_addr,
        o_nCE => ExtBusController_o_nCE,
        o_nOE => ExtBusController_o_nOE,
        o_nWE => ExtBusController_o_nWE
    );
    UART_inst: port map (
        i_clock => ,
        io_sysBus_data => ,
        i_data => ,
        i_writeBegin => ,
        o_writeReady => UART_o_writeReady,
        o_writeDone => UART_o_writeDone,
        o_data => UART_o_data,
        i_readBegin => ,
        o_readReady => UART_o_readReady,
        o_readDone => UART_o_readDone,
        i_tbre => ,
        i_tsre => ,
        o_wrn => UART_o_wrn,
        i_data_ready => ,
        o_rdn => UART_o_rdn
    );

end;