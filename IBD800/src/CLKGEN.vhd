----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:15:53 07/25/2015 
-- Design Name: 
-- Module Name:    CLKGEN - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.


entity CLKGEN is
    Port ( 
			  rst        : in  STD_LOGIC;
           DanteMclkpad  : in  STD_LOGIC;
			  DanteBclkpad  : in  STD_LOGIC;
           DanteFsclkpad : in  STD_LOGIC;
			
			  ExtMclkInpad     : in std_logic;
			  DanteClkCheckpad : in std_logic;	
           DanteFsOutpad    : out std_logic;			  
          
			  ADMclk1pad    : out STD_LOGIC;
			  ADBclk1pad    : out STD_LOGIC;
			  ADFsclk1pad   : out STD_LOGIC;
			  
			  ADMclk2pad    : out STD_LOGIC;
			  ADBclk2pad    : out STD_LOGIC;
			  ADFsclk2pad   : out STD_LOGIC;
			  
			  ArmMclkpad    : out STD_LOGIC;
			  ArmBclkpad    : out STD_LOGIC;
			  ArmFsclkpad   : out STD_LOGIC;
			  GArmBclk       : out STD_LOGIC;
			  
			  monitorMclkpad    : out STD_LOGIC;
			  monitorBclkpad    : out STD_LOGIC;
			  monitorFsclkpad   : out STD_LOGIC;
			  
			  MadiMclkpad    		: out STD_LOGIC;
			  MadiBclkpad    		: out STD_LOGIC;
			  MadiFsclkpad   		: out STD_LOGIC;
			  
			  DspMclkpad    		   : out STD_LOGIC;
			  DspBclkpad   	      : out STD_LOGIC;
			  DspFsclkpad  		   : out STD_LOGIC;
			  
			  GSysMclk    		  		: out STD_LOGIC;
			  GSysBclk  	      	: out STD_LOGIC;
			  GSysFsclk  		   	: out STD_LOGIC;
			 -- GArmMclk              : out STD_LOGIC;
			  led500mspad  			: out std_logic
			);
end CLKGEN;

architecture Behavioral of CLKGEN is
component EDGEDETECT 
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end component;


		signal iDanteMclk : std_logic := '0';
		signal iDanteBclk : std_logic := '0';
		signal iDanteFsclk : std_logic := '0';
		--signal iDante12288 : std_logic := '0';
		
		signal iExtMclk :  std_logic := '0';
		signal iExt18432 : std_logic := '0';
		signal iExt12288 : std_logic := '0';
		signal iExt3072: 	 std_logic := '0';
		signal iExt48: 	 std_logic := '0';
		
		signal iArmMclk : std_logic := '0';
		signal iArmBclk : std_logic := '0';
		signal iArmFsclk : std_logic := '0';
		
		signal isysMclk : std_logic := '0';
		signal isysBclk : std_logic := '0';
		signal isysFsclk : std_logic := '0';
		
		signal isysFsEdge : std_logic := '0';
		
		signal currlrclk : std_logic := '0';
		
		signal iled500ms : std_logic := '0';
		
		signal iiArmBclk : std_logic := '0';
		signal iiiArmBclk : std_logic := '0';
	

  ---------------------DCM--------------------------
	--	signal clkin1            : std_logic;
	  -- Output clock buffering
	  signal clkfb             : std_logic;
	
	  signal status_internal   : std_logic_vector(7 downto 0);
	  signal dcmsrcclk          : std_logic;
	  signal dcmrst             :std_logic := '0';
	  signal dcmrstshiftreg   	 : std_logic_vector(15 downto 0);
	  
begin
-----------------------------DCM------------------------------------------
iExtMclk_buf : IBUFG
  port map
   (O => iExtMclk,
    I => ExtMclkInpad);

---------------------------selelct dcm src clk---------------------------------

dcmsrcclk <=  iExtMclk  when DanteClkCheckpad = '0' else   
				  iDanteMclk;
