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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PIPELINES is
    Port ( CLK : in  STD_LOGIC;
			  OUT_MEM_INSTRUCT : in  STD_LOGIC_VECTOR (31 downto 0);

end PIPELINES;

architecture Behavioral of PIPELINES is

	signal LI_DI_OP : STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_A : STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_B : STD_LOGIC_VECTOR (7 downto 0);
	signal LI_DI_C : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_OP : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_A : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_B : STD_LOGIC_VECTOR (7 downto 0);
	signal DI_EX_C : STD_LOGIC_VECTOR (7 downto 0);
	signal EX_MEM_OP   STD_LOGIC_VECTOR (7 downto 0);
	signal EX_MEM_A : STD_LOGIC_VECTOR (7 downto 0);
	signal EX_MEM_B : STD_LOGIC_VECTOR (7 downto 0);
	signal MEM_RE_OP   STD_LOGIC_VECTOR (7 downto 0);
	signal MEM_RE_A : STD_LOGIC_VECTOR (7 downto 0);
	signal MEM_RE_B : STD_LOGIC_VECTOR (7 downto 0));
	signal MUX_BC_REGISTREs: STD_LOGIC_VECTOR (7 downto 0);
	signal MUX_ALU: STD_LOGIC_VECTOR (7 downto 0);
	signal MUX_DATA_MEMORY: STD_LOGIC_VECTOR (7 downto 0);

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
	 
	 COMPONENT INSTRUCT_MEMORY
    PORT(
         ADDR : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         DATAOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;

begin
	 alu: ALU PORT MAP (
		 A => A,
		 B => B,
		 Ctrl_Alu => Ctrl_Alu,
		 S => S,
		 N => N,
		 O => O,
		 Z => Z,
		 C => C
	  );

	bc_registres: BC_REGISTREs PORT MAP (
			 ADDR_A => ADDR_A,
			 ADDR_B => ADDR_B,
			 ADDR_W => ADDR_W,
			 DATA => DATA,				 
			 RST => RST,
			 CLK => CLK,
			 QA => QA,
			 QB => QB,
			 W => W
		  );
			  
   data_memory: DATA_MEMORY PORT MAP (
          ADDR => ADDR,
          DATAIN => DATAIN,
          RW => RW,
          RST => RST,
          CLK => CLK,
          DATAOUT => DATAOUT
        );
		  
	instruct_memory: INSTRUCT_MEMORY PORT MAP (
          ADDR => ADDR,
          CLK => CLK,
          DATAOUT => DATAOUT
        );
		  
	PIPELINES : process (CLK) is
	begin

		if rising_edge(CLK) then
		   --LI/DI
			LI_DI_OP <= OUT_MEM_INSTRUCT(24 downto 31);
         LI_DI_A <= OUT_MEM_INSTRUCT(16 downto 23);  
         LI_DI_B <= OUT_MEM_INSTRUCT(8 downto 15);  
         LI_DI_C <= OUT_MEM_INSTRUCT(7 downto 0); 
			
			--DI/EX
			DI_EX_OP <= LI_DI_OP;
			DI_EX_A <= LI_DI_A;
			DI_EX_B <= LI_DI_B;
			
			--EX/MEM
			EX_MEM_OP <= DI_EX_OP;
			EX_MEM_A <= DI_EX_A;
			EX_MEM_B <= DI_EX_B;
			
			--MEM/RE
			MEM_RE_OP <= EX_MEM_OP;
			MEM_RE_A <= EX_MEM_A;
			MEM_RE_B <= EX_MEM_B;
			
			--ALU
			ADDR_W <= MEM_RE_A;
			W <= '1'; -- LC de MEM_RE_OP;
			DATA <= MEM_RE_B;
					
		end if;
	end process;

	-- multiplexer :
	-- selon valeur de LI_DI_OP (="01 ou autre") on assigne la valeur B ou QA a DI_EX_B
--	with LI_DI_OP select DI_EX_B <= LI_DI_B when "01", QA when others;
		

end Behavioral;

