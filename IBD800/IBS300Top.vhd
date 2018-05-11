----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:09 07/07/2016 
-- Design Name: 
-- Module Name:    IBS300Top - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity IBS300Top is
    Port ( 
	        nFpgaReset : in  STD_LOGIC;                        --Reset input , low level active
           AudioIn : in  STD_LOGIC_VECTOR (7 downto 0);       --AES3 or analog audio input, total 8 stereo channels. 
			  AudioOut : out std_logic_vector(7 downto 0);       --AES3 or ananlog audio output,total 8 stereo channels.
           ADMclk1 : out  STD_LOGIC;                          --Mclk to AD/DA modules, the first 4 stereo channels.
           ADMclk2 : out  STD_LOGIC;                          --Mclk to AD/DA modules, the last 4 stereo channels. IBS300 reseverd
           ADBclk1 : out  STD_LOGIC;                          --Bclk to AD/DA
           ADBclk2 : out  STD_LOGIC;                          --IBS300 reserved
           ADFsclk1 : out  STD_LOGIC;                          --Fsclk to AD/DA 
           --ADFsclk2 : out  STD_LOGIC;                          --IBS300 reserved
			  
			  FsclkToDSP : out std_logic;                        --Fsclk to DSP 
			  BclkToDSP  : out std_logic_vector(3 downto 0);     --Bclk to DSP
			  MCLKToDSP  : out std_logic;                        --Mclk to DSP
			  IISToDSP 	 : out std_logic_vector(3 downto 0);     --Data to DSP 
			  IISFromDSP : IN std_logic_vector(3 downto 0);      --Data from DSP
			  DSP_RSTn   : out std_logic;                        --Dsp Reset signal
			   
			  FPGA2_SPI_SDI  : in std_logic;                     --ARM spi communication interface, Data in
 			  FPGA2_SPI_CSn  : in std_logic;                     --ARM spi chip select,fpga is in slave mode
			  FPGA2_SPI_CLK  : in std_logic;                     --ARM spi clock
			  FPGA2_SPI_SDO  : out std_logic;                    --ARM spi data out
			  
			--  ArmIISMclk : out std_logic;                        --ARM IIS monitor interface ,FPGA is in master mode 
			  ArmIISMclk : out std_logic;                        --ARM IIS monitor interface ,FPGA is in master mode 
			  ArmIISBclk : out std_logic;                        --ARM iis bclk output
			  ArmIISFsclk : out std_logic;                       --ARM iis fsclk output
			  ArmIISSDI   : out std_logic;                        --ARM iis sdin, internal backup music 
			  ArmIISSDO   : in std_logic;                         --ARM iis sdout, to ARM aoip
			   
			  DanteSDIN  : out std_logic_vector(7 downto 0);      --IIS Data from Dante, IBS300 use the first 4 stereo channels
			  DanteSDOUT : in std_logic_vector(7 downto 0);       --IIS Data to Dante, IBS300 use the first 2 stereo channels
			  MuteIn     : in std_logic;                          --Dante Mute out signal
			  
			  GPI        : in std_logic_vector(7 downto 0);      --8 GPI  
			  GPO        : out std_logic_vector(7 downto 0);     --8 GPO
			  FPGA_MclkIn : in std_logic;                        --Mclk From Dante  24.576Mhz
			  FPGA_BclkIn : in std_logic;                        --Bclk From Dante  3.072Mhz-24.576Mhz, according to the Broklyn II
			  FPGA_FsclkIn : in std_logic;                       --Fsclk From Dante 48Khz
			  MADI_Mclk    : out std_logic;                      --Mclk to MADI FPGA
			  MADI_Fsclk   : out std_logic;                      --FSCLK to MADI fpga
			  MADI_Bclk    : out std_logic;                      --Bclk to MADI fpga
			  MADI_Data    : in std_logic_vector(3 downto 0);    --Madi Data input    4 stereo 
			  MADI_SEL     : out std_logic_vector(5 downto 0);   --Madi select pins 
			  
			  RERRA     : in std_logic_vector(7 downto 0);       --AES3 unlock indicator, IBS300 use the first 2 
		  
			  MonitorFs : out std_logic;     						  -- Fsclk To AIC23B
			  MonitorBclk : out std_logic;   						  -- Bclk to AIC23B
			  MonitorMclk : out std_logic;   						  -- main clk to AIC23B
			  MonitorSDI  : out std_logic;   						  -- Data output to AIC23B
			  
			  M3v3_CK   : in std_logic;                          --main power status check
			  S3v3_CK   : in std_logic;                          --slave power status check
			  Led_MP    : out std_logic;                         --main power led indicator
			  Led_SP    : out std_logic;                         --slave power led indicator
			  Led_work  : out std_logic;                         --arm led work indicator
			  Led_fail  : out std_logic;                         --Dante initial success indicator
			  FP_spi_SDI : in std_logic;       	                 --Front pannel spi communicator interface, fpga is in slave mode
			  FP_spi_SDO : out std_logic;                        --Front pannel spi data out
			  FP_spi_cs  : in std_logic;                         --Front pannel spi chip select
			  FP_spi_clk : in std_logic;                         --Front pannel spi clock
			  FP_ResetIn : in std_logic;                         --Reset the fpga 
			  FP_CHK_FPGA : out std_logic;                       --wait for fpga load programe down
			  
			  DanteFsOut    : out std_logic;                        --为了检测Dante模块的时钟是否存在
           DanteCheck  : in std_logic;                        --位时钟峰值检测之后的检测端，如果高电平表示Dante模块存在，低电平表示Dante模块不存在 
           CLK24576M  : in std_logic;			                 --外部有源晶振，当有Dante模块时使用Dante主时钟，当没有Dante模块时使用此时钟。
			  
			  FPGA_led : out std_logic;                           --FPGA test led
			  TQ_5	  : out std_logic   
			  
			  );
