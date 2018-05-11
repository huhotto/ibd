
-- VHDL Instantiation Created from source file ListenModule.vhd -- 15:55:52 01/15/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ListenModule
	PORT(
		rst : IN std_logic;
		AudioIn : IN std_logic_vector(7 downto 0);
		MCLK : IN std_logic;
		Fsclk : IN std_logic;
		bclk2034 : IN std_logic;
		FPGAI2Sin : IN std_logic;
		bclk3072 : IN std_logic;
		FPSelIn : IN std_logic_vector(2 downto 0);
		ArmSelIn : IN std_logic_vector(3 downto 0);          
		hpout : OUT std_logic;
		FPGAI2Sout : OUT std_logic;
		I2Sinter : OUT std_logic
		);
	END COMPONENT;

	Inst_ListenModule: ListenModule PORT MAP(
		rst => ,
		AudioIn => ,
		MCLK => ,
		Fsclk => ,
		bclk2034 => ,
		FPGAI2Sin => ,
		bclk3072 => ,
		hpout => ,
		FPGAI2Sout => ,
		I2Sinter => ,
		FPSelIn => ,
		ArmSelIn => 
	);


