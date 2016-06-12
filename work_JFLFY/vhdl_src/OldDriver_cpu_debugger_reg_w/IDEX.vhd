----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:18:53 11/18/2015 
-- Design Name: 
-- Module Name:    IDEX - Behavioral 
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

entity IDEX is
Port(
	-- 时钟
	clk:in std_logic;
	-- 清零
	rst:in std_logic;
	-- 是否冒险重置寄存器
	riskReset:in std_logic;
	-- rs
	rsValueInput:in std_logic_vector(31 downto 0);
	multiSelOutput:out std_logic;						--in reg
	rsValueOutput:out std_logic_vector(31 downto 0);	--in reg
	rsAbsValueOutput:out std_logic_vector(31 downto 0);	--in reg
	-- rt
	rtValueInput:in std_logic_vector(31 downto 0);
	rtValueOutput:out std_logic_vector(31 downto 0);	--in reg
	rtAbsValueOutput:out std_logic_vector(31 downto 0);	--in reg
	-- 立即数
	immInput:in std_logic_vector(15 downto 0);
	immOutput:out std_logic_vector(15 downto 0);
	-- PC + 4的值
	pc4Input:in std_logic_vector(31 downto 0);
	pc4Output:out std_logic_vector(31 downto 0);
	-- index
	wbRtOrRdOrRa:in std_logic_vector(1 downto 0);
	rtIndexInput:in std_logic_vector(4 downto 0);
	rdIndexInput:in std_logic_vector(4 downto 0);
	rdIndexOutput:out std_logic_vector(4 downto 0);
	wbIndexoutput:out std_logic_vector(4 downto 0);
	-- 用于EX级的信号
	aluOpInput:in std_logic_vector(3 downto 0);
	aluOpOutput:out std_logic_vector(3 downto 0);
	immExtendInput:in std_logic;
	immExtendOutput:out std_logic;
	immOrRtInput:in std_logic;
	immOrRtOutput:out std_logic;
	slimmOrRsInput:in std_logic;
	slimmOrRsOutput:out std_logic;
	exSelectInput:in std_logic_vector(1 downto 0);
	exSelectOutput:out std_logic_vector(1 downto 0);
	hiloReadInput:in std_logic;
	hiloReadOutput:out std_logic;
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
	-- 异常信息输入
	ifidExcCodeInput:in std_logic_vector(31 downto 0);
	ctrlExcCodeInput:in std_logic_vector(31 downto 0);
	-- 异常信息输出
	excCodeOutput:out std_logic_vector(31 downto 0);
	-- 发生异常是否需要清空
	excOccur:in std_logic;
	-- 延迟槽传递
	excDelayInput:in std_logic;
	excDelayOutput:out std_logic;
	-- forbid interrupt
	intDisableInput:in std_logic;
	intDisableOutput:out std_logic;

	-- update in version 6.0 
	mmuPreserve:in std_logic
);
end IDEX;

architecture Behavioral of IDEX is
	constant zero: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal wbReg:std_logic_vector(4 downto 0);
	signal excCode : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal intDisable : std_logic := '0';
	signal rsValueReg:std_logic_vector(31 downto 0);
	signal rtValueReg:std_logic_vector(31 downto 0);
	signal rsAbsValueReg:std_logic_vector(31 downto 0);
	signal rtAbsValueReg:std_logic_vector(31 downto 0);
	signal multiSelReg:std_logic;
begin
	-- optimization****
	rsValueOutput<=rsValueReg;
	rtValueOutput<=rtValueReg;
	rsAbsValueOutput<=rsAbsValueReg;
	rtAbsValueOutput<=rtAbsValueReg;
	multiSelOutput<=multiSelReg;

	wbReg <= 
			"11111" when (wbRtOrRdOrRa = "11") else--;--;--;--;--;--;--;--;需要约定wbRbOrRtOrRA的值
			rtIndexInput when (wbRtOrRdOrRa = "01") else
			rdIndexInput when (wbRtOrRdOrRa = "10") else
			"00000";
	excCode <= ifidExcCodeInput when (ifidExcCodeInput /= zero) else
			   ctrlExcCodeInput when (ctrlExcCodeInput /= zero) else
			   zero;
	intDisable <= intDisableInput or excOccur;
	process(clk)
	begin
		if (clk'event and clk = '1')then
			if excOccur = '1' or rst = '0' or (mmuPreserve = '0' and riskReset = '1') then
				-- 延迟槽
				excDelayOutput <= '0';
				-- Ex
				aluOpOutput <= "1011";
				immExtendOutput <= '0';
				immOrRtOutput <= '0';
				slimmOrRsOutput <= '0';
				exSelectOutput <= "00";
				hiloReadOutput <= '0';
				-- Mem
				memWriteOutput <= '0';
				isSBOutput <= '0';
				-- WB
				ldstLenOutput <= "00";
				loadExModeOutput <= '0';
				memReadOutput <= '0';
				regWriteOutput <= '0';
				hiloWriteOutput <= "00";
				cp0WriteOutput <= '0';
				-- 寄存器值
				rsValueReg <= zero;
				rtValueReg <= zero;
				rsAbsValueReg <= zero;
				rtAbsValueReg <= zero;
				multiSelReg <= '0';
				-- 立即数
				immOutput <= "0000000000000000";
				-- PC + 4
				pc4Output <= zero;
				-- index
				rdIndexOutput <= "00000";
				-- 写回寄存器号
				wbIndexoutput <= "00000";
				excCodeOutput <= zero;
				intDisableOutput <= '1';
			elsif mmuPreserve = '0' then
				-- 延迟槽
				excDelayOutput <= excDelayInput;
				-- Ex
				aluOpOutput <= aluOpInput;
				immExtendOutput <= immExtendInput;
				immOrRtOutput <= immOrRtInput;
				slimmOrRsOutput <= slimmOrRsInput;
				exSelectOutput <= exSelectInput;
				hiloReadOutput <= hiloReadInput;
				-- Mem
				memWriteOutput <= memWriteInput;
				isSBOutput <= isSBInput;
				-- WB
				loadExModeOutput <= loadExModeInput;
				ldstLenOutput <= ldstLenInput;
				memReadOutput <= memReadInput;
				regWriteOutput <= regWriteInput;
				hiloWriteOutput <= hiloWriteInput;
				cp0WriteOutput <= cp0WriteInput;
				-- 寄存器值
				rsValueReg <= rsValueInput;
				rtValueReg <= rtValueInput;
				case rsValueInput(31) is
				when '0'=>
					rsAbsValueReg<=rsValueInput;
				when '1'=>
					rsAbsValueReg<=(not rsValueInput)+1;
				when others=>
				end case;
				case rtValueInput(31) is
				when '0'=>
					rtAbsValueReg<=rtValueInput;
				when '1'=>
					rtAbsValueReg<=(not rtValueInput)+1;
				when others=>
				end case;
				multiSelReg <= rsValueInput(31) xor rtValueInput(31);

				-- 立即数
				immOutput <= immInput;
				-- PC + 4
				pc4Output <= pc4Input;
				-- index
				rdIndexOutput <= rdIndexInput;
				-- 写回寄存器号
				wbIndexoutput <= wbReg;
				-- 异常相管
				excCodeOutput <= excCode;
				intDisableOutput <= intDisable;	
			else
				-- empty
			end if;
		end if;
	end process;
end Behavioral;