end IBS300Top;
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
architecture Behavioral of IBS300Top is
COMPONENT CLKGEN
	PORT(
		rst : IN std_logic;
		DanteMclkpad : IN std_logic;
		DanteBclkpad : IN std_logic;
		DanteFsclkpad : IN std_logic;
		ExtMclkInpad : IN std_logic;
		DanteClkCheckpad : IN std_logic;          
		DanteFsOutpad : OUT std_logic;
		ADMclk1pad : OUT std_logic;
		ADBclk1pad : OUT std_logic;
		ADFsclk1pad : OUT std_logic;
		ADMclk2pad : OUT std_logic;
		ADBclk2pad : OUT std_logic;
		ADFsclk2pad : OUT std_logic;
		ArmMclkpad : OUT std_logic;
		ArmBclkpad : OUT std_logic;
		ArmFsclkpad : OUT std_logic;
		GArmBclk       : out STD_LOGIC;
		monitorMclkpad : OUT std_logic;
		monitorBclkpad : OUT std_logic;
		monitorFsclkpad : OUT std_logic;
		MadiMclkpad : OUT std_logic;
		MadiBclkpad : OUT std_logic;
		MadiFsclkpad : OUT std_logic;
		DspMclkpad : OUT std_logic;
		DspBclkpad : OUT std_logic;
		DspFsclkpad : OUT std_logic;
		GSysMclk : OUT std_logic;
		GSysBclk : OUT std_logic;
		GSysFsclk : OUT std_logic;
    --  GArmMclk  : out STD_LOGIC;
		led500mspad : OUT std_logic
		);
	END COMPONENT;

--COMPONENT CLKGEN is
--    Port ( 
--			  rst        : in  STD_LOGIC;
--           DanteMclk  : in  STD_LOGIC;
--			  DanteBclk  : in  STD_LOGIC;
--           DanteFsclk : in  STD_LOGIC;
--			
--			  ExtMclkIn     : in std_logic;
--			  DanteClkCheck : in std_logic;	
--           DanteFsOut    : out std_logic;			  
--          
--			  ADMclk1    : out STD_LOGIC;
--			  ADMclk2    : out STD_LOGIC;
--			  MCLKToDSP  : out std_logic;
--			  ArmIISMclk : out std_logic;
--			  MadiMclk   : out std_logic;
--			  MonitorMclk : out std_logic;
--			  
--			  ADBclk1    : out std_logic;
--			  ADBclk2    : out std_logic;
--			  BclkToDSP  : out std_logic;
--			  ArmIISBclk : out std_logic;
--			  MadiBclk   : out std_logic;
--			  MonitorBclk : out std_logic;
--			  
--			  ADFsclk1    : out std_logic;
--			  ADFsclk2    : out std_logic;
--			  FsclkToDSP  : out std_logic;
--			  ArmIISFsclk : out std_logic;
--			  MadiFsclk   : out std_logic;
--			  MonitorFsclk : out std_logic;
--			  clock500ms   : out std_logic
--			);
--end COMPONENT;

COMPONENT ChannelConfig is
    Port ( AES3_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           AOIP_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           MADI_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           Music_In : in  STD_LOGIC;
           Ch1Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch2Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch3Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch4Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch5Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch6Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch7Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch8Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           ChOut : out  STD_LOGIC_VECTOR (7 downto 0)
          );
end COMPONENT;

