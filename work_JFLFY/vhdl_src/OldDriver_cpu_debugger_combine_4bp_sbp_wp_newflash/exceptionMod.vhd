----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:28 11/19/2015 
-- Design Name: 
-- Module Name:    exceptionMod - Behavioral 
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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.defines.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exceptionMod is
Port(
	clk,rst:in std_logic;

	memRead:in std_logic;
	memWrite:in std_logic;

	isBreakInput:in std_logic;
	exmemExcCodeInput:in std_logic_vector(31 downto 0);
	mmuExcCodeInput:in std_logic_vector(31 downto 0);
	statusInput:in std_logic_vector(31 downto 0);
	causeInput:in std_logic_vector(31 downto 0);
	
	-- 延迟槽传�	
	branchOrJumpInput:in  std_logic_vector(1 downto 0);
	excDelayInput:in std_logic;
	excDelayOutput:out std_logic;

	-- 输出
	excOccur:out std_logic;
	excReturn:out std_logic;
	excCode:out std_logic_vector(31 downto 0);
	-- update in version 6
	excTLB:out std_logic;
	excNested:out std_logic;
	-- update ends

	-- TODO: complete the output logic of excTLB and excNested

	dbCont,dbStep,dbStop:in std_logic;
	hard_break:in brk_arr;
	watch_point:in wtc_arr;
	dbOccur:out std_logic;
	dbOccurS:out std_logic;

	-- 中断禁止
	intDisable:in std_logic;
	-- PC + 4 传�	
	pc4Input:in std_logic_vector(31 downto 0);
	pc4Output:out std_logic_vector(31 downto 0);
	
	memVaddrInput:in std_logic_vector(31 downto 0);	
	vaddrInput:in std_logic_vector(31 downto 0);	-- for BadVaddr
	badvaddrOutput:out std_logic_vector(31 downto 0)

);
end exceptionMod;

architecture Behavioral of exceptionMod is
	constant zero:std_logic_vector(31 downto 0):=X"00000000";
	signal realInterupt:std_logic_vector(7 downto 0):="00000000";
	signal inExcCode:std_logic_vector(31 downto 0):=X"00000000";

	signal pc_o,pc4_o,mvaddr_o:std_logic_vector(31 downto 0);
	signal bj_o,delay_o:std_logic;

	signal last_pc:std_logic_vector(31 downto 0);
	signal db_step,db_cont,db_stop:std_logic;

	signal dbOccur_now:std_logic;
	signal dbOccur_last:std_logic;
