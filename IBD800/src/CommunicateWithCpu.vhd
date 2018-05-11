----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:51 08/22/2015 
-- Design Name: 
-- Module Name:    CommunicateWithCpu - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.FPGARegs.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity CommunicateWithCpu is
    Port ( 
			  MCLK   : in std_logic;
			  DanteCheck : in std_logic;
			  RERRA_1 : in  STD_LOGIC;
           RERRB_1 : in  STD_LOGIC;
           RERRA_2 : in  STD_LOGIC;
			  
           FPGA_GPI : in  STD_LOGIC_VECTOR (7 downto 0);
           FPGA_GPO : out  STD_LOGIC_VECTOR (7 downto 0);
			  
			  --testOut : out std_logic;
			  
			  MaxCh1L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh1R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh2L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh2R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh3L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh3R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh4L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh4R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh5L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh5R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh6L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh6R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh7L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh7R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh8L:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  MaxCh8R:           IN  STD_LOGIC_VECTOR(15 downto 0); 
			  
			  MaxAudioOutL:      in std_logic_vector(15 downto 0);
			  MaxAudioOutR:      in std_logic_vector(15 downto 0);
			  
           XSPIMOSI1 : in  STD_LOGIC;             --Arm SPI
           XSPIMISO1 : out  STD_LOGIC;
           XSPICSN1  : in  STD_LOGIC;
           XSPICLK1  : in  STD_LOGIC;
			  
			  FP_SPIMOSI : in std_logic;             --Front pannel SPI interface
			  FP_SPIMISO : out std_logic;
			  FP_SPICLK  : in std_logic;
			  FP_SPICS   : in std_logic;
			  
			  currentChannel : out std_logic_vector(2 downto 0);
			  AutoSwitchEn : out std_logic;
			  AutoReturnEn : out std_logic;
			  AutoSwitchTimeThrd : out std_logic_vector(7 downto 0);
			  AutoReturnTimeThrd : out std_logic_vector(7 downto 0);
			  VuThrd : out std_logic_vector(15 downto 0);
			  FP_ListenCh : out std_logic_vector(2 downto 0);
			  newChFlag  : in std_logic;
			  NewChannel : in std_logic_vector(2 downto 0);
			  
			  M3v3_CK   : in std_logic;
			  S3v3_CK   : in std_logic;
			 
           xysum : in STD_LOGIC_VECTOR(40 downto 0);  --Correlation
			  root :  in STD_LOGIC_VECTOR(41 downto 0);
			  CorrelationCh : in std_logic_vector(2 downto 0);
			  SaveCe   : in std_logic;			  
			  DivideEn : in std_logic;
			  divide_ok : in std_logic;
			  po_clr : in std_logic;
			  
			  Counter14 : in std_logic_vector(7 downto 0);
			  Counter15 : in std_logic_vector(7 downto 0);
			  
			  ArmListenChSel : out std_logic_vector(3 downto 0);
			  ch1Config: out std_logic_vector(3 downto 0);
			  ch2Config: out std_logic_vector(3 downto 0);
			  ch3Config: out std_logic_vector(3 downto 0);
			  ch4Config: out std_logic_vector(3 downto 0);
			  ch5Config: out std_logic_vector(3 downto 0);
			  ch6Config: out std_logic_vector(3 downto 0);
			  ch7Config: out std_logic_vector(3 downto 0);
			  ch8Config: out std_logic_vector(3 downto 0);
			  TQ_5	   :out std_logic;
			  Reg_AudioRevert: out std_logic	
		 );
end CommunicateWithCpu;

architecture Behavioral of CommunicateWithCpu is

COMPONENT StoreCorrMediaData
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

component divider
	port (
	clk: in std_logic;
	ce: in std_logic;
	sclr: in std_logic;
	rfd: out std_logic;
	dividend: in std_logic_vector(31 downto 0);
	divisor: in std_logic_vector(31 downto 0);
	quotient: out std_logic_vector(31 downto 0);
	fractional: out std_logic_vector(7 downto 0));
end component;

component Spi is
    Port ( SpiClk : in  STD_LOGIC;
           SpiMOSI : in  STD_LOGIC;
           SpiMISO : out  STD_LOGIC;
           SpiCS : in  STD_LOGIC;
           MCLK : in  STD_LOGIC;
           Address : out  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  RdPrep  : out std_logic;
			  RdWrn    : out std_logic;
           DataOut : out  STD_LOGIC_VECTOR (7 downto 0);
           DataIn : in  STD_LOGIC_VECTOR (7 downto 0);
           FallingSPICsn : out  STD_LOGIC;
           RisingSPICsn : out  STD_LOGIC);
