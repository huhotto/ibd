----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:42 07/11/2016 
-- Design Name: 
-- Module Name:    AutoSwitchModule - Behavioral 
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

entity AutoSwitchModule is
    Port ( 
			  MCLK : in std_logic;
			  reset : in std_logic;
			  VuStatusIn : in  STD_LOGIC_VECTOR (15 downto 0);
           Clock500ms : in  STD_LOGIC;    -- 0.5s at least
			  AutoSwitchEn : in std_logic;
			  AutoReturnEn : in std_logic;
			  TimeSwitchThrd : in std_logic_vector(7 downto 0); -- 5-60s
			  TimeReturnThrd : in std_logic_vector(7 downto 0); -- 5-60s
			  CurrentChannel : in std_logic_vector(2 downto 0); -- 1-8
           ChangeFlag : out Std_logic;
			  Counter14: out std_logic_vector(7 downto 0);
			  Counter15: out std_logic_vector(7 downto 0);
			  NewChannel : out std_logic_vector(2 downto 0)
			);
end AutoSwitchModule;

architecture Behavioral of AutoSwitchModule is


COMPONENT AudioCounter is
    Port ( WDI : in  STD_LOGIC;
	        RSTIN : in std_logic;
           Clock : in  STD_LOGIC;
			  Enable : in std_logic;
			  Direction : in std_logic;
           Counter : out  STD_LOGIC_VECTOR (7 downto 0));
end COMPONENT;

type CounterArray is Array(15 downto 0) of std_logic_vector(7 downto 0);
signal iSwitchCounter : CounterArray;
signal iReturnCounter  : CounterArray;

signal iSwitchCounterSave : CounterArray;
signal iReturnCounterSave : CounterArray;

signal iAutoSwitchThrd : std_logic_vector(7 downto 0);
signal iReturnThrd : std_logic_vector(7 downto 0);
signal iNewChannel : std_logic_vector(2 downto 0);
signal iChangeFlag : std_logic :='0';
signal iTimerSwitch : std_logic_vector(7 downto 0);
signal iTimerReturn : std_logic_vector(7 downto 0);
signal iCheckAudioForSwitch : std_logic;
signal iCheckAudioForReturn : std_logic;
signal iSwitchDly1 : std_logic := '0';
signal iSwitchFallingEdge : std_logic;
signal iReturnDly1 : std_logic := '0';
signal iReturnFallingEdge : std_logic;
signal iCmpSwitch : std_logic_vector(7 downto 0);
signal iCmpReturn : std_logic_vector(7 downto 0);
signal iReturnOkList : std_logic_vector(15 downto 0);
signal iSwitchOkList : std_logic_vector(15 downto 0);
signal iChannelSaved : std_logic_vector(2 downto 0) := B"000";

begin
-------------------------------------------------------------------------------
iAutoSwitchThrd  <= B"0000_1010" when (reset = '0') else 
                    TimeSwitchThrd(6 downto 0) & '0';   -- the real time for autoswitch
iReturnThrd      <= B"0000_1010" when (reset = '0') else 
                    TimeReturnThrd(6 downto 0) & '0';   -- the real time for autoreturn
Counter14 <= iSwitchCounter(14);
Counter15 <= iSwitchCounter(15);
--------------------------Caculate the real value of audio--------------------           ---two direction counter
SwtichAudioCheck_inst: for i in 0 to 15 generate
begin
AA:  AudioCounter port map
         ( WDI => VuStatusIn(i),
			  RSTIN => reset,
           Clock => Clock500ms,
			  Enable => '1',--(not iCheckAudioForSwitch),
			  Direction => '1',
           Counter   => iSwitchCounter(i)
			);
end generate SwtichAudioCheck_inst;

ReturnAudioCheck_inst: for i in 0 to 15 generate
begin
BB:  AudioCounter port map
         ( WDI => not VuStatusIn(i),
			  RSTIN => reset,
           Clock => Clock500ms,
			  Enable => '1',--(not iCheckAudioForSwitch),
			  Direction => '1',
           Counter   => iReturnCounter(i)
			);
end generate ReturnAudioCheck_inst;


