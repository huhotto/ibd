----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:04:47 07/24/2015 
-- Design Name: 
-- Module Name:    CH_RAM - Behavioral 
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

entity CH_RAM is
    Port ( clka : in  STD_LOGIC;
           clkb : in  STD_LOGIC;
           wea : in  STD_LOGIC;
           web : in  STD_LOGIC;
           ena : in  STD_LOGIC;
           enb : in  STD_LOGIC;
			  enout : in std_logic;
			  addr_a : in std_logic_vector(8 downto 0);
			  addr_b : in std_logic_vector(8 downto 0);
           data_l : in  STD_LOGIC_VECTOR (15 downto 0);
           data_r : in  STD_LOGIC_VECTOR (15 downto 0);
           out_l : out  STD_LOGIC_VECTOR (15 downto 0);
           out_r : out  STD_LOGIC_VECTOR (15 downto 0));
end CH_RAM;

architecture Behavioral of CH_RAM is

COMPONENT RAM 
    Port ( clka : in  STD_LOGIC;
           clkb : in  STD_LOGIC;
           ena : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           wea : in  STD_LOGIC;
           web : in  STD_LOGIC;
			  enout : in  STD_LOGIC;
           addra : in  STD_LOGIC_VECTOR (8 downto 0);
           addrb : in  STD_LOGIC_VECTOR (8 downto 0);
           wdata : in  STD_LOGIC_VECTOR (15 downto 0);
           Dout : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT;


begin
----------------------------------------------------------
RAM_INST0:  RAM
       PORT MAP(
		            clka => clka,
						clkb => clkb,
						ena  => ena,
						enb  => enb,
						wea  => wea,
						web  => web,
						enout => enout,
						addra => addr_a,
						addrb => addr_b,
						wdata => data_l,
						Dout  => out_l
		 );
RAM_INST1:  RAM
       PORT MAP(
		            clka => clka,
						clkb => clkb,
						ena  => ena,
						enb  => enb,
						wea  => wea,
						web  => web,
						enout => enout,
						addra => addr_a,
						addrb => addr_b,
						wdata => data_r,
						Dout  => out_r
		 );

----------------------------------------------------------
----------------------------------------------------------
end Behavioral;

