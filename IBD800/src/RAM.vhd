----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:08:53 07/24/2015 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
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

entity RAM is
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
end RAM;

architecture Behavioral of RAM is

COMPONENT DRAM
   PORT(
	        clka : in std_logic;
			  clkb : in std_logic;
			  ena  : in std_logic;
			  enb  : in std_logic;
			  wea  : in std_logic;
			  web  : in std_logic;
           addra : in  STD_LOGIC_VECTOR (8 downto 0);
           addrb : in  STD_LOGIC_VECTOR (8 downto 0);
			  dina  : in std_logic_vector(15 downto 0);
			  dinb  : in std_logic_vector(15 downto 0);
			  douta : out std_logic_vector(15 downto 0);
			  doutb : out std_logic_vector(15 downto 0)	
		);
END COMPONENT;

COMPONENT MUX16
    PORT(
				EN : IN STD_LOGIC;
				SEL : IN STD_LOGIC;
				A_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				B_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				C_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END COMPONENT;

 signal idataA : std_logic_vector(15 downto 0);
 signal idataB : std_logic_vector(15 downto 0);
 
begin


DRAM_INST0:  DRAM 
        PORT MAP(
		             clka => clka,
						 clkb => clkb,
						 ena  => ena,
						 enb  => enb,
						 wea  => wea,
						 web  => web,
						 addra => addra,
						 addrb => addrb,
						 dina  => wdata,
						 dinb  => wdata,
						 douta => idataA,
						 doutb => idataB
		  );
		  
MUX16_INST:  MUX16
        PORT MAP(
		             EN  => enout,
						 SEL => wea,
						 A_IN => idataA,
						 B_IN => idataB,
						 C_OUT => Dout
		  );

end Behavioral;

