----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:05:49 04/22/2020 
-- Design Name: 
-- Module Name:    BC_REGISTREs - Behavioral 
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BC_REGISTREs is
    Port ( ADDR_A : in  STD_LOGIC_VECTOR (3 downto 0);
           ADDR_B : in  STD_LOGIC_VECTOR (3 downto 0);
           ADDR_W : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
			  
end BC_REGISTREs;




architecture Behavioral of BC_REGISTREs is
	type REGISTRE is Array(0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
   signal banc_de_registre: REGISTRE;

begin

   process (CLK)
   BEGIN 
		if (clk'event and CLK='0') then
			if RST='0' then 								--reset tous les registres	
				--for I in 0 to 15 loop
				--	banc_de_registre(I)<= "00000000";
				--end loop;			
				banc_de_registre <= (others =>"00000000");
				QA <= "00000000";
				QB <= "00000000";
			else
				 if W='1' then   						-- ecriture           
					  banc_de_registre(to_integer(unsigned(ADDR_W))) <= DATA;	
				 end if;
				 --QA <= banc_de_registre(to_integer(unsigned(ADDR_A))) when (ADDR_A /= ADDR_W or W='0') else DATA; --This construct is only supported in VHDL 1076-2008
				 if (ADDR_A /= ADDR_W or W='0') then
					QA <= banc_de_registre(to_integer(unsigned(ADDR_A)));
				 else
					QA <= DATA;
				 end if;
				 --QB <= banc_de_registre(to_integer(unsigned(ADDR_B))) when (ADDR_B /= ADDR_W or W='0') else DATA; --This construct is only supported in VHDL 1076-2008
				 if (ADDR_B /= ADDR_W or W='0') then
					QB <= banc_de_registre(to_integer(unsigned(ADDR_B)));
				 else
					QB <= DATA;
				 end if;
			end if;
		end if;	  
									
	END process;

END Behavioral;

