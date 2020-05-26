----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:18 05/07/2020 
-- Design Name: 
-- Module Name:    PIPELINES - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROCESSOR is
    Port ( CLK : in STD_LOGIC;
			  OUT_MEM_INSTRUCT : in STD_LOGIC_VECTOR (31 downto 0));
end PROCESSOR;

architecture Behavioral of PROCESSOR is

	signal LI_DI_OP: STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_A : STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_B : STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_C : STD_LOGIC_VECTOR (7 downto 0);
	
	signal DI_EX_OP: STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_A : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_B : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_C : STD_LOGIC_VECTOR (7 downto 0);
	
	signal EX_MEM_OP: STD_LOGIC_VECTOR (7 downto 0);
	signal EX_MEM_A : STD_LOGIC_VECTOR (7 downto 0);
	signal EX_MEM_B : STD_LOGIC_VECTOR (7 downto 0);
	
	signal MEM_RE_OP: STD_LOGIC_VECTOR (7 downto 0);
	signal MEM_RE_A : STD_LOGIC_VECTOR (7 downto 0);
	signal MEM_RE_B : STD_LOGIC_VECTOR (7 downto 0);	
	
   --ALU
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal Ctrl_Alu : std_logic_vector(2 downto 0) := (others => '0');
   signal S : std_logic_vector(7 downto 0);
   signal N : std_logic;
   signal O : std_logic;
   signal Z : std_logic;
   signal C : std_logic;
	
   --BC_REGISTREs
   signal ADDR_A : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_B : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_W : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST_REG : std_logic := '0';
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);
	
	--DATA_MEMORY
   signal ADDR_MEM : std_logic_vector(7 downto 0) := (others => '0');
   signal DATAIN : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST_MEM : std_logic := '0';
   signal DATAOUT : std_logic_vector(7 downto 0);
	

	COMPONENT BC_REGISTREs 
	PORT(
		ADDR_A : IN  std_logic_vector(3 downto 0);
		ADDR_B : IN  std_logic_vector(3 downto 0);
		ADDR_W : IN  std_logic_vector(3 downto 0);
		W : IN  std_logic;
		DATA : IN  std_logic_vector(7 downto 0);
		RST : IN  std_logic;
		CLK : IN  std_logic;
		QA : OUT  std_logic_vector(7 downto 0);
		QB : OUT  std_logic_vector(7 downto 0)
	  );
	END COMPONENT;

	COMPONENT ALU 
	PORT(
		A : IN  std_logic_vector(7 downto 0);
		B : IN  std_logic_vector(7 downto 0);
		Ctrl_Alu : IN  std_logic_vector(2 downto 0);
		S : OUT  std_logic_vector(7 downto 0);
		N : OUT  std_logic;
		O : OUT  std_logic;
		Z : OUT  std_logic;
		C : OUT  std_logic
	  );
	END COMPONENT;

	COMPONENT DATA_MEMORY
	PORT(
		ADDR : IN  std_logic_vector(7 downto 0);
		DATAIN : IN  std_logic_vector(7 downto 0);
		RW : IN  std_logic;
		RST : IN  std_logic;
		CLK : IN  std_logic;
		DATAOUT : OUT  std_logic_vector(7 downto 0)
	  );
	END COMPONENT;

