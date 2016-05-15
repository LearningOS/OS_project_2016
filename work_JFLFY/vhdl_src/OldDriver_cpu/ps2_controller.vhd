----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:48 12/20/2015 
-- Design Name: 
-- Module Name:    ps2_controller - Behavioral 
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

entity ps2_controller is
Port(
	clk:in std_logic;
	rst:in std_logic;

	intAck: in std_logic;
	intReq: out std_logic;

	enHi:in std_logic;
	enLo:in std_logic;

	lightHi:out std_logic_vector(0 to 6);
	lightLo:out std_logic_vector(0 to 6);

	kdb_data:in std_logic_vector(3 downto 0)
);
end ps2_controller;

architecture Behavioral of ps2_controller is
	component ps2_module
	Port(
		clk:in std_logic;
		rst:in std_logic;

		intAck:in std_logic;
		intReqOutput:out std_logic;
		asciiOutput:out std_logic_vector(7 downto 0);

		enHi:in std_logic;
		enLo:in std_logic;

		kbdDataInput:in std_logic_vector(3 downto 0)
	);
	end component;

	component light_controller
	Port(
		dataInput:in std_logic_vector(3 downto 0);
		segOutput:out std_logic_vector(0 to 6)
	);
	end component;

	signal ascii:std_logic_vector(7 downto 0);

begin
	u0:ps2_module
	port map(
		clk => clk,
		rst => rst,
		intAck => intAck,
		intReqOutput => intReq,
		asciiOutput => ascii,
		enHi => enHi,
		enLo => enLo,
		kbdDataInput => kdb_data
	);

	uHi:light_controller
	port map(
		dataInput => ascii(7 downto 4),
		segOutput => lightHi
	);

	uLo:light_controller
	port map(
		dataInput => ascii(3 downto 0),
		segOutput => lightLo
	);

end Behavioral;