COMPONENT  I2S_STP 
    Port ( BITCLK : in  STD_LOGIC;
           FSCLK : in  STD_LOGIC;
           Audio : in  STD_LOGIC_VECTOR (7 downto 0);
			  SelAudio : in std_logic;
           ch1_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch2_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch3_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch4_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rd : out  STD_LOGIC_VECTOR (15 downto 0);
			  ch5_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch6_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch7_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch8_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rd : out  STD_LOGIC_VECTOR (15 downto 0);
			  SelAudioLP : out std_logic_vector(15 downto 0);
			  SelAudioRP : out std_logic_vector(15 downto 0)
			  );
 END COMPONENT;
 
COMPONENT MeasureTop
 PORT(
			FSCLK       : IN   STD_LOGIC;
			BITCLK      : IN   STD_LOGIC;
			rst         : IN   STD_LOGIC;
			
			ch1_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch1_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch2_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch2_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch3_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch3_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch4_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch4_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch5_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch5_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch6_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch6_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch7_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch7_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);
			ch8_ld      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);	
			ch8_rd      : IN   STD_LOGIC_VECTOR(15 DOWNTO 0);	
			
			ch9_ld      : in std_logic_vector(15 downto 0);
			ch9_rd      : in std_logic_vector(15 downto 0);
			
			MaxCh1L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh1R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);

			MaxCh2L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh2R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh3L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh3R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh4L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh4R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh5L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh5R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh6L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh6R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh7L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh7R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh8L       : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			MaxCh8R      : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			MaxCh9L      : out std_logic_vector(15 downto 0);
			MaxCh9R      : out std_logic_vector(15 downto 0);
			
			MaxStore    : OUT STD_LOGIC
	  );
 END COMPONENT;
 
COMPONENT MeterCheck is
    Port (  testOut : std_logic;
	        Reset : in  STD_LOGIC; 
			  clock : in std_logic;
	        iMaxLoad : in std_logic;
				MaxCh1L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh1R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh2L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh2R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh3L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh3R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh4L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh4R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh5L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh5R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh6L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh6R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh7L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh7R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh8L       : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
				MaxCh8R      : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			  VuThresh : in std_logic_vector(15 downto 0);
           VuCheckResult : out  STD_LOGIC_VECTOR (15 downto 0)
         );
end COMPONENT;

--COMPONENT AutoSwitchModule is
--    Port ( MCLK : in std_logic;
--	        reset : in std_logic;
--			  VuStatusIn : in  STD_LOGIC_VECTOR (15 downto 0);
--           Clock500ms : in  STD_LOGIC;    -- 0.5s at least
--			  AutoSwitchEn : in std_logic;
--			  AutoReturnEn : in std_logic;
--			  TimeSwitchThrd : in std_logic_vector(7 downto 0); -- 5-60s
--			  TimeReturnThrd : in std_logic_vector(7 downto 0); -- 5-60s
--			  CurrentChannel : in std_logic_vector(2 downto 0); -- 1-8
--           ChangeFlag : out Std_logic;
--			  Counter14: out std_logic_vector(7 downto 0); ---test
--			  Counter15: out std_logic_vector(7 downto 0); ---test
--			  NewChannel : out std_logic_vector(2 downto 0)
--			);
--end COMPONENT;
COMPONENT CorrelationTop
    Port ( rst : in  STD_LOGIC;
           MCLK : in  STD_LOGIC;
           fsclk : in  STD_LOGIC;
           bitclk : in  STD_LOGIC;
           ch1_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rd : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  xysum : out STD_LOGIC_VECTOR(40 downto 0);
			  root :  out STD_LOGIC_VECTOR(41 downto 0);
			  CorrelationCh : out STD_LOGIC_VECTOR(2 downto 0);
			  CorrSaveEn : out std_logic;
			  divide_ok  : out std_logic;
			  po_clr : out std_logic
			 );
END COMPONENT;

COMPONENT ListenModule
	PORT(
		rst : IN std_logic;
		AudioIn : IN std_logic_vector(7 downto 0);
		MCLK : IN std_logic;
		Reg_AudioRevert : in std_logic;
		Fsclk : IN std_logic;
		bclk2034 : IN std_logic;
		FPGAI2Sin : IN std_logic;
		bclk3072 : IN std_logic;
		FPSelIn : IN std_logic_vector(2 downto 0);
		ArmSelIn : IN std_logic_vector(3 downto 0);          
		hpout : OUT std_logic;
		FPGAI2Sout : OUT std_logic;
		I2Sinter : OUT std_logic
		);
	END COMPONENT;

COMPONENT CommunicateWithCpu is
    Port ( 
			  MCLK    : in  STD_LOGIC;
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
			  SaveCe : in std_logic;
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
			  TQ_5	  : out std_logic;
			  Reg_AudioRevert: out std_logic
			
		 );
