----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:00 11/18/2015 
-- Design Name: 
-- Module Name:    EXMEM - Behavioral 
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

entity EXMEM is
Port(
	-- 时钟
	clk:in std_logic;
	-- 同步清零
	rst:in std_logic;
	-- 值传递
	exResultInput:in std_logic_vector(31 downto 0);
	exResultOutput:out std_logic_vector(31 downto 0);

	rtValueInput:in std_logic_vector(31 downto 0);
	rtValueOutput:out std_logic_vector(31 downto 0);

	wbIndexInput:in std_logic_vector(4 downto 0);
	wbIndexOutput:out std_logic_vector(4 downto 0);

	hiCalcInput:in std_logic_vector(31 downto 0);
	hiWBOutput:out std_logic_vector(31 downto 0);
	
	loCalcInput:in std_logic_vector(31 downto 0);
	loWBOutput:out std_logic_vector(31 downto 0);
	
	-- PC加4传递
	pc4Input:in std_logic_vector(31 downto 0);
	pc4Output:out std_logic_vector(31 downto 0);

	-- 异常发生否?
	excOccur:in std_logic;
	-- 延迟槽传递
	excDelayInput:in std_logic;
	excDelayOutput:out std_logic;
	-- 异常码传递
	idexExcCodeInput:in std_logic_vector(31 downto 0);
	excCodeOutput:out std_logic_vector(31 downto 0);

	-- update in version 6
	mmuPreserve:in std_logic;
	mmuReset:in std_logic;
	-- update end

	-- TODO : finish the logic about the mmuReset and mmuPreserve
	
	-- 用于MEM级的信号
	memWriteInput:in std_logic;
	memWriteOutput:out std_logic;
	-- update in version 6.0
	isSBInput:in std_logic;
	isSBOutput:out std_logic;
	-- update end
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

	-- forbid the interrupt
	intDisableInput:in std_logic;
	intDisableOutput:out std_logic
	-- addrLoOutput,发送可能写入地址的低两位
	-- addrLoOutput:out std_logic_vector(1 downto 0)
);
end EXMEM;

architecture Behavioral of EXMEM is
constant zero:std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal excOccurAndRstAndMmuReset:std_logic_vector(2 downto 0);
	signal intDisable : std_logic := '0';

	-- optimization *** have erase something
	signal exResultReg:std_logic_vector(31 downto 0);
	signal hiCalcReg:std_logic_vector(31 downto 0);
	signal loCalcReg:std_logic_vector(31 downto 0);
	signal hiloWriteReg:std_logic_vector(1 downto 0);
begin
	excOccurAndRstAndMmuReset <= excOccur & not rst & mmuReset;
	intDisable <= intDisableInput or excOccur;

	-- put selection on MEM can short key path
	exResultOutput<=exResultReg;
	hiloWriteOutput<=hiloWriteReg;
	with hiloWriteReg select
	hiWBOutput<=
		exResultReg when "10",
		hiCalcReg when others;
	with hiloWriteReg select
	loWBOutput<=
		exResultReg when "01",
		loCalcReg when others;

	process(clk)
	begin
		if (clk = '1' and clk'event)then
			case excOccurAndRstAndMmuReset is
				when "000" =>
					if (mmuPreserve = '0')then
						-- PC
						pc4Output <= pc4Input;
						-- Mem
						memWriteOutput <= memWriteInput;
						isSBOutput <= isSBInput;
						-- WB
						ldstLenOutput <= ldstLenInput;
						loadExModeOutput <= loadExModeInput;
						memReadOutput <= memReadInput;
						regWriteOutput <= regWriteInput;
						hiloWriteReg <= hiloWriteInput;
						cp0WriteOutput <= cp0WriteInput;
						
						exResultReg <= exResultInput;
						rtValueOutput <= rtValueInput;
						wbIndexOutput <= wbIndexInput;
						-- hiWBOutput <= hiCalcInput;
						-- loWBOutput <= loCalcInput;
						-- 异常
						excCodeOutput <= idexExcCodeInput;
						excDelayOutput <= excDelayInput;
						intDisableOutput <= intDisable;
						-- addr
						--addrLoOutput <= exResultInput(1 downto 0);

						hiCalcReg <= hiCalcInput;
						loCalcReg <= loCalcInput;
					end if;
				when others =>
					-- PC
					pc4Output <= zero;
					-- mem
					memWriteOutput <= '0';
					isSBOutput <= '0';
					-- WB
					ldstLenOutput <= "00";
					memReadOutput <= '0';
					loadExModeOutput <= '0';
					regWriteOutput <= '0';
					hiloWriteReg <= "00";
					cp0WriteOutput <= '0';
					
					exResultReg <= zero;
					rtValueOutput <= zero;
					wbIndexOutput <= "00000";
					hiCalcReg <= zero;
					loCalcReg <= zero;
					-- 异常
					excCodeOutput <= zero;
					excDelayOutput <= '0';
					intDisableOutput <= '1';
					-- addr
					--addrLoOutput <= "00";
			end case;
		end if;
	end process;

end Behavioral;

