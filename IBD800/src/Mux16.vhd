----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:51 10/06/2008 
-- Design Name: 
-- Module Name:    Mux16 - Behavioral 
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

entity Mux16 is
    GENERIC(WIDTH : INTEGER := 16);
    Port ( A_IN : in  STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           B_IN : in  STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
			  EN   : in  STD_LOGIC;
           SEL : in  STD_LOGIC;
           C_OUT : out  STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end Mux16;

architecture Behavioral of Mux16 is

	SIGNAL CTL : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	
begin
   
	CTL <= EN & SEL;--SEL=EAN_A--EN=EAN_B
	
	with CTL select
		C_OUT <= A_IN WHEN "10",
		         B_IN WHEN "11",
					(OTHERS => '0')  WHEN OTHERS;
					
end Behavioral;