end COMPONENT;

--COMPONENT AudioRevert
--	PORT(
--		mclk : IN std_logic;
--		bitclk : IN std_logic;
--		fsclk : IN std_logic;
--		din : IN std_logic;          
--		dout : OUT std_logic
--		);
--	END COMPONENT;

	
	signal testLed : std_logic := '1';
	signal iResetn : std_logic := '1';
	signal iBclkToDsp : std_logic := '0';
	signal iChSel1 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel2 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel3 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel4 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel5 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel6 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel7 : std_logic_vector(3 downto 0) := B"0000";
	signal iChSel8 : std_logic_vector(3 downto 0) := B"0000";
	signal iChOut : std_logic_vector(7 downto 0) := B"0000_0000";

--	signal iADMclk1 : std_logic := '0';
--	signal iADMclk2 : std_logic := '0';
--	signal iADBclk1 : std_logic := '0';
--	signal iADBclk2 : std_logic := '0';
--	signal iADFsclk1 : std_logic := '0';
--	signal iADFsclk2 : std_logic := '0';
--	signal iArmIISBclk : std_logic :='0';
--	signal iMonitorBclk : std_logic := '0';
--	signal iMonitorFs   : std_logic := '0';
--   signal iArmIISFsclk : std_logic := '0';
	
	signal ich1_ld     : std_logic_vector(15 downto 0);
	signal ich1_rd     : std_logic_vector(15 downto 0);
	signal ich2_ld     : std_logic_vector(15 downto 0);
	signal ich2_rd     : std_logic_vector(15 downto 0);
	signal ich3_ld     : std_logic_vector(15 downto 0);
	signal ich3_rd     : std_logic_vector(15 downto 0);
	signal ich4_ld     : std_logic_vector(15 downto 0);
	signal ich4_rd     : std_logic_vector(15 downto 0);
	signal ich5_ld     : std_logic_vector(15 downto 0);
	signal ich5_rd     : std_logic_vector(15 downto 0);
	signal ich6_ld     : std_logic_vector(15 downto 0);
	signal ich6_rd     : std_logic_vector(15 downto 0);
	signal ich7_ld     : std_logic_vector(15 downto 0);
	signal ich7_rd     : std_logic_vector(15 downto 0);
	signal ich8_ld     : std_logic_vector(15 downto 0);
	signal ich8_rd     : std_logic_vector(15 downto 0);
	signal ich_out_ld  : std_logic_vector(15 downto 0);
	signal ich_out_rd  : std_logic_vector(15 downto 0);
	
	signal iMaxCh1L    : std_logic_vector(15 downto 0);
	signal iMaxCh1R    : std_logic_vector(15 downto 0);
	signal iMaxCh2L    : std_logic_vector(15 downto 0);
	signal iMaxCh2R    : std_logic_vector(15 downto 0);
	signal iMaxCh3L    : std_logic_vector(15 downto 0);
	signal iMaxCh3R    : std_logic_vector(15 downto 0);
	signal iMaxCh4L    : std_logic_vector(15 downto 0);
	signal iMaxCh4R    : std_logic_vector(15 downto 0);
	signal iMaxCh5L    : std_logic_vector(15 downto 0);
	signal iMaxCh5R    : std_logic_vector(15 downto 0);
	signal iMaxCh6L    : std_logic_vector(15 downto 0);
	signal iMaxCh6R    : std_logic_vector(15 downto 0);
	signal iMaxCh7L    : std_logic_vector(15 downto 0);
	signal iMaxCh7R    : std_logic_vector(15 downto 0);
	signal iMaxCh8L    : std_logic_vector(15 downto 0);
	signal iMaxCh8R    : std_logic_vector(15 downto 0);
	signal iMaxCh9L    : std_logic_vector(15 downto 0);
	signal iMaxCh9R    : std_logic_vector(15 downto 0);
	
	signal iMaxStore   : std_logic;
	
--	signal iClock500ms 		: std_logic :='0';
	signal iListenHp   		: std_logic := '0';
	signal iSwitchOut  		: std_logic := '0';
	signal iCurrentChannel  : std_logic_vector(2 downto 0);
	signal iVuThresh   		: std_logic_vector(15 downto 0);
	signal iVuCheck    		: std_logic_vector(15 downto 0);
	signal iTimeSwitchThrd  : std_logic_vector(7 downto 0);
	signal iTimeReturnThrd  : std_logic_vector(7 downto 0);
	signal iAutoSwitchEn,iAutoReturnEn : std_logic;
	signal iFP_ListenCh     : std_logic_vector(2 downto 0);
	signal iArmListenSel    : std_logic_vector(3 downto 0);
	signal iNewChannel      : std_logic_vector(2 downto 0);
   signal iNewChannelFlag  : std_logic;
	signal iMusicSDI : std_logic := '0';
	
	signal ichnb       : std_logic_vector(2 downto 0);
	signal isavece     : std_logic;
	signal idivide_ok  : std_logic;
	signal ipo_clr     : std_logic;
	signal iroot       : std_logic_vector(41 downto 0);
	signal ixysum      : std_logic_vector(40 downto 0);
	signal iTestOut   : std_logic;
	signal iGlobalRst : std_logic;
	signal iCounter14 : std_logic_vector(7 downto 0);
	signal iCounter15 : std_logic_vector(7 downto 0);