end component;

COMPONENT DRAM_Reg
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;


	signal iMeterMute    : std_logic_vector(15 downto 0);
	signal iMeterCurrent : std_logic_vector(15 downto 0);
	
	signal iAESStatus : std_logic_vector(2 downto 0);
	signal iGPI       : std_logic_vector(7 downto 0);
	signal iGPO       : std_logic_vector(7 downto 0);
	signal iGPOLock  : std_logic;
	

	signal iNumber_slt : std_logic_vector(3 downto 0);
	signal iListenChSel : std_logic_vector(3 downto 0);
	
	signal irootToDivider : std_logic_vector(31 downto 0);
   signal ixySumToDivider : std_logic_vector(31 downto 0);
   signal irooAccessCnt : std_logic_vector(2 downto 0);
   signal ixysumAccessCnt : std_logic_vector(2 downto 0);
	
	signal iresult :       std_logic_vector(15 downto 0);
	signal iDivideRd :     std_logic;
	signal iCorrelation0 : std_logic_vector(7 downto 0);
	signal iCorrelation1 : std_logic_vector(7 downto 0);
	signal iCorrelation2 : std_logic_vector(7 downto 0);
	signal iCorrelation3 : std_logic_vector(7 downto 0);
	signal iCorrelation4 : std_logic_vector(7 downto 0);
	signal iCorrelation5 : std_logic_vector(7 downto 0);
	signal iCorrelation6 : std_logic_vector(7 downto 0);
	signal iCorrelation7 : std_logic_vector(7 downto 0);
   signal irfdEDGE,idly1 : std_logic;
	
	signal iArmSpiAddress : std_logic_vector(15 downto 0);
	signal iArmRdPrep: std_logic;
	signal iDataFromArm : std_logic_vector(7 downto 0);
	signal iDataToArmRam : std_logic_vector(7 downto 0);
	signal iArmSpiCsFallEdge : std_logic;
	signal iArmSpiCsRiseEdge : std_logic;
	signal iDataWrByFpgaToArm : std_logic_vector(7 downto 0);

	signal iFPSpiAddress : std_logic_vector(15 downto 0);
	signal iFPRdPrep: std_logic;
	signal iDataFromFP : std_logic_vector(7 downto 0);
	signal iDataToFPRam : std_logic_vector(7 downto 0);
	signal iFPSpiCsFallEdge : std_logic;
	signal iFPSpiCsRiseEdge : std_logic;	
	signal iDataWrByFpgaToFp : std_logic_vector(7 downto 0);
	
	----------------------------------------------------------------
	signal iReg_AudioOut : std_logic_vector(2 downto 0);
	signal iReg_FP_HPOut : std_logic_vector(2 downto 0);
	signal iReg_ReturnEn : std_logic;
	signal iReg_AutoEn   : std_logic;
	signal iReg_PowStat  : std_logic_vector(1 downto 0);
	signal iReg_AesStat  : std_logic_vector(2 downto 0);
	signal iReg_AudioRevert  : std_logic_vector(7 downto 0) := B"0000_0000";
	
	signal iReg_VuThrdH  : std_logic_vector(7 downto 0) := B"0000_0000";
	signal iReg_VuThrdL  : std_logic_vector(7 downto 0) := B"0110_0111";  --- -50dbfs
	signal iReg_SW_Time  : std_logic_vector(7 downto 0) := B"0000_0101";
	signal iReg_RT_Time  : std_logic_vector(7 downto 0) := B"0000_0001";
	signal imode  : std_logic_vector(3 downto 0) := B"0000";
	
	signal iArmListenChSel : std_logic_vector(3 downto 0);	
	signal iReg_Message  : std_logic_vector(7 downto 0);
	signal iAmOk         : std_logic_vector(7 downto 0);
	signal iCorrInArm  : std_logic_vector(7 downto 0);
	signal iMaxVuInArm : std_logic_vector(7 downto 0);
	signal iCorrInFP  : std_logic_vector(7 downto 0);
	signal iMaxVuInFP : std_logic_vector(7 downto 0);
	signal iFPRdWr    : std_logic;
	signal iArmRdWr   : std_logic;
	----------------------------------------------------------------

   constant iTEST : std_logic_vector(15 downto 0) := (others=>'1');
