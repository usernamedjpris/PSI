--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:47:26 04/30/2020
-- Design Name:   
-- Module Name:   /home/jgantet/microprocesseur/TEST_DATA_MEMORY.vhd
-- Project Name:  microprocesseur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DATA_MEMORY
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
 
ENTITY TEST_DATA_MEMORY IS
END TEST_DATA_MEMORY;
 
ARCHITECTURE behavior OF TEST_DATA_MEMORY IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal ADDR : std_logic_vector(7 downto 0) := (others => '0');
   signal DATAIN : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal DATAOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATA_MEMORY PORT MAP (
          ADDR => ADDR,
          DATAIN => DATAIN,
          RW => RW,
          RST => RST,
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
		
		
		-- on ecrit 1 dans deuxieme case
		-- DATAOUT <= "00000001"
		wait for CLK_period*10;
		DATAIN <= "00000001";
		ADDR <= "00000010";
		RST <= '1';
		RW <= '0';
		
		-- on reset 
		-- DATAOUT <= "00000000" 
		wait for CLK_period*10;
		DATAIN <= "00000001";
		ADDR <= "00000010";
		RST <= '0';
		RW <= '1';
		
		-- on lit dans deuxieme case
		-- DATAOUT <= "00000000" 
		wait for CLK_period*10;
		DATAIN <= "00000011";
		ADDR <= "00000010";
		RW <= '1';
		RST <= '1';		
		
		-- on ecrit 111 dans deuxieme case
		-- DATAOUT <= "00000111"
		wait for CLK_period*10;
		DATAIN <= "00000111";
		ADDR <= "00000010";
		RST <= '1';
		RW <= '0';
		
		-- on lit dans deuxieme case
		-- DATAOUT <= "00000111"
		wait for CLK_period*10;
		DATAIN <= "00000000";
		ADDR <= "00000010";
		RST <= '1';
		RW <= '1';

      wait;
   end process;

END;
