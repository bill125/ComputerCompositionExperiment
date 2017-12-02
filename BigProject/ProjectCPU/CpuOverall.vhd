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
        i_click : in std_logic;  -- high clock (0MHz?)
        i_nReset : in std_logic;
        i_sw   : in  STD_LOGIC_VECTOR (15 downto 0);
        -- o_clock : std_logic;  -- CPU clock

        o_Led : out word_t;
        o_Dig1 : out std_logic_vector(6 downto 0);
        o_Dig2 : out std_logic_vector(6 downto 0);

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
        o_UART_rdn          : out std_logic;

        -- VGA Interface
        o_VGA_hs : out std_logic;
        o_VGA_vs : out std_logic;
        o_VGA_r  : out std_logic_vector(2 downto 0);
        o_VGA_g  : out std_logic_vector(2 downto 0);
        o_VGA_b  : out std_logic_vector(2 downto 0);
        

        -- PS/2 Interface
        i_PS2_clock : in std_logic;
        i_PS2_data  : in std_logic
    );
end CPUOverall;

architecture Behavioral of CPUOverall is
    component seg7 is
        port(
            code: in std_logic_vector(3 downto 0);
            seg_out : out std_logic_vector(6 downto 0)
        );
    end component seg7;
    component FreqDiv is
        generic
        (
            div : integer := 50;
            half : integer := 25 
        );
        port
        (
            CLK: in std_logic;
            RST: in std_logic;
            O: out std_logic
        );
    end component FreqDiv;
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
            -- break
            o_keyNDataReceive : out std_logic;
            i_keyDataReady : in std_logic;
            i_keyData : in std_logic_vector(7 downto 0);
            o_clockNDataReceive : out std_logic;
            i_clockDataReady : in std_logic;

            o_TEST_word : out word_t;
            o_TEST_addr : out bus_addr_t;
            o_TEST_EN : out std_logic;
            o_registers : out Reg;
            o_PC_o_PC : out word_t;
            o_StallClearController_o_nextPC : out word_t;
            o_IM_o_inst : out inst_t;
            o_ForwardUnit_o_OP0 : out std_logic_vector(15 downto 0);
            o_ForwardUnit_o_OP1 : out std_logic_vector(15 downto 0);
            o_Control_o_DMRE : out std_logic;
            o_Control_o_DMWR : out std_logic;
            o_Decoder_o_OP0Addr : out std_logic_vector(3 downto 0);
            o_Decoder_o_OP0Data : out std_logic_vector(15 downto 0);
            o_Decoder_o_OP1Addr : out std_logic_vector(3 downto 0);
            o_Decoder_o_OP1Data : out std_logic_vector(15 downto 0);
            o_ImmExtend_o_immExtend : out std_logic_vector(15 downto 0);
            o_ALU_MUX_o_ALURes : out word_t;
            o_DM_o_DMRes : out word_t;
            o_MEM_WB_o_wbAddr : out reg_addr_t;
            o_MEM_WB_o_wbData : out word_t;
            o_EX_MEM_o_ALURes : out word_t;
            o_EX_MEM_o_DMRE : out std_logic;
            o_EX_MEM_o_DMWR : out std_logic;
            o_EX_MEM_o_addr : out word_t;
            o_EX_MEM_o_data : out word_t;
            o_ID_EX_o_DMRE : out std_logic;
            o_ID_EX_o_DMWR : out std_logic;
            o_ID_EX_o_OP : out op_t;
            o_ID_EX_o_OP0 : out word_t;
            o_ID_EX_o_OP1 : out word_t;
            o_ID_EX_o_OP0Src : out opSrc_t;
            o_ID_EX_o_OP1Src : out opSrc_t;
            o_ID_EX_o_imm : out word_t;
            o_ID_EX_o_wbAddr : out reg_addr_t
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
            o_rdn          : out std_logic;

            o_read_state   : out std_logic_vector(1 downto 0);
            o_write_state   : out std_logic_vector(2 downto 0)
        );
    end component;
    component Keyboard
    	port (
            PS2Data : in std_logic; -- PS2 data
            PS2Clock : in std_logic; -- PS2 clk
            Clock : in std_logic;
            Reset : in std_logic;
            DataReceive : in std_logic;
            DataReady : out std_logic ;  -- data output enable signal
            Output : out std_logic_vector(7 downto 0) -- scan code signal output
        );
    end component;
    component ClockBreak is
    port (
        i_clock : in std_logic;
		i_nReceive : in std_logic;
		o_dataReady : out std_logic := '0'
    );
    end component;
    component VGA
        port 
        (
            i_busResponse : in bus_response_t;
            o_busRequest : out bus_request_t;
            
            i_clock : in std_logic;
            o_hs : out std_logic;
            o_vs : out std_logic;
            o_r : out std_logic_vector(2 downto 0);
            o_g : out std_logic_vector(2 downto 0);
            o_b : out std_logic_vector(2 downto 0);
            o_read_EN : out std_logic;
            i_EN : in std_logic
        );
    end component;
    component BusArbiter  -- 1 > 0
        port
        (
            i_busRequest_0 : in bus_request_t; 
            i_busRequest_1 : in bus_request_t; 
            o_busResponse_0 : out bus_response_t;
            o_busResponse_1 : out bus_response_t;

            o_busRequest : out bus_request_t;
            i_busResponse : in bus_response_t
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
    signal CPUCore_o_ForwardUnit_o_OP0 : std_logic_vector(15 downto 0);
    signal CPUCore_o_ForwardUnit_o_OP1 : std_logic_vector(15 downto 0);
    signal CPUCore_o_Control_o_DMRE : std_logic;
    signal CPUCore_o_Control_o_DMWR : std_logic;
    signal CPUCore_o_Decoder_o_OP0Addr : std_logic_vector(3 downto 0);
    signal CPUCore_o_Decoder_o_OP0Data : std_logic_vector(15 downto 0);
    signal CPUCore_o_Decoder_o_OP1Addr : std_logic_vector(3 downto 0);
    signal CPUCore_o_Decoder_o_OP1Data : std_logic_vector(15 downto 0);
    signal CPUCore_o_ImmExtend_o_immExtend : std_logic_vector(15 downto 0);
    signal CPUCore_o_ALU_MUX_o_ALURes : word_t;
    signal CPUCore_o_DM_o_DMRes : word_t;
    signal CPUCore_o_MEM_WB_o_wbAddr : reg_addr_t;
    signal CPUCore_o_MEM_WB_o_wbData : word_t;
    signal CPUCore_o_EX_MEM_o_ALURes : word_t;
    signal CPUCore_o_EX_MEM_o_DMRE : std_logic;
    signal CPUCore_o_EX_MEM_o_DMWR : std_logic;
    signal CPUCore_o_EX_MEM_o_addr : word_t;
    signal CPUCore_o_EX_MEM_o_data : word_t;
    signal CPUCore_o_ID_EX_o_DMRE : std_logic;
    signal CPUCore_o_ID_EX_o_DMWR : std_logic;
    signal CPUCore_o_ID_EX_o_OP : op_t;
    signal CPUCore_o_ID_EX_o_OP0 : word_t;
    signal CPUCore_o_ID_EX_o_OP1 : word_t;
    signal CPUCore_o_ID_EX_o_OP0Src : opSrc_t;
    signal CPUCore_o_ID_EX_o_OP1Src : opSrc_t;
    signal CPUCore_o_ID_EX_o_imm : word_t;
    signal CPUCore_o_ID_EX_o_wbAddr : reg_addr_t;
    signal CPUCore_o_keyNDataReceive : std_logic;
    signal CPUCore_o_clockNDataReceive : std_logic;

    signal BusArbiter_busResponse_0 : bus_response_t;
    signal BusArbiter_busResponse_1 : bus_response_t;
    signal BusArbiter_busRequest : bus_request_t;
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
    signal UART_read_state   : std_logic_vector(1 downto 0);
    signal UART_write_state   : std_logic_vector(2 downto 0);
    signal Keyboard_DataReady : std_logic;
    signal Keyboard_Output : std_logic_vector(7 downto 0);
    signal ClockBreak_o_dataReady : std_logic;
    signal VGA_busRequest : bus_request_t;
    signal VGA_hs : std_logic;
    signal VGA_vs : std_logic;
    signal VGA_r : std_logic_vector(2 downto 0);
    signal VGA_b : std_logic_vector(2 downto 0);
    signal VGA_g : std_logic_vector(2 downto 0);
    signal VGA_o_read_EN : std_logic;
    signal clock : std_logic;
    signal clock_50m : std_logic;
    signal clock_25m : std_logic;
    signal clock_12m : std_logic;
    -- debug
    signal led : word_t;

begin
    -- TODO: Add clock Frequency Divider
    Seg7_Inst1 : Seg7
    port map
    (
        code => led(7 downto 4),
        seg_out => o_Dig1
    );
    Seg7_Inst2 : Seg7
    port map
    (
        code => led(3 downto 0),
        seg_out => o_Dig2
    );
    clock_50m <= i_clock;
    FD_Inst : FreqDiv
    generic map
    (
        div => 2,
        half => 1
    )
    port map
    (
        CLK => i_clock,
        RST => '0', 
        O => clock_25m
    );
    FD_Inst2 : FreqDiv
    generic map
    (
        div => 4,
        half => 2
    )
    port map
    (
        CLK => i_clock,
        RST => '0', 
        O => clock_12m
    );

    clock <= clock_50m when i_sw(15 downto 14) = "00" else
             clock_25m when i_sw(15 downto 14) = "01" else
             clock_12m when i_sw(15 downto 14) = "10" else 
             not i_click;

    process (i_sw)
    begin
        if i_sw(12 downto 4) = "100000000" then
            led <= CPUCore_o_registers(to_integer(unsigned(i_sw(3 downto 0))));
        elsif i_sw(12 downto 4) = "110000000" then
            case i_sw(3 downto 0) is
                when "0000" => led <= CPUCore_o_PC_o_PC;
                when "0001" => led <= CPUCore_o_i_StallClearController_o_nextPC;
                when "0010" => led <= CPUCore_o_IM_o_inst;
                when others => led <= (others => '1');
            end case;
        elsif i_sw(12 downto 4) = "111000000" then
            case i_sw(3 downto 0) is
                when "0000" => led <= CPUCore_o_ForwardUnit_o_OP0 ;
                when "0001" => led <= CPUCore_o_ForwardUnit_o_OP1 ;
                when "0010" => led <= UART_read_state &
                    i_UART_tbre & i_UART_tsre & i_UART_data_ready & 
                    UART_readReady & UART_readDone & 
                    UART_writeReady & UART_writeDone & 
                    UART_wrn & UART_rdn & 
                    UART_bus_EN & ExtBusController_bus_EN & 
                    SystemBusController_bus_EN & CPUCore_o_Control_o_DMRE & CPUCore_o_Control_o_DMWR ;
                when "0011" => led <= UART_data;
                when "0100" => led <= UART_bus_data;
                when "0101" => led <= "000000000000" & CPUCore_o_Decoder_o_OP0Addr ;
                when "0110" => led <= CPUCore_o_Decoder_o_OP0Data ;
                when "0111" => led <= "000000000000" & CPUCore_o_Decoder_o_OP1Addr ;
                when "1000" => led <= CPUCore_o_Decoder_o_OP1Data ;
                when "1001" => led <= CPUCore_o_ImmExtend_o_immExtend ;
                when "1010" => led <= CPUCore_o_ALU_MUX_o_ALURes;
                when "1011" => led <= CPUCore_o_DM_o_DMRes;
                when "1100" => led <= "000000000000" & CPUCore_o_MEM_WB_o_wbAddr;
                when "1101" => led <= CPUCore_o_MEM_WB_o_wbData;
                when others => led <= (others => '1') ;
            end case;
        elsif i_sw(12 downto 4) = "111100000" then
            case i_sw(3 downto 0) is
                when "0000" => led <= CPUCore_o_EX_MEM_o_ALURes;
                when "0010" => led <= UART_write_state & "000000000" & CPUCore_o_ID_EX_o_DMRE & CPUCore_o_ID_EX_o_DMWR & CPUCore_o_EX_MEM_o_DMRE & CPUCore_o_EX_MEM_o_DMWR;
                when "0011" => led <= CPUCore_o_EX_MEM_o_addr;
                when "0100" => led <= CPUCore_o_EX_MEM_o_data;
                when "1000" => led <= CPUCore_o_ID_EX_o_OP0;
                when "1001" => led <= CPUCore_o_ID_EX_o_OP1;
                when "1100" => led <= CPUCore_o_ID_EX_o_imm;
                when "1101" => led <= "000000000000" & CPUCore_o_ID_EX_o_wbAddr;
                when others => led <= (others => '1');
            end case;
        elsif i_sw(12 downto 4) = "111110000" then
            led <= "0000" & VGA_hs & VGA_vs & VGA_r & VGA_g & VGA_b & VGA_o_read_EN;
        else
            led <= CPUCore_o_TEST_word; 
        end if;
    end process;
    o_Led <= led;

    CPUCore_inst: CPUCore port map (
        i_clock => clock,
        i_nReset => i_nReset,

        o_sysBusRequest => CPUCore_sysBusRequest,  
        i_sysBusResponse => BusArbiter_busResponse_0, 
        o_IM_extBusRequest => CPUCore_IM_extBusRequest,  
        i_IM_extBusResponse => ExtBusController_IM_busResponse,  
        o_DM_extBusRequest => CPUCore_DM_extBusRequest,
        i_DM_extBusResponse => ExtBusController_DM_busResponse,

        -- break
        o_keyNDataReceive => CPUCore_o_keyNDataReceive,
        i_keyDataReady => Keyboard_DataReady,
        i_keyData => Keyboard_Output,
        o_clockNDataReceive => CPUCore_o_clockNDataReceive,
        i_clockDataReady => ClockBreak_o_dataReady,
        
		
        o_TEST_word => CPUCore_o_TEST_word,
		o_TEST_addr => CPUCore_o_TEST_addr,
        o_TEST_EN => CPUCore_o_TEST_EN,
        o_registers => CPUCore_o_registers,
        o_PC_o_PC => CPUCore_o_PC_o_PC,
        o_StallClearController_o_nextPC => CPUCore_o_i_StallClearController_o_nextPC,
        o_IM_o_inst => CPUCore_o_IM_o_inst,
        o_ForwardUnit_o_OP0 => CPUCore_o_ForwardUnit_o_OP0,
        o_ForwardUnit_o_OP1 => CPUCore_o_ForwardUnit_o_OP1,
        o_Control_o_DMRE => CPUCore_o_Control_o_DMRE,
        o_Control_o_DMWR => CPUCore_o_Control_o_DMWR,
        o_Decoder_o_OP0Addr => CPUCore_o_Decoder_o_OP0Addr,
        o_Decoder_o_OP0Data => CPUCore_o_Decoder_o_OP0Data,
        o_Decoder_o_OP1Addr => CPUCore_o_Decoder_o_OP1Addr,
        o_Decoder_o_OP1Data => CPUCore_o_Decoder_o_OP1Data,
        o_ImmExtend_o_immExtend => CPUCore_o_ImmExtend_o_immExtend,
        o_ALU_MUX_o_ALURes => CPUCore_o_ALU_MUX_o_ALURes,
        o_DM_o_DMRes => CPUCore_o_DM_o_DMRes,
        o_MEM_WB_o_wbAddr => CPUCore_o_MEM_WB_o_wbAddr,
        o_MEM_WB_o_wbData => CPUCore_o_MEM_WB_o_wbData,
        o_EX_MEM_o_ALURes => CPUCore_o_EX_MEM_o_ALURes,
        o_EX_MEM_o_DMRE => CPUCore_o_EX_MEM_o_DMRE,
        o_EX_MEM_o_DMWR => CPUCore_o_EX_MEM_o_DMWR,
        o_EX_MEM_o_addr => CPUCore_o_EX_MEM_o_addr,
        o_EX_MEM_o_data => CPUCore_o_EX_MEM_o_data,
        o_ID_EX_o_DMRE => CPUCore_o_ID_EX_o_DMRE,
        o_ID_EX_o_DMWR => CPUCore_o_ID_EX_o_DMWR,
        o_ID_EX_o_OP => CPUCore_o_ID_EX_o_OP,
        o_ID_EX_o_OP0 => CPUCore_o_ID_EX_o_OP0,
        o_ID_EX_o_OP1 => CPUCore_o_ID_EX_o_OP1,
        o_ID_EX_o_OP0Src => CPUCore_o_ID_EX_o_OP0Src,
        o_ID_EX_o_OP1Src => CPUCore_o_ID_EX_o_OP1Src,
        o_ID_EX_o_imm => CPUCore_o_ID_EX_o_imm,
        o_ID_EX_o_wbAddr => CPUCore_o_ID_EX_o_wbAddr
    );

    BusArbiter_inst: BusArbiter port map (
        i_busRequest_0 => CPUCore_sysBusRequest,
        i_busRequest_1 => VGA_busRequest, 
        o_busResponse_0 => BusArbiter_busResponse_0,
        o_busResponse_1 => BusArbiter_busResponse_1,
        o_busRequest => BusArbiter_busRequest,
        i_busResponse => SystemBusController_busResponse
    );

    VGA_inst: VGA port map (
        i_busResponse => BusArbiter_busResponse_1,
        o_busRequest => VGA_busRequest,
        i_clock => clock,
        o_hs => VGA_hs,
        o_vs => VGA_vs,
        o_r => VGA_r,
        o_g => VGA_g,
        o_b => VGA_b,
        o_read_EN => VGA_o_read_EN,
        i_EN => i_sw(13)
    );
    o_VGA_hs <= VGA_hs;
    o_VGA_vs <= VGA_vs;
    o_VGA_r <= VGA_r;
    o_VGA_g <= VGA_g;
    o_VGA_b <= VGA_b;

    SystemBusController_inst: SystemBusController port map (
        i_clock => clock,
        i_busRequest => BusArbiter_busRequest,
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
        i_clock => clock,
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
        i_clock => clock,
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
        o_rdn => UART_rdn,
        o_read_state => UART_read_state,
        o_write_state => UART_write_state--  : out std_logic_vector(1 downto 0)
    );
    o_UART_rdn <= UART_rdn;
    o_UART_wrn <= UART_wrn;

    Keyboard_inst: Keyboard port map (
        PS2Data => i_PS2_data,
        PS2Clock => i_PS2_clock,
        Clock => clock_50m,
        Reset => not i_nReset,
        DataReady => Keyboard_DataReady,  -- data output enable signal
        DataReceive => CPUCore_o_keyNDataReceive,
        Output => Keyboard_Output
    );
    ClockBreak_inst: ClockBreak port map (
        i_clock => clock,
        i_nReceive => CPUCore_o_clockNDataReceive,
        o_dataReady => ClockBreak_o_dataReady
    );

end;