----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:07 10/31/2008 
-- Design Name: 
-- Module Name:    ram_cntl - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity CorrelationRamCntl is
    Port ( rst		: in STD_LOGIC;
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
			  divide_ok    : out std_logic;
			  po_clr			: out STD_LOGIC;	--clr process output
			  enao			: out STD_LOGIC;
			  enbo			: out STD_LOGIC;
			  ch_numb		: out STD_LOGIC_VECTOR(2 downto 0)
			  );
end CorrelationRamCntl;

architecture Behavioral of CorrelationRamCntl is
constant rsbase		: std_logic_vector(10 downto 0) :="00000001010";    --10
constant rsunber 		: std_logic_vector(10 downto 0) :="01111111111";    --1024
constant rsoffset		: std_logic_vector(10 downto 0) :=B"000_0111_1100"; --124 after process use

signal read_en 		: std_logic;
signal read_end		: std_logic;
signal read_en_clr	: std_logic;
signal read_ena		: std_logic;
signal read_enb		: std_logic;
signal write_ena		: std_logic;
signal write_enb		: std_logic;

signal fsclk_cnt		: std_logic_vector(9 downto 0) := (others=>'0');
signal mclk_cnt 		: std_logic_vector(10 downto 0):="00000000000";
signal done_trb		: std_logic :='0';
signal done_cnt		: std_logic_vector(2 downto 0) := B"000";
signal rfram_add 		: STD_LOGIC_VECTOR (8 downto 0) := (others=>'0');
signal wfram_add		: STD_LOGIC_VECTOR (8 downto 0) := (others=>'0');
--signal tmp_512			: std_logic :='0';
--signal d1_tmp_512		: std_logic :='0';
--signal d2_tmp_512		: std_logic :='0';
--signal d3_tmp_512		: std_logic :='0';

signal averf_ce	: std_logic;
signal averf_ced	: std_logic;
signal averf_cednn: std_logic;
signal averf_cedn : std_logic;
signal sub_ce	: std_logic;
signal en1_r	: std_logic;
signal en2_r	: std_logic;
signal en3_r	: std_logic;
signal en4_r	: std_logic;
signal en5_r	: std_logic;
signal en6_r	: std_logic;
signal en7_r	: std_logic;
signal en8_r	: std_logic;
signal mult1_ce	: std_logic;
signal sum32_ce	: std_logic;
signal sqrroot_ce	: std_logic;--pluse 13 must
signal mult2_ce	: std_logic;--mute pluse 1 must
signal save_ce		: std_logic;--result save ce
signal idivide_ok : std_logic;
signal process_clr : std_logic;--clr very times
----
signal rd1_cnta : std_logic;
signal rd1_cntb : std_logic;
signal rd2_cnta : std_logic;
signal rd2_cntb : std_logic;
signal rd3_cnta : std_logic;
signal rd3_cntb : std_logic;
signal rd4_cnta : std_logic;
signal rd4_cntb : std_logic;
signal rd5_cnta : std_logic;
signal rd5_cntb : std_logic;
signal rd6_cnta : std_logic;
signal rd6_cntb : std_logic;
signal rd7_cnta : std_logic;
signal rd7_cntb : std_logic;
signal rd8_cnta : std_logic;
signal rd8_cntb : std_logic;

signal addra_op : std_logic_vector(8 downto 0);
signal addrb_op : std_logic_vector(8 downto 0);

signal ena_tmp : std_logic;
signal enb_tmp : std_logic;


begin
-----get 512 point-----
---------------------------------------------------
-- change ping/pong buffer each 512 samples buffer
-- is full ----------------------------------------
process(fsclk)
begin
	if rising_edge(fsclk) then
		if rst='1' then
			fsclk_cnt <= (others=>'0');
		else
			fsclk_cnt <= fsclk_cnt + 1;
		end if;
	end if;
