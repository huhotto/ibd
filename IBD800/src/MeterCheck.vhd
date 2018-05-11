----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:36:50 07/11/2016 
-- Design Name: 
-- Module Name:    MeterCheck - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity MeterCheck is
    Port ( testOut : out std_logic;
	        Reset : in  STD_LOGIC; 
			  clock : in std_logic;     ---12.288M
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
end MeterCheck;

architecture Behavioral of MeterCheck is

COMPONENT ACC
  PORT (
    b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    q : OUT STD_LOGIC_VECTOR(21 DOWNTO 0)
  );
END COMPONENT;

component EDGEDETECT 
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end component;

Type MaxAccType is Array(15 downto 0) of std_logic_vector(21 downto 0);
signal iMaxAcc : MaxAccType;
signal iCacEnEdge : std_logic := '0';
signal iCaculateEn : std_logic := '0';
signal iReset : std_logic;
signal iStoreCounter : integer range 0 to 63;        ----check each 341.3ms 
signal iCacCounter : integer range 0 to 65;
signal icmp : std_logic := '0';
TYPE matrix is array (63 downto 0) of std_logic_vector(15 downto 0);

signal iCh1LMaxStore : matrix;
signal iCh2LMaxStore : matrix;
signal iCh3LMaxStore : matrix;
signal iCh4LMaxStore : matrix;
signal iCh5LMaxStore : matrix;
signal iCh6LMaxStore : matrix;
signal iCh7LMaxStore : matrix;
signal iCh8LMaxStore : matrix;
signal iCh1RMaxStore : matrix;
signal iCh2RMaxStore : matrix;
signal iCh3RMaxStore : matrix;
signal iCh4RMaxStore : matrix;
signal iCh5RMaxStore : matrix;
signal iCh6RMaxStore : matrix;
signal iCh7RMaxStore : matrix;
signal iCh8RMaxStore : matrix;
signal iVuThresh : std_logic_vector(15 downto 0);

begin
------------------------------------------------------------------------
testOut  <= iCmp;   ----for test

-- store the maxvu to caculate the average value
process(Reset,iMaxLoad)
begin
	if(Reset = '0') then
		iStoreCounter <= 0;
	elsif(rising_edge(iMaxLoad)) then
		iStoreCounter <= iStoreCounter + 1;
		if(iStoreCounter = 63) then
			iCaculateEn <= '1';
		else
			iCaculateEn <= '0';
		end if;
	end if;
end process;


process(iMaxLoad,iStoreCounter)
begin
	if(rising_edge(iMaxLoad)) then
		iCh1LMaxStore(iStoreCounter) <= MaxCh1L;
		iCh2LMaxStore(iStoreCounter) <= MaxCh2L;
		iCh3LMaxStore(iStoreCounter) <= MaxCh3L;
		iCh4LMaxStore(iStoreCounter) <= MaxCh4L;
		iCh5LMaxStore(iStoreCounter) <= MaxCh5L;
		iCh6LMaxStore(iStoreCounter) <= MaxCh6L;
		iCh7LMaxStore(iStoreCounter) <= MaxCh7L;
		iCh8LMaxStore(iStoreCounter) <= MaxCh8L;
		iCh1RMaxStore(iStoreCounter) <= MaxCh1R;
		iCh2RMaxStore(iStoreCounter) <= MaxCh2R;
		iCh3RMaxStore(iStoreCounter) <= MaxCh3R;
		iCh4RMaxStore(iStoreCounter) <= MaxCh4R;
		iCh5RMaxStore(iStoreCounter) <= MaxCh5R;
		iCh6RMaxStore(iStoreCounter) <= MaxCh6R;
		iCh7RMaxStore(iStoreCounter) <= MaxCh7R;
		iCh8RMaxStore(iStoreCounter) <= MaxCh8R;
   end if;
end process;
-----------------------------------------------------------------------
-- caculate the summery
CacEnEdge_check: EDGEDETECT
                 port map(
					             BITCLOCK => clock,
									 FSCLOCK  => iCaculateEn,
									 EDGE     => open,
									 RISEDGE  => iCacEnEdge
					          );

process(iCacEnEdge,clock)
begin
	if(iCacEnEdge = '1') then
		iCacCounter <= 0;
		iReset <= '1';
		iCmp <= '0';
	elsif(rising_edge(clock)) then
	   iReset <= '0';
		if(iCaculateEn = '1') then
			if(iCacCounter = 64) then
				iCmp  <= '1';
				iCacCounter <= iCacCounter + 1;
			elsif(iCacCounter = 65) then
				iCmp <= '0';
			else
				iCacCounter <= iCacCounter + 1;
			end if;
		end if;
	end if;
end process;
		
ACC_inst0: ACC port map
			 (
				 b => iCh1LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(0)
			 );
ACC_inst1: ACC port map
			 (
				 b => iCh1RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(1)
			 );
ACC_inst2: ACC port map
			 (
				 b => iCh2LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(2)
			 );
ACC_inst3: ACC port map
			 (
				 b => iCh2RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(3)
			 );
ACC_inst4: ACC port map
			 (
				 b => iCh3LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(4)
			 );
ACC_inst5: ACC port map
			 (
				 b => iCh3RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(5)
			 );
ACC_inst6: ACC port map
			 (
				 b => iCh4LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(6)
			 );
ACC_inst7: ACC port map
			 (
				 b => iCh4RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(7)
			 );
ACC_inst8: ACC port map
			 (
				 b => iCh5LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(8)
			 );
ACC_inst9: ACC port map
			 (
				 b => iCh5RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(9)
			 );
ACC_inst10: ACC port map
			 (
				 b => iCh6LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(10)
			 );
ACC_inst11: ACC port map
			 (
				 b => iCh6RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(11)
			 );
ACC_inst12: ACC port map
			 (
				 b => iCh7LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(12)
			 );
ACC_inst13: ACC port map
			 (
				 b => iCh7RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(13)
			 );
ACC_inst14: ACC port map
			 (
				 b => iCh8LMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(14)
			 );
ACC_inst15: ACC port map
			 (
				 b => iCh8RMaxStore(iCacCounter),
				 clk => clock,
				 sclr => iReset,
				 q => iMaxAcc(15)
			 );			 
			 
---------------------------------------------------------------
iVuThresh <= B"0000_0000_0110_0111" when (Reset = '0') else
             VuThresh;
---------------------------------------------------------------			 
-- cmp and output the result
EE: for i in 0 to 15 generate
begin
	process(iCmp,clock)
	begin
		if(falling_edge(clock)) then
			if(iCmp = '1') then
				if(iMaxAcc(i)(21 downto 6) > iVuThresh) then
					VuCheckResult(i) <= '1';
				else
					VuCheckResult(i) <= '0';
				end if;
			end if;
		end if;
	end process;
end generate;
------------------------------------------------------------------------
end Behavioral;

