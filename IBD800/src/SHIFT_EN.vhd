----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:23 10/14/2008 
-- Design Name: 
-- Module Name:    SHIFT_EN - Behavioral 
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

entity SHIFT_EN is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           DONE : out  STD_LOGIC);
end SHIFT_EN;

architecture Behavioral of SHIFT_EN is

	SIGNAL CNT : INTEGER RANGE 0 TO 16 := 0;
	SIGNAL iDONE : STD_LOGIC := '1';
	
begin
-------------------------------------------
	PROCESS(RST,CLK)
	BEGIN
		IF(RST = '1') THEN
			CNT  <= 0;
			iDONE <= '1';
		ELSIF(FALLING_EDGE(CLK)) THEN
			CNT <= CNT + 1;
			IF(CNT = 16) THEN
				CNT <= 0;
				iDONE <= '0';
			END IF;
		END IF;
	END PROCESS;
  DONE <= iDONE;
--------------------------------------------	
   WITH CNT SELECT
	ENOUT <= B"1000_0000_0000_0000" WHEN 1,
				B"0100_0000_0000_0000" WHEN 2,
				B"0010_0000_0000_0000" WHEN 3,
				B"0001_0000_0000_0000" WHEN 4,
				B"0000_1000_0000_0000" WHEN 5,
				B"0000_0100_0000_0000" WHEN 6,
				B"0000_0010_0000_0000" WHEN 7,
				B"0000_0001_0000_0000" WHEN 8,
				B"0000_0000_1000_0000" WHEN 9,
				B"0000_0000_0100_0000" WHEN 10,
				B"0000_0000_0010_0000" WHEN 11,
				B"0000_0000_0001_0000" WHEN 12,
				B"0000_0000_0000_1000" WHEN 13,
				B"0000_0000_0000_0100" WHEN 14,
				B"0000_0000_0000_0010" WHEN 15,
				B"0000_0000_0000_0001" WHEN 16,
				B"0000_0000_0000_0000" WHEN OTHERS;

end Behavioral;

