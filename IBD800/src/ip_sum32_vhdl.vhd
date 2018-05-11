----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:54 12/02/2008 
-- Design Name: 
-- Module Name:    ip_sum32_vhdl - Behavioral 
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

entity ip_sum32_vhdl is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           aclr : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           q : out  STD_LOGIC_VECTOR (40 downto 0));
end ip_sum32_vhdl;

architecture Behavioral of ip_sum32_vhdl is
signal b_tmp : std_logic_vector(40 downto 0);
signal q_tmp : std_logic_vector(40 downto 0);
begin
b_tmp <= "000000000" & b when b(31)='0' else
			"111111111" & b when b(31)='1' else
			b_tmp;
process(clk,aclr)
begin
	if aclr='1' then
		q_tmp <= (others=>'0');
	elsif rising_edge(clk) then
		if ce='1' then
			q_tmp <= q_tmp + b_tmp;
		end if;
	end if;
end process;
q <= q_tmp;
end Behavioral;

