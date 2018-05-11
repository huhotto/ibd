----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:09:28 12/02/2008 
-- Design Name: 
-- Module Name:    subc_vhdl - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity subc_vhdl is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           a : in  STD_LOGIC_VECTOR (15 downto 0);
           b : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (15 downto 0));
end subc_vhdl;

architecture Behavioral of subc_vhdl is
begin
process(clk)
begin
	if rising_edge(clk) then
		if ce='1' then
			q <= a - b;
		end if;
	end if;
end process;
end Behavioral;

