----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:50:50 07/23/2015 
-- Design Name: 
-- Module Name:    I2S_STP - Behavioral 
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

entity I2S_STP is
    Port ( BITCLK : in  STD_LOGIC;
           FSCLK : in  STD_LOGIC;
           Audio : in  STD_LOGIC_VECTOR (7 downto 0);
			  SelAudio : in std_logic;
           ch1_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch2_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch3_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch4_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rd : out  STD_LOGIC_VECTOR (15 downto 0);
			  ch5_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch6_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch7_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           ch8_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rd : out  STD_LOGIC_VECTOR (15 downto 0);
			  SelAudioLP : out std_logic_vector(15 downto 0);
			  SelAudioRP : out std_logic_vector(15 downto 0)
			  );
end I2S_STP;

architecture Behavioral of I2S_STP is

COMPONENT IIS
      PORT(
		     BITCLK :  in  STD_LOGIC;
           FSCLK :   in  STD_LOGIC;
           DONE_IN : in  STD_LOGIC;
           DATA :    in  STD_LOGIC;
			  CLR  :    IN  STD_LOGIC;
           EN :      in  STD_LOGIC_VECTOR (15 downto 0);
           CH_L :    out  STD_LOGIC_VECTOR (15 downto 0);
           CH_R :    out  STD_LOGIC_VECTOR (15 downto 0)
		    );
END COMPONENT;

COMPONENT SHIFT_EN 
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENOUT : out  STD_LOGIC_VECTOR (15 downto 0);
           DONE : out  STD_LOGIC);
END COMPONENT;


COMPONENT SHIFT_RST
    Port (
			  BITCLOCK : in  STD_LOGIC;
           FSCLOCK  : in  STD_LOGIC;
			  EDGE  : out STD_LOGIC
			);
END COMPONENT;

signal iEnOut : std_logic_vector(15 downto 0);
signal iDone : std_logic;
signal iFsEdge : std_logic;

begin
---------------------------------------------------------------
---------------------------------------------------------------
SHIFT_EN_INST: SHIFT_EN
               PORT MAP
					(CLK => BITCLK,
					 RST => iFsEdge,
					 ENOUT => iEnOut,
					 DONE	 => iDone
					);
----------------------------------------------------------------
SHIFT_RST_INST: SHIFT_RST
					PORT MAP
					(
						BITCLOCK => BITCLK,
						FSCLOCK  => FSCLK,
						EDGE     => iFsEdge
					);
-----------------------------------------------------------------
IIS_2P_INST0: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(0),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch1_ld,
						CH_R     => ch1_rd			  
				  );
IIS_2P_INST1: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(1),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch2_ld,
						CH_R     => ch2_rd			  
				  );
IIS_2P_INST2: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(2),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch3_ld,
						CH_R     => ch3_rd			  
				  );
IIS_2P_INST3: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(3),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch4_ld,
						CH_R     => ch4_rd			  
				  );				  
IIS_2P_INST4: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(4),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch5_ld,
						CH_R     => ch5_rd			  
				  );
IIS_2P_INST5: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(5),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch6_ld,
						CH_R     => ch6_rd			  
				  );
IIS_2P_INST6: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(6),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch7_ld,
						CH_R     => ch7_rd			  
				  );
IIS_2P_INST7: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => Audio(7),
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => ch8_ld,
						CH_R     => ch8_rd			  
				  );	
IIS_2P_INST9: IIS
				  PORT MAP
				  (
				      BITCLK => BITCLK,
						FSCLK  => FSCLK,
						DONE_IN => iDONE,
						DATA    => SelAudio,
						CLR     => iFsEdge,
						EN      => iEnOut,
						CH_L    => SelAudioLP,
						CH_R     => SelAudioRP			  
				  );	

--------------------------------------------------------
--------------------------------------------------------				  
end Behavioral;