--   signal iChange : std_logic := '0';
	signal iReg_AudioRevert  : std_logic;

--	signal iAudioRevertDin   : std_logic;
	--signal iAudioRevertDout   : std_logic;
	signal iSwitchOut_stream   :std_logic_vector(7 downto 0);
   
	
	signal iGSysMclk   		: std_logic := '0';
	signal iGSysBclk  		: std_logic := '0';
	signal iGSysFsclk  		: std_logic := '0';
   signal iGArmBclk  		: std_logic := '0';
	signal iGSysarmMclk  		: std_logic := '0';
	
	       
begin
--****************************************************************************--

--iSwitchOut		 <= iChOut(conv_integer(iCurrentChannel));
--iAudioRevertDin <= iChOut(conv_integer(iCurrentChannel));
--iSwitchOut		 <= iAudioRevertDout when iReg_AudioRevert(conv_integer(iArmListenSel))= '1' else iMusicSDI;
iSwitchOut		 <= iMusicSDI;
AudioOut(0)     <= iSwitchOut_stream(0);
AudioOut(1)     <= iSwitchOut_stream(1);
AudioOut(2)     <= iSwitchOut_stream(2);
AudioOut(3)     <= iSwitchOut_stream(3);
AudioOut(7 downto 4) <= (others=>'0');

Led_work <='0';
Led_fail <= '1';
Led_MP <= not M3v3_CK;
Led_SP <= not S3v3_CK;

IISToDSP <= (others=>'0');
--DanteSDIN <= B"0000" & iSwitchOut & AudioIn(2 downto 0); 
DanteSDIN <= B"0000" & AudioIn(3 downto 0); 

--FPGA_led <= iClock500ms; 
iResetn  <= nFpgaReset;
iGlobalRst <= FP_ResetIn;       ---MCU reset the fpga logic
FP_CHK_FPGA <= '1';

BclkToDSP(0) <=  iBclkToDsp;
BclkToDSP(1) <=  iBclkToDsp;
BclkToDSP(2) <=  iBclkToDsp;
BclkToDSP(3) <=  iBclkToDsp;
DSP_RSTn <= '1';

--ADMclk1 <= iADMclk1;
--ADMclk2 <= iADMclk2;
--ADBclk1 <= iADBclk1; 
--ADBclk2 <= iADBclk2;
--ADFsclk1 <= iADFsclk1;
--ADFsclk2 <= iADFsclk2;

--ArmIISBclk   <= iArmIISBclk; 
--MonitorBclk  <= iMonitorBclk;
--MonitorFs    <= iMonitorFs;
--ArmIISFsclk  <= iArmIISFsclk;

MADI_SEL <= (others=>'0');
ArmIISMclk <=iGSysarmMclk;
----------------------------------------------------------------------
iSwitch_Fanout4 : 
               FOR i IN 4 downto 0 generate
			U0_fan:	FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>iSwitchOut_stream(i),C =>iGSysMclk,CE => '1',CLR => '0',D => iSwitchOut);
					end generate;
----------------------------------------------------------------------
--Clock generator-----------------------------------------------------

Inst_CLKGEN: CLKGEN PORT MAP(
		rst =>iGlobalRst ,
		DanteMclkpad =>  FPGA_MclkIn,
		DanteBclkpad =>  FPGA_BclkIn,
		DanteFsclkpad => FPGA_FsclkIn,
		ExtMclkInpad =>  CLK24576M,
		DanteClkCheckpad => DanteCheck,
		DanteFsOutpad => DanteFsOut,
		ADMclk1pad => ADMclk1,
		ADBclk1pad => ADBclk1,
		ADFsclk1pad => ADFsclk1,
		ADMclk2pad => ADMclk2,
		ADBclk2pad => ADBclk2,
		ADFsclk2pad => open,--ADFsclk2,
		ArmMclkpad => iGSysarmMclk,
		ArmBclkpad => ArmIISBclk,
		ArmFsclkpad => ArmIISFsclk,
		GArmBclk    =>  iGArmBclk,
		monitorMclkpad => MonitorMclk,
		monitorBclkpad => MonitorBclk,
		monitorFsclkpad => MonitorFs,
		MadiMclkpad => MADI_Mclk,
		MadiBclkpad => MADI_Bclk,
		MadiFsclkpad => MADI_Fsclk,
		DspMclkpad => MclkToDSP,
		DspBclkpad => iBclkToDsp,
		DspFsclkpad =>FsclkToDSP,
		GSysMclk => iGSysMclk,
		GSysBclk => iGSysBclk,
		GSysFsclk => iGSysFsclk,
		--GArmMclk  =>iGSysarmMclk,
		led500mspad =>FPGA_led 
	);

