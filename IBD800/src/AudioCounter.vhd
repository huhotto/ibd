----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:12 07/13/2016 
-- Design Name: 
-- Module Name:    NoAudioCounter - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity AudioCounter is
    Port ( WDI : in  STD_LOGIC;
	        RSTIN : in std_logic;
           Clock : in  STD_LOGIC;
			  Enable : in std_logic;
			  Direction : in std_logic;
           Counter : out  STD_LOGIC_VECTOR (7 downto 0));
end AudioCounter;

architecture Behavioral of AudioCounter is

signal iCounter : std_logic_vector(7 downto 0) := (others=>'0');
begin

Counter <= iCounter;
	
process(WDI,Clock,Enable,RSTIN)
begin
	if((WDI = '1') or (RSTIN = '0')) then
		iCounter <= (others=>'0');
	elsif(rising_edge(Clock)) then
		if(Enable = '1') then
			if(Direction = '1') then
				if(iCounter /= B"1111_1111") then
					iCounter <= iCounter + 1;
				end if;
			else
				if(iCounter /= x"00") then
					iCounter <= iCounter - 1;
				end if;
			end if;
		end if;
	end if;
end process;


end Behavioral;

