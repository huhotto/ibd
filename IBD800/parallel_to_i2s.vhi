
-- VHDL Instantiation Created from source file parallel_to_i2s.vhd -- 10:21:29 01/12/2018
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT parallel_to_i2s
	PORT(
		LR_CK : IN std_logic;
		BIT_CK : IN std_logic;
		RESET : IN std_logic;
		DATA_L : IN std_logic_vector(15 downto 0);
		DATA_R : IN std_logic_vector(15 downto 0);          
		DIN : OUT std_logic
		);
	END COMPONENT;

	Inst_parallel_to_i2s: parallel_to_i2s PORT MAP(
		LR_CK => ,
		BIT_CK => ,
		RESET => ,
		DATA_L => ,
		DATA_R => ,
		DIN => 
	);