----------------------------------------------------------------------
--clockGen_Module: CLKGEN port map
--                (
--						  rst        =>iGlobalRst, 
--						  DanteMclk  =>FPGA_MclkIn,
--						  DanteBclk  =>FPGA_BclkIn,
--						  DanteFsclk =>FPGA_FsclkIn,
--
--						  ExtMclkIn  => CLK24576M,
--						  DanteClkCheck => DanteCheck,
--                    DanteFsOut    => DanteFsOut,	
--						  
--						  ADMclk1    =>iADMclk1,
--						  ADMclk2    =>iADMclk2,
--						  MCLKToDSP  =>MCLKToDSP,
--						  ArmIISMclk =>ArmIISMclk,
--						  MadiMclk   =>MADI_Mclk,
--						  MonitorMclk =>MonitorMclk,
--						  
--						  ADBclk1    =>iADBclk1,
--						  ADBclk2    =>iADBclk2,
--						  BclkToDSP  =>iBclkToDsp,
--						  ArmIISBclk =>iArmIISBclk,
--						  MadiBclk   =>MADI_Bclk,
--						  MonitorBclk =>iMonitorBclk,
--						  
--						  ADFsclk1    =>iADFsclk1,
--						  ADFsclk2    =>iADFsclk2,
--						  FsclkToDSP  =>FsclkToDSP,
--						  ArmIISFsclk =>iArmIISFsclk,
--						  MadiFsclk   =>MADI_Fsclk,
--						  MonitorFsclk =>iMonitorFs,
--						  clock500ms   => iClock500ms
--					 );
-----------------------------------------------------------------------
-----------------------------------------------------------------------
ChannelModule: ChannelConfig 
                   Port map
						 ( 	  
						        AES3_IN => AudioIn(3 downto 0),
								  AOIP_IN => DanteSDOUT(3 downto 0),
								  MADI_IN => MADI_Data,
								  Music_In => iMusicSDI,
								  Ch1Sel   => iChSel1,
								  Ch2Sel   => iChSel2,
								  Ch3Sel   => iChSel3,
								  Ch4Sel   => iChSel4,
								  Ch5Sel   => iChSel5,
								  Ch6Sel   => iChSel6,
								  Ch7Sel   => iChSel7,
								  Ch8Sel   => iChSel8,
								  ChOut    => iChOut
						);
IISToSTP: I2S_STP 
        port map
          ( 
			  BITCLK => iGSysBclk,
           FSCLK  => iGSysFsclk,
           Audio  => iChOut,
			  SelAudio => iSwitchOut_stream(4),
           ch1_ld => ich1_ld,
           ch1_rd => ich1_rd,
           ch2_ld => ich2_ld,
           ch2_rd => ich2_rd,
           ch3_ld => ich3_ld,
           ch3_rd => ich3_rd,
           ch4_ld => ich4_ld,
           ch4_rd => ich4_rd,
			  ch5_ld => ich5_ld,
           ch5_rd => ich5_rd,
           ch6_ld => ich6_ld,
           ch6_rd => ich6_rd,
           ch7_ld => ich7_ld,
           ch7_rd => ich7_rd,
           ch8_ld => ich8_ld,
           ch8_rd => ich8_rd,
			  SelAudioLP => ich_out_ld,
			  SelAudioRP => ich_out_rd
			  );	
