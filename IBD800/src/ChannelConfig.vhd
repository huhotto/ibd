----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:38:20 07/08/2016 
-- Design Name: 
-- Module Name:    Sel8to1Core - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ChannelConfig is
    Port ( AES3_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           AOIP_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           MADI_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           Music_In : in  STD_LOGIC;		
           Ch1Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch2Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch3Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch4Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch5Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch6Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch7Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           Ch8Sel : in  STD_LOGIC_VECTOR (3 downto 0);
           ChOut : out  STD_LOGIC_VECTOR (7 downto 0)
          );
end ChannelConfig;

architecture Behavioral of ChannelConfig is

begin

ChOut(0) <= AES3_IN(0) when Ch1Sel = B"0000" else   --0
				AES3_IN(1) when Ch1Sel = B"0001" else	 --1
				AES3_IN(2) when Ch1Sel = B"0010" else	 --2
				AES3_IN(3) when Ch1Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch1Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch1Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch1Sel = B"0110" else   --6
				AOIP_IN(3) when Ch1Sel = B"0111" else   --7
				MADI_IN(0) when Ch1Sel = B"1000" else   --8
				MADI_IN(1) when Ch1Sel = B"1001" else   --9
				MADI_IN(2) when Ch1Sel = B"1010" else   --10
				MADI_IN(3) when Ch1Sel = B"1011" else   --11
				Music_IN   when Ch1Sel = B"1100" else   --12
				'0';

ChOut(1) <= AES3_IN(0) when Ch2Sel = B"0000" else   --0
				AES3_IN(1) when Ch2Sel = B"0001" else	 --1
				AES3_IN(2) when Ch2Sel = B"0010" else	 --2
				AES3_IN(3) when Ch2Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch2Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch2Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch2Sel = B"0110" else   --6
				AOIP_IN(3) when Ch2Sel = B"0111" else   --7
				MADI_IN(0) when Ch2Sel = B"1000" else   --8
				MADI_IN(1) when Ch2Sel = B"1001" else   --9
				MADI_IN(2) when Ch2Sel = B"1010" else   --10
				MADI_IN(3) when Ch2Sel = B"1011" else   --11
				Music_IN   when Ch2Sel = B"1100" else   --12
				'0';

ChOut(2) <= AES3_IN(0) when Ch3Sel = B"0000" else   --0
				AES3_IN(1) when Ch3Sel = B"0001" else	 --1
				AES3_IN(2) when Ch3Sel = B"0010" else	 --2
				AES3_IN(3) when Ch3Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch3Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch3Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch3Sel = B"0110" else   --6
				AOIP_IN(3) when Ch3Sel = B"0111" else   --7
				MADI_IN(0) when Ch3Sel = B"1000" else   --8
				MADI_IN(1) when Ch3Sel = B"1001" else   --9
				MADI_IN(2) when Ch3Sel = B"1010" else   --10
				MADI_IN(3) when Ch3Sel = B"1011" else   --11
				Music_IN   when Ch3Sel = B"1100" else   --12
				'0';

ChOut(3) <= AES3_IN(0) when Ch4Sel = B"0000" else   --0
				AES3_IN(1) when Ch4Sel = B"0001" else	 --1
				AES3_IN(2) when Ch4Sel = B"0010" else	 --2
				AES3_IN(3) when Ch4Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch4Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch4Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch4Sel = B"0110" else   --6
				AOIP_IN(3) when Ch4Sel = B"0111" else   --7
				MADI_IN(0) when Ch4Sel = B"1000" else   --8
				MADI_IN(1) when Ch4Sel = B"1001" else   --9
				MADI_IN(2) when Ch4Sel = B"1010" else   --10
				MADI_IN(3) when Ch4Sel = B"1011" else   --11
				Music_IN   when Ch4Sel = B"1100" else   --12
				'0';

ChOut(4) <= AES3_IN(0) when Ch5Sel = B"0000" else   --0
				AES3_IN(1) when Ch5Sel = B"0001" else	 --1
				AES3_IN(2) when Ch5Sel = B"0010" else	 --2
				AES3_IN(3) when Ch5Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch5Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch5Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch5Sel = B"0110" else   --6
				AOIP_IN(3) when Ch5Sel = B"0111" else   --7
				MADI_IN(0) when Ch5Sel = B"1000" else   --8
				MADI_IN(1) when Ch5Sel = B"1001" else   --9
				MADI_IN(2) when Ch5Sel = B"1010" else   --10
				MADI_IN(3) when Ch5Sel = B"1011" else   --11
				Music_IN   when Ch5Sel = B"1100" else   --12
				'0';

ChOut(5) <= AES3_IN(0) when Ch6Sel = B"0000" else   --0
				AES3_IN(1) when Ch6Sel = B"0001" else	 --1
				AES3_IN(2) when Ch6Sel = B"0010" else	 --2
				AES3_IN(3) when Ch6Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch6Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch6Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch6Sel = B"0110" else   --6
				AOIP_IN(3) when Ch6Sel = B"0111" else   --7
				MADI_IN(0) when Ch6Sel = B"1000" else   --8
				MADI_IN(1) when Ch6Sel = B"1001" else   --9
				MADI_IN(2) when Ch6Sel = B"1010" else   --10
				MADI_IN(3) when Ch6Sel = B"1011" else   --11
				Music_IN   when Ch6Sel = B"1100" else   --12
				'0';
				
ChOut(6) <= AES3_IN(0) when Ch7Sel = B"0000" else   --0
				AES3_IN(1) when Ch7Sel = B"0001" else	 --1
				AES3_IN(2) when Ch7Sel = B"0010" else	 --2
				AES3_IN(3) when Ch7Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch7Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch7Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch7Sel = B"0110" else   --6
				AOIP_IN(3) when Ch7Sel = B"0111" else   --7
				MADI_IN(0) when Ch7Sel = B"1000" else   --8
				MADI_IN(1) when Ch7Sel = B"1001" else   --9
				MADI_IN(2) when Ch7Sel = B"1010" else   --10
				MADI_IN(3) when Ch7Sel = B"1011" else   --11
				Music_IN   when Ch7Sel = B"1100" else   --12
				'0';

ChOut(7) <= AES3_IN(0) when Ch8Sel = B"0000" else   --0
				AES3_IN(1) when Ch8Sel = B"0001" else	 --1
				AES3_IN(2) when Ch8Sel = B"0010" else	 --2
				AES3_IN(3) when Ch8Sel = B"0011" else	 --3
				AOIP_IN(0) when Ch8Sel = B"0100" else	 --4
				AOIP_IN(1) when Ch8Sel = B"0101" else	 --5
				AOIP_IN(2) when Ch8Sel = B"0110" else   --6
				AOIP_IN(3) when Ch8Sel = B"0111" else   --7
				MADI_IN(0) when Ch8Sel = B"1000" else   --8
				MADI_IN(1) when Ch8Sel = B"1001" else   --9
				MADI_IN(2) when Ch8Sel = B"1010" else   --10
				MADI_IN(3) when Ch8Sel = B"1011" else   --11
				Music_IN   when Ch8Sel = B"1100" else   --12
				'0';
				
end Behavioral;

