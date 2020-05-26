----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:04 04/30/2020 
-- Design Name: 
-- Module Name:    INSTRUCT_MEMORY - Behavioral 
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
USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INSTRUCT_MEMORY is
    Port ( ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           DATAOUT : out STD_LOGIC_VECTOR (31 downto 0));
end INSTRUCT_MEMORY;

architecture Behavioral of INSTRUCT_MEMORY is

type MEMORY is Array(0 to 255) of STD_LOGIC_VECTOR (31 downto 0); 
signal instruct_memory: MEMORY;

begin
	instruct_memory <=
			(  0 => x"01abcdef", --"00000110000000010000100100000100", -- AFC R1 R9 R4
				1 => x"fedcba10", --"00000001000000010000100100000100",  -- ADD R1 R9 R4 
				others => x"00000000"
			);
			
	--instruct_memory(to_integer(unsigned(x"00"))) <= "00000110000000010000100100000100"; -- AFC R1 R9 R4
	--instruct_memory(to_integer(unsigned(x"01"))) <= "00000001000000010000100100000100"; -- ADD R1 R9 R4
process (CLK)
   BEGIN 
		if (clk'event and CLK='1') then   		   
			DATAOUT <= instruct_memory(to_integer(unsigned(ADDR)));
		end if;	  									
	END process;
	
end Behavioral;