----------------------------when change clk rst dcm-----------------------------
process(rst,iExtMclk)
begin
	if(rst='0')then
			dcmrst <='1';
			dcmrstshiftreg <= B"0000_0000_0000_0001";
	elsif(rising_edge(iExtMclk)) then
				dcmrstshiftreg <= dcmrstshiftreg(14 downto 0) & DanteClkCheckpad;
				if((dcmrstshiftreg =B"0000_0000_0000_0000") or (dcmrstshiftreg =B"1111_1111_1111_1111"))then
					dcmrst <='0';
				else 	
					dcmrst <='1';
				end if; 	
	end if; 
end process; 
------------------------------------------------------------------------------
  -- Clocking primitive
  --------------------------------------
  
  -- Instantiation of the DCM primitive
  --    * Unused inputs are tied off
  --    * Unused outputs are labeled unused
  dcm_sp_inst: DCM_SP
  generic map
   (CLKDV_DIVIDE          => 4.000,
    CLKFX_DIVIDE          => 2,
    CLKFX_MULTIPLY        => 3,
    CLKIN_DIVIDE_BY_2     => TRUE,
    CLKIN_PERIOD          => 40.69,
    CLKOUT_PHASE_SHIFT    => "NONE",
    CLK_FEEDBACK          => "1X",
    DESKEW_ADJUST         => "SYSTEM_SYNCHRONOUS",
    PHASE_SHIFT           => 0,
    STARTUP_WAIT          => FALSE)
  port map
   -- Input clock
   (CLKIN                 => dcmsrcclk,
    CLKFB                 => clkfb,
    -- Output clocks
    CLK0                  => iExt12288,
    CLK90                 => open,
    CLK180                => open,
    CLK270                => open,
    CLK2X                 => open,
    CLK2X180              => open,
    CLKFX                 => iExt18432,
    CLKFX180              => open,
    CLKDV                 => iExt3072,
   -- Ports for dynamic phase shift
    PSCLK                 => '0',
    PSEN                  => '0',
    PSINCDEC              => '0',
    PSDONE                => open,
   -- Other control and status signals
    LOCKED                => open,
    STATUS                => status_internal,
    RST                   => dcmrst,
   -- Unused pin, tie low
    DSSEN                 => '0');

 -- Output buffering
  -------------------------------------
 clkf_buf : BUFG
  port map
   (O => clkfb,
    I => iExt12288);
---------------Arm listen bitclk 48K*48=2.304----------iarmckk= 2.304*8=18.432mhz---------------------------
--armsynsfs : EDGEDETECT 
--    Port map(
--			  BITCLOCK => isysMclk,
--           FSCLOCK  => isysFsclk,
--           EDGE     => isysFsEdge,
--			  RISEDGE  => open
--			);

process(isysFsclk,iExt18432)
variable counter : integer range 0 to 3 := 0;
begin
	if(rising_edge(iExt18432)) then
		if(isysFsclk /= currlrclk) then
			currlrclk <= isysFsclk;
			counter := 0;
			iiiArmBclk <= '1';
		elsif(counter =3) then
				counter := 0;
				iiiArmBclk <= not iiiArmBclk;
		else 	
			counter := counter + 1;		

		end if;
	end if;
end process; 
process(iExt18432)
begin
	if(rising_edge(iExt18432)) then
			iiArmBclk <=iiiArmBclk;
			iArmBclk <=	iiArmBclk;
  	end if;		
end process; 
----------------------Generate 48Khz from external 24.576Mhz---------
process(rst,iExtMclk)-----------------clkin1 = exitmclk via ibufg
variable counter : integer range 0 to 255:= 0;
begin
	if(rst = '0') then
		counter := 0;
		iExt48 <= '0';
	elsif(rising_edge(iExtMclk)) then
		if(counter = 255) then
			counter := 0;
			iExt48 <= not iExt48;
		else
			counter := counter + 1;
		end if;
	end if;
end process;
--------------------------------------------------------------------------
iDanteMclk_buf : IBUFG
  port map
   (O => iDanteMclk,
    I => DanteMclkpad);
	 
