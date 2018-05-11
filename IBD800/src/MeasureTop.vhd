----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:44 08/19/2015 
-- Design Name: 
-- Module Name:    MeasureTop - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity MeasureTop is
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
end MeasureTop;

architecture Behavioral of MeasureTop is

component FINDMAX
    Port ( 
			  BUSIN : in  STD_LOGIC_VECTOR (15 downto 0);
			  LOAD  : IN  STD_LOGIC;
			  EN    : IN  STD_LOGIC;
           RST : in  STD_LOGIC;
           MAXOUT : out  STD_LOGIC_VECTOR (15 downto 0)
			 );
end component;

component EDGEDETECT 
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end component;

component selgen 
    Port ( 
	        SELCOUNTER : out  STD_LOGIC_VECTOR (3 downto 0);
	        BitClk : in std_logic;
           LOAD : out  STD_LOGIC;
           FSCLOCK : in  STD_LOGIC
			);
end component;
---------------------------------------------------------------------------------
  signal iFsEdge : std_logic := '0';
  signal max_cmp : std_logic := '0';
  signal iFsRisingEdge : std_logic := '0';
  signal sampleCounter : integer range 0 to 512;
  signal bitclk_cnt : std_logic_vector(5 downto 0);
  signal iMaxReset: std_logic;
  
  Type iMaxChType is array(17 downto 0) of std_logic_vector(15 downto 0);
  signal iMaxCh : iMaxChType;
  signal iCh  : iMaxChType;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
begin

   MaxStore <= iMaxReset;

	process(sampleCounter,FSCLK)	
	begin
		if(rising_edge(FSCLK)) then
			if(sampleCounter = 510) then
			   MaxCh1L  <= iMaxCh(0);
				MaxCh1R  <= iMaxCh(1);  
				MaxCh2L  <= iMaxCh(2);
				MaxCh2R  <= iMaxCh(3);   
				MaxCh3L  <= iMaxCh(4);
				MaxCh3R  <= iMaxCh(5);   
				MaxCh4L  <= iMaxCh(6);
				MaxCh4R  <= iMaxCh(7);   
				MaxCh5L  <= iMaxCh(8);
				MaxCh5R  <= iMaxCh(9);   
				MaxCh6L  <= iMaxCh(10);
				MaxCh6R  <= iMaxCh(11);   
				MaxCh7L  <= iMaxCh(12);
				MaxCh7R  <= iMaxCh(13);   
				MaxCh8L  <= iMaxCh(14);
				MaxCh8R  <= iMaxCh(15);  
				MaxCh9L  <= iMaxCh(16);
				MaxCh9R  <= iMaxCh(17);
			end if;
		end if;
	end process;
	
		
			iCh(0) <= ch1_ld when ((ch1_ld(15) = '0')) else
                  ((not ch1_ld(15 downto 0)) + '1') when ((ch1_ld(15) = '1'));
 
			iCh(1) <= ch1_rd when ((ch1_rd(15) = '0')) else
                  ((not ch1_rd(15 downto 0)) + '1') when ((ch1_rd(15) = '1') );	
						
			iCh(2) <= ch2_ld when ((ch2_ld(15) = '0')) else
                  ((not ch2_ld(15 downto 0)) + '1') when ((ch2_ld(15) = '1'));
                   						
			iCh(3) <= ch2_rd when ((ch2_rd(15) = '0') ) else
                  ((not ch2_rd(15 downto 0)) + '1') when ((ch2_rd(15) = '1') );	
						
			iCh(4) <= ch3_ld when ((ch3_ld(15) = '0')) else
                  ((not ch3_ld(15 downto 0)) + '1') when ((ch3_ld(15) = '1') );
                   						
			iCh(5) <= ch3_rd when ((ch3_rd(15) = '0') ) else
                  ((not ch3_rd(15 downto 0)) + '1') when ((ch3_rd(15) = '1'));	
						
			iCh(6) <= ch4_ld when ((ch4_ld(15) = '0')) else
                  ((not ch4_ld(15 downto 0)) + '1') when ((ch4_ld(15) = '1'));
                   						
			iCh(7) <= ch4_rd when ((ch4_rd(15) = '0') ) else
                  ((not ch4_rd(15 downto 0)) + '1') when ((ch4_rd(15) = '1') );	
						
			iCh(8) <= ch5_ld when ((ch5_ld(15) = '0')  ) else
                  ((not ch5_ld(15 downto 0)) + '1') when ((ch5_ld(15) = '1') );
                   						
			iCh(9) <= ch5_rd when ((ch5_rd(15) = '0') ) else
                  ((not ch5_rd(15 downto 0)) + '1') when ((ch5_rd(15) = '1') );	
						
			iCh(10) <= ch6_ld when ((ch6_ld(15) = '0') ) else
                  ((not ch6_ld(15 downto 0)) + '1') when ((ch6_ld(15) = '1'));
                   						
			iCh(11) <= ch6_rd when ((ch6_rd(15) = '0') ) else
                  ((not ch6_rd(15 downto 0)) + '1') when ((ch6_rd(15) = '1'));	
						
			iCh(12) <= ch7_ld when ((ch7_ld(15) = '0') ) else
                  ((not ch7_ld(15 downto 0)) + '1') when ((ch7_ld(15) = '1'));
                   						
			iCh(13) <= ch7_rd when ((ch7_rd(15) = '0')) else
                  ((not ch7_rd(15 downto 0)) + '1') when ((ch7_rd(15) = '1'));	
						
			iCh(14) <= ch8_ld when ((ch8_ld(15) = '0') ) else
                  ((not ch8_ld(15 downto 0)) + '1') when ((ch8_ld(15) = '1') );
                   						
			iCh(15) <= ch8_rd when ((ch8_rd(15) = '0') ) else
                  ((not ch8_rd(15 downto 0)) + '1') when ((ch8_rd(15) = '1'));	
						
			iCh(16) <= ch9_ld when ((ch9_ld(15) = '0') ) else
                  ((not ch9_ld(15 downto 0)) + '1') when ((ch9_ld(15) = '1') );
                   						
			iCh(17) <= ch9_rd when ((ch9_rd(15) = '0') ) else
                  ((not ch9_rd(15 downto 0)) + '1') when ((ch9_rd(15) = '1'));					
