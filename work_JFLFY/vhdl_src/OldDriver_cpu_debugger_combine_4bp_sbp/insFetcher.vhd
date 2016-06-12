----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:04:09 11/04/2015 
-- Design Name: 
-- Module Name:    insFetcher - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- 取值模块,工作在IF阶段
-- 在下降沿触发
entity insFetcher is
Port(
	-- 时钟
	clk:in std_logic;
	-- reset
	rst:in std_logic;
	-- 计算出来的跳转地址
	jmpPCAddr:in std_logic_vector(31 downto 0);
	-- 是否需要跳转
	jmpFlag:in std_logic;
	-- 是否需要锁住PC
	riskPreserve:in std_logic;
	-- mmu stop
	mmuPreserve:in std_logic;
	-- excCodeTrans
	excCodeTrans:in std_logic_vector(31 downto 0);
	-- transform instruction
	inStrTrans:in std_logic_vector(31 downto 0);
	
	-- ver 6.1
	dbOccurS:in std_logic;
	excOccur:in std_logic;


	-- 异常代码
	excCode:out std_logic_vector(31 downto 0);
	-- 取到的指令
	inStr:out std_logic_vector(31 downto 0);
	-- PC加4
	pc4Output:out std_logic_vector(31 downto 0);
	-- for ram
	pcVaddrOutput:out std_logic_vector(31 downto 0)
);
end insFetcher;

architecture Behavioral of insFetcher is

	constant pcStart:std_logic_vector(31 downto 0):=X"B0000000";
	signal pcReg:std_logic_vector(31 downto 0):=pcStart;
	signal pcPlus4:std_logic_vector(31 downto 0):=pcStart+4;
	signal unStart:std_logic:='0';

	-- init value is the start
begin
	-- it can be use when pcReg is stable
	pcVaddrOutput<=pcReg;
	instr<=instrTrans;
	pcPlus4<=pcReg+4;
	pc4Output<=pcPlus4;
	excCode<=excCodeTrans;
	
	process(clk)
	begin
	-- only next rising edge is coming, the all in-signals are stable
	-- we can't bring it to falling edge
	if (clk'event and clk='1') then
		if (rst='0') then
			pcReg<=X"B0000000";
				-- trick for self-boot
			unStart<='0';
		else
			--if riskPreserve = '0' and mmuPreserve = '0' then
			--	case jmpFlag is
			--		when '1'=>
			--			pcReg<=jmpPCAddr;
			--		when '0'=>
			--			pcReg<=pcPlus4;
			--		when others=>
			--	end case;
			--end if;

			-- ver 6.1
			if (unStart='0') then
				pcReg<=pcStart;
				unStart<='1';
			else 
				if (riskPreserve = '0' and mmuPreserve = '0') or excOccur = '1' or dbOccurS='1' then
					case jmpFlag is
						when '1'=>
							pcReg<=jmpPCAddr;
						when '0'=>
							pcReg<=pcPlus4;
						when others=>
					end case;
				end if;
			end if;
		end if;
	end if;
	end process;	

end Behavioral;

