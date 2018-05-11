----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:38 11/19/2008 
-- Design Name: 
-- Module Name:    dat_switch - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AudioSwitch is
    Port ( ch1_eno : in  STD_LOGIC;
           ch2_eno : in  STD_LOGIC;
			  ch3_eno : in  STD_LOGIC;
           ch4_eno : in  STD_LOGIC;
			  ch5_eno : in  STD_LOGIC;
           ch6_eno : in  STD_LOGIC;
			  ch7_eno : in  STD_LOGIC;
           ch8_eno : in  STD_LOGIC;
			  -------------
           ch1_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch2_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch3_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch4_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch5_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch6_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch7_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch8_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ------------
			  mclk : in STD_LOGIC;
			  ------------
           out_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           out_rd : out  STD_LOGIC_VECTOR (15 downto 0));
end AudioSwitch;

architecture Behavioral of AudioSwitch is

begin

out_ld <= ch1_ldo when ch1_eno='1' else
			 ch2_ldo when ch2_eno='1' else
			 ch3_ldo when ch3_eno='1' else
			 ch4_ldo when ch4_eno='1' else
			 ch5_ldo when ch5_eno='1' else
			 ch6_ldo when ch6_eno='1' else
			 ch7_ldo when ch7_eno='1' else
			 ch8_ldo when ch8_eno='1' else
			 "0000000000000000";

out_rd <= ch1_rdo when ch1_eno='1' else
			 ch2_rdo when ch2_eno='1' else
			 ch3_rdo when ch3_eno='1' else
			 ch4_rdo when ch4_eno='1' else
			 ch5_rdo when ch5_eno='1' else
			 ch6_rdo when ch6_eno='1' else
			 ch7_rdo when ch7_eno='1' else
			 ch8_rdo when ch8_eno='1' else
			 "0000000000000000";
end Behavioral;

