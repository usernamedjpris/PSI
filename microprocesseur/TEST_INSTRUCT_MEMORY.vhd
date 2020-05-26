--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:50:10 04/30/2020
-- Design Name:   
-- Module Name:   /home/jgantet/microprocesseur/TEST_INSTRUCT_MEMORY.vhd
-- Project Name:  microprocesseur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: INSTRUCT_MEMORY
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
 
ENTITY TEST_INSTRUCT_MEMORY IS
END TEST_INSTRUCT_MEMORY;
 
ARCHITECTURE behavior OF TEST_INSTRUCT_MEMORY IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT INSTRUCT_MEMORY
    PORT(
         ADDR : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         DATAOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADDR : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal DATAOUT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: INSTRUCT_MEMORY PORT MAP (
          ADDR => ADDR,
          CLK => CLK,
          DATAOUT => DATAOUT
        );

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

		-- on lit la premiere instruction
		-- DATAOUT <= "00000001000000010000100100000100"; -- AFC R1 R9 R4
		wait for CLK_period*10;
		ADDR <= "00000001";
		
		-- on lit dans deuxieme instruction
		-- DATAOUT <= "00000110000000010000100100000100"; -- AFC R1 R9 R4
		wait for CLK_period*10;
		ADDR <= "00000010";
		
		-- on lit dans troisieme instruction
		-- DATAOUT <= "00000000000000000000000000000000"; -- neant
		wait for CLK_period*10;
		ADDR <= "00000011";

      wait;
   end process;

END;
