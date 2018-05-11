----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:00:14 12/02/2008 
-- Design Name: 
-- Module Name:    ip_sum_vhdl - Behavioral 
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

entity ip_sum_vhdl is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           xin : in  STD_LOGIC_VECTOR (15 downto 0);
           q : out  STD_LOGIC_VECTOR (24 downto 0));
end ip_sum_vhdl;

architecture Behavioral of ip_sum_vhdl is
signal xin_tmp : std_logic_vector(24 downto 0);
signal q_tmp : std_logic_vector(24 downto 0);
begin
xin_tmp <= "000000000" & xin when xin(15)='0' else
			  "111111111" & xin when xin(15)='1' else
			  xin_tmp;
process(clk,clr)
begin
	if clr='1' then
		q_tmp <= (others=>'0');
	elsif rising_edge(clk) then
		if ce='1' then
			q_tmp <= q_tmp + xin_tmp;
		end if;
	end if;
end process;
q <= q_tmp;
end Behavioral;

