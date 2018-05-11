----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:51 01/31/2008 
-- Design Name: 
-- Module Name:    EDGEDETECT - Behavioral 
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

entity EDGEDETECT is
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
           EDGE     : out STD_LOGIC;
			  RISEDGE  : out STD_LOGIC
			);
end EDGEDETECT;

architecture Behavioral of EDGEDETECT is
	
	SIGNAL ifs_dly1:  std_logic;
	SIGNAL ifs_dly2:  std_logic;
	SIGNAL ifsclock:  std_logic;
	SIGNAL ibitclock: std_logic;
	CONSTANT logic_one : std_logic := '1';
	CONSTANT logic_zero: std_logic := '0';
begin

	ifsclock  <= FSCLOCK;
	ibitclock <= BITCLOCK;
	
FDCENO_0: FDCE GENERIC MAP(INIT => '0') 
          PORT MAP(Q=>ifs_dly1,C=>ibitclock,CE=>logic_one,CLR=>logic_zero,D=>ifsclock); 
FDCENO_1: FDCE GENERIC MAP(INIT => '0')
			 PORT MAP(Q=>ifs_dly2,C=>ibitclock,CE=>logic_one,CLR=>logic_zero,D=>ifs_dly1);
EDGE    <= ifs_dly1 xor ifs_dly2;
RISEDGE <= ifs_dly1 and (not ifs_dly2);
end Behavioral;