end process;
-----------------------------------------------------
---- ping/pong read and write enable is negative
---- phase ------------------------------------------
read_ena   <= (not fsclk_cnt(9)) and (not rst);
read_enb   <= fsclk_cnt(9) and (not rst);
write_ena  <= fsclk_cnt(9) and (not rst);
write_enb  <= (not fsclk_cnt(9)) and (not rst);
wea_o      <= write_ena;	---output write ram signal ping
web_o      <= write_enb;	---output write ram signal pong
-----------------------------------------------------
-- ping/pong buffer clk must be change 
-- when write to ram clk is fsclk ,when read from
-- ram clk is mclk ----------------------------------
clka_o <= not fsclk when write_ena='1' else	--clka
			 not mclk when read_ena='1' else
			 '0';
clkb_o <= not fsclk when write_enb='1' else	--clkb
			 not mclk when read_enb='1' else
			 '0';
-----------------------------------------------------
--- read operation counter need to be clear when
-- start ,it is defined by fsclk_cnt(9), each 512
-- point it while be clear, because ping/pong buffer
-- need to be change --------------------------------/
process(mclk)
begin
	if rising_edge(mclk) then
		read_end <= read_en;
	end if;
end process;
read_en_clr <= read_en xor read_end;      --512 point clr
read_en <= fsclk_cnt(9);
------------------------------------------------------------------
wfram_add <= fsclk_cnt(8 downto 0) when rst='0' else "000000000";                                     --ram write address
rfram_add <= mclk_cnt(8 downto 0)-rsbase(8 downto 0) when mclk_cnt<rsunber+rsbase+1 else "000000000"; --ram read address
------------------------------------------------------------------
process(mclk,read_en_clr)
begin
	if(read_en_clr = '1') then
		mclk_cnt <=(others=>'0');
	elsif (rising_edge(mclk)) then
		if mclk_cnt>=rsunber+rsoffset+rsbase+1 then
			mclk_cnt <= (others=>'0');
			done_cnt <= done_cnt + 1;
		else
			mclk_cnt <= mclk_cnt + 1;
		end if;
	end if;
end process;
-----------------------------------------------------------------------------------------------
-------------process eight channels audio correlation -----------------------------------------
-- each one is finished. done_trb is set '1' that make done_cnt + 1, mclk_cnt = 0;
-----------------------------------------------------------------------------------------------
--done_trb <= '1' when mclk_cnt=rsunber+rsoffset+rsbase-1 else '0';
ch_numb <= done_cnt;
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
averf_ce <= '1'    when mclk_cnt>=rsbase+1           and mclk_cnt<rsbase+512           else '0';	   --avref process
sub_ce <= '1'      when mclk_cnt>rsbase+512          and mclk_cnt<rsunber+rsbase+2     else '0';      --sub process
mult1_ce <= '1'    when mclk_cnt>rsbase+513          and mclk_cnt<rsunber+rsbase+3     else '0';      --mult1 process
sum32_ce <= '1'    when mclk_cnt>rsbase+514          and mclk_cnt<rsunber+rsbase+4     else '0';      --sum process
sqrroot_ce <= '1'  when mclk_cnt>rsunber+rsbase+3    and mclk_cnt<rsunber+rsbase+19    else '0';      --sqrroot process 13 time mclk--give 15clk
mult2_ce <= '1'    when mclk_cnt>rsunber+rsbase+19   and mclk_cnt<rsunber+rsbase+22    else '0';      --sqrroot process 1 time mclk--give 2clk
save_ce <='1'      when mclk_cnt>rsunber+rsbase+22   and mclk_cnt<rsunber+rsbase+119   else '0';      -- to enable divider add by dxp
idivide_ok <= '1'  when mclk_cnt>=rsunber+rsbase+119 and mclk_cnt<rsunber+rsbase+121   else '0';      -- save divide result
process_clr <= '1' when mclk_cnt>=rsunber+rsbase+121 and mclk_cnt<rsunber+rsbase+123   else '0';      --every process time clr

