----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:45:33 10/15/2008 
-- Design Name: 
-- Module Name:    SHIFT_RST - Behavioral 
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

entity SHIFT_RST is
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
			  EDGE  : out STD_LOGIC
			);
end SHIFT_RST;

architecture Behavioral of SHIFT_RST is
	SIGNAL ifs_dly1:  std_logic;
	SIGNAL ifsclock:  std_logic;
	SIGNAL ibitclock: std_logic;
	CONSTANT logic_one : std_logic := '1';
	CONSTANT logic_zero: std_logic := '0';
begin
	ifsclock  <= FSCLOCK;
	ibitclock <= BITCLOCK;
	
FDCENO_0: FDCE GENERIC MAP(INIT => '0') 
          PORT MAP(Q=>ifs_dly1,C=>ibitclock,CE=>logic_one,CLR=>logic_zero,D=>ifsclock); 
EDGE <= ifs_dly1 XOR ifsclock;

end Behavioral;

