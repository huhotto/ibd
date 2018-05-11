
-- VHDL Instantiation Created from source file i2s_to_parallel.vhd -- 17:50:08 01/11/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT i2s_to_parallel
	PORT(
		LR_CK : IN std_logic;
		BIT_CK : IN std_logic;
		DIN : IN std_logic;
		RESET : IN std_logic;          
		DATA_L : OUT std_logic_vector(15 downto 0);
		DATA_R : OUT std_logic_vector(15 downto 0);
		STROBE : OUT std_logic
		);
	END COMPONENT;

	Inst_i2s_to_parallel: i2s_to_parallel PORT MAP(
		LR_CK => ,
		BIT_CK => ,
		DIN => ,
		RESET => ,
		DATA_L => ,
		DATA_R => ,
		STROBE => 
	);