begin

	process(clk,rst)
		variable pc,pc4,mvaddr:std_logic_vector(31 downto 0);
		variable bj,delay:std_logic;
	begin
	if (clk'event and clk='1') then
		if (rst='0') then
			db_step<='0';
			db_cont<='1';
			db_stop<='0';
			last_pc<=X"00000000";
			dbOccur_last<='0';
		else
			pc:=pc4Input-4;
			pc4:=pc4Input;
			mvaddr:=memVaddrInput;
			if(branchOrJumpInput="00") then
				bj:='0';
			else
				bj:='1';
			end if;
			delay:=excDelayInput;

			dbOccur_last<=dbOccur_now;

			if (dbStep='1') then
				db_step<='1';
			end if;
			if (dbCont='1') then
				db_cont<='1';
				db_step<='1';
			end if;
			if (dbStop='1') then
				db_stop<='1';
			end if;
			if (db_stop='1' and pc4Input/=X"00000000" and delay='0' and  pc4Input-4/=last_pc) then
				db_stop<='0';
				db_cont<='0';
				db_step<='0';
			end if;
			if (
				(
					('1'&pc=hard_break(0) and delay='0') or ('1'&pc4=hard_break(0) and bj='1') or
					('1'&pc=hard_break(1) and delay='0') or ('1'&pc4=hard_break(1) and bj='1') or
					('1'&pc=hard_break(2) and delay='0') or ('1'&pc4=hard_break(2) and bj='1') or
					('1'&pc=hard_break(3) and delay='0') or ('1'&pc4=hard_break(3) and bj='1') or
					(
						(memRead='1' or memWrite='1') and
						(
							(mvaddr=watch_point(0)(31 downto 0) and ("11"=(watch_point(0)(33 downto 32)or(memRead&memWrite)))) or
							(mvaddr=watch_point(1)(31 downto 0) and ("11"=(watch_point(1)(33 downto 32)or(memRead&memWrite)))) or
							(mvaddr=watch_point(2)(31 downto 0) and ("11"=(watch_point(2)(33 downto 32)or(memRead&memWrite)))) or
							(mvaddr=watch_point(3)(31 downto 0) and ("11"=(watch_point(3)(33 downto 32)or(memRead&memWrite)))) 
						)
					)or
					isBreakInput='1'
				) and
				pc4Input-4/=last_pc
			) then
				db_cont<='0';
			end if;
			if (pc4Input/=X"00000000" and delay='0' and pc4Input-4/=last_pc) then
				db_step<='0';
				last_pc<=pc4Input-4;
			end if;
		end if;
	end if;
	end process;

	-- just translation
	--badvaddrOutput<=vaddrInput;
	badvaddrOutput<=pc4Input-4 when exmemExcCodeInput/=zero else vaddrInput;	-- this signal is undefined in most cases.
	pc4Output<=pc4Input;
	excDelayOutput<=excDelayInput;
	excCode<=inExcCode;
	realInterupt<=causeInput(15 downto 8) and statusInput(15 downto 8);

	pc_o<=pc4Input-4;
	pc4_o<=pc4Input;
	mvaddr_o<=memVaddrInput;
	bj_o<='0' when branchOrJumpInput="00" else '1';
	delay_o<=excDelayInput;
	dbOccur_now<=
		'1' when 
			pc4Input/=X"00000000" and (
				(db_cont='0' and db_step='0') or
				(db_stop='1' and pc4Input/=X"00000000" and delay_o='0' and  pc4Input-4/=last_pc) or
				(	
					(
						('1'&pc_o=hard_break(0) and delay_o='0') or ('1'&pc4_o=hard_break(0) and bj_o='1') or
						('1'&pc_o=hard_break(1) and delay_o='0') or ('1'&pc4_o=hard_break(1) and bj_o='1') or
						('1'&pc_o=hard_break(2) and delay_o='0') or ('1'&pc4_o=hard_break(2) and bj_o='1') or
						('1'&pc_o=hard_break(3) and delay_o='0') or ('1'&pc4_o=hard_break(3) and bj_o='1') or
						(
							(memRead='1' or memWrite='1') and
							(
								(mvaddr_o=watch_point(0)(31 downto 0) and ("11"=(watch_point(0)(33 downto 32)or(memRead&memWrite)))) or
								(mvaddr_o=watch_point(1)(31 downto 0) and ("11"=(watch_point(1)(33 downto 32)or(memRead&memWrite)))) or
								(mvaddr_o=watch_point(2)(31 downto 0) and ("11"=(watch_point(2)(33 downto 32)or(memRead&memWrite)))) or
								(mvaddr_o=watch_point(3)(31 downto 0) and ("11"=(watch_point(3)(33 downto 32)or(memRead&memWrite)))) 
							)
						)or
						isBreakInput='1'
					)
					and pc4Input-4/=last_pc and db_cont='1'
				) or
				(pc4Input/=X"00000000" and delay_o='0' and pc4Input-4/=last_pc and db_step='1' and db_cont='0')
			) else 
		'0';
	dbOccur<=dbOccur_now;
	dbOccurS<='1' when dbOccur_last='1' and dbOccur_now='0' else '0';

	-- is to CP0 to determinate 
	inExcCode<=
		exmemExcCodeInput when exmemExcCodeInput/=zero else 
		mmuExcCodeInput when mmuExcCodeInput/=zero else
		-- if Interupt is not allow, this expression is wrong but lead to no erro in other modulars
		-- so we use it to save time and simplify expression
		zero(30 downto 0)&'1' when realInterupt/="00000000" else zero;

	excOccur<=
		'0' when dbOccur_now='1' else
		'1' when (intDisable='0' and statusInput(1)='0' and statusInput(0)='1' and realInterupt/="00000000") or
						mmuExcCodeInput/=zero or exmemExcCodeInput/=zero else '0';

	excReturn<='1' when exmemExcCodeInput(30)='1' else '0';			--ERET:30
	excTLB<='1' when (inExcCode(3) or inExcCode(2))='1' else '0';   	--TLBL:2 TLBS:3

	-- excNested<='1' when statusInput(1)='1' else '0';

	-- ver 6.1 --
	excNested <= '1' when statusInput(1)='1' and exmemExcCodeInput(30)/='1' else '0';

end Behavioral;