VuMeter: MeasureTop
 PORT map(
			FSCLK       => iGSysFsclk,
			BITCLK      => iGSysBclk,
			rst         => not iResetn,
			
         ch1_ld => ich1_ld,
         ch1_rd => ich1_rd,
         ch2_ld => ich2_ld,
         ch2_rd => ich2_rd,
         ch3_ld => ich3_ld,
         ch3_rd => ich3_rd,
         ch4_ld => ich4_ld,
         ch4_rd => ich4_rd,
			ch5_ld => ich5_ld,
         ch5_rd => ich5_rd,
         ch6_ld => ich6_ld,
         ch6_rd => ich6_rd,
         ch7_ld => ich7_ld,
         ch7_rd => ich7_rd,
         ch8_ld => ich8_ld,
         ch8_rd => ich8_rd,
			
			ch9_ld => ich_out_ld,
			ch9_rd => ich_out_rd,
			
			MaxCh1L => iMaxCh1L,
			MaxCh1R => iMaxCh1R,
			MaxCh2L => iMaxCh2L,
			MaxCh2R => iMaxCh2R,
			MaxCh3L => iMaxCh3L,
			MaxCh3R => iMaxCh3R,
			MaxCh4L => iMaxCh4L,
			MaxCh4R => iMaxCh4R,
			MaxCh5L => iMaxCh5L,
			MaxCh5R => iMaxCh5R,
			MaxCh6L => iMaxCh6L,
			MaxCh6R => iMaxCh6R,
			MaxCh7L => iMaxCh7L,
			MaxCh7R => iMaxCh7R,
			MaxCh8L => iMaxCh8L,
			MaxCh8R => iMaxCh8R,
			MaxCh9L => iMaxCh9L,
			MaxCh9R => iMaxCh9R,
			MaxStore => iMaxStore
	  );
MeterCheck_inst: MeterCheck     
          Port map( testOut =>iTestOut,
						  Reset => iGlobalRst, 
						  clock => iGSysMclk,
						  iMaxLoad => iMaxStore,
						  MaxCh1L => iMaxCh1L,
						  MaxCh1R => iMaxCh1R,
						  MaxCh2L => iMaxCh2L,
						  MaxCh2R => iMaxCh2R,
						  MaxCh3L => iMaxCh3L,
						  MaxCh3R => iMaxCh3R,
						  MaxCh4L => iMaxCh4L,
						  MaxCh4R => iMaxCh4R,
						  MaxCh5L => iMaxCh5L,
						  MaxCh5R => iMaxCh5R,
						  MaxCh6L => iMaxCh6L,
						  MaxCh6R => iMaxCh6R,
						  MaxCh7L => iMaxCh7L,
						  MaxCh7R => iMaxCh7R,
						  MaxCh8L => iMaxCh8L,
						  MaxCh8R => iMaxCh8R,
						  
						  VuThresh => iVuThresh,
						  VuCheckResult =>iVuCheck
         );
--SwitchModule_inst:    AutoSwitchModule 
--        Port map ( 
--		     MCLK => iADMclk2,
--			  reset => iGlobalRst,
--			  VuStatusIn => iVuCheck,
--           Clock500ms => iClock500ms,
--			  AutoSwitchEn => iAutoSwitchEn,
--			  AutoReturnEn => iAutoReturnEn,
--			  TimeSwitchThrd => iTimeSwitchThrd,
--			  TimeReturnThrd => iTimeReturnThrd,
--			  CurrentChannel => iCurrentChannel,
--           ChangeFlag => iNewChannelFlag,
--			  Counter14 => iCounter14,
--			  Counter15 => iCounter15,
--			  NewChannel => iNewChannel
--			);
Communication_inst:  CommunicateWithCpu   
   Port map( 
			  MCLK    => iGSysMclk,
			  DanteCheck => DanteCheck,
			  RERRA_1 => RERRA(0),
           RERRB_1 => RERRA(1),
           RERRA_2 => RERRA(2),
			  
           FPGA_GPI => GPI,
           FPGA_GPO => GPO,
			  
			  --testOut => iChange,
				MaxCh1L => iMaxCh1L,
				MaxCh1R => iMaxCh1R,
				MaxCh2L => iMaxCh2L,
				MaxCh2R => iMaxCh2R,
				MaxCh3L => iMaxCh3L,
				MaxCh3R => iMaxCh3R,
				MaxCh4L => iMaxCh4L,
				MaxCh4R => iMaxCh4R,
				MaxCh5L => iMaxCh5L,
				MaxCh5R => iMaxCh5R,
				MaxCh6L => iMaxCh6L,
				MaxCh6R => iMaxCh6R,
				MaxCh7L => iMaxCh7L,
				MaxCh7R => iMaxCh7R,
				MaxCh8L => iMaxCh8L,
				MaxCh8R => iMaxCh8R,
			  
			  MaxAudioOutL => iMaxCh9L,
			  MaxAudioOutR => iMaxCh9R,
			  
           XSPIMOSI1 => FPGA2_SPI_SDI,            --Arm SPI
           XSPIMISO1 => FPGA2_SPI_SDO,
           XSPICSN1  => FPGA2_SPI_CSn,
           XSPICLK1  => FPGA2_SPI_CLK,
			  
			  FP_SPIMOSI => FP_spi_SDI,             --Front pannel SPI interface
			  FP_SPIMISO => FP_spi_SDO,
			  FP_SPICLK  => FP_spi_clk,
			  FP_SPICS   => FP_spi_cs,
			  
			  currentChannel => iCurrentChannel,
			  AutoSwitchEn   => iAutoSwitchEn,
			  AutoReturnEn   => iAutoReturnEn,
			  AutoSwitchTimeThrd => iTimeSwitchThrd,
			  AutoReturnTimeThrd => iTimeReturnThrd,
			  VuThrd             => iVuThresh,
			  FP_ListenCh        => iFP_ListenCh,
			  newChFlag          => iNewChannelFlag,
			  NewChannel         => iNewChannel,
			  
			  M3v3_CK            => M3v3_CK,
			  S3v3_CK            => S3v3_CK,  
			 
           xysum              => ixysum,
			  root               => iroot,
			  CorrelationCh      => ichnb,
			  SaveCe             => isavece,
			  DivideEn 				=> isavece,
			  divide_ok 			=> idivide_ok,
			  po_clr 				=> ipo_clr,
			  
			  Counter14         => iCounter14,
			  Counter15         => iCounter15,
			  
			  ArmListenChSel     => iArmListenSel,
			  ch1Config          => iChSel1,
			  ch2Config          => iChSel2,
			  ch3Config          => iChSel3,
			  ch4Config          => iChSel4,
			  ch5Config          => iChSel5,
			  ch6Config          => iChSel6,
			  ch7Config          => iChSel7,
			  ch8Config          => iChSel8,
			  TQ_5    				=>TQ_5,
			  Reg_AudioRevert    =>iReg_AudioRevert
		 );
