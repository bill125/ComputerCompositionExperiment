ARCHITECTURE behavior OF <name> IS
    component PC 
    	port (
            i_clock : in std_logic;
    		i_stall : in std_logic;
    		i_nextPC : in std_logic_vector(15 downto 0);
    		o_PC : out std_logic_vector(15 downto 0)
    	);
    end component;
    component IM 
        port
        (
            i_PC           : in addr_t;
            o_inst         : out inst_t;
    
            i_busResponse  : in bus_response_t;
            o_busRequest   : out bus_request_t;
    
            o_stallRequest : out std_logic
        );   
    end component;
    component IF_ID 
        port (
            i_clock : in std_logic;
            i_inst : in word_t;
            i_PC : in addr_t;
            i_stall : in std_logic;
            i_clear : in std_logic;
            o_PC : out addr_t;
            o_inst : out word_t;
            o_rxAddr : out std_logic_vector(3 downto 0);
            o_ryAddr : out std_logic_vector(3 downto 0);
            o_rzAddr : out std_logic_vector(3 downto 0)
        );
    end component;
    component myRegter is
    	Port (
            i_rxAddr : in std_logic_vector(2 downto 0);
            i_ryAddr : in std_logic_vector(2 downto 0);
            i_wbData : in std_logic_vector(15 downto 0);
            i_wbAddr : in std_logic_vector(3 downto 0); 
            o_rxData : out std_logic_vector(15 downto 0);
            o_ryData : out std_logic_vector(15 downto 0);
            o_T : out std_logic_vector(15 downto 0);
            o_SP : out std_logic_vector(15 downto 0);
            o_IH : out std_logic_vector(15 downto 0)
    	);
    end component;
    component ImmExtend 
        port (
            i_inst : in  std_logic_vector (15 downto 0);
            o_immExtend : out std_logic_vector (15 downto 0)
        );
    end ImmExtend component;
    component Control 
        Port(
            i_inst : in inst_t;
            o_ALUOP : out alu_op_t;
            o_OP0Type : out std_logic_vector (2 downto 0);
            o_OP1Type : out std_logic_vector (2 downto 0);
            o_wbType : out std_logic_vector (2 downto 0);
            o_OP0Src : out opSrc_t;
            o_OP1Src : out opSrc_t;
            o_DMRE : out std_logic;
            o_DMWR : out std_logic;
            o_OP : out op_t
        );
    end component;
    component Decoder 
    	port (
            i_OP0Type : in std_logic_vector(2 downto 0);
            i_OP1Type : in std_logic_vector(2 downto 0);
            i_wbType : in std_logic_vector(2 downto 0);
            i_rxAddr : in std_logic_vector(3 downto 0);
            i_rxData : in std_logic_vector(15 downto 0);
            i_ryAddr : in std_logic_vector(3 downto 0);
            i_ryData : in std_logic_vector(15 downto 0);
            i_rzAddr : in std_logic_vector(3 downto 0);
            i_IH : in std_logic_vector(15 downto 0);
            i_SP : in std_logic_vector(15 downto 0);
            i_PC : in std_logic_vector(15 downto 0);
            i_T : in std_logic_vector(15 downto 0);
    
            o_OP0Addr : out std_logic_vector(3 downto 0);
            o_OP0Data : out std_logic_vector(15 downto 0);
            o_OP1Addr : out std_logic_vector(3 downto 0);
            o_OP1Data : out std_logic_vector(15 downto 0);
            o_wbAddr : out std_logic_vector(3 downto 0)
        );
    end component;
    component ForwardUnit 
    	port(
            i_OP0Data : in std_logic_vector(15 downto 0);
            i_OP1Data : in std_logic_vector(15 downto 0);
            i_OP0Addr : in std_logic_vector(3 downto 0);
            i_OP1Addr : in std_logic_vector(3 downto 0);
    
            i_ALU1Res : in std_logic_vector(15 downto 0);
            i_ALU1Addr : in std_logic_vector(3 downto 0);
            i_ALU2Res : in std_logic_vector(15 downto 0);
            i_ALU2Addr : in std_logic_vector(3 downto 0);
            i_DMRes : in std_logic_vector(15 downto 0);
            i_DMAddr : in std_logic_vector(3 downto 0);
            
            o_OP0 : out std_logic_vector(15 downto 0);
            o_OP1 : out std_logic_vector(15 downto 0)
        );
    end component;
    component JumpAndBranch 
        port (
            i_OP0 : in word_t; -- T or rx
            i_OP1 : in word_t; -- PC
            i_imm : in word_t;
            i_OP : in op_t;
    
            o_jumpEN : out std_logic;
            o_jumpTarget : out word_t
        );
    end component;
    component ID_EX 
        port (
            i_clock : in std_logic;
            i_ALUOP : in alu_op_t;
            i_DMRE : in std_logic;
            i_DMWR : in std_logic;
            i_OP : in op_t;
            i_OP0 : in word_t;
            i_OP1 : in word_t;
            i_clear : in std_logic;
            i_imm : in word_t;
            i_stall : in std_logic;
            i_wbAddr : in reg_addr_t;
    
            o_ALUOP : out alu_op_t;
            o_DMRE : out std_logic;
            o_DMWR : out std_logic;
            o_OP : out op_t;
            o_OP0 : out word_t;
            o_OP1 : out word_t;
            o_imm : out word_t;
            o_wbAddr : out reg_addr_t
        );
    end component;
    component ALU_MUX 
        Port(
            i_ALURes : in word_t;
            i_OP0 : in word_t;
            i_OP1 : in word_t;
            i_OP : in op_t;
            o_addr : out addr_t;
            o_data : out word_t;
            o_ALURes : out word_t
        );
    end component;
    component ALU 
        Port(
            i_OP0 : in word_t;
            i_OP1 : in word_t;
            i_imm : in word_t;
            i_OP0Src : in opSrc_t;
            i_OP1Src : in opSrc_t;
            i_ALUOP : in alu_op_t;
            o_ALURes : out word_t
        );
    end component;
    component EX_MEM 
        port (
            i_clock : in std_logic;
            i_ALURes : in word_t;
            i_DMRE : in std_logic;
            i_DMWR : in std_logic;
            -- i_OP1 : in std_logic;
            i_addr : in word_t;
            i_clear : in std_logic;
            i_data : in word_t;
            i_stall : in std_logic;
            i_wbAddr : in reg_addr_t;
    
            o_ALURes : out word_t;
            o_DMRE : out std_logic;
            o_DMWR : out std_logic;
            o_addr : out word_t;
            o_data : out word_t;
            o_wbAddr : out reg_addr_t
        );
    end component;
    component DM 
        port 
        (
            i_data         : in word_t;
            i_addr         : in addr_t;
            i_ALURes       : in word_t;
            o_DMRes        : out word_t;
            o_wbData       : out word_t;
    
            i_DMRE         : in std_logic;
            i_DMWR         : in std_logic;
            o_stallRequest : out std_logic;
    
            o_busRequest   : out bus_request_t;
            i_busResponse  : in bus_response_t        
        );
    end component;
    component MEM_WB 
        port (
            i_clock : in std_logic;
            i_clear : in std_logic;
            i_stall : in std_logic;
            i_wbAddr : in reg_addr_t;
            i_wbData : in word_t;
    
            o_wbAddr : out reg_addr_t;
            o_wbData : out word_t
        );
    end component;
    component StallClearController 
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
    end component;
    component BTB 
        port (
            -- BTBRead
            i_IMPC : in word_t;
            o_predPC : out word_t;
    
            -- BTBWrite
            i_REGPC : in word_t; -- for BTBWrite
            i_jumpEN : in std_logic;
            i_jumpTarget : in word_t;
            i_predPC : in word_t;
            o_predSucc : out std_logic
        );
    end component;

    signal PC_o_PC : std_logic_vector(15 downto 0);
    signal IM_o_inst         : inst_t;
    signal IM_o_busRequest   : bus_request_t;
    signal IM_o_stallRequest : std_logic;
    signal IF_ID_o_PC : addr_t;
    signal IF_ID_o_inst : word_t;
    signal IF_ID_o_rxAddr : std_logic_vector(3 downto 0);
    signal IF_ID_o_ryAddr : std_logic_vector(3 downto 0);
    signal IF_ID_o_rzAddr : std_logic_vector(3 downto 0);
    signal myRegister_o_rxData : std_logic_vector(15 downto 0);
    signal myRegister_o_ryData : std_logic_vector(15 downto 0);
    signal myRegister_o_T : std_logic_vector(15 downto 0);
    signal myRegister_o_SP : std_logic_vector(15 downto 0);
    signal myRegister_o_IH : std_logic_vector(15 downto 0);
    signal ImmExtend_o_immExtend : std_logic_vector (15 downto 0);
    signal Control_o_ALUOP : alu_op_t;
    signal Control_o_OP0Type : std_logic_vector (2 downto 0);
    signal Control_o_OP1Type : std_logic_vector (2 downto 0);
    signal Control_o_wbType : std_logic_vector (2 downto 0);
    signal Control_o_OP0Src : opSrc_t;
    signal Control_o_OP1Src : opSrc_t;
    signal Control_o_DMRE : std_logic;
    signal Control_o_DMWR : std_logic;
    signal Control_o_OP : op_t;
    signal Decoder_o_OP0Addr : std_logic_vector(3 downto 0);
    signal Decoder_o_OP0Data : std_logic_vector(15 downto 0);
    signal Decoder_o_OP1Addr : std_logic_vector(3 downto 0);
    signal Decoder_o_OP1Data : std_logic_vector(15 downto 0);
    signal Decoder_o_wbAddr : std_logic_vector(3 downto 0);
    signal ForwardUnit_o_OP0 : std_logic_vector(15 downto 0);
    signal ForwardUnit_o_OP1 : std_logic_vector(15 downto 0);
    signal JumpAndBranch_o_jumpEN : std_logic;
    signal JumpAndBranch_o_jumpTarget : word_t;
    signal ID_EX_o_ALUOP : alu_op_t;
    signal ID_EX_o_DMRE : std_logic;
    signal ID_EX_o_DMWR : std_logic;
    signal ID_EX_o_OP : op_t;
    signal ID_EX_o_OP0 : word_t;
    signal ID_EX_o_OP1 : word_t;
    signal ID_EX_o_imm : word_t;
    signal ID_EX_o_wbAddr : reg_addr_t;
    signal ALU_MUX_o_addr : addr_t;
    signal ALU_MUX_o_data : word_t;
    signal ALU_MUX_o_ALURes : word_t;
    signal ALU_o_ALURes : word_t;
    signal EX_MEM_o_ALURes : word_t;
    signal EX_MEM_o_DMRE : std_logic;
    signal EX_MEM_o_DMWR : std_logic;
    signal EX_MEM_o_addr : word_t;
    signal EX_MEM_o_data : word_t;
    signal EX_MEM_o_wbAddr : reg_addr_t;
    signal DM_o_DMRes        : word_t;
    signal DM_o_wbData       : word_t;
    signal DM_o_stallRequest : std_logic;
    signal DM_o_busRequest   : bus_request_t;
    signal MEM_WB_o_wbAddr : reg_addr_t;
    signal MEM_WB_o_wbData : word_t;
    signal StallClearController_o_nextPC : addr_t;
    signal StallClearController_o_clear : std_logic_vector(0 to 4);
    signal StallClearController_o_stall : std_logic_vector(0 to 4);
    signal BTB_o_predPC : word_t;
    signal BTB_o_predSucc : std_logic;

