----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:38:29 07/24/2015 
-- Design Name: 
-- Module Name:    CorrelationTop - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity CorrelationTop is
    Port ( rst : in  STD_LOGIC;
           MCLK : in  STD_LOGIC;
           fsclk : in  STD_LOGIC;
           bitclk : in  STD_LOGIC;
           ch1_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch1_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch2_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch3_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch4_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch5_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch6_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch7_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_ld : in  STD_LOGIC_VECTOR (15 downto 0);
           ch8_rd : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  xysum : out STD_LOGIC_VECTOR(40 downto 0);
			  root :  out STD_LOGIC_VECTOR(41 downto 0);
			  CorrelationCh : out STD_LOGIC_VECTOR(2 downto 0);
			  CorrSaveEn : out std_logic;
			  divide_ok  : out std_logic;
			  po_clr : out std_logic

			  );
end CorrelationTop;

architecture Behavioral of CorrelationTop is

COMPONENT CorrelationRamCntl
     PORT(
			  rst		: in STD_LOGIC;
			  mclk 	: in  STD_LOGIC;
			  fsclk	: in STD_LOGIC;
			  bitclk	: in STD_LOGIC;
			  ---------------
			  wea_o		: out STD_LOGIC;
			  web_o		: out STD_LOGIC;
			  clka_o		: out STD_LOGIC;
			  clkb_o		: out STD_LOGIC;
			  addra_o	: out STD_LOGIC_VECTOR(8 downto 0);
			  addrb_o 	: out STD_LOGIC_VECTOR(8 downto 0);
			  ---------------
           rd_cnt_en : out  STD_LOGIC;
           ch1_eno 	: out  STD_LOGIC;
           ch2_eno 	: out  STD_LOGIC;
           ch3_eno 	: out  STD_LOGIC;
           ch4_eno 	: out  STD_LOGIC;
           ch5_eno 	: out  STD_LOGIC;
           ch6_eno 	: out  STD_LOGIC;
           ch7_eno 	: out  STD_LOGIC;
           ch8_eno 	: out  STD_LOGIC;
			  ---------------
			  avrefo_ce		: out STD_LOGIC;	--avref process
			  subo_ce		: out STD_LOGIC;	--tmp_512 singal delay 1~clk
			  multo_ce		: out STD_LOGIC;	--tmp_512 signal delay 2~clk
			  sum32o_ce		: out STD_LOGIC;	--tmp_512 signal delay 3~clk
			  sqrrooto_ce	: out STD_LOGIC;	--total 13 clk over no.(512+3=515)~clk
			  mul2o_ce		: out STD_LOGIC;	--no.(516)~clk
			  saveo_ce		: out STD_LOGIC;
			  divide_ok    : out std_logic;  -- save the divider result
			  po_clr			: out STD_LOGIC;	--clr process output
			  enao			: out STD_LOGIC;
			  enbo			: out STD_LOGIC;
			  ch_numb		: out STD_LOGIC_VECTOR(2 downto 0)
			 
			 );
END COMPONENT;

COMPONENT RAM_ARRAY
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
END COMPONENT;

COMPONENT CorrTop
      Port ( mclk : in  STD_LOGIC;
           averf_ce : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           XIN : in  STD_LOGIC_VECTOR (15 downto 0);
           YIN : in  STD_LOGIC_VECTOR (15 downto 0);
           mult1_ce : in  STD_LOGIC;
           sum32_ce : in  STD_LOGIC;
           sub_ce : in  STD_LOGIC;
           mult2_ce : in  STD_LOGIC;
           sqrroot_ce : in  STD_LOGIC;
			  xy_sum    : out std_logic_vector(40 downto 0);
			  root    : out std_logic_vector(41 downto 0)
			  );     
