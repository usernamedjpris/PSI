--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:49:35 04/30/2020
-- Design Name:   
-- Module Name:   /home/jgantet/microprocesseur/TEST_BC_REGISTREs.vhd
-- Project Name:  microprocesseur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BC_REGISTREs
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TEST_BC_REGISTREs IS
END TEST_BC_REGISTREs;
 
ARCHITECTURE behavior OF TEST_BC_REGISTREs IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    --COMPONENT BC_REGISTREs
    --PORT(
     --    ADDR_A : IN  std_logic_vector(3 downto 0);
     --    ADDR_B : IN  std_logic_vector(3 downto 0);
     --    ADDR_W : IN  std_logic_vector(3 downto 0);
      --   W : IN  std_logic;
      --   DATA : IN  std_logic_vector(7 downto 0);
      --   RST : IN  std_logic;
      --   CLK : IN  std_logic;
      --   QA : OUT  std_logic_vector(7 downto 0);
      --   QB : OUT  std_logic_vector(7 downto 0)
      --  );
    --END COMPONENT;
    

   --Inputs
   signal ADDR_A : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_B : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_W : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   --uut: BC_REGISTREs PORT MAP (
   ----       ADDR_A => ADDR_A,
--ADDR_B => ADDR_B,
   --       ADDR_W => ADDR_W,
   --       W => W,
    --      DATA => DATA,
    --      RST => RST,
    --      CLK => CLK,
     ---     QA => QA,
     --     QB => QB
     --   );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		-- Q_A <= "00000000" // indetermine
		-- Q_B <= "11111111" // bypass
		wait for CLK_period*10;	
		ADDR_A <= "0001";
		ADDR_B <= "0010";
		ADDR_W <= "0010";
		DATA <= "11111111";
		W <= '1';
		RST <= '1';
		
		-- on reset tout
		-- Q_A <= "00000000" // reset
		-- Q_B <= "00000000" // reset
		wait for CLK_period*10;	
		ADDR_A <= "0001";
		ADDR_B <= "0010";
		ADDR_W <= "0011";
		DATA <= "11111111";
		W <= '1';
		RST <= '0';

		-- Q_A <= "00000000" // indetermine
		-- Q_B <= "00000000" // indetermine
		wait for CLK_period*10;	
		ADDR_A <= "0001";
		ADDR_B <= "0010";
		ADDR_W <= "0011";
		DATA <= "11111111";
		W <= '1';
		RST <= '1';
		
		-- Q_A <= "10000001" // bypass
		-- Q_B <= "11111111" // lecture ok
		wait for CLK_period*10;	
		ADDR_A <= "0001";
		ADDR_B <= "0011";
		ADDR_W <= "0001";
		DATA <= "10000001";
		W <= '1';
		RST <= '1';
		
		-- Q_A <= "11111111" // lecture ok
		-- Q_B <= "10000001" // lecture ok
		wait for CLK_period*10;	
		ADDR_A <= "0011";
		ADDR_B <= "0001";
		ADDR_W <= "0001";
		DATA <= "10001111";
		W <= '0';
		RST <= '1';


      wait;
   end process;

END;