begin
    PC_inst: port map (
        i_clock => ,
        i_stall => ,
        i_nextPC => ,
        o_PC => PC_o_PC
    );
    IM_inst: port map (
        i_PC => ,
        o_inst => IM_o_inst,
        i_busResponse => ,
        o_busRequest => IM_o_busRequest,
        o_stallRequest => IM_o_stallRequest
    );
    IF_ID_inst: port map (
        i_clock => ,
        i_inst => ,
        i_PC => ,
        i_stall => ,
        i_clear => ,
        o_PC => IF_ID_o_PC,
        o_inst => IF_ID_o_inst,
        o_rxAddr => IF_ID_o_rxAddr,
        o_ryAddr => IF_ID_o_ryAddr,
        o_rzAddr => IF_ID_o_rzAddr
    );
    myRegister_inst: port map (
        i_rxAddr => ,
        i_ryAddr => ,
        i_wbData => ,
        i_wbAddr => ,
        o_rxData => myRegister_o_rxData,
        o_ryData => myRegister_o_ryData,
        o_T => myRegister_o_T,
        o_SP => myRegister_o_SP,
        o_IH => myRegister_o_IH
    );
    ImmExtend_inst: port map (
        i_inst => ,
        o_immExtend => ImmExtend_o_immExtend
    );
    Control_inst: port map (
        i_inst => ,
        o_ALUOP => Control_o_ALUOP,
        o_OP0Type => Control_o_OP0Type,
        o_OP1Type => Control_o_OP1Type,
        o_wbType => Control_o_wbType,
        o_OP0Src => Control_o_OP0Src,
        o_OP1Src => Control_o_OP1Src,
        o_DMRE => Control_o_DMRE,
        o_DMWR => Control_o_DMWR,
        o_OP => Control_o_OP
    );
    Decoder_inst: port map (
        i_OP0Type => ,
        i_OP1Type => ,
        i_wbType => ,
        i_rxAddr => ,
        i_rxData => ,
        i_ryAddr => ,
        i_ryData => ,
        i_rzAddr => ,
        i_IH => ,
        i_SP => ,
        i_PC => ,
        i_T => ,
        o_OP0Addr => Decoder_o_OP0Addr,
        o_OP0Data => Decoder_o_OP0Data,
        o_OP1Addr => Decoder_o_OP1Addr,
        o_OP1Data => Decoder_o_OP1Data,
        o_wbAddr => Decoder_o_wbAddr
    );
    ForwardUnit_inst: port map (
        i_OP0Data => ,
        i_OP1Data => ,
        i_OP0Addr => ,
        i_OP1Addr => ,
        i_ALU1Res => ,
        i_ALU1Addr => ,
        i_ALU2Res => ,
        i_ALU2Addr => ,
        i_DMRes => ,
        i_DMAddr => ,
        o_OP0 => ForwardUnit_o_OP0,
        o_OP1 => ForwardUnit_o_OP1
    );
    JumpAndBranch_inst: port map (
        i_OP0 => ,
        i_OP1 => ,
        i_imm => ,
        i_OP => ,
        o_jumpEN => JumpAndBranch_o_jumpEN,
        o_jumpTarget => JumpAndBranch_o_jumpTarget
    );
    ID_EX_inst: port map (
        i_clock => ,
        i_ALUOP => ,
        i_DMRE => ,
        i_DMWR => ,
        i_OP => ,
        i_OP0 => ,
        i_OP1 => ,
        i_clear => ,
        i_imm => ,
        i_stall => ,
        i_wbAddr => ,
        o_ALUOP => ID_EX_o_ALUOP,
        o_DMRE => ID_EX_o_DMRE,
        o_DMWR => ID_EX_o_DMWR,
        o_OP => ID_EX_o_OP,
        o_OP0 => ID_EX_o_OP0,
        o_OP1 => ID_EX_o_OP1,
        o_imm => ID_EX_o_imm,
        o_wbAddr => ID_EX_o_wbAddr
    );
    ALU_MUX_inst: port map (
        i_ALURes => ,
        i_OP0 => ,
        i_OP1 => ,
        i_OP => ,
        o_addr => ALU_MUX_o_addr,
        o_data => ALU_MUX_o_data,
        o_ALURes => ALU_MUX_o_ALURes
    );
    ALU_inst: port map (
        i_OP0 => ,
        i_OP1 => ,
        i_imm => ,
        i_OP0Src => ,
        i_OP1Src => ,
        i_ALUOP => ,
        o_ALURes => ALU_o_ALURes
    );
    EX_MEM_inst: port map (
        i_clock => ,
        i_ALURes => ,
        i_DMRE => ,
        i_DMWR => ,
        -- i_OP1 => ,
        i_addr => ,
        i_clear => ,
        i_data => ,
        i_stall => ,
        i_wbAddr => ,
        o_ALURes => EX_MEM_o_ALURes,
        o_DMRE => EX_MEM_o_DMRE,
        o_DMWR => EX_MEM_o_DMWR,
        o_addr => EX_MEM_o_addr,
        o_data => EX_MEM_o_data,
        o_wbAddr => EX_MEM_o_wbAddr
    );
    DM_inst: port map (
        i_data => ,
        i_addr => ,
        i_ALURes => ,
        o_DMRes => DM_o_DMRes,
        o_wbData => DM_o_wbData,
        i_DMRE => ,
        i_DMWR => ,
        o_stallRequest => DM_o_stallRequest,
        o_busRequest => DM_o_busRequest,
        i_busResponse => 
    );
    MEM_WB_inst: port map (
        i_clock => ,
        i_clear => ,
        i_stall => ,
        i_wbAddr => ,
        i_wbData => ,
        o_wbAddr => MEM_WB_o_wbAddr,
        o_wbData => MEM_WB_o_wbData
    );
    StallClearController_inst: port map (
        -- clea => ,
        i_breakEN => ,
        i_breakPC => ,
        i_jumpTarget => ,
        i_predPC => ,
        i_predSucc => ,
        o_nextPC => StallClearController_o_nextPC,
        o_clear => StallClearController_o_clear,
        -- stal => ,
        i_wbAddr => ,
        i_DMStallReq => ,
        i_IFStallReq => ,
        i_DMRE => ,
        i_OP0Addr => ,
        i_OP1Addr => ,
        o_stall => StallClearController_o_stall
    );
    BTB_inst: port map (
        -- BTBRea => ,
        i_IMPC => ,
        o_predPC => BTB_o_predPC,
        -- BTBWrit => ,
        i_REGPC => ,
        i_jumpEN => ,
        i_jumpTarget => ,
        i_predPC => ,
        o_predSucc => BTB_o_predSucc
    );

end;