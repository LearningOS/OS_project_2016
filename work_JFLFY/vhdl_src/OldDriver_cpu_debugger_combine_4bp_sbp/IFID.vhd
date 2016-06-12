----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:59:20 11/04/2015 
-- Design Name: 
-- Module Name:    IFID - Behavioral 
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

entity IFID is
Port(
	-- 时钟信号
	clk:in std_logic;
	-- 清零
	rst:in std_logic;
	-- 整条指令
	instrInput:in std_logic_vector(31 downto 0);
	-- PC�	
	pc4Input:in std_logic_vector(31 downto 0);
	-- 异常代码输入
	excCodeInput:in std_logic_vector(31 downto 0);
	-- 是否发生异常
	dbOccurS:in std_logic;
	excOccur:in std_logic;
	-- 是否处于延迟�	
	excDelayInput:in std_logic;
	--	是否冒险(即是否需要暂停流�
	riskPreserve:in std_logic;
	-- mmu stop
	mmuPreserve:in std_logic;
	
	-- 将整条指令输�	-- instrOutput: out std_logic_vector(31 downto 0);
	------
	opOutput:out std_logic_vector(5 downto 0);
	rsOutput:out std_logic_vector(4 downto 0);
	rtOutput:out std_logic_vector(4 downto 0);
	rdOutput:out std_logic_vector(4 downto 0);
	-- slOutput:out std_logic_vector(4 downto 0);
	functOutput:out std_logic_vector(5 downto 0);
	------
	immOffsetOutput:out std_logic_vector(15 downto 0);
	immAddrOutput:out std_logic_vector(9 downto 0);
	------
	mc0Output:out std_logic;
	brcType:out std_logic_vector(3 downto 0);
	------
	-- instruction end.
	-- 将PC值输�	
	pc4Output: out std_logic_vector(31 downto 0);
	-- 延迟槽输�	
	excDelayOutput:out std_logic;
	-- 将异常代码输�	
	excCodeOutput:out std_logic_vector(31 downto 0);
	-- ???????????????????????????????????????????????????????
	intDisableOutput:out std_logic
);
end IFID;

architecture Behavioral of IFID is
constant zero:std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal instrOutput:std_logic_vector(31 downto 0) := zero;
signal excOccurAndRst : std_logic_vector(1 downto 0) := "00";
begin

	opOutput <= instrOutput(31 downto 26);
	rsOutput <= instrOutput(25 downto 21);
	rtOutput <= instrOutput(20 downto 16);
	rdOutput <= instrOutput(15 downto 11);
	functOutput <= instrOutput(5 downto 0);

	immOffsetOutput <= instrOutput(15 downto 0);
	immAddrOutput <= instrOutput(25 downto 16);

	mc0Output <= instrOutput(23);
	brcType <= instrOutput(28 downto 26) & instrOutput(16) when excOccur='0' and dbOccurS='0' else
			   "1000";

	excOccurAndRst <= (dbOccurS or excOccur) & not rst;

	process(clk)
	begin
		if (clk'event and clk = '1') then
			case excOccurAndRst is
				when "00" =>
					if (riskPreserve = '0' and mmuPreserve = '0')then
						instrOutput <= instrInput;
						pc4Output <= pc4Input;
						excDelayOutput <= excDelayInput;
						excCodeOutput <= excCodeInput;
						intDisableOutput <= excOccur;
					end if;
				when others =>
					excCodeOutput <= zero;
					excDelayOutput <= '0';
					instrOutput <= zero;
					pc4Output <= zero;
					intDisableOutput <= '1';
			end case;
		end if;
	end process;

end Behavioral;

