----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:24 07/25/2015 
-- Design Name: 
-- Module Name:    XYMAC - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity XYMAC is
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
end XYMAC;

architecture Behavioral of XYMAC is

COMPONENT subc_vhdl is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;

component mul_new
	port (
	clk: IN std_logic;
	a: IN std_logic_VECTOR(15 downto 0);
	b: IN std_logic_VECTOR(15 downto 0);
	ce: IN std_logic;
	sclr: IN std_logic;
	p: OUT std_logic_VECTOR(31 downto 0));
end component;

COMPONENT ip_sum32_vhdl
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           aclr : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           q : out  STD_LOGIC_VECTOR (40 downto 0));
END COMPONENT;

component SQRRoot
	port (
	x_in: IN std_logic_VECTOR(40 downto 0);
	x_out: OUT std_logic_VECTOR(20 downto 0);
	clk: IN std_logic;
	ce: IN std_logic);
end component;

COMPONENT MUL21_new
  PORT (
    clk : IN STD_LOGIC;
    a : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
    ce : IN STD_LOGIC;
    p : OUT STD_LOGIC_VECTOR(41 DOWNTO 0)
  );
END COMPONENT;

signal iXsubcOut : std_logic_vector(15 downto 0);
signal iYsubcOut : std_logic_vector(15 downto 0);
signal iXsquareOut : std_logic_vector(31 downto 0);
signal iXYOut : std_logic_vector(31 downto 0);
signal iYsquareOut : std_logic_vector(31 downto 0);
signal iX2Square : std_logic_vector(40 downto 0);
signal iY2Square : std_logic_vector(40 downto 0);
signal iXsqroot : std_logic_vector(20 downto 0);
signal iYsqroot : std_logic_vector(20 downto 0);


begin
---------------------------------------------------------
---------------------------------------------------------

x_xAver_inst0: subc_vhdl                     --- stage 1
          port map(
			           clk => clk,
						  ce => subc_ce,
						  a => XDATA,
						  b => XAverage,
						  q => iXsubcOut
			         );
y_yAver_inst1: subc_vhdl
          port map(
			           clk => clk,
						  ce => subc_ce,
						  a => YDATA,
						  b => YAverage,
						  q => iYsubcOut
			         );
------------------------------------------------
-------------------------------------------------
XXmul_inst0: mul_new                             --- stage2
          port map(
			            clk => clk,
							a => iXsubcOut,
							b => iXsubcOut,
							ce => mul1_ce,
							sclr => clr,
							p => iXsquareOut
			         );
XYmul_inst0: mul_new
          port map(
			            clk => clk,
							a => iXsubcOut,
							b => iYsubcOut,
							ce => mul1_ce,
							sclr => clr,
							p => iXYOut
			         );
YYmul_inst0: mul_new
          port map(
			            clk => clk,
							a => iYsubcOut,
							b => iYsubcOut,
							ce => mul1_ce,
							sclr => clr,
							p => iYsquareOut
			         );
------------------------------------------------
-------------------------------------------------
SUM_XX_inst0 :  ip_sum32_vhdl          --- stage3
          Port map( 
							clk => clk,
							ce => sum32_ce,
							aclr => clr,
							b => iXsquareOut,
							q => iX2Square
                  );
SUM_XY_inst0 :  ip_sum32_vhdl
          Port map( 
							clk => clk,
							ce => sum32_ce,
							aclr => clr,
							b => iXYOut,
							q => xy_sum
                  );
SUM_YY_inst0 :  ip_sum32_vhdl
          Port map( 
							clk => clk,
							ce => sum32_ce,
							aclr => clr,
							b => iYsquareOut,
							q => iY2Square
                  );
-------------------------------------------------
-------------------------------------------------
Xsqroot_inst0 : SQRRoot
          port map (  
							x_in  => iX2Square,
							x_out => iXsqroot,
							clk   => clk,
							ce    => sqr_ce
			           );
Ysqroot_inst0 : SQRRoot
          port map (  
							x_in  => iY2Square,
							x_out => iYsqroot,
							clk   => clk,
							ce    => sqr_ce
			           );
-------------------------------------------------
-------------------------------------------------
X2Y2_MUL_inst0 : MUL21_new
          port map (
			            clk => clk,
							a => iXsqroot,
							b => iYsqroot,
							ce => mul21_ce,
							p => root
			          );
--***********************************************--
--*************************************************

end Behavioral;

