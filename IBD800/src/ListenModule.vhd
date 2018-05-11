----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:35:22 07/18/2016 
-- Design Name: 
-- Module Name:    ListenModule - Behavioral 
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

entity ListenModule is
    Port ( 
			  rst    : in std_logic;
			  AudioIn : in  STD_LOGIC_VECTOR (7 downto 0);
	        MCLK    : in std_logic;
			  Reg_AudioRevert : in std_logic;
			  Fsclk : in  STD_LOGIC;  --48k
           bclk2034 : in  STD_LOGIC; --2.034MHZ
			  FPGAI2Sin : in std_logic;  --I2S SD to fpga 2.034MHZ
			  bclk3072 : in std_logic;  ---3.072MHZ
			  hpout : out  STD_LOGIC;  --headphone i2s stream
           FPGAI2Sout : out  STD_LOGIC;   --I2S SD TO arm 
			  I2Sinter  : out std_logic;    -- IIS streame to DA       --I2S SD to fpga 3.072
           FPSelIn : in  STD_LOGIC_VECTOR (2 downto 0);
           ArmSelIn : in  STD_LOGIC_VECTOR (3 downto 0)
			  );
end ListenModule;

architecture Behavioral of ListenModule is

constant widthnum : integer :=24;
signal ifsEdge : std_logic := '0';
signal currlrclk: std_logic := '0';
signal iI2Sfpgaselect : std_logic := '0';
------------------------------------------------------------------------
-----------------------FPGATOARM-----------------------------------------
signal fpgatoarmdatal: std_logic_vector(widthnum-1 downto 0);
signal fpgatoarmdatar: std_logic_vector(widthnum-1 downto 0);
signal fpgadatatemp : std_logic_vector(widthnum-1 downto 0);
signal ifpgasampCnt : integer range 0 to 31 := 0;
signal iI2sCnt0 : integer range 0 to 31 := 0;
 
-----------------------ARMT0FPGA-----------------------------------------
signal armtofpgadatal: std_logic_vector(widthnum-1 downto 0);
signal armtofpgadatar: std_logic_vector(widthnum-1 downto 0);
signal armdatatemp : std_logic_vector(widthnum-1 downto 0);
signal iarmsampCnt : integer range 0 to 31 := 0;
signal iI2sCnt : integer range 0 to 31 := 0;

--signal i2stest: std_logic := '0'; 
component EDGEDETECT 
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end component;
begin
----------------------------------------------------------------------
--fsclkcheck: EDGEDETECT 
--    Port map(
--			  BITCLOCK => MCLK,
--           FSCLOCK  => Fsclk,
--           EDGE     => ifsEdge,
--			  RISEDGE  => open
--			);

-----------front pannel listen , AIC23B ------------------------------------
hpout <= AudioIn(0) when FPSelIn = B"000" else --AES
		    AudioIn(1) when FPSelIn = B"001" else  --ANA
			 AudioIn(2) when FPSelIn = B"010" else  --DT1
			 AudioIn(3) when FPSelIn = B"011" else  --DT2
			 AudioIn(4) when FPSelIn = B"100" else  --DT3
			 AudioIn(5) when FPSelIn = B"101" else  --DT4
			 AudioIn(6) when FPSelIn = B"110" else   --ARMSDI
			 AudioIn(7) when FPSelIn = B"111" else --NULL
			 '0';
--hpout <=AudioIn(6);
--iI2Sfpgaselect  <=   AudioIn(0);
----------------------------------------------------------------------	 
iI2Sfpgaselect  <=   AudioIn(0)  when ArmSelIn = "0000" else
						   AudioIn(1)  when ArmSelIn = "0001" else
						   AudioIn(2)  when ArmSelIn = "0010" else
						   AudioIn(3)  when ArmSelIn = "0011" else
				         AudioIn(4)  when ArmSelIn = "0100" else
				         AudioIn(5)  when ArmSelIn = "0101" else
				         AudioIn(6)  when ArmSelIn = "0110" else
				         AudioIn(7)  when ArmSelIn = "0111" else
						  -- AudioIn(8) when ArmSelIn = "1000" else
						   '0';
