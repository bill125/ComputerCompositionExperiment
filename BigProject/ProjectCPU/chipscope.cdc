#ChipScope Core Inserter Project File Version 3.0
#Sat Dec 02 11:49:45 IRKT 2017
Project.device.designInputFile=Y\:\\workspace\\course\\3.1\\computer-organzation\\final-project\\ComputerCompositionExperiment\\BigProject\\ProjectCPU\\CPUOverall_cs.ngc
Project.device.designOutputFile=Y\:\\workspace\\course\\3.1\\computer-organzation\\final-project\\ComputerCompositionExperiment\\BigProject\\ProjectCPU\\CPUOverall_cs.ngc
Project.device.deviceFamily=13
Project.device.enableRPMs=true
Project.device.outputDirectory=Y\:\\workspace\\course\\3.1\\computer-organzation\\final-project\\ComputerCompositionExperiment\\BigProject\\ProjectCPU\\_ngo
Project.device.useSRL16=true
Project.filter.dimension=19
Project.filter<0>=*clock*
Project.filter<10>=*begin
Project.filter<11>=begin*
Project.filter<12>=UART*
Project.filter<13>=UART
Project.filter<14>=/read*
Project.filter<15>=read*
Project.filter<16>=N16*
Project.filter<17>=N16
Project.filter<18>=
Project.filter<1>=clock
Project.filter<2>=*inst*
Project.filter<3>=*DMWR*
Project.filter<4>=*DMRE*
Project.filter<5>=*pc*
Project.filter<6>=*stall*
Project.filter<7>=stall**
Project.filter<8>=stall*
Project.filter<9>=stall
Project.icon.boundaryScanChain=1
Project.icon.enableExtTriggerIn=false
Project.icon.enableExtTriggerOut=false
Project.icon.triggerInPinName=
Project.icon.triggerOutPinName=
Project.unit.dimension=1
Project.unit<0>.clockChannel=i_clock
Project.unit<0>.clockEdge=Rising
Project.unit<0>.dataDepth=8192
Project.unit<0>.dataEqualsTrigger=true
Project.unit<0>.dataPortWidth=80
Project.unit<0>.enableGaps=false
Project.unit<0>.enableStorageQualification=true
Project.unit<0>.enableTimestamps=false
Project.unit<0>.timestampDepth=0
Project.unit<0>.timestampWidth=0
Project.unit<0>.triggerChannel<0><0>=UART_inst/o_wrn
Project.unit<0>.triggerChannel<0><10>=CPUCore_inst/IF_ID_inst/i_stall_inv
Project.unit<0>.triggerChannel<0><11>=CPUCore_inst/EX_MEM_inst/i_stall_inv
Project.unit<0>.triggerChannel<0><12>=CPUCore_inst/MEM_WB_inst/i_stall_inv
Project.unit<0>.triggerChannel<0><13>=CPUCore_inst/PC_inst/o_PC<15>
Project.unit<0>.triggerChannel<0><14>=CPUCore_inst/PC_inst/o_PC<14>
Project.unit<0>.triggerChannel<0><15>=CPUCore_inst/PC_inst/o_PC<13>
Project.unit<0>.triggerChannel<0><16>=CPUCore_inst/PC_inst/o_PC<12>
Project.unit<0>.triggerChannel<0><17>=CPUCore_inst/PC_inst/o_PC<11>
Project.unit<0>.triggerChannel<0><18>=CPUCore_inst/PC_inst/o_PC<10>
Project.unit<0>.triggerChannel<0><19>=CPUCore_inst/PC_inst/o_PC<9>
Project.unit<0>.triggerChannel<0><1>=UART_inst/o_writeReady
Project.unit<0>.triggerChannel<0><20>=CPUCore_inst/PC_inst/o_PC<8>
Project.unit<0>.triggerChannel<0><21>=CPUCore_inst/PC_inst/o_PC<7>
Project.unit<0>.triggerChannel<0><22>=CPUCore_inst/PC_inst/o_PC<6>
Project.unit<0>.triggerChannel<0><23>=CPUCore_inst/PC_inst/o_PC<5>
Project.unit<0>.triggerChannel<0><24>=CPUCore_inst/PC_inst/o_PC<4>
Project.unit<0>.triggerChannel<0><25>=CPUCore_inst/PC_inst/o_PC<3>
Project.unit<0>.triggerChannel<0><26>=CPUCore_inst/PC_inst/o_PC<2>
Project.unit<0>.triggerChannel<0><27>=CPUCore_inst/PC_inst/o_PC<1>
Project.unit<0>.triggerChannel<0><28>=CPUCore_inst/PC_inst/o_PC<0>
Project.unit<0>.triggerChannel<0><29>=CPUCore_inst/BTB_o_predPC<15>
Project.unit<0>.triggerChannel<0><2>=UART_inst/o_writeDone
Project.unit<0>.triggerChannel<0><30>=CPUCore_inst/BTB_o_predPC<14>
Project.unit<0>.triggerChannel<0><31>=CPUCore_inst/BTB_o_predPC<13>
Project.unit<0>.triggerChannel<0><32>=CPUCore_inst/BTB_o_predPC<12>
Project.unit<0>.triggerChannel<0><33>=CPUCore_inst/BTB_o_predPC<11>
Project.unit<0>.triggerChannel<0><34>=CPUCore_inst/BTB_o_predPC<10>
Project.unit<0>.triggerChannel<0><35>=CPUCore_inst/BTB_o_predPC<9>
Project.unit<0>.triggerChannel<0><36>=CPUCore_inst/BTB_o_predPC<8>
Project.unit<0>.triggerChannel<0><37>=CPUCore_inst/BTB_o_predPC<7>
Project.unit<0>.triggerChannel<0><38>=CPUCore_inst/BTB_o_predPC<6>
Project.unit<0>.triggerChannel<0><39>=CPUCore_inst/BTB_o_predPC<5>
Project.unit<0>.triggerChannel<0><3>=UART_inst/o_readReady
Project.unit<0>.triggerChannel<0><40>=CPUCore_inst/BTB_o_predPC<4>
Project.unit<0>.triggerChannel<0><41>=CPUCore_inst/BTB_o_predPC<3>
Project.unit<0>.triggerChannel<0><42>=CPUCore_inst/BTB_o_predPC<2>
Project.unit<0>.triggerChannel<0><43>=CPUCore_inst/BTB_o_predPC<1>
Project.unit<0>.triggerChannel<0><44>=CPUCore_inst/BTB_o_predPC<0>
Project.unit<0>.triggerChannel<0><45>=CPUCore_inst/EX_MEM_inst/o_DMRE
Project.unit<0>.triggerChannel<0><46>=CPUCore_inst/EX_MEM_inst/o_DMWR
Project.unit<0>.triggerChannel<0><47>=CPUCore_inst/ID_EX_inst/o_DMRE
Project.unit<0>.triggerChannel<0><48>=CPUCore_inst/ID_EX_inst/o_DMWR
Project.unit<0>.triggerChannel<0><49>=CPUCore_o_Control_o_DMRE
Project.unit<0>.triggerChannel<0><4>=UART_inst/o_readDone
Project.unit<0>.triggerChannel<0><50>=CPUCore_o_Control_o_DMWR
Project.unit<0>.triggerChannel<0><51>=
Project.unit<0>.triggerChannel<0><52>=
Project.unit<0>.triggerChannel<0><53>=
Project.unit<0>.triggerChannel<0><54>=
Project.unit<0>.triggerChannel<0><55>=
Project.unit<0>.triggerChannel<0><56>=
Project.unit<0>.triggerChannel<0><57>=
Project.unit<0>.triggerChannel<0><58>=
Project.unit<0>.triggerChannel<0><59>=
Project.unit<0>.triggerChannel<0><5>=UART_inst/o_rdn
Project.unit<0>.triggerChannel<0><60>=
Project.unit<0>.triggerChannel<0><61>=
Project.unit<0>.triggerChannel<0><62>=
Project.unit<0>.triggerChannel<0><63>=
Project.unit<0>.triggerChannel<0><64>=
Project.unit<0>.triggerChannel<0><65>=
Project.unit<0>.triggerChannel<0><66>=
Project.unit<0>.triggerChannel<0><67>=
Project.unit<0>.triggerChannel<0><68>=
Project.unit<0>.triggerChannel<0><69>=
Project.unit<0>.triggerChannel<0><6>=UART_inst/o_bus_EN
Project.unit<0>.triggerChannel<0><70>=
Project.unit<0>.triggerChannel<0><71>=
Project.unit<0>.triggerChannel<0><72>=
Project.unit<0>.triggerChannel<0><73>=
Project.unit<0>.triggerChannel<0><74>=
Project.unit<0>.triggerChannel<0><75>=
Project.unit<0>.triggerChannel<0><76>=
Project.unit<0>.triggerChannel<0><77>=
Project.unit<0>.triggerChannel<0><78>=
Project.unit<0>.triggerChannel<0><79>=
Project.unit<0>.triggerChannel<0><7>=SystemBusController_UART_readBegin
Project.unit<0>.triggerChannel<0><8>=SystemBusController_UART_writeBegin
Project.unit<0>.triggerChannel<0><9>=BusArbiter_busResponse_0_stallRequest
Project.unit<0>.triggerConditionCountWidth=0
Project.unit<0>.triggerMatchCount<0>=1
Project.unit<0>.triggerMatchCountWidth<0><0>=0
Project.unit<0>.triggerMatchType<0><0>=1
Project.unit<0>.triggerPortCount=1
Project.unit<0>.triggerPortIsData<0>=true
Project.unit<0>.triggerPortWidth<0>=80
Project.unit<0>.triggerSequencerLevels=16
Project.unit<0>.triggerSequencerType=1
Project.unit<0>.type=ilapro
