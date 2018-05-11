----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:44 07/24/2015 
-- Design Name: 
-- Module Name:    RAM_ARRAY - Behavioral 
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

entity RAM_ARRAY is
      PORT(
				 mclk    : IN STD_LOGIC;
				 clka    : IN STD_LOGIC;
				 clkb    : IN STD_LOGIC;
				 ena     : IN STD_LOGIC;
				 enb     : IN STD_LOGIC;
				 wea     : IN STD_LOGIC;
				 web     : IN STD_LOGIC;
				 addra   : IN STD_LOGIC_VECTOR(8 downto 0);
				 addrb   : IN STD_LOGIC_VECTOR(8 downto 0);
				 enOut   : IN std_logic_vector(7 downto 0);
				 ch1_ld  : IN std_logic_vector(15 downto 0);
				 ch1_rd  : IN std_logic_vector(15 downto 0);
				 ch2_ld  : IN std_logic_vector(15 downto 0);
				 ch2_rd  : IN std_logic_vector(15 downto 0);
				 ch3_ld  : IN std_logic_vector(15 downto 0);
				 ch3_rd  : IN std_logic_vector(15 downto 0);
				 ch4_ld  : IN std_logic_vector(15 downto 0);
				 ch4_rd  : IN std_logic_vector(15 downto 0);
				 ch5_ld  : IN std_logic_vector(15 downto 0);
				 ch5_rd  : IN std_logic_vector(15 downto 0);
				 ch6_ld  : IN std_logic_vector(15 downto 0);
				 ch6_rd  : IN std_logic_vector(15 downto 0);
				 ch7_ld  : IN std_logic_vector(15 downto 0);
				 ch7_rd  : IN std_logic_vector(15 downto 0);
				 ch8_ld  : IN std_logic_vector(15 downto 0);
				 ch8_rd  : IN std_logic_vector(15 downto 0);
				 Xout    : OUT std_logic_vector(15 downto 0);
				 Yout    : OUT std_logic_vector(15 downto 0)
		    );
end RAM_ARRAY;

architecture Behavioral of RAM_ARRAY is

 COMPONENT CH_RAM
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
 END COMPONENT;

 COMPONENT AudioSwitch
	 Port (
	        ch1_eno : in  STD_LOGIC;
           ch2_eno : in  STD_LOGIC;
			  ch3_eno : in  STD_LOGIC;
           ch4_eno : in  STD_LOGIC;
			  ch5_eno : in  STD_LOGIC;
           ch6_eno : in  STD_LOGIC;
			  ch7_eno : in  STD_LOGIC;
           ch8_eno : in  STD_LOGIC;
			  -------------
           ch1_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch2_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch3_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch4_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch5_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch6_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch7_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ch8_ldo : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rdo : in  STD_LOGIC_VECTOR (15 downto 0);
			  ------------
			  mclk : in STD_LOGIC;
			  ------------
           out_ld : out  STD_LOGIC_VECTOR (15 downto 0);
           out_rd : out  STD_LOGIC_VECTOR (15 downto 0)
	 
	 );
 END COMPONENT;

 signal idata0L : std_logic_vector(15 downto 0);
 signal idata0R : std_logic_vector(15 downto 0);
 signal idata1L : std_logic_vector(15 downto 0);
 signal idata1R : std_logic_vector(15 downto 0);
 signal idata2L : std_logic_vector(15 downto 0);
 signal idata2R : std_logic_vector(15 downto 0);
 signal idata3L : std_logic_vector(15 downto 0);
 signal idata3R : std_logic_vector(15 downto 0);
 
 signal idata4L : std_logic_vector(15 downto 0);
 signal idata4R : std_logic_vector(15 downto 0);
 signal idata5L : std_logic_vector(15 downto 0);
 signal idata5R : std_logic_vector(15 downto 0);
 signal idata6L : std_logic_vector(15 downto 0);
 signal idata6R : std_logic_vector(15 downto 0);
 signal idata7L : std_logic_vector(15 downto 0);
 signal idata7R : std_logic_vector(15 downto 0);
 
begin
--------------------------------------------------------------
--------------------------------------------------------------
AudioSwtich_INST:  AudioSwitch
		 PORT MAP (
		               ch1_eno => enOut(0),
							ch2_eno => enOut(1),
							ch3_eno => enOut(2),
							ch4_eno => enOut(3),
							ch5_eno => enOut(4),
							ch6_eno => enOut(5),
							ch7_eno => enOut(6),
							ch8_eno => enOut(7),
							ch1_ldo => idata0L,
							ch1_rdo => idata0R,
							ch2_ldo => idata1L,
							ch2_rdo => idata1R,
							ch3_ldo => idata2L,
							ch3_rdo => idata2R,
							ch4_ldo => idata3L,
							ch4_rdo => idata3R,
							ch5_ldo => idata4L,
							ch5_rdo => idata4R,
							ch6_ldo => idata5L,
							ch6_rdo => idata5R,
							ch7_ldo => idata6L,
							ch7_rdo => idata6R,
							ch8_ldo => idata7L,
							ch8_rdo => idata7R,
							mclk    => mclk,
							out_ld  => Xout,
							out_rd  => Yout
		          );
---------------------------------------------------------------		 
CH_RAM_INST0: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(0),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch1_ld,
						data_r => ch1_rd,
						out_l  => idata0L,
						out_r  => idata0R
		         );
CH_RAM_INST1: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(1),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch2_ld,
						data_r => ch2_rd,
						out_l  => idata1L,
						out_r  => idata1R
		         );
CH_RAM_INST2: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(2),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch3_ld,
						data_r => ch3_rd,
						out_l  => idata2L,
						out_r  => idata2R
		         );					
					
CH_RAM_INST3: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(3),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch4_ld,
						data_r => ch4_rd,
						out_l  => idata3L,
						out_r  => idata3R
		         );
CH_RAM_INST4: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(4),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch5_ld,
						data_r => ch5_rd,
						out_l  => idata4L,
						out_r  => idata4R
		         );
CH_RAM_INST5: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(5),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch6_ld,
						data_r => ch6_rd,
						out_l  => idata5L,
						out_r  => idata5R
		         );
CH_RAM_INST6: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(6),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch7_ld,
						data_r => ch7_rd,
						out_l  => idata6L,
						out_r  => idata6R
		         );
CH_RAM_INST7: CH_RAM
       PORT MAP(
						clka => clka,
			         clkb => clkb,
						wea  => wea,
						web  => web,
						ena  => ena,
						enb  => enb,
						enout => enOut(7),
						addr_a => addra,
						addr_b => addrb,
						data_l => ch8_ld,
						data_r => ch8_rd,
						out_l  => idata7L,
						out_r  => idata7R
		         );
			
end Behavioral;