--	Type ChType is array(7 downto 0) of std_logic_vector(3 downto 0);
--	Type ChNUM  is array(7 downto 0) of std_logic_vector(7 downto 0);
--	signal iChType : ChType;
--	signal iChNum  : ChNUM;
	
   signal iArmTempArrayIndex : integer range 0 to 7;
	signal iFpTempArrayIndex  : integer range 0 to 7;
	signal iamReady : std_logic_vector(7 downto 0) := (others=>'0');
	
begin
--------------------------------------------------------------------------------------------------------------
	iAESStatus(0) <= RERRA_1;
	iAESStatus(1) <= RERRB_1;
	iAESStatus(2) <= RERRA_2;
	

iamReady <= B"0101_0101" when DanteCheck = '0' else
            B"1010_1010";
				
-------------------------------------------------------------------------------------------------------------
ARM_SPI_Inst: spi port map
                  (
						  SpiClk => XSPICLK1,
						  SpiMOSI => XSPIMOSI1,
						  SpiMISO => XSPIMISO1,
						  SpiCS => XSPICSN1,
						  MCLK  => MCLK,
						  Address => iArmSpiAddress,
						  RdPrep =>iArmRdPrep,
						  RdWrn   => iArmRdWr,
						  DataOut => iDataFromArm,
						  DataIn => iDataWrByFpgaToArm,
						  FallingSPICsn => iArmSpiCsFallEdge,
						  RisingSPICsn  => iArmSpiCsRiseEdge						
						);
----------------------------------------------------------------
FP_SPI_Inst : spi port map
                 (
						  SpiClk => FP_SPICLK,
						  SpiMOSI => FP_SPIMOSI,
						  SpiMISO => FP_SPIMISO,
						  SpiCS => FP_SPICS,
						  MCLK  => MCLK,
						  Address => iFPSpiAddress,
						  RdPrep =>iFPRdPrep,
						  RdWrn   => iFPRdWr,
						  DataOut => iDataFromFP,
						  DataIn => iDataWrByFpgaToFp,         ---iDataWrByFpgaToFp
						  FallingSPICsn => iFPSpiCsFallEdge,
						  RisingSPICsn  => iFPSpiCsRiseEdge
					  );
------------------------------------------------------------------------------------------------------
otherRegs : DRAM_Reg
  PORT MAP (
				 clka => MCLK,
				 ena => '1',
				 wea(0) =>  iArmSpiCsRiseEdge and (not iArmRdWr),
				 addra => iArmSpiAddress(7 downto 0),
				 dina => iDataFromArm,
				 douta => iDataToArmRam,
				 clkb =>  MCLK,
				 enb => '1',
				 web(0) => iFPSpiCsRiseEdge and (not iFPRdWr),
				 addrb => iFPSpiAddress(7 downto 0),
				 dinb => iDataFromFp,
				 doutb => iDataToFPRam
  );
--------------------------------------Main switch reg  write --------------------------------------------------
--process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,newChFlag,iDataFromArm(2 downto 0),iDataFromFP(2 downto 0),NewChannel,
--        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--begin
--	if(falling_edge(MCLK)) then
--		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_AOUT and iArmRdWr='0') then
--			iReg_AudioOut <= iDataFromArm(2 downto 0);
--		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_AOUT and iFPRdWr='0') then
--			iReg_AudioOut <= iDataFromFP(2 downto 0);
--		elsif(newChFlag = '1') then
--			iReg_AudioOut <= NewChannel;
--		end if;
--	end if;
--end process;
--currentChannel <= iReg_AudioOut; 
-------------------------------------front pannel pre-listen reg  write----------------------------------------
process(MCLK,iFPSpiCsRiseEdge,iDataFromFP(2 downto 0),iFPSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_HP and iFPRdWr='0') then
			iReg_FP_HPOut <= iDataFromFP(2 downto 0);
		end if;
	end if;
end process;
FP_ListenCh  <= iReg_FP_HPOut;
--------------------------------------Arm Listen reg write -----------------------------------------------------
process(MCLK,iArmSpiCsRiseEdge,iDataFromArm(3 downto 0),iArmSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_Listen and iArmRdWr='0') then
			iArmListenChSel <= iDataFromArm(3 downto 0);
		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_Listen and iFPRdWr='0') then
			iArmListenChSel <= iDataFromFP(3 downto 0);
		end if;
	end if;
