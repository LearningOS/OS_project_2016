----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:28 11/04/2015 
-- Design Name: 
-- Module Name:    multi - Behavioral 
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

-- 该模块处于EXE级

entity multi is
Port(
	multiSel:in std_logic;
	rsAbsValue:in std_logic_vector(31 downto 0);
	rtAbsValue:in std_logic_vector(31 downto 0);
	hiOutput:out std_logic_vector(31 downto 0);
	loOutput:out std_logic_vector(31 downto 0)
);
end multi;

architecture Behavioral of multi is
	signal tmp : std_logic_vector(63 downto 0);
begin
	with multiSel select
	tmp<=
		rsAbsValue*rtAbsValue when '0',
		not(rsAbsValue*rtAbsValue)+1 when '1';
	hiOutput<=tmp(63 downto 32);
	loOutput<=tmp(31 downto 0);
end Behavioral;

