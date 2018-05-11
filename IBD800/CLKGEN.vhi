
-- VHDL Instantiation Created from source file CLKGEN.vhd -- 13:14:58 01/11/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT CLKGEN
	PORT(
		rst : IN std_logic;
		DanteMclkpad : IN std_logic;
		DanteBclkpad : IN std_logic;
		DanteFsclkpad : IN std_logic;
		ExtMclkInpad : IN std_logic;
		DanteClkCheckpad : IN std_logic;          
		DanteFsOutpad : OUT std_logic;
		ADMclk1pad : OUT std_logic;
		ADBclk1pad : OUT std_logic;
		ADFsclk1pad : OUT std_logic;
		ADMclk2pad : OUT std_logic;
		ADBclk2pad : OUT std_logic;
		ADFsclk2pad : OUT std_logic;
		ArmMclkpad : OUT std_logic;
		ArmBclkpad : OUT std_logic;
		ArmFsclkpad : OUT std_logic;
		monitorMclkpad : OUT std_logic;
		monitorBclkpad : OUT std_logic;
		monitorFsclkpad : OUT std_logic;
		MadiMclkpad : OUT std_logic;
		MadiBclkpad : OUT std_logic;
		MadiFsclkpad : OUT std_logic;
		DspMclkpad : OUT std_logic;
		DspBclkpad : OUT std_logic;
		DspFsclkpad : OUT std_logic;
		GSysMclk : OUT std_logic;
		GSysBclk : OUT std_logic;
		GSysFsclk : OUT std_logic;
		led500mspad : OUT std_logic
		);
	END COMPONENT;

	Inst_CLKGEN: CLKGEN PORT MAP(
		rst => ,
		DanteMclkpad => ,
		DanteBclkpad => ,
		DanteFsclkpad => ,
		ExtMclkInpad => ,
		DanteClkCheckpad => ,
		DanteFsOutpad => ,
		ADMclk1pad => ,
		ADBclk1pad => ,
		ADFsclk1pad => ,
		ADMclk2pad => ,
		ADBclk2pad => ,
		ADFsclk2pad => ,
		ArmMclkpad => ,
		ArmBclkpad => ,
		ArmFsclkpad => ,
		monitorMclkpad => ,
		monitorBclkpad => ,
		monitorFsclkpad => ,
		MadiMclkpad => ,
		MadiBclkpad => ,
		MadiFsclkpad => ,
		DspMclkpad => ,
		DspBclkpad => ,
		DspFsclkpad => ,
		GSysMclk => ,
		GSysBclk => ,
		GSysFsclk => ,
		led500mspad => 
	);