------------------------------------------------------------------------------------------------
--- read enable signal is one clock before the address  ----------------------------------------
en1_r <= '1' when mclk_cnt>=rsbase-5 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=0 else '0';
en2_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=1 else '0';
en3_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=2 else '0';
en4_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=3 else '0';
en5_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=4 else '0';
en6_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=5 else '0';
en7_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=6 else '0';
en8_r <= '1' when mclk_cnt>=rsbase-1 and mclk_cnt<=rsunber+rsbase+1 and done_cnt=7 else '0';
rd_cnt_en <= en1_r or en2_r or en3_r or en4_r or en5_r or en6_r or en7_r or en8_r;
addra_op <= wfram_add when write_ena='1' else
			  rfram_add when read_ena='1' and (en1_r='1' or en2_r='1' or en3_r='1' or en4_r='1' or en5_r='1' or en6_r='1' or en7_r='1' or en8_r='1') else
			  "000000000";
addrb_op <= wfram_add when write_enb='1' else
			  rfram_add when read_enb='1' and (en1_r='1' or en2_r='1' or en3_r='1' or en4_r='1' or en5_r='1' or en6_r='1' or en7_r='1' or en8_r='1') else
			  "000000000";
averf_ced<= averf_ce when done_cnt<8 else '0';
-----------------------------------------------------------------------------------------------
process(mclk)
begin
	if rising_edge(mclk) then
		rd1_cnta <= en1_r and read_ena;
		rd1_cntb <= en1_r and read_enb;
		rd2_cnta <= en2_r and read_ena;
		rd2_cntb <= en2_r and read_enb;
		rd3_cnta <= en3_r and read_ena;
		rd3_cntb <= en3_r and read_enb;
		rd4_cnta <= en4_r and read_ena;
		rd4_cntb <= en4_r and read_enb;
		rd5_cnta <= en5_r and read_ena;
		rd5_cntb <= en5_r and read_enb;
		rd6_cnta <= en6_r and read_ena;
		rd6_cntb <= en6_r and read_enb;
		rd7_cnta <= en7_r and read_ena;
		rd7_cntb <= en7_r and read_enb;
		rd8_cnta <= en8_r and read_ena;
		rd8_cntb <= en8_r and read_enb;
		----------
		averf_cedn <= averf_ced;
		avrefo_ce <= averf_ced or averf_cedn;
		subo_ce <= sub_ce;
		multo_ce <= mult1_ce;
		sum32o_ce <= sum32_ce;
		saveo_ce <= save_ce;
		sqrrooto_ce <= sqrroot_ce;
		mul2o_ce <= mult2_ce;
		divide_ok <= idivide_ok;
		po_clr <= process_clr;
		----------
		addra_o <= addra_op;
		addrb_o <= addrb_op;
	end if;
end process;
----------
ch1_eno <= rd1_cnta or rd1_cntb;
ch2_eno <= rd2_cnta or rd2_cntb;
ch3_eno <= rd3_cnta or rd3_cntb;
ch4_eno <= rd4_cnta or rd4_cntb;
ch5_eno <= rd5_cnta or rd5_cntb;
ch6_eno <= rd6_cnta or rd6_cntb;
ch7_eno <= rd7_cnta or rd7_cntb;
ch8_eno <= rd8_cnta or rd8_cntb;
--------
--------
--ena_tmp <= '1' when write_ena='1' else
--			  (en1_r or en2_r or en3_r or en4_r or en5_r or en6_r or en7_r or en8_r) when read_ena='1' else
--			  '0';
--enb_tmp <= '1' when write_enb='1' else
--			  (en1_r or en2_r or en3_r or en4_r or en5_r or en6_r or en7_r or en8_r) when read_enb='1' else
--			  '0';
--------
process(mclk)
begin
	if rising_edge(mclk) then
		if rst='1' then
			enao <= '0';
			enbo <= '0';
		else
			enao <= '1';--ena_tmp;
			enbo <= '1';--enb_tmp;
		end if;
	end if;
end process;

end Behavioral;