process(Clock500ms,AutoSwitchEn,AutoReturnEn,CurrentChannel)
variable iTemp : std_logic_vector(3 downto 0);
variable ppp : std_logic_vector(2 downto 0);
begin
   if(falling_edge(Clock500ms)) then
	   iNewChannel <= CurrentChannel;
	   if(AutoSwitchEn = '1') then              --- AutoReturn is enable
				iTemp := CurrentChannel(2 downto 0) & '0';
				if((iSwitchCounter(conv_integer(iTemp)) >= iAutoSwitchThrd) or (iSwitchCounter(conv_integer(iTemp)+1) >= iAutoSwitchThrd) ) then
					if((iSwitchCounter(0) < iAutoSwitchThrd) and (iSwitchCounter(1) < iAutoSwitchThrd)) then
						iNewChannel <= B"000";
						ppp := B"000";
					elsif((iSwitchCounter(2) < iAutoSwitchThrd) and (iSwitchCounter(3) < iAutoSwitchThrd)) then
						iNewChannel <= B"001";
						ppp := B"001";
					elsif((iSwitchCounter(4) < iAutoSwitchThrd) and (iSwitchCounter(5) < iAutoSwitchThrd)) then
						iNewChannel <= B"010";
						ppp := B"010";
					elsif((iSwitchCounter(6) < iAutoSwitchThrd) and (iSwitchCounter(7) < iAutoSwitchThrd)) then
						iNewChannel <= B"011";
						ppp := B"011";
					elsif((iSwitchCounter(8) < iAutoSwitchThrd) and (iSwitchCounter(9) < iAutoSwitchThrd)) then--------------7¸Ä³É8
						iNewChannel <= B"100";
						ppp := B"100";
					elsif((iSwitchCounter(10) < iAutoSwitchThrd) and (iSwitchCounter(11) < iAutoSwitchThrd)) then
						iNewChannel <= B"101";
						ppp := B"101";
					elsif((iSwitchCounter(12) < iAutoSwitchThrd) and (iSwitchCounter(13) < iAutoSwitchThrd)) then
						iNewChannel <= B"110";
						ppp := B"110";
					elsif((iSwitchCounter(14) < iAutoSwitchThrd) and (iSwitchCounter(15) < iAutoSwitchThrd)) then
						iNewChannel <= B"111";
						ppp := B"111";
					end if;
				elsif(AutoReturnEn = '1') then
					if((iReturnCounter(0) >= iReturnThrd) and (iReturnCounter(1) >= iReturnThrd)) then
						iNewChannel <= B"000";
						ppp := B"000";
					elsif((iReturnCounter(2) >= iReturnThrd) and (iReturnCounter(3) >= iReturnThrd)) then
						iNewChannel <= B"001";
						ppp := B"001";
					elsif((iReturnCounter(4) >= iReturnThrd) and (iReturnCounter(5) >= iReturnThrd)) then
						iNewChannel <= B"010";
						ppp := B"010";
					elsif((iReturnCounter(6) >= iReturnThrd) and (iReturnCounter(7) >= iReturnThrd)) then
						iNewChannel <= B"011";
						ppp := B"011";
					elsif((iReturnCounter(8) >= iReturnThrd) and (iReturnCounter(9) >= iReturnThrd)) then
						iNewChannel <= B"100";
						ppp := B"100";
					elsif((iReturnCounter(10) >= iReturnThrd) and (iReturnCounter(11) >= iReturnThrd)) then
						iNewChannel <= B"101";
						ppp := B"101";
					elsif((iReturnCounter(12) >= iReturnThrd) and (iReturnCounter(13) >= iReturnThrd)) then
						iNewChannel <= B"110";
						ppp := B"110";
					elsif((iReturnCounter(14) >= iReturnThrd) and (iReturnCounter(15) >= iReturnThrd)) then
						iNewChannel <= B"111";
						ppp := B"111";
					end if;
					if(ppp > CurrentChannel) then
						iNewChannel <= CurrentChannel;
					end if;
				end if;
      end if;
   end if;
end process;
------------------------------------------------------------------------
process(MCLK,CurrentChannel,AutoSwitchEn)
begin
	if(falling_edge(MCLK)) then
		if((iNewChannel /= CurrentChannel) and (AutoSwitchEn = '1')) then
			iChangeFlag <= '1';
		else
			iChangeFlag <= '0';
	   end if;
	end if;
end process;
------------------------------------------------------------------------
NewChannel <= iNewChannel;
ChangeFlag <= iChangeFlag;
------------------------------------------------------------------------
------------------------------------------------------------------------
end Behavioral;

