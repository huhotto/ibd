----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:23:22 10/14/2008 
-- Design Name: 
-- Module Name:    IIS - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity IIS is
    Port ( BITCLK : in  STD_LOGIC;
           FSCLK : in  STD_LOGIC;
           DONE_IN : in  STD_LOGIC;
           DATA : in  STD_LOGIC;
			  CLR  : IN  STD_LOGIC;
           EN : in  STD_LOGIC_VECTOR (15 downto 0);
           CH_L : out  STD_LOGIC_VECTOR (15 downto 0);
           CH_R : out  STD_LOGIC_VECTOR (15 downto 0));
end IIS;

architecture Behavioral of IIS is
 SIGNAL TEMP        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

begin
------------------------------------------------------------------
SHIFTMAP : 
               FOR i IN 15 downto 0 generate
			U1:		FDCE 
						generic map (INIT => '0')
			          PORT MAP(Q =>TEMP(i),C =>BITCLK,CE =>EN(i),CLR => CLR,D => DATA);
					end generate;
------------------------------------------------------------------	
					CH_L <= TEMP WHEN (FSCLK = '0' AND DONE_IN = '1');
					CH_R <= TEMP WHEN (FSCLK = '1' AND DONE_IN = '1');	

-------------------------------------------------------------------					

end Behavioral;