process(Fsclk,MCLK)
begin
	if(falling_edge(MCLK)) then
		if(currlrclk /= Fsclk) then
			currlrclk <=Fsclk;
			if(Fsclk = '1') then
				--fpgatoarmdatal <=  x"f4af3a";--fpgadatatemp;
			    --fpgatoarmdatal <= fpgadatatemp;  
				 if(Reg_AudioRevert ='1')then
						fpgatoarmdatal <= not fpgadatatemp +'1';
				 else
						fpgatoarmdatal <= fpgadatatemp;
				 end if;		
				 armtofpgadatal <= armdatatemp;
				--armtofpgadatal <=fpgadatatemp;
			else
			--fpgatoarmdatar <= x"f4bf3a";--fpgadatatemp;
			   fpgatoarmdatar <= fpgadatatemp;
				armtofpgadatar <= armdatatemp;
			--armtofpgadatar <=fpgadatatemp;
			end if;
			   ifsEdge <='1';
		else
				ifsEdge <='0';
		end if;
 	end if;
end process;
----------------------------FPGATOARM--------------------------------
 process(ifsEdge,bclk3072)
 begin
	if(ifsEdge = '1') then
		ifpgasampCnt <= 0;
	elsif(rising_edge(bclk3072)) then
		ifpgasampCnt <= ifpgasampCnt + 1;
	end if;
 end process;

process(bclk3072,Fsclk,ifsEdge)
begin
	if(rising_edge(bclk3072)) then
		if(iarmsampCnt <=widthnum and ifpgasampCnt >= 1) then
			fpgadatatemp(widthnum - ifpgasampCnt) <= iI2Sfpgaselect;
		end if;
	end if;
end process;
 -----------------------------------------------2034 start
process(ifsEdge,bclk2034)
 begin
	if(ifsEdge = '1') then
		iI2sCnt0 <= 0;
	elsif(rising_edge(bclk2034)) then
		iI2sCnt0 <= iI2sCnt0 + 1;
	end if;
 end process;
------------------------------------------------------------------- 
process(bclk2034,Fsclk)
begin
	if(falling_edge(bclk2034)) then
		if(iI2sCnt0 <=widthnum and iI2sCnt0 >= 1) then
			if(Fsclk = '0') then
				FPGAI2Sout <= fpgatoarmdatal(widthnum - iI2sCnt0);
			elsif(Fsclk = '1') then
				FPGAI2Sout <= fpgatoarmdatar(widthnum - iI2sCnt0 );
			end if;
		else
			FPGAI2Sout <= '0';
		end if;
	end if;
end process;
------------------------------ARMTOFPGA-------------------------------------------------------------------
 process(ifsEdge,bclk2034)
 begin
	if(ifsEdge = '1') then
		iarmsampCnt <= 0;
	elsif(rising_edge(bclk2034)) then
		iarmsampCnt <= iarmsampCnt + 1;
	end if;
 end process;
 --*****************************************************************************************
process(bclk2034,Fsclk,ifsEdge)
begin
	if(rising_edge(bclk2034)) then
		if(iarmsampCnt <=widthnum and iarmsampCnt >= 1) then
			armdatatemp(widthnum - iarmsampCnt) <=FPGAI2Sin;
			end if;
	end if;
end process;----------------2034end
 -----------------------------------------------
process(ifsEdge,bclk3072)
 begin
	if(ifsEdge = '1') then
		iI2sCnt <= 0;
	elsif(rising_edge(bclk3072)) then
		iI2sCnt <= iI2sCnt + 1;
	end if;
 end process;
------------------------------------------------------------------- 
process(bclk3072,Fsclk)
begin
	if(falling_edge(bclk3072)) then
		if(iI2sCnt <=widthnum and iI2sCnt >= 1) then
			if(Fsclk = '0') then
				I2Sinter <= armtofpgadatal(widthnum - iI2sCnt);
			elsif(Fsclk = '1') then
				I2Sinter <= armtofpgadatar(widthnum - iI2sCnt );
			end if;
		else
			I2Sinter <= '0';
		end if;
	end if;
end process;


end Behavioral;