end process;
ArmListenChSel  <= iArmListenChSel;
--------------------------------------Auto Return switch reg  write-------------------------------------
--process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm(0),iDataFromFP(0),
--        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--begin
--	if(falling_edge(MCLK)) then
--		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_ReturnEn and iArmRdWr='0') then
--			iReg_ReturnEn <= iDataFromArm(0);
--		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_ReturnEn and iFPRdWr='0') then
--			iReg_ReturnEn <= iDataFromFP(0);
--		end if;
--	end if;
--end process;
--AutoReturnEn  <= iReg_ReturnEn;
--------------------------------------Auto switch reg  write--------------------------------------------
--process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm(0),iDataFromFP(0),
--        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--begin
--	if(falling_edge(MCLK)) then
--		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_SwitchEn and iArmRdWr='0') then
--			iReg_AutoEn <= iDataFromArm(0);
--			--testOut <= '1';
--		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_SwitchEn and iFPRdWr='0') then
--			iReg_AutoEn <= iDataFromFP(0);
--			--testOut <= '0';
--		end if;
--	end if;
--end process;
--AutoSwitchEn  <= iReg_AutoEn;
------------------------------------GPO reg  write----------------------------------------------------
process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0) )
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_GPO and iArmRdWr='0') then
			iGPO <= iDataFromArm;
		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_GPO and iFPRdWr='0') then
			iGPO <= iDataFromFP;
		end if;
	end if;
end process;
FPGA_GPO  <= iGPO;
------------------------------------Reg message  write -----------------------------------------------
process(MCLK,newChFlag,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_Message and iArmRdWr='0') then
			iReg_Message <= iDataFromArm;
		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_Message and iFPRdWr='0') then
			iReg_Message <= iDataFromFP;
		elsif(newChFlag = '1') then
			iReg_Message(0) <= '1'; 
		end if;
	end if;
end process;
------------------------------------Reg Vu threshold  write-------------------------------------------
process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_VuThrdH and iArmRdWr='0') then	
			iReg_VuThrdH <= iDataFromArm;
		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_VuThrdH and iFPRdWr='0') then
			iReg_VuThrdH <= iDataFromFP;
		end if;
	end if;
end process;
process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_VuThrdL and iArmRdWr='0') then	
			iReg_VuThrdL <= iDataFromArm;
		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_VuThrdL and iFPRdWr='0') then
			iReg_VuThrdL <= iDataFromFP;
		end if;
	end if;
end process;
VuThrd  <= iReg_VuThrdH & iReg_VuThrdL;		  
-------------------------------------Reg switch Time Threshold  write----------------------------------
--process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
--        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--begin
--	if(falling_edge(MCLK)) then
--		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_SW_TIME and iArmRdWr='0') then	
--			iReg_SW_Time <= iDataFromArm;
--		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_SW_TIME and iFPRdWr='0') then
--			iReg_SW_Time <= iDataFromFP;
--		end if;
--	end if;
--end process;
--AutoSwitchTimeThrd <= iReg_SW_Time;
---------------------------------------Reg Return Time Threshold  write----------------------------------
--process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
--        iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--begin
--	if(falling_edge(MCLK)) then
--		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_RT_TIME and iArmRdWr='0') then	
--			iReg_RT_Time <= iDataFromArm;
--		elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_RT_TIME and iFPRdWr='0') then
--			iReg_RT_Time <= iDataFromFP;
--		end if;
--	end if;
--end process;
--AutoReturnTimeThrd <= iReg_RT_Time;
-------------------------------------mode----------------------------------
process(MCLK,iArmSpiCsRiseEdge,iDataFromArm,iArmSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
	if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_Mode and iArmRdWr='0') then	
			imode <= iDataFromArm(3 downto 0);
		end if;
	end if;
end process;
TQ_5	<='0' when ((imode = "0000") or (imode = "0001")) else
		  '1';
		  
-------------------------------------Reg AudioRevert----------------------------------
process(MCLK,iArmSpiCsRiseEdge,iDataFromArm,iArmSpiAddress(7 downto 0))
begin
	if(falling_edge(MCLK)) then
		if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_AudioRevert and iArmRdWr='0') then	
			iReg_AudioRevert <= iDataFromArm;
		end if;
	end if;
end process;
Reg_AudioRevert <= '0' when iReg_AudioRevert = B"0000_0000" else 
					    '1';
