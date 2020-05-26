--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:36:24 05/13/2020
-- Design Name:   
-- Module Name:   /home/jgantet/microprocesseur/TEST_PROCESSOR.vhd
-- Project Name:  microprocesseur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PROCESSOR
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
 
ENTITY TEST_PROCESSOR IS
END TEST_PROCESSOR;
 
ARCHITECTURE behavior OF TEST_PROCESSOR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROCESSOR
    PORT(
         CLK : IN  std_logic;
         OUT_MEM_INSTRUCT : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal OUT_MEM_INSTRUCT : std_logic_vector(31 downto 0) := (others => '0');

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROCESSOR PORT MAP (
          CLK => CLK,
          OUT_MEM_INSTRUCT => OUT_MEM_INSTRUCT
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
 
      -- AFC de 9 dans reg 1
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"06010900";--"00000110000000010000100100000100"; 
		
		-- AFC 9 dans reg 2
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"06020900";--"00000110000010010000100100000000"; 
		
		 --AFC de 4 dans reg 3
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"06030400";--"00000110000001000000010000000000"; 
		
      -- COP 0x1 0x1 0x5
     -- wait for CLK_period*10;
		--OUT_MEM_INSTRUCT <= x"05010105";--"00000101000000010000000100000101"; 
		
		-- ADD de 1 et 2 dans reg 4 ( donc 18 dans 4)
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"01040102";--"00000001000000010000100100000100"; 
		
		-- MUL de 4 et 3 dans 5 ( donc 72 dans 5)
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"02050403";--"00000010000000010000100000000101"; 
	
--		-- SOU de 05 et 04 dans reg 6 ( donc 54 dans 6)
     wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"03060504";--<= "00000011000000010000100100000100"; 
--		
--		-- STORE de 06 dans mem 0 (donc 54 dans mem 0) 
      wait for CLK_period*10;
	OUT_MEM_INSTRUCT <= x"08000600";--<= "00001000000000010000100100000100"; 
--					
--		-- LOAD  de mem 0 dans 7 ( donc 54 dans 7)
      wait for CLK_period*10;
		OUT_MEM_INSTRUCT <= x"07070000";--<= "00000111000000010000100000000101"; 

      wait;
   end process;

END;
