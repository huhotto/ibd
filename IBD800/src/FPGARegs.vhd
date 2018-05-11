--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FPGARegs is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	constant ADDR_AOUT   	: std_logic_vector(7 downto 0) :=x"01";
	constant ADDR_HP     	: std_logic_vector(7 downto 0) :=x"02";
	constant ADDR_ReturnEn  : std_logic_vector(7 downto 0) :=x"03";
	constant ADDR_SwitchEn 	: std_logic_vector(7 downto 0) :=x"04";
	constant ADDR_PowStat  	: std_logic_vector(7 downto 0) :=x"05";
	constant ADDR_AesStat   : std_logic_vector(7 downto 0) :=x"06";
	constant ADDR_GPI 	   : std_logic_vector(7 downto 0) :=x"07";
	constant ADDR_GPO  	   : std_logic_vector(7 downto 0) :=x"08";	
	
	constant ADDR_CH1Type   : std_logic_vector(7 downto 0) :=x"09";
	constant ADDR_Ch2Type   : std_logic_vector(7 downto 0) :=x"0A";
	constant ADDR_Ch3Type   : std_logic_vector(7 downto 0) :=x"0B";
	constant ADDR_Ch4Type   : std_logic_vector(7 downto 0) :=x"0C";
	constant ADDR_Ch5Type   : std_logic_vector(7 downto 0) :=x"0D";
	constant ADDR_Ch6Type   : std_logic_vector(7 downto 0) :=x"0E";
	constant ADDR_Ch7Type   : std_logic_vector(7 downto 0) :=x"0F";
	constant ADDR_Ch8Type   : std_logic_vector(7 downto 0) :=x"10";
	
	constant ADDR_CH1Num   : std_logic_vector(7 downto 0) :=x"11";
	constant ADDR_CH2Num   : std_logic_vector(7 downto 0) :=x"12";
	constant ADDR_CH3Num   : std_logic_vector(7 downto 0) :=x"13";
	constant ADDR_CH4Num   : std_logic_vector(7 downto 0) :=x"14";
	constant ADDR_CH5Num   : std_logic_vector(7 downto 0) :=x"15";
	constant ADDR_CH6Num   : std_logic_vector(7 downto 0) :=x"16";
	constant ADDR_CH7Num   : std_logic_vector(7 downto 0) :=x"17";
	constant ADDR_CH8Num   : std_logic_vector(7 downto 0) :=x"18";

	constant ADDR_Listen   : std_logic_vector(7 downto 0) :=x"19";
	constant ADDR_VuThrdH  : std_logic_vector(7 downto 0) :=x"1A";
	constant ADDR_VuThrdL  : std_logic_vector(7 downto 0) :=x"1B";
	constant ADDR_SW_TIME  : std_logic_vector(7 downto 0) :=x"1C";
	constant ADDR_RT_TIME  : std_logic_vector(7 downto 0) :=x"1D";    ---IBD PARA chaneg message
	constant ADDR_CH6Prio  : std_logic_vector(7 downto 0) :=x"1E";    ---NULL
	constant ADDR_CH7Prio  : std_logic_vector(7 downto 0) :=x"1F";    ---NULL
	constant ADDR_CH8Prio  : std_logic_vector(7 downto 0) :=x"20";    ---NULL
	
	constant ADDR_ArmIp1	  : std_logic_vector(7 downto 0) :=x"21";
	constant ADDR_ArmIp2	  : std_logic_vector(7 downto 0) :=x"22";
	constant ADDR_ArmIp3	  : std_logic_vector(7 downto 0) :=x"23";
	constant ADDR_ArmIp4	  : std_logic_vector(7 downto 0) :=x"24";
	
	constant ADDR_ArmMask1 : std_logic_vector(7 downto 0) :=x"25";	
	constant ADDR_ArmMask2 : std_logic_vector(7 downto 0) :=x"26";	
	constant ADDR_ArmMask3 : std_logic_vector(7 downto 0) :=x"27";	
	constant ADDR_ArmMask4 : std_logic_vector(7 downto 0) :=x"28";	
	
	constant ADDR_ArmGway1 : std_logic_vector(7 downto 0) :=x"29";	
	constant ADDR_ArmGway2 : std_logic_vector(7 downto 0) :=x"2A";
	constant ADDR_ArmGway3 : std_logic_vector(7 downto 0) :=x"2B";
	constant ADDR_ArmGway4 : std_logic_vector(7 downto 0) :=x"2C";	
	
	constant ADDR_DanteMIP1 : std_logic_vector(7 downto 0) :=x"2D";
	constant ADDR_DanteMIP2 : std_logic_vector(7 downto 0) :=x"2E";
	constant ADDR_DanteMIP3 : std_logic_vector(7 downto 0) :=x"2F";
	constant ADDR_DanteMIP4 : std_logic_vector(7 downto 0) :=x"30";	

	constant ADDR_DanteSIP1 : std_logic_vector(7 downto 0) :=x"31";
	constant ADDR_DanteSIP2 : std_logic_vector(7 downto 0) :=x"32";
	constant ADDR_DanteSIP3 : std_logic_vector(7 downto 0) :=x"33";
	constant ADDR_DanteSIP4 : std_logic_vector(7 downto 0) :=x"34";	

	constant ADDR_NameStart : std_logic_vector(7 downto 0) :=x"35";
	constant ADDR_NameEnd   : std_logic_vector(7 downto 0) :=x"4E";
	
	constant ADDR_AOIP1_NAME_SRART : std_logic_vector(7 downto 0) := x"4F";
	constant ADDR_AOIP1_NAME_END   : std_logic_vector(7 downto 0) := x"68";

	constant ADDR_AOIP2_NAME_SRART : std_logic_vector(7 downto 0) := x"69";
	constant ADDR_AOIP2_NAME_END   : std_logic_vector(7 downto 0) := x"82";	
	
	constant ADDR_AOIP3_NAME_SRART : std_logic_vector(7 downto 0) := x"83";
	constant ADDR_AOIP3_NAME_END   : std_logic_vector(7 downto 0) := x"9C";

	constant ADDR_AOIP4_NAME_SRART : std_logic_vector(7 downto 0) := x"9D";
	constant ADDR_AOIP4_NAME_END   : std_logic_vector(7 downto 0) := x"B6";	
	
	constant ADDR_MADISel_Start : std_logic_vector(7 downto 0) :=x"B7";
	constant ADDR_MADISel_End   : std_logic_vector(7 downto 0) :=x"BF";
	
	constant ADDR_VU_Start : std_logic_vector(7 downto 0) :=X"C0";
	constant ADDR_VU_End   : std_logic_vector(7 downto 0) :=X"E4";
	
	constant ADDR_Corr_Start : std_logic_vector(7 downto 0) :=X"E5";
	constant ADDR_Corr_End   : std_logic_vector(7 downto 0) :=X"EC";	
	
	constant ADDR_iAmOk      : std_logic_vector(7 downto 0) := X"EF";
	constant ADDR_Counter14  : std_logic_vector(7 downto 0) := X"F0";
	constant ADDR_Counter15  : std_logic_vector(7 downto 0) := X"F1";	
	
	constant ADDR_DelayTimeH : std_logic_vector(7 downto 0) := X"F2";
	constant ADDR_DelayTimeL : std_logic_vector(7 downto 0) := X"F3";
	constant ADDR_BuildTimeL : std_logic_vector(7 downto 0) := X"F4";
	constant ADDR_DumpTime   : std_logic_vector(7 downto 0) := X"F5";
	constant ADDR_MaxTime	 : std_logic_vector(7 downto 0) := X"F6";
	constant ADDR_SafeTime   : std_logic_vector(7 downto 0) := X"F7";
	constant ADDR_PanicTime  : std_logic_vector(7 downto 0) := X"F8";
	constant ADDR_Mode  		 : std_logic_vector(7 downto 0) := X"F9";
	constant ADDR_KeyValu	 : std_logic_vector(7 downto 0) := X"FA";
	constant ADDR_MUSICEN	 : std_logic_vector(7 downto 0) := X"FB";
	constant ADDR_BuildTimeH : std_logic_vector(7 downto 0) := X"FC";
	constant ADDR_AudioRevert  : std_logic_vector(7 downto 0) := X"FD";
	constant ADDR_Message : std_logic_vector(7 downto 0 ) :=x"FE";
	
end FPGARegs;

package body FPGARegs is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
  
 
end FPGARegs;