END COMPONENT;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
------------------------------------------------------------------------
  signal iwea : 		std_logic;
  signal iweb : 		std_logic;
  signal iclka : 		std_logic;
  signal iclkb : 		std_logic;
  signal iaddra:     std_logic_vector(8 downto 0);
  signal iaddrb:     std_logic_vector(8 downto 0);
  
  signal ichEno : 		  std_logic_vector(7 downto 0);
  signal iavrefo_ce :     std_logic;
  signal isubo_ce:    	  std_logic; 
  signal imulto_ce:   	  std_logic;
  signal isum32o_ce:		  STD_LOGIC;	                --tmp_512 signal delay 3~clk
  signal isqrrooto_ce	: STD_LOGIC;	          --total 13 clk over no.(512+3=515)~clk
  signal imul2o_ce		: STD_LOGIC;	          --no.(516)~clk
  signal isaveo_ce		: STD_LOGIC;
  signal idivide_ok     : std_logic;
  signal ipo_clr		: STD_LOGIC;	             --clr process output
  signal ienao			: STD_LOGIC;
  signal ienbo			: STD_LOGIC;
  signal ich_numb		: STD_LOGIC_VECTOR(2 downto 0);
  signal iXout       : std_logic_vector(15 downto 0);
  signal iYout       : std_logic_vector(15 downto 0);
  
  signal ixy_sum     : std_logic_vector(40 downto 0);
  signal iroot       : std_logic_vector(41 downto 0);
  

begin
-----------------------------------------------------------------
	process(isum32o_ce)
	begin
		if (falling_edge(isum32o_ce)) then
			xysum  <= ixy_sum;
		end if;
	end process;
	
	root   <= iroot;
	
	CorrelationCh <= ich_numb;
	CorrSaveEn <= isaveo_ce;
	divide_ok <= idivide_ok;
	po_clr <= ipo_clr;
-----------------------------------------------------------------
CorrelationRamCntl_INST: CorrelationRamCntl
        PORT MAP(
		              rst => rst,
						  mclk => MCLK,
						  fsclk => fsclk,
						  bitclk => bitclk,
						  wea_o => iwea,
						  web_o => iweb,
						  clka_o	=> iclka,
						  clkb_o	=> iclkb,
						  addra_o => iaddra,
						  addrb_o => iaddrb,
						  rd_cnt_en => open,
						  ch1_eno => ichEno(0),
						  ch2_eno => ichEno(1),
						  ch3_eno => ichEno(2),
						  ch4_eno => ichEno(3),
						  ch5_eno => ichEno(4),
						  ch6_eno => ichEno(5),
						  ch7_eno => ichEno(6),
						  ch8_eno => ichEno(7),
						  avrefo_ce	=> iavrefo_ce,
			           subo_ce	=> isubo_ce,
			           multo_ce	=> imulto_ce,
			           sum32o_ce	=> isum32o_ce,
			           sqrrooto_ce	=> isqrrooto_ce,
			           mul2o_ce		=> imul2o_ce,
			           saveo_ce		=> isaveo_ce,
						  divide_ok    => idivide_ok,
			           po_clr			=> ipo_clr,
			           enao			=> ienao,
			           enbo			=> ienbo,
						  ch_numb      => ich_numb	
		          );
---------------------------------------------------
RAM_ARRAY_INST: RAM_ARRAY
         PORT MAP (
				 mclk   => MCLK,
				 clka   => iclka,
				 clkb   => iclkb,
				 ena    => ienao,
				 enb    => ienao,
				 wea    => iwea,
				 web    => iweb,
				 addra  => iaddra,
				 addrb  => iaddrb,
				 enOut  => ichEno,
				 ch1_ld  => ch1_ld,
				 ch1_rd  => ch1_rd,
				 ch2_ld  => ch2_ld,
				 ch2_rd  => ch2_rd,
				 ch3_ld  => ch3_ld,
				 ch3_rd  => ch3_rd,
				 ch4_ld  => ch4_ld,
				 ch4_rd  => ch4_rd,
				 ch5_ld  => ch5_ld,
				 ch5_rd  => ch5_rd,
				 ch6_ld  => ch6_ld,
				 ch6_rd  => ch6_rd,
				 ch7_ld  => ch7_ld,
				 ch7_rd  => ch7_rd,
				 ch8_ld  => ch8_ld,
				 ch8_rd  => ch8_rd,
				 Xout    => iXout,
				 Yout    => iYout 
			);
--------------------------------------------------------------
CorrTop_INST: CorrTop
         PORT MAP(
				  mclk   => MCLK,
				  averf_ce => iavrefo_ce,
				  clr => ipo_clr,
				  XIN => iXout,
				  YIN => iYout,
				  mult1_ce => imulto_ce,
				  sum32_ce => isum32o_ce,
				  sub_ce   => isubo_ce,
				  mult2_ce => imul2o_ce,
				  sqrroot_ce => isqrrooto_ce,
				  xy_sum    => ixy_sum,
				  root      => iroot
			  );
--------------------------------------------------------------
end Behavioral;

