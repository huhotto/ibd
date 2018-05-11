----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:49:28 07/25/2015 
-- Design Name: 
-- Module Name:    AvergC - Behavioral 
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

entity AvergC is
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           CLR : in  STD_LOGIC;
           XIN : in  STD_LOGIC_VECTOR (15 downto 0);
           YIN : in  STD_LOGIC_VECTOR (15 downto 0);
           XSUM : out  STD_LOGIC_VECTOR (24 downto 0);
           YSUM : out  STD_LOGIC_VECTOR (24 downto 0));
end AvergC;

architecture Behavioral of AvergC is

COMPONENT ip_sum_vhdl
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           xin : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (24 downto 0));
END COMPONENT;

begin
-------------------------------------------------------------------
-------------------------------------------------------------------
ipsum_inst0 : ip_sum_vhdl
       port map
		 (
			 clk => CLK,
			 ce  => CE,
			 clr => CLR,
			 xin => XIN,
			 q   => XSUM
		 );
ipsum_inst1 : ip_sum_vhdl
       port map
		 (
			 clk => CLK,
			 ce  => CE,
			 clr => CLR,
			 xin => YIN,
			 q   => YSUM
		 );
-------------------------------------------------------------------

end Behavioral;