--------------------Gen 12.288M from Dante 24.576Mhz-------------------
--process(iDanteMclk,rst)
--begin
--	if(rst = '0') then
--		iDante12288 <= '0';
--	elsif(rising_edge(iDanteMclk)) then
--		iDante12288 <= not iDante12288;
--	end if;
--end process;
------------------------------------------------------------------------
iDanteBclk_buf : IBUFG
  port map
   (O => iDanteBclk,
    I => DanteBclkpad);
iDanteFsclk_buf : IBUFG
  port map
   (O => iDanteFsclk,
    I => DanteFsclkpad);

-----------------------------time select---------------------------------------
----------------------------------------------------------------------------
Danteclkcheck_inst : BUF                     
				PORT MAP
				(
					I => iDanteFsclk,
					O => DanteFsOutpad
				);
isysMclk <=  iExt12288;--dcm out 12288 
--isysMclk <=  iExt12288  when DanteClkCheckpad = '0' else   
--		    iDante12288;
			 
isysBclk <=  iExt3072  when DanteClkCheckpad = '0' else   
		    iDanteBclk;
			 
isysFsclk <=  iExt48  when  DanteClkCheckpad = '0' else   
		    iDanteFsclk;
			 
--------------------outputpad--------------------------------------
-------------------------GSYS-------------------------------------
sys_INST1: BUFG
            port map
				(
					I => isysMclk,
					O => GSysMclk
				);
sys_INST2: BUFG
            port map
				(
					I => isysBclk,
					O => GSysBclk
				);
sys_INST3: BUFG
            port map
				(
					I => isysFsclk,
					O => GSysFsclk
				);
sysarm_INST1: BUFG
            port map
				(
					I => iArmBclk,
					O => GArmBclk
				);
--sysarm_INST2: BUFG
--            port map
--				(
--					I => iExt18432,
--					O => GArmMclk
--				);				
----------------------AD1---------------------------------------
AD1_INST1: BUF
            port map
				(
					I => isysMclk,
					O => ADMclk1pad
				);
AD1_INST2: BUF
            port map
				(
					I => isysBclk,
					O => ADBclk1pad
				);
AD1_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => ADFsclk1pad
				);
-------------------------AD2--------------------------------
AD2_INST1: BUF
            port map
				(
					I => isysMclk,
					O => ADMclk2pad
				);
AD2_INST2: BUF
            port map
				(
					I => isysBclk,
					O => ADBclk2pad
				);
AD2_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => ADFsclk2pad
				);
------------------------arm---------------------------------
arm_INST1: BUF
            port map
				(
					I => iExt18432,
					O => ArmMclkpad
				);
arm_INST2: BUF
            port map
				(
					I => iArmBclk,
					O => ArmBclkpad
				);
 
arm_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => ArmFsclkpad
				);
----------------------monitor-------------------------------
monitor_INST1: BUF
            port map
				(
					I => isysMclk,
					O => monitorMclkpad
				);
monitor_INST2: BUF
            port map
				(
					I => isysBclk,
					O => monitorBclkpad
				);
monitor_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => monitorFsclkpad
				);
----------------------madi-----------------------------------
madi_INST1: BUF
            port map
				(
					I => isysMclk,
					O => MadiMclkpad
				);
madi_INST2: BUF
            port map
				(
					I => isysBclk,
					O => MadiBclkpad
				);
madi_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => MadiFsclkpad
				);

-------------------------dsp--------------------------------
dsp_INST1: BUF
            port map
				(
					I => isysMclk,
					O => DspMclkpad
				);
dsp_INST2: BUF
            port map
				(
					I => isysBclk,
					O => DspBclkpad
				);
dsp_INST3: BUF
            port map
				(
					I => isysFsclk,
					O => DspFsclkpad
				);
				


---------------------------0.5s time interval generation --------------------------------
process(rst,isysFsclk)
variable iCounter500ms : integer range 0 to 12000;
begin
	 if(rst = '0') then
		  iCounter500ms := 0;
	 elsif(rising_edge(isysFsclk)) then
		  iCounter500ms := iCounter500ms + 1;
		  if(iCounter500ms = 11999) then
				iled500ms <= not iled500ms;
				iCounter500ms := 0;
		  end if;
	 end if;
end process;
led500mspad <= iled500ms;
------------------------------------------------------------------------------------------
end Behavioral;