--------------------------------------Channel Config write --------------------------------------------------------------
--CHTYPE_STORE: for i in 0 to 7 generate
--	process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm(3 downto 0),iDataFromFP(3 downto 0),
--			  iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--	begin
--		if(falling_edge(MCLK)) then
--			if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_CH1Type + i and iArmRdWr='0') then	
--				iChType(i)  <= iDataFromArm(3 downto 0);
--			elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_CH1Type + i and iFPRdWr='0') then
--				iChType(i)  <= iDataFromFP(3 downto 0);
--			end if;
--		end if;
--	end process;
--end generate CHTYPE_STORE;
--------------------------------------------------------------------------------------------------------------------------
--CHNUM_STORE:  for i in 0 to 7 generate
--	process(MCLK,iArmSpiCsRiseEdge,iFPSpiCsRiseEdge,iDataFromArm,iDataFromFP,
--			  iArmSpiAddress(7 downto 0),iFPSpiAddress(7 downto 0))
--	begin
--		if(falling_edge(MCLK)) then
--			if(iArmSpiCsRiseEdge = '1' and iArmSpiAddress(7 downto 0) = ADDR_CH1Num + i and iArmRdWr='0') then	
--				iChNum(i)  <= iDataFromArm;
--			elsif(iFPSpiCsRiseEdge = '1' and iFPSpiAddress(7 downto 0) = ADDR_CH1Num + i and iFPRdWr='0') then
--				iChNum(i)  <= iDataFromFP;
--			end if;
--		end if;
--	end process;
--end generate CHNUM_STORE;
---------------------------------------------------------------------------------------------------------------------------
iDataWrByFpgaToArm <= B"0000_0" & iReg_AudioOut when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_AOUT) else
                      iReg_Message when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Message) else
							 iReg_VuThrdH when  (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VuThrdH) else
							 iReg_VuThrdL when  (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VuThrdL) else
							 iReg_SW_Time when  (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_SW_TIME) else
							 FPGA_GPI     when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_GPI) else
							 B"0000_0" & RERRA_2 & RERRB_1 & RERRA_1 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_AesStat) else
							 B"0000_00" & S3v3_CK & M3v3_CK when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_PowStat) else
							 iMaxVuInArm  when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) >= ADDR_VU_Start)  and (iArmSpiAddress(7 downto 0) < ADDR_VU_End) else
							 iCorrInArm  when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) >= ADDR_Corr_Start) and (iArmSpiAddress(7 downto 0) < ADDR_Corr_Start + 8) else
							 iDataToArmRam;

iMaxVuInArm <= MaxCh1L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start) else
            MaxCh1L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"01") else
            MaxCh1R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"02") else
            MaxCh1R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"03") else              
            MaxCh2L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"04") else
            MaxCh2L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"05") else 
            MaxCh2R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"06") else
            MaxCh2R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"07") else 
				
				MaxCh3L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"08") else
            MaxCh3L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"09") else
            MaxCh3R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0A") else
            MaxCh3R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0B") else              
            MaxCh4L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0C") else----0B¸Ä³É0C
            MaxCh4L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0D") else 
            MaxCh4R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0E") else
            MaxCh4R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"0F") else 
				MaxCh5L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"10") else
            MaxCh5L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"11") else
            MaxCh5R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"12") else
            MaxCh5R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"13") else              
            MaxCh6L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"14") else
            MaxCh6L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"15") else 
            MaxCh6R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"16") else
            MaxCh6R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"17") else 
				MaxCh7L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"18") else
            MaxCh7L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"19") else
            MaxCh7R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1A") else
            MaxCh7R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1B") else              
            MaxCh8L(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1C") else
            MaxCh8L(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1D") else 
            MaxCh8R(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1E") else
            MaxCh8R(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"1F") else 
				MaxAudioOutL(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"20") else
            MaxAudioOutL(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"21") else
            MaxAudioOutR(15 downto 8 )when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"22") else
            MaxAudioOutR(7 downto 0 ) when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_VU_Start+x"23") else
            B"0000_0000";            

iCorrInArm <= iCorrelation0 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start)         else
              iCorrelation1 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"01") else
				  iCorrelation2 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"02") else
              iCorrelation3 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"03") else
				  iCorrelation4 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"04") else
              iCorrelation5 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"05") else
				  iCorrelation6 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"06") else
              iCorrelation7 when (iArmRdPrep = '1') and (iArmSpiAddress(7 downto 0) = ADDR_Corr_Start + x"07") else
				  B"0000_0000";