------------------------------------------------------------------------------------------------
FFF: for i in 0 to 17 generate
	process(iMaxReset,max_cmp,iCh(i),iMaxCh(i))
	begin
		if(iMaxReset = '1') then
			iMaxCh(i) <= (others=>'0');
		elsif(max_cmp = '1') then
			if(iCh(i) > iMaxCh(i)) then
				iMaxCh(i) <= iCh(i);
			end if;
		end if;
	end process;
end generate FFF;

------------------------------------------------------

FS_EDGE_INST: EDGEDETECT
              port map
				  (
						BITCLOCK => BITCLK,
						FSCLOCK  => FSCLK,
						EDGE     => iFsEdge,
						RISEDGE  => iFsRisingEdge
				  );
 
process(iFsEdge, BITCLK)
begin
	if iFsEdge='1' then
		bitclk_cnt <= (others=>'0');
	elsif rising_edge(BITCLK) then
			bitclk_cnt <= bitclk_cnt + '1';
	end if;
end process;

max_cmp   <= '1' when (bitclk_cnt="011101") else '0';--and sw_do_test(15) = '0'
 
 process(FSCLK,rst)
 begin
	if(rst = '1') then
		sampleCounter <= 0;
		iMaxReset <= '1';
	elsif(rising_edge(FSCLK)) then
		sampleCounter <= sampleCounter + 1;
		iMaxReset <= '0';
		if(sampleCounter >= 511) then
			sampleCounter <= 0;
			iMaxReset <= '1';
		end if;
	end if;
 end process;
 
 
-----------------------------------------------------
-----------------------------------------------------
end Behavioral;