begin

	my_alu: ALU PORT MAP (
		A => A,
		B => B,
		Ctrl_Alu => Ctrl_Alu,
		S => S,
		N => N,
		O => O,
		Z => Z,
		C => C
	);

	my_bc_registres: BC_REGISTREs PORT MAP (
		ADDR_A => ADDR_A,
		ADDR_B => ADDR_B,
		ADDR_W => ADDR_W,
		DATA => DATA,				 
		RST => RST_REG ,
		CLK => CLK,
		QA => QA,
		QB => QB,
		W => W
	);
			  
   my_data_memory: DATA_MEMORY PORT MAP (
		ADDR => ADDR_MEM,
		DATAIN => DATAIN,
		RW => RW,
		RST => RST_MEM,
		CLK => CLK,
		DATAOUT => DATAOUT
	);
		  
  
	PIPELINES : process (CLK) is
	begin

		if rising_edge(CLK) then
		   
			--reset
			RST_MEM <= '1';
			RST_REG <= '1';
			
		   --LI/DI
			LI_DI_OP <= OUT_MEM_INSTRUCT(31 downto 24);
         LI_DI_A <= OUT_MEM_INSTRUCT(23 downto 16);  
         LI_DI_B <= OUT_MEM_INSTRUCT(15 downto 8);  
         LI_DI_C <= OUT_MEM_INSTRUCT(7 downto 0); 
			
			--DI/EX
			DI_EX_OP <= LI_DI_OP;
			DI_EX_A <= LI_DI_A;			 
			if LI_DI_OP = x"06" or LI_DI_OP = x"07" then --AFC  LOAD --DI/EX B MUX	
				DI_EX_B <= LI_DI_B;
			end if;
			if LI_DI_OP = x"05" or LI_DI_OP = x"08" then --COP 
				DI_EX_B <= QA; --sortie A du banc de registres
			end if;	
			if LI_DI_OP = x"01" or LI_DI_OP = x"02" or LI_DI_OP = x"03" or LI_DI_OP = x"04" then  --ADD MUL SOU DIV
				DI_EX_B <= QA; --sortie A du banc de registres
				DI_EX_C <= QB; --sortie A du banc de registres
			end if;			
			
			--EX/MEM
			EX_MEM_OP <= DI_EX_OP;
			EX_MEM_A <= DI_EX_A;		
			if DI_EX_OP = x"01" or DI_EX_OP = x"02" or DI_EX_OP = x"03" or DI_EX_OP = x"04" then  --ADD, MUL, SOU ou DIV --EX/MEM B MUX
				EX_MEM_B <= S;  --sortie de l'alu
			end if;	
			if DI_EX_OP = x"05" or DI_EX_OP = x"06" or DI_EX_OP = x"07" or DI_EX_OP = x"08" then --COP ou AFC ou LOAD
				EX_MEM_B <= DI_EX_B;
			end if;
			
			--MEM/RE
			if EX_MEM_OP = x"01" or EX_MEM_OP = x"02" or EX_MEM_OP = x"03" or EX_MEM_OP = x"04" or EX_MEM_OP = x"05" or EX_MEM_OP = x"06" or EX_MEM_OP = x"07" then
				MEM_RE_OP <= EX_MEM_OP;
				MEM_RE_A <= EX_MEM_A;			
			end if;
			if EX_MEM_OP = x"05" or EX_MEM_OP = x"01" or EX_MEM_OP = x"02" or EX_MEM_OP = x"03" or EX_MEM_OP = x"04" or EX_MEM_OP = x"06" then
				MEM_RE_B <= EX_MEM_B;
			elsif EX_MEM_OP = x"07" then --LOAD
				MEM_RE_B <= DATAOUT;
			end if;
			
			--BC_REGISTREs
			if LI_DI_OP = x"05" or LI_DI_OP = x"01" or LI_DI_OP = x"02" or LI_DI_OP = x"03" or LI_DI_OP = x"04" or LI_DI_OP = x"08" then
				ADDR_A <= LI_DI_B(3 downto 0);
			end if;
			if LI_DI_OP = x"01" or LI_DI_OP = x"02" or LI_DI_OP = x"03" or LI_DI_OP= x"04" then
				ADDR_B <= LI_DI_C(3 downto 0);
			end if;
			if MEM_RE_OP = x"01" or MEM_RE_OP = x"02" or MEM_RE_OP = x"03" or MEM_RE_OP = x"04" or MEM_RE_OP = x"05" or MEM_RE_OP = x"06" or MEM_RE_OP = x"07" then
				ADDR_W <= MEM_RE_A(3 downto 0);
				W <= '1'; -- LC de MEM_RE_OP;
				DATA <= MEM_RE_B;
			end if;
			
			--ALU
			A <= DI_EX_B;
			B <= DI_EX_C;
			Ctrl_Alu <= DI_EX_OP(2 downto 0); --CTRL ALU (3 bits)	--LC de 

			--DATA_MEMORY 
			if EX_MEM_OP = x"07" then --LOAD 
				ADDR_MEM <= EX_MEM_B;
			elsif  EX_MEM_OP = x"08" then --STORE
				ADDR_MEM <= EX_MEM_A;
			end if;
			
			if EX_MEM_OP = x"08" then --STORE
				DATAIN <= EX_MEM_B;
			end if;
			
			if EX_MEM_OP = x"01" or EX_MEM_OP = x"02" or EX_MEM_OP = x"03" or EX_MEM_OP = x"04" or EX_MEM_OP = x"05" or EX_MEM_OP = x"06" or EX_MEM_OP = x"07" then
			   RW <= '1'; 
			elsif EX_MEM_OP = x"08" then --STORE (ecriture)
				RW <= '0'; 
			end if;
			
			




		end if; --clk
	end process;

		

end Behavioral;