----------------------------------------------------------------------------------------------------------------------------
iDataWrByFpgaToFp <=  iamReady when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_iAmOk) else
                      iReg_VuThrdH when  (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VuThrdH) else
							 iReg_VuThrdL when  (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VuThrdL) else
							 iReg_SW_Time when  (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_SW_TIME) else
                      B"0000_0" & iReg_AudioOut when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_AOUT) else
                      iReg_Message when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_Message) else
							 B"0000_00" & S3v3_CK & M3v3_CK when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_PowStat) else
							 B"0000_0" & RERRA_2 & RERRB_1 & RERRA_1 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_AesStat) else
							 iMaxVuInFP  when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) >= ADDR_VU_Start)  and (iFPSpiAddress(7 downto 0) < ADDR_VU_End) else
							 iCorrInFP  when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) >= ADDR_Corr_Start) and (iFPSpiAddress(7 downto 0) < ADDR_Corr_Start + 8) else
							 iDataToFPRam;

iMaxVuInFP <= MaxCh1L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start) else
            MaxCh1L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"01") else
            MaxCh1R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"02") else
            MaxCh1R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"03") else              
            MaxCh2L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"04") else
            MaxCh2L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"05") else 
            MaxCh2R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"06") else
            MaxCh2R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"07") else 
				
				MaxCh3L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"08") else
            MaxCh3L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"09") else
            MaxCh3R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0A") else
            MaxCh3R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0B") else              
            MaxCh4L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0C") else
            MaxCh4L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0D") else 
            MaxCh4R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0E") else
            MaxCh4R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"0F") else 
				MaxCh5L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"10") else
            MaxCh5L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"11") else
            MaxCh5R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"12") else
            MaxCh5R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"13") else              
            MaxCh6L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"14") else
            MaxCh6L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"15") else 
            MaxCh6R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"16") else
            MaxCh6R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"17") else 
				MaxCh7L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"18") else
            MaxCh7L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"19") else
            MaxCh7R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1A") else
            MaxCh7R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1B") else              
            MaxCh8L(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1C") else
            MaxCh8L(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1D") else 
            MaxCh8R(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1E") else
            MaxCh8R(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"1F") else 
				MaxAudioOutL(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"20") else
            MaxAudioOutL(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"21") else
            MaxAudioOutR(15 downto 8 )when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"22") else
            MaxAudioOutR(7 downto 0 ) when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) = ADDR_VU_Start+x"23");            

--process(iFPRdPrep,iFPSpiAddress(7 downto 0))
--begin
--	if(rising_edge(iFPRdPrep)) then
--		if(iFPSpiAddress(7 downto 0)    =  ADDR_Corr_Start) then
--			iCorrInFP <=  iCorrelation0; 
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"01")) then
--			iCorrInFP <=  iCorrelation1; 
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"02")) then
--			iCorrInFP <=  iCorrelation2;
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"03")) then
--			iCorrInFP <=  iCorrelation3;
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"04")) then
--			iCorrInFP <=  iCorrelation4; 
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"05")) then
--			iCorrInFP <=  iCorrelation5; 
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"06")) then
--			iCorrInFP <=  iCorrelation6; 
--		elsif(iFPSpiAddress(7 downto 0) = (ADDR_Corr_Start + x"07")) then
--			iCorrInFP <=  iCorrelation7;
--		end if;
--	end if;
--end process;
  iCorrInFp <= iCorrelation0 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  ADDR_Corr_Start)  else
               iCorrelation1 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"01"))  else
					iCorrelation2 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"02"))  else
					iCorrelation3 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"03")) else
					iCorrelation4 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"04"))  else
					iCorrelation5 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"05"))  else
					iCorrelation6 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"06"))  else
					iCorrelation7 when (iFPRdPrep = '1') and (iFPSpiAddress(7 downto 0) =  (ADDR_Corr_Start+x"07"))  else
					(others=>'0');
					
