----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:23 11/18/2015 
-- Design Name: 
-- Module Name:    exSelecter - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exSelecter is
Port(
	cp0Input:in std_logic_vector(31 downto 0);
	hiloInput:in std_logic_vector(31 downto 0);
	aluInput:in std_logic_vector(31 downto 0);
	pc4Input:in std_logic_vector(31 downto 0);
	exResult:out std_logic_vector(31 downto 0);
	-- 选择信号
	-- "00" 表示cp0
	-- "01" 表示hilo
	-- "10" 表示alu
	-- "11" 表示rpc
	exSelect:in std_logic_vector(1 downto 0)
);
end exSelecter;

architecture Behavioral of exSelecter is
begin
	with exSelect select 
	exResult<=
		cp0Input when "00",
		hiloInput when "01",
		aluInput when "10",
		pc4Input+4 when "11";
end Behavioral;

