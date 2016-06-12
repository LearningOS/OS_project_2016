----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:28:41 12/20/2015 
-- Design Name: 
-- Module Name:    light_controller - Behavioral 
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

entity light_controller is
Port(
	dataInput:in std_logic_vector(3 downto 0);
	segOutput:out std_logic_vector(0 to 6)
);
end light_controller;

architecture Behavioral of light_controller is
	signal seg: std_logic_vector(0 to 6) := (others => '0');
begin

	segOutput <= seg;
	process (dataInput)
	begin
		case dataInput is
			when "0000" => seg <= "1111110";
			when "0001" => seg <= "0110000";
			when "0010" => seg <= "1101101";
			when "0011" => seg <= "1111001";
			when "0100" => seg <= "0110011";
			when "0101" => seg <= "1011011";
			when "0110" => seg <= "1011111";
			when "0111" => seg <= "1110000";
			when "1000" => seg <= "1111111";
			when "1001" => seg <= "1110011";
			when "1010" => seg <= "1110111";
			when "1011" => seg <= "0011111";
			when "1100" => seg <= "1001110";
			when "1101" => seg <= "0111101";
			when "1110" => seg <= "1001111";
			when "1111" => seg <= "1000111";
			when others => seg <= "0000000";
		end case;
	end process;
end Behavioral;

