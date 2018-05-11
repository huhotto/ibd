----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:14:18 07/14/2016 
-- Design Name: 
-- Module Name:    Spi - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Spi is
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
end Spi;

architecture Behavioral of Spi is

	signal iSPICounter : integer range 0 to 24; 
	signal iDataToCpu : std_logic_vector(7 downto 0);
	signal iSpiDataFromCpu : std_logic_vector(23 downto 0);
	signal iAddrSetByCpu : std_logic_vector(7 downto 0);
	signal iSpiRvEn  : std_logic_vector(23 downto 0);
	signal iCsFallingEdge : std_logic;
	signal iCsRisingEdge : std_logic;
	signal iCSStage1 : std_logic;
	signal iCSStage2: std_logic;
	signal iAddress : std_logic_vector(15 downto 0);
	signal iRdPrep : std_logic :='0';
	signal iSpiClk : std_logic := '0';
	signal iSpiMOSI : std_logic := '0';
begin
----------------------------------------------------------------------------------------------------
process(MCLK,SpiCs,iSPICounter,iSpiDataFromCpu(7 downto 0)) 
begin
	if(rising_edge(MCLK)) then
		if((iSPICounter = 24) and (SpiCs = '0')) then
			DataOut <= iSpiDataFromCpu(7 downto 0);    
		end if;
	end if;
end process;
-----------------------------------------------------------------------------------------------------
iDataToCpu <= DataIn when iRdPrep = '1';
RdPrep  <= iRdPrep;
RdWrn   <= iAddress(15);				
Address(14 downto 0) <= iAddress(14 downto 0); ----the MSB of address is RD/WRn  bit
Address(15) <= '0';
FallingSPICsn <= iCsFallingEdge;
RisingSPICsn  <= iCsRisingEdge;
---------------------------------------------------------------------------------------------------------------------------
FDCE_SPICLK_SYNC: FDCE
                generic map(INIT =>'0')
                PORT MAP(Q =>iSpiClk,C=>not MCLK,CE=>'1',CLR =>'0',D=>SpiClk);
FDCE_SPIMO_SYNC: FDCE
                generic map(INIT =>'0')
                PORT MAP(Q =>iSpiMOSI,C=> not MCLK,CE=>'1',CLR =>'0',D=>SpiMOSI);					 
---------------------------------------------------------------------------------------------------------------------------			
SPIInput_inst : 
               FOR i IN 23 downto 0 generate
  SPI1FromCpu:		FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>iSpiDataFromCpu(i),C =>iSpiClk,CE => iSpiRvEn(i),CLR => iCsFallingEdge,D => iSpiMOSI);
					end generate;
--------------------------------------------------------------------------------------------------------------------------
	Process(iCsFallingEdge,SpiCS,iSpiClk)
	begin
		if(iCsFallingEdge = '1') then
			iSPICounter <= 0;
		elsif(falling_edge(iSpiClk)) then
			if(SpiCS = '0') then
				iSPICounter <= iSPICounter + 1;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------------------------------------------
CS_Edge_inst0: FDCE
			generic map(INIT => '0')
         port map(Q => iCSStage1,C => MCLK, CE=>'1',CLR =>'0', D => SpiCS);
CS_Edge_inst1: FDCE
			generic map(INIT => '0')
         port map(Q => iCSStage2,C => MCLK, CE=>'1',CLR =>'0', D => iCSStage1);
iCsFallingEdge <= (iCSStage2 and (not iCSStage1) );
iCsRisingEdge  <= ((not iCSStage2) and iCSStage1 );			
------------------------------------------------------------------------------------------------------------------
SpiMISO  <= iDataToCpu(23-iSPICounter) when ((iSPICounter < 24) and (SpiCs = '0'));
------------------------------------------------------------------------------------------------------------------
process(MCLK,iSPICounter,SpiCS,iSpiDataFromCpu)
begin
	if(rising_edge(MCLK)) then
		if((iSPICounter >= 16) and (SpiCS = '0')) then
			iRdPrep  <= iSpiDataFromCpu(23);
		else
			iRdPrep <= '0';
      end if;
   end if;
end process;	
--------------------------------------------------------------
process(MCLK,iSPICounter,SpiCS,iSpiDataFromCpu)
begin
	if(rising_edge(MCLK)) then
		if((iSPICounter >= 16) and (SpiCS = '0')) then
			iAddress  <= iSpiDataFromCpu(23 downto 8);
      end if;
   end if;
end process;
-----------------------------------------------------------------------------------------------------------------
iSpiRvEn <=  x"800000" when iSPICounter = 0 else
             x"400000" when iSPICounter = 1 else
             x"200000" when iSPICounter = 2 else
             x"100000" when iSPICounter = 3 else
             x"080000" when iSPICounter = 4 else				 
             x"040000" when iSPICounter = 5 else
             x"020000" when iSPICounter = 6 else
             x"010000" when iSPICounter = 7 else
             x"008000" when iSPICounter = 8 else
             x"004000" when iSPICounter = 9 else
             x"002000" when iSPICounter = 10 else				 
             x"001000" when iSPICounter = 11 else
             x"000800" when iSPICounter = 12 else
             x"000400" when iSPICounter = 13 else
             x"000200" when iSPICounter = 14 else
             x"000100" when iSPICounter = 15 else
             x"000080" when iSPICounter = 16 else				 
             x"000040" when iSPICounter = 17 else
             x"000020" when iSPICounter = 18 else
             x"000010" when iSPICounter = 19 else
             x"000008" when iSPICounter = 20 else
             x"000004" when iSPICounter = 21 else
             x"000002" when iSPICounter = 22 else				 
             x"000001" when iSPICounter = 23 else
				 x"000000";

end Behavioral;

