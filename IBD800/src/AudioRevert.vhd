----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:42 06/13/2017 
-- Design Name: 
-- Module Name:    AudioRevert - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity AudioRevert is
    Port ( mclk : in  STD_LOGIC;
           bitclk : in  STD_LOGIC;
           fsclk : in  STD_LOGIC;
           din : in  STD_LOGIC;
           dout : out  STD_LOGIC);
end AudioRevert;

architecture Behavioral of AudioRevert is
component EDGEDETECT 
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end component;
	signal iDAAout	   : std_logic;
	--signal ilrck	   : std_logic;
	signal ifsEdge	   : std_logic;
	signal ich_l   	 	: std_logic_vector(23 downto 0);
	signal ich_r    	: std_logic_vector(23 downto 0);
	--signal ich_l_out   	 	: std_logic_vector(23 downto 0);
	--signal ich_r_out    	: std_logic_vector(23 downto 0);
	signal iCounter : integer range 0 to 31 := 0;

	signal iSample_Data:STD_LOGIC_VECTOR(23 DOWNTO 0); 
	signal iReadEn		 :STD_LOGIC_VECTOR(24 DOWNTO 0); 
	--signal  ReadFromswitch_Clr : std_logic;
begin
AudioRevert: EDGEDETECT 
    Port map(
			  BITCLOCK => mclk,
           FSCLOCK  => fsclk,
           EDGE     => ifsEdge,
			  RISEDGE  => open
			);
----------------------------------------------------

ReadFromswitch : 
               FOR i IN 23 downto 0 generate
			U34:		FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>iSample_Data(i),C =>bitclk,CE =>iReadEn(i),CLR => ifsEdge,D => din);
					end generate;

--iReadEn <= x"800000" when iCounter = 1 else
--			  x"400000" when iCounter = 2 else
--			  x"200000" when iCounter = 3 else
--			  x"100000" when iCounter = 4 else
--			  x"080000" when iCounter = 5 else
--			  x"040000" when iCounter = 6 else
--			  x"020000" when iCounter = 7 else
--			  x"010000" when iCounter = 8 else
--			  x"008000" when iCounter = 9 else
--			  x"004000" when iCounter = 10 else
--			  x"002000" when iCounter = 11 else
--			  x"001000" when iCounter = 12 else
--			  x"000800" when iCounter = 13 else
--			  x"000400" when iCounter = 14 else
--			  x"000200" when iCounter = 15 else
--			  x"000100" when iCounter = 16 else	
--			  x"000080" when iCounter = 17 else
--			  x"000040" when iCounter = 18 else
--			  x"000020" when iCounter = 19 else
--			  x"000010" when iCounter = 20 else
--			  x"000008" when iCounter = 21 else
--			  x"000004" when iCounter = 22 else
--			  x"000002" when iCounter = 23 else
--			  x"000001" when iCounter = 24 else				  
--			  (others=>'0');		
process(bitclk,ifsEdge)
begin
	if( ifsEdge = '1' ) then
		iReadEn <= B"1_0000_0000_0000_0000_0000_0000";
	elsif (falling_edge(bitclk)) then
		iReadEn <= '0' & iReadEn(24 downto 1);
	end if;
end process;
 
process(bitclk)
begin
	if(rising_edge(bitclk)) then
		if(iCounter = 25)then
			if(fsclk = '1') then
				ich_l <= not iSample_Data +'1';
			else
				ich_r <= iSample_Data;
			end if;
		end if;
	 end if;	
end process;	

------------------------------------------------		  
PROCESS(fsclk,bitclk) 
 begin
	if(ifsEdge = '1') then
		iCounter <= 0;
	elsif(rising_edge(bitclk)) then
		iCounter <= iCounter + 1;
	end if;
 end process;

--------------------²¢´®×ª---------------------------
PROCESS(fsclk,bitclk)
begin
if(falling_edge(bitclk)) then
		if (iCounter >= 1 and iCounter <= 24 ) then 
			if(fsclk = '0') then
				iDAAout <= ich_l(24 - iCounter);
			elsif(fsclk = '1') then
				iDAAout <= ich_r(24 - iCounter );
			end if;
		else
			iDAAout <= '0';
		end if;
	end if;
end process;
	dout <= iDAAout;
end Behavioral;

