----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:07 11/18/2015 
-- Design Name: 
-- Module Name:    MEMWB - Behavioral 
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

entity MEMWB is
Port(
	-- rst
	rst:in std_logic;
	-- clk
	clk:in std_logic;
	-- 参数及信号传递
	--insResultInput:in std_logic_vector(31 downto 0);
	--insResultOutput:out std_logic_vector(31 downto 0);
	aluResultInput:in std_logic_vector(31 downto 0);
	aluResultOutput:out std_logic_vector(31 downto 0);

	mmuResultInput:in std_logic_vector(31 downto 0);
	mmuResultOutput:out std_logic_vector(31 downto 0);

	wbIndexInput:in std_logic_vector(4 downto 0);
	wbIndexOutput:out std_logic_vector(4 downto 0);
	
	hiWBInput:in std_logic_vector(31 downto 0);
	hiWBOutput:out std_logic_vector(31 downto 0);

	loWBInput:in std_logic_vector(31 downto 0);
	loWBOutput:out std_logic_vector(31 downto 0);

	-- 用于WB级的信号
	memReadInput:in std_logic;
	memReadOutput:out std_logic;
	loadExModeInput:in std_logic;
	loadExModeOutput:out std_logic;
	ldstLenInput:in std_logic_vector(1 downto 0);
	ldstLenOutput:out std_logic_vector(1 downto 0);
	regWriteInput:in std_logic;
	regWriteOutput:out std_logic;
	hiloWriteInput:in std_logic_vector(1 downto 0);
	hiloWriteOutput:out std_logic_vector(1 downto 0);
	cp0WriteInput:in std_logic;
	cp0WriteOutput:out std_logic;

	-- TODO: finish the logic about 

	-- 是否发生异常
	excOccur:in std_logic;
	-- update in vertion 6
	mmuReset:in std_logic

	-- TODO: deal the logic about mmuReset

);
end MEMWB;

architecture Behavioral of MEMWB is
signal excOccurAndRstAndMmuReset:std_logic_vector(2 downto 0);
constant zero:std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
begin
	excOccurAndRstAndMmuReset <= excOccur & not rst & mmuReset;
	process(clk)
	begin
		if (clk'event and clk = '1')then
			case excOccurAndRstAndMmuReset is
				when "000" =>
					
					regWriteOutput <= regWriteInput;
					hiloWriteOutput <= hiloWriteInput;
					cp0WriteOutput <= cp0WriteInput;
					
					--insResultOutput <= insResultInput;
					aluResultOutput <= aluResultInput;
					mmuResultOutput <= mmuResultInput;

					wbIndexOutput <= wbIndexInput;
					hiWBOutput <= hiWBInput;
					loWBOutput <= loWBInput;

					memReadOutput <= memReadInput;
					loadExModeOutput <= loadExModeInput;
					ldstLenOutput <= ldstLenInput;
					regWriteOutput <= regWriteInput;
					hiloWriteOutput <= hiloWriteInput;
					cp0WriteOutput <= cp0WriteInput;
				when others =>
					regWriteOutput <= '0';
					hiloWriteOutput <= "00";
					cp0WriteOutput <= '0';

					--insResultOutput <= zero;
					aluResultOutput <= zero;
					mmuResultOutput <= zero;

					wbIndexOutput <= "00000";
					hiWBOutput <= zero;
					loWBOutput <= zero;

					ldstLenOutput <= "00";
					memReadOutput <= '0';
					loadExModeOutput <= '0';
					regWriteOutput <= '0';
					hiloWriteOutput <= "00";
					cp0WriteOutput <= '0';
			end case;
		end if;
	end process;

end Behavioral;

