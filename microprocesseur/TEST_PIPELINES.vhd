--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:57:56 05/07/2020
-- Design Name:   
-- Module Name:   /home/jgantet/microprocesseur/TEST_PIPELINES.vhd
-- Project Name:  microprocesseur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PIPELINES
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
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TEST_PIPELINES IS
END TEST_PIPELINES;
 
ARCHITECTURE behavior OF TEST_PIPELINES IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PIPELINES
    PORT(
         CLK : IN  std_logic;
         OUT_MEM_INSTRUCT : IN  std_logic_vector(31 downto 0);
         LI_DI_OP : INOUT  std_logic_vector(7 downto 0);
         LI_DI_A : INOUT  std_logic_vector(7 downto 0);
         LI_DI_B : INOUT  std_logic_vector(7 downto 0);
         LI_DI_C : INOUT  std_logic_vector(7 downto 0);
         DI_EX_OP : INOUT  std_logic_vector(7 downto 0);
         DI_EX_A : INOUT  std_logic_vector(7 downto 0);
         DI_EX_B : INOUT  std_logic_vector(7 downto 0);
         DI_EX_C : INOUT  std_logic_vector(7 downto 0);
         EX_MEM_OP : INOUT  std_logic_vector(7 downto 0);
         EX_MEM_A : INOUT  std_logic_vector(7 downto 0);
         EX_MEM_B : INOUT  std_logic_vector(7 downto 0);
         MEM_RE_OP : INOUT  std_logic_vector(7 downto 0);
         MEM_RE_A : INOUT  std_logic_vector(7 downto 0);
         MEM_RE_B : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal OUT_MEM_INSTRUCT : std_logic_vector(31 downto 0) := (others => '0');

	--BiDirs
   signal LI_DI_OP : std_logic_vector(7 downto 0);
   signal LI_DI_A : std_logic_vector(7 downto 0);
   signal LI_DI_B : std_logic_vector(7 downto 0);
   signal LI_DI_C : std_logic_vector(7 downto 0);
   signal DI_EX_OP : std_logic_vector(7 downto 0);
   signal DI_EX_A : std_logic_vector(7 downto 0);
   signal DI_EX_B : std_logic_vector(7 downto 0);
   signal DI_EX_C : std_logic_vector(7 downto 0);
   signal EX_MEM_OP : std_logic_vector(7 downto 0);
   signal EX_MEM_A : std_logic_vector(7 downto 0);
   signal EX_MEM_B : std_logic_vector(7 downto 0);
   signal MEM_RE_OP : std_logic_vector(7 downto 0);
   signal MEM_RE_A : std_logic_vector(7 downto 0);
   signal MEM_RE_B : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PIPELINES PORT MAP (
          CLK => CLK,
          OUT_MEM_INSTRUCT => OUT_MEM_INSTRUCT,
          LI_DI_OP => LI_DI_OP,
          LI_DI_A => LI_DI_A,
          LI_DI_B => LI_DI_B,
          LI_DI_C => LI_DI_C,
          DI_EX_OP => DI_EX_OP,
          DI_EX_A => DI_EX_A,
          DI_EX_B => DI_EX_B,
          DI_EX_C => DI_EX_C,
          EX_MEM_OP => EX_MEM_OP,
          EX_MEM_A => EX_MEM_A,
          EX_MEM_B => EX_MEM_B,
          MEM_RE_OP => MEM_RE_OP,
          MEM_RE_A => MEM_RE_A,
          MEM_RE_B => MEM_RE_B
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

      wait for CLK_period*10;

      OUT_MEM_INSTRUCT <= "00000001000000000000000000000000";

      wait;
   end process;

END;
