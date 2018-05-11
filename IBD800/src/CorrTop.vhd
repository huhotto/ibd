----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:12:51 07/24/2015 
-- Design Name: 
-- Module Name:    CorrTop - Behavioral 
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

entity CorrTop is
    Port ( mclk : in  STD_LOGIC;
           averf_ce : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           XIN : in  STD_LOGIC_VECTOR (15 downto 0);
           YIN : in  STD_LOGIC_VECTOR (15 downto 0);
           mult1_ce : in  STD_LOGIC;
           sum32_ce : in  STD_LOGIC;
           sub_ce : in  STD_LOGIC;
           mult2_ce : in  STD_LOGIC;
           sqrroot_ce : in  STD_LOGIC;
			  xy_sum    : out std_logic_vector(40 downto 0);
			  root    : out std_logic_vector(41 downto 0)
			  );
end CorrTop;


architecture Behavioral of CorrTop is


COMPONENT AvergC 
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           CLR : in  STD_LOGIC;
           XIN : in  STD_LOGIC_VECTOR (15 downto 0);
           YIN : in  STD_LOGIC_VECTOR (15 downto 0);
           XSUM : out  STD_LOGIC_VECTOR (24 downto 0);
           YSUM : out  STD_LOGIC_VECTOR (24 downto 0));
			  
END COMPONENT;

COMPONENT XYMAC
      Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           subc_ce : in  STD_LOGIC;
           mul1_ce : in  STD_LOGIC;
           sum32_ce : in  STD_LOGIC;
			  sqr_ce : in std_logic;
			  mul21_ce : in std_logic;
			  XDATA : in std_logic_vector(15 downto 0);
			  YDATA : in std_logic_vector(15 downto 0);
			  XAverage : in std_logic_vector(15 downto 0);
			  YAverage : in std_logic_vector(15 downto 0);
           xy_sum : out  STD_LOGIC_VECTOR (40 downto 0);
           root : out  STD_LOGIC_VECTOR (41 downto 0));
END COMPONENT;


  signal iXAverage : std_logic_vector(24 downto 0);
  signal iYAverage : std_logic_vector(24 downto 0);
  signal iXData : std_logic_vector(15 downto 0);
  signal iYData : std_logic_vector(15 downto 0);
  
begin
--------------------------------------------------------------------
--------------------------------------------------------------------

AverC_INST:  AvergC
      PORT MAP(
						CLK => mclk,
						CE  => averf_ce,
						CLR => clr,
					   XIN => XIN,
					   YIN => YIN,
					   XSUM => iXAverage,
					   YSUM => iYAverage	
		        );  
----------------------------------------------
FD16CE_INST0:  
               FOR i IN 15 downto 0 generate
			U1:		FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>iXData(i),C =>mclk,CE =>'1',CLR => clr,D => XIN(i));
					end generate;
----------------------------------------------
FD16CE_INST1:  
               FOR i IN 15 downto 0 generate
			U1:		FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>iYData(i),C =>mclk,CE =>'1',CLR => clr,D => YIN(i));
					end generate;
----------------------------------------------
XYMAC_INST: XYMAC
       PORT MAP(
						clk => mclk,
						clr => clr,
						subc_ce  => sub_ce,
						mul1_ce  => mult1_ce,
						sum32_ce   => sum32_ce,
						sqr_ce   => sqrroot_ce,
						mul21_ce => mult2_ce,
						XDATA => iXData,
						YDATA => iYData,
						XAverage => iXAverage(24 downto 9),
						YAverage => iYAverage(24 downto 9),
						xy_sum => xy_sum,
						root => root
		         );
-----------------------------------------------
end Behavioral;

