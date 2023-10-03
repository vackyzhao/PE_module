//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-5
//Part Number: GW5AST-LV138FPG676AES
//Device: GW5AST-138
//Device Version: B
//Created Time: Sun Oct 01 21:12:05 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	RiscV_AE350_SOC_Top your_instance_name(
		.FLASH_SPI_CSN(FLASH_SPI_CSN_io), //inout FLASH_SPI_CSN
		.FLASH_SPI_MISO(FLASH_SPI_MISO_io), //inout FLASH_SPI_MISO
		.FLASH_SPI_MOSI(FLASH_SPI_MOSI_io), //inout FLASH_SPI_MOSI
		.FLASH_SPI_CLK(FLASH_SPI_CLK_io), //inout FLASH_SPI_CLK
		.FLASH_SPI_HOLDN(FLASH_SPI_HOLDN_io), //inout FLASH_SPI_HOLDN
		.FLASH_SPI_WPN(FLASH_SPI_WPN_io), //inout FLASH_SPI_WPN
		.DDR3_MEMORY_CLK(DDR3_MEMORY_CLK_i), //input DDR3_MEMORY_CLK
		.DDR3_CLK_IN(DDR3_CLK_IN_i), //input DDR3_CLK_IN
		.DDR3_LOCK(DDR3_LOCK_i), //input DDR3_LOCK
		.DDR3_STOP(DDR3_STOP_o), //output DDR3_STOP
		.DDR3_INIT(DDR3_INIT_o), //output DDR3_INIT
		.DDR3_BANK(DDR3_BANK_o), //output [2:0] DDR3_BANK
		.DDR3_CS_N(DDR3_CS_N_o), //output DDR3_CS_N
		.DDR3_RAS_N(DDR3_RAS_N_o), //output DDR3_RAS_N
		.DDR3_CAS_N(DDR3_CAS_N_o), //output DDR3_CAS_N
		.DDR3_WE_N(DDR3_WE_N_o), //output DDR3_WE_N
		.DDR3_CK(DDR3_CK_o), //output DDR3_CK
		.DDR3_CK_N(DDR3_CK_N_o), //output DDR3_CK_N
		.DDR3_CKE(DDR3_CKE_o), //output DDR3_CKE
		.DDR3_RESET_N(DDR3_RESET_N_o), //output DDR3_RESET_N
		.DDR3_ODT(DDR3_ODT_o), //output DDR3_ODT
		.DDR3_ADDR(DDR3_ADDR_o), //output [13:0] DDR3_ADDR
		.DDR3_DM(DDR3_DM_o), //output [1:0] DDR3_DM
		.DDR3_DQ(DDR3_DQ_io), //inout [15:0] DDR3_DQ
		.DDR3_DQS(DDR3_DQS_io), //inout [1:0] DDR3_DQS
		.DDR3_DQS_N(DDR3_DQS_N_io), //inout [1:0] DDR3_DQS_N
		.TCK_IN(TCK_IN_i), //input TCK_IN
		.TMS_IN(TMS_IN_i), //input TMS_IN
		.TRST_IN(TRST_IN_i), //input TRST_IN
		.TDI_IN(TDI_IN_i), //input TDI_IN
		.TDO_OUT(TDO_OUT_o), //output TDO_OUT
		.TDO_OE(TDO_OE_o), //output TDO_OE
		.CORE_CLK(CORE_CLK_i), //input CORE_CLK
		.DDR_CLK(DDR_CLK_i), //input DDR_CLK
		.AHB_CLK(AHB_CLK_i), //input AHB_CLK
		.APB_CLK(APB_CLK_i), //input APB_CLK
		.RTC_CLK(RTC_CLK_i), //input RTC_CLK
		.RESET_N(RESET_N_i) //input RESET_N
	);

//--------Copy end-------------------