----------------------------------------------------	 
CorrelationTop_INST: CorrelationTop
            PORT MAP(
							  rst => not iResetn,
							  MCLK  => iGSysMclk,
							  fsclk => iGSysFsclk,
							  bitclk => iGSysBclk,
							  ch1_ld  => ich1_ld,
							  ch1_rd  => ich1_Rd,
							  ch2_ld  => ich2_ld,
							  ch2_rd  => ich2_Rd,
							  ch3_ld  => ich3_ld,
							  ch3_rd  => ich3_rd,
							  ch4_ld  => ich4_ld,
							  ch4_rd  => ich4_rd,
							  ch5_ld  => ich5_ld,
							  ch5_rd  => ich5_rd,
							  ch6_ld  => ich6_ld,
							  ch6_rd  => ich6_rd,
							  ch7_ld  => ich7_ld,
							  ch7_rd  => ich7_rd,
							  ch8_ld  => ich8_ld,
							  ch8_rd  => ich8_rd,
							  
							  xysum 		    => ixysum,
							  root 		    => iroot,
							  CorrelationCh => ichnb,
							  CorrSaveEn 	 => isavece,
							  divide_ok     => idivide_ok,
							  po_clr 		 => ipo_clr		 

				         );
------------------------------------------------------------
ListenModule_inst : ListenModule 
              port map
				  (  rst     => iResetn,
					  AudioIn => iChOut,
					  MCLK => iGSysarmMclk,
					  Reg_AudioRevert=>iReg_AudioRevert,
--					  CH1L => ich1_ld,
--					  CH1R => ich1_rd,
--					  CH2L => ich2_ld,
--					  CH2R => ich2_rd,
--					  CH3L => ich3_ld,
--					  CH3R => ich3_rd,
--					  CH4L => ich4_ld,
--					  CH4R => ich4_rd,
--					  CH5L => ich5_ld,
--					  CH5R => ich5_rd,
--					  CH6L => ich6_ld,
--					  CH6R => ich6_rd,
--					  CH7L => ich7_ld,
--					  CH7R => ich7_rd,
--					  CH8L => ich8_ld,
--					  CH8R => ich8_rd,
--					  CH9L => ich_out_ld,
--					  CH9R => ich_out_rd,
					  Fsclk =>iGSysFsclk,
					  bclk2034 => iGArmBclk,
					  FPGAI2Sin => ArmIISSDO,
					  bclk3072 => iGSysBclk,			  
					  hpout      => MonitorSDI,
					  FPGAI2Sout     => ArmIISSDI,
					  I2Sinter      => iMusicSDI,
					  FPSelIn     => iFP_ListenCh,
					  ArmSelIn    => iArmListenSel			  
				  );
------------------------------------------------------------
--Inst_AudioRevert: AudioRevert PORT MAP(
--		mclk =>   iGSysMclk,
--		bitclk => iGSysBclk,
--		fsclk =>  iGSysFsclk,
--		din =>    iMusicSDI,
--		dout =>   iAudioRevertDout
--	);
end Behavioral; 

