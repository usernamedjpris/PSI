----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:14:04 04/30/2020 
-- Design Name: 
-- Module Name:    DATA_MEMORY - Behavioral 
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

entity DATA_MEMORY is
    Port ( ADDR : in  STD_LOGIC_VECTOR (7 downto 0);
           DATAIN : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DATAOUT : out  STD_LOGIC_VECTOR (7 downto 0));
end DATA_MEMORY;

architecture Behavioral of DATA_MEMORY is

type MEMORY is Array(0 to 255) of STD_LOGIC_VECTOR (7 downto 0); 
signal data_memory: MEMORY;
	
begin

process (CLK)
   BEGIN 
		if (clk'event and CLK='0') then --mettre failing edge
			if RST='0' then 								
				data_memory <= (others =>"00000000");
				DATAOUT <= "00000000";	
			else
				 if RW='1' then   						-- lecture         
					  DATAOUT <= data_memory(to_integer(unsigned(ADDR)));
				 else                               -- ecriture					  
					  data_memory(to_integer(unsigned(ADDR))) <= DATAIN;
					  DATAOUT <= DATAIN;
				 end if;
			end if;
		end if;	  
									
	END process;

end Behavioral;