---------------------------------------------------------------------------------------------------------------------------
ch1Config <= B"0000"; --AES
--ch2Config <= "0001"; --ANA
ch2Config <= B"0010"; --ANA
ch3Config <= B"0100"; --AOIP1
ch4Config <= B"0101"; --AO1P2
ch5Config <= B"0110"; --AOIP3
ch6Config <= B"0111"; --AOIP4
ch7Config <= B"1100"; --arm sdi
ch8Config <= B"1111";--NULL
--ch1Config <= "0000" when (iChType(0) = B"0000") and (iChNum(0) = B"0000") else   ---AES(0)
--             "0001" when (iChType(0) = B"0000") and (iChNum(0) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(0) = B"0000") and (iChNum(0) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(0) = B"0000") and (iChNum(0) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(0) = B"0001") and (iChNum(0) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(0) = B"0001") and (iChNum(0) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(0) = B"0001") and (iChNum(0) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(0) = B"0001") and (iChNum(0) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(0) = B"0010") and (iChNum(0) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(0) = B"0010") and (iChNum(0) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(0) = B"0010") and (iChNum(0) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(0) = B"0010") and (iChNum(0) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(0) = B"0011") else                          	---Internal Music
--				 "1111";
--
--ch2Config <= "0000" when (iChType(1) = B"0000") and (iChNum(1) = B"0000") else   ---AES(0)
--             "0001" when (iChType(1) = B"0000") and (iChNum(1) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(1) = B"0000") and (iChNum(1) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(1) = B"0000") and (iChNum(1) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(1) = B"0001") and (iChNum(1) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(1) = B"0001") and (iChNum(1) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(1) = B"0001") and (iChNum(1) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(1) = B"0001") and (iChNum(1) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(1) = B"0010") and (iChNum(1) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(1) = B"0010") and (iChNum(1) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(1) = B"0010") and (iChNum(1) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(1) = B"0010") and (iChNum(1) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(1) = B"0011") else                          	---Internal Music
--				 "1111";
--				 
--ch3Config <= "0000" when (iChType(2) = B"0000") and (iChNum(2) = B"0000") else   ---AES(0)
--             "0001" when (iChType(2) = B"0000") and (iChNum(2) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(2) = B"0000") and (iChNum(2) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(2) = B"0000") and (iChNum(2) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(2) = B"0001") and (iChNum(2) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(2) = B"0001") and (iChNum(2) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(2) = B"0001") and (iChNum(2) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(2) = B"0001") and (iChNum(2) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(2) = B"0010") and (iChNum(2) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(2) = B"0010") and (iChNum(2) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(2) = B"0010") and (iChNum(2) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(2) = B"0010") and (iChNum(2) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(2) = B"0011") else                          	---Internal Music
--				 "1111";	
--ch4Config <= "0000" when (iChType(3) = B"0000") and (iChNum(3) = B"0000") else   ---AES(0)
--             "0001" when (iChType(3) = B"0000") and (iChNum(3) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(3) = B"0000") and (iChNum(3) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(3) = B"0000") and (iChNum(3) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(3) = B"0001") and (iChNum(3) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(3) = B"0001") and (iChNum(3) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(3) = B"0001") and (iChNum(3) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(3) = B"0001") and (iChNum(3) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(3) = B"0010") and (iChNum(3) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(3) = B"0010") and (iChNum(3) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(3) = B"0010") and (iChNum(3) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(3) = B"0010") and (iChNum(3) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(3) = B"0011") else                          	---Internal Music
--				 "1111";	
--ch5Config <= "0000" when (iChType(4) = B"0000") and (iChNum(4) = B"0000") else   ---AES(0)
--             "0001" when (iChType(4) = B"0000") and (iChNum(4) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(4) = B"0000") and (iChNum(4) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(4) = B"0000") and (iChNum(4) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(4) = B"0001") and (iChNum(4) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(4) = B"0001") and (iChNum(4) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(4) = B"0001") and (iChNum(4) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(4) = B"0001") and (iChNum(4) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(4) = B"0010") and (iChNum(4) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(4) = B"0010") and (iChNum(4) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(4) = B"0010") and (iChNum(4) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(4) = B"0010") and (iChNum(4) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(4) = B"0011") else                          	---Internal Music
--				 "1111";
--ch6Config <= "0000" when (iChType(5) = B"0000") and (iChNum(5) = B"0000") else   ---AES(0)
--             "0001" when (iChType(5) = B"0000") and (iChNum(5) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(5) = B"0000") and (iChNum(5) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(5) = B"0000") and (iChNum(5) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(5) = B"0001") and (iChNum(5) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(5) = B"0001") and (iChNum(5) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(5) = B"0001") and (iChNum(5) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(5) = B"0001") and (iChNum(5) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(5) = B"0010") and (iChNum(5) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(5) = B"0010") and (iChNum(5) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(5) = B"0010") and (iChNum(5) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(5) = B"0010") and (iChNum(5) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(5) = B"0011") else                          	---Internal Music
--				 "1111";	
--				 
--ch7Config <= "0000" when (iChType(6) = B"0000") and (iChNum(6) = B"0000") else   ---AES(0)
--             "0001" when (iChType(6) = B"0000") and (iChNum(6) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(6) = B"0000") and (iChNum(6) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(6) = B"0000") and (iChNum(6) = B"0011") else   ---AES(3)
--				 
--				 "0100" when (iChType(6) = B"0001") and (iChNum(6) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(6) = B"0001") and (iChNum(6) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(6) = B"0001") and (iChNum(6) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(6) = B"0001") and (iChNum(6) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(6) = B"0010") and (iChNum(6) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(6) = B"0010") and (iChNum(6) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(6) = B"0010") and (iChNum(6) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(6) = B"0010") and (iChNum(6) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(6) = B"0011") else                          	---Internal Music
--				 "1111";
--				 
--ch8Config <= "0000" when (iChType(7) = B"0000") and (iChNum(7) = B"0000") else   ---AES(0)
--             "0001" when (iChType(7) = B"0000") and (iChNum(7) = B"0001") else   ---AES(1)
--				 "0010" when (iChType(7) = B"0000") and (iChNum(7) = B"0010") else   ---AES(2)
--				 "0011" when (iChType(7) = B"0000") and (iChNum(7) = B"0011") else   ---AES(3)
--				
--				 "0100" when (iChType(7) = B"0001") and (iChNum(7) = B"0000") else   ---AOIP(0)
--				 "0101" when (iChType(7) = B"0001") and (iChNum(7) = B"0001") else   ---AOIP(1)
--				 "0110" when (iChType(7) = B"0001") and (iChNum(7) = B"0010") else   ---AOIP(2)
--				 "0111" when (iChType(7) = B"0001") and (iChNum(7) = B"0011") else	---AOIP(3)
--				 
--				 "1000" when (iChType(7) = B"0010") and (iChNum(7) = B"0000") else	---MADI(0)
--				 "1001" when (iChType(7) = B"0010") and (iChNum(7) = B"0001") else	---MADI(1)
--				 "1010" when (iChType(7) = B"0010") and (iChNum(7) = B"0010") else	---MADI(2)
--				 "1011" when (iChType(7) = B"0010") and (iChNum(7) = B"0011") else	---MADI(3)
--				 "1100" when (iChType(7) = B"0011") else                          	---Internal Music
--				 "1111";				 
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---ArmRead_module
--iDataToArm    <=
---------------------------------------------------------------------------------------------------------------
---FP_Read_module
--iDataToFP     <= 
------------------------------------------------------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------------------					  
process(SaveCe)
begin
	if (rising_edge(SaveCe)) then
				irootToDivider <= root(40 downto 9);
				if (root(40 downto 9) = B"0000_0000_0000_0000_0000_0000_0000_0000") then
					irootToDivider <= B"0000_0000_0000_0000_0000_0000_0000_0001";
				end if;
	end if;
