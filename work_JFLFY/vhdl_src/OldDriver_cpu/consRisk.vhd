----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:52:52 12/01/2015 
-- Design Name: 
-- Module Name:    consRisk - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity consRisk is
Port(
	-- clk
	clk:in std_logic;
	-- rst
	rst:in std_logic;

	cntBubble:in std_logic_vector(4 downto 0);

	-- output
	stateGeqZero:out std_logic;
	stateGeqOne:out std_logic;
	stateEqualOne:out std_logic
);
end consRisk;

architecture Behavioral of consRisk is

signal state:std_logic_vector(4 downto 0):="00000";

begin
	stateGeqZero<='1' when '0'&state>0 else '0';
	stateGeqOne<='1' when '0'&state>1 else '0';
	stateEqualOne<='1' when state=1 else '0';
	
	--stateGeqZero<='1' when (state(4) = '0' and state /= "00000") else '0';
	--stateGeqOne<='1' when (state(4) = '0' and state /= "00000" and ) else '0';
	--stateEqualOne<='1' when (state = "00001") else '0';

	process(clk)
	begin
	if (clk'event and clk='0') then
		-- we must consider that this rst is in falling edge.
		-- it may failed when rst is too short to last a period.
		if (rst='0') then
			state<="00000";
		else
			case state is
			when "00000"=>
				state<=cntBubble;
			when others=>
				state<=state-1;
			end case;
		end if;
	end if;
	end process;

end Behavioral;

