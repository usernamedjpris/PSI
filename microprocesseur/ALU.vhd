----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:16:58 04/21/2020 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

	signal add: std_logic_vector(8 downto 0);
	signal sub: std_logic_vector(8 downto 0);
	signal mul: std_logic_vector(15 downto 0);
	
begin

	add <= (b"0"&A)+(b"0"&B);
	sub <= (b"0"&A)-(b"0"&B);
	mul <= A*B;

	C <= add(8);
	
	N <= add(7) when Ctrl_Alu = "001" else 
		  mul(7) when Ctrl_Alu = "010" else 
		  sub(7);
		  
	Z <= '0' when ((Ctrl_Alu = "001") and (add(7 downto 0) = "00000000")) else
		  '0' when ((Ctrl_Alu = "010") and (mul(7 downto 0) = "00000000")) else
		  '0' when ((Ctrl_Alu = "011") and (sub(7 downto 0) = "00000000")) else
		  '1';
		  
	O <= '0' when ((Ctrl_Alu = "011") or (Ctrl_Alu = "001") ) else
		  '0' when ((Ctrl_Alu = "010") and (mul(15 downto 8) = "00000000")) else
		  '1';

	S <= add(7 downto 0) when Ctrl_Alu = "001" else 
		  mul(7 downto 0) when Ctrl_Alu = "010" else 
		  sub(7 downto 0);

end Behavioral;