end process;

ixySumToDivider <= xysum(40 downto 9);

		 
divid_inst: divider
				port map
				(
					clk => MCLK,
					ce  => SaveCe,
					sclr => po_clr,
					rfd  => open,
					dividend => ixySumToDivider,
					divisor =>  irootToDivider,
					quotient(31 downto 8) => open,
					quotient(7 downto 0) => iresult(15 downto 8),
					fractional => iresult(7 downto 0)
				);
---------------------------------------------------------------------
process(divide_ok,CorrelationCh,iresult)
variable itempBuff : std_logic_vector(7 downto 0);
begin
		if(rising_edge(divide_ok)) then
			if(iresult(15 downto 8) = x"01") then
				itempBuff := x"7f";
			elsif(iresult(15 downto 8) = x"ff") then
				itempBuff := x"81";
			else
				itempBuff := iresult(7 downto 0);
			end if;
			-------------------------------------
			if(CorrelationCh = B"000") then
				iCorrelation0 <= itempBuff;
			elsif(CorrelationCh= B"001") then
				iCorrelation1 <= itempBuff;
			elsif(CorrelationCh = B"010") then
				iCorrelation2 <= itempBuff;
			elsif(CorrelationCh = B"011") then
				iCorrelation3 <= itempBuff;
			elsif(CorrelationCh = B"100") then
				iCorrelation4 <= itempBuff;
			elsif(CorrelationCh = B"101") then
				iCorrelation5 <= itempBuff;
			elsif(CorrelationCh = B"110") then
				iCorrelation6 <= itempBuff;
			elsif(CorrelationCh = B"111") then
				iCorrelation7 <= itempBuff;
			end if;
			-----------------------------------		
		end if;
end process;


--------------------------------------------------------------------------------------
	
end Behavioral;

