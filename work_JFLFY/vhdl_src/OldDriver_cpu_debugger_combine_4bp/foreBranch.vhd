----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:49:16 11/03/2015 
-- Design Name: 
-- Module Name:    foreBranch - Behavioral 
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

-- 该模块工作在 ID 阶段
entity foreBranch is

Port(
	-- PC�后的�	
	pc4Input: in std_logic_vector(31 downto 0);
	-- 用于跳转的输�	
	rsValue: in std_logic_vector(31 downto 0); -- 第一个寄存器的�	
	rtValue: in std_logic_vector(31 downto 0); -- 第二个寄存器的�	
	immOffset: in std_logic_vector(15 downto 0); -- 16位的立即数�	
	immAddr: in std_logic_vector(9 downto 0); -- 用于Jump�6位的�0�	
	-- 控制B或J信号�时代表跳转模式为branch
	branchOrJump: in std_logic_vector(1 downto 0);
	-- 针对J跳转的信�约定�时跳转到寄存器指定的�	
	jumpRegOrImm: in std_logic;
	-- 用于检测branch的判断类�	
	----- 0011 表示BGEZ
	----- 0010 表示BLTZ
	----- 100* 表示BEQ
	----- 101* 表示BNE
	----- 1100 表示BLEZ
	----- 1110 表示BGTZ
	brcType:in std_logic_vector(3 downto 0);

	-- 异常处理支持:
	-- ebase输入
	ebaseInput:in std_logic_vector(31 downto 0);
	-- EPC的�	
	epcInput:in std_logic_vector(31 downto 0);
	-- 发生了除ERET之外的异�	
	excOccur:in std_logic;
	-- 发生了ERET异常(在这里将ERET看做异常)
	excReturn:in std_logic;

	-- version 6 update
	excTLB:in std_logic;
	excNested:in std_logic;
	-- update end

	-- TODO : add logic of excTLB and excNested. 
	
	-- output
	-- 控制是否跳转(这里指的是branch)的指�也就是说J指令此输出为'1'
	jmpFlag: out std_logic;
	-- 输出跳转到的地址
	jmpPCAddr: out std_logic_vector(31 downto 0)
	
);

end foreBranch;

architecture Behavioral of foreBranch is
	constant zero:std_logic_vector(31 downto 0):=X"00000000";
	signal offset:std_logic_vector(31 downto 0);
begin
	-- modify without check by lyx
	jmpFlag<=
		'1' when excOccur='1' else -- 出现异常需要跳�		
		'1' when branchOrJump="01" else --jump 无条件跳�		-- 以下均为branch条件跳转
		'1' when (brcType = "0011" and rsValue(31) = '0' and branchOrJump = "10") else -- 大于等于�		
		'1' when (brcType = "0010" and rsValue(31) = '1' and branchOrJump = "10") else -- 小于�		
		'1' when (brcType(3 downto 1) = "100" and rsValue = rtValue and branchOrJump = "10") else -- 二者相�		
		'1' when (brcType(3 downto 1) = "101" and rsValue /= rtValue and branchOrJump = "10") else -- 二者不�		
		'1' when (brcType = "1100" and (rsValue(31) = '1' or rsValue = zero) and branchOrJump = "10") else -- 小于等于
		'1' when (brcType = "1110" and (rsValue(31) = '0' and rsValue /= zero) and branchOrJump = "10") else -- 大于�
		-- branch条件检测不满足 �非跳转指�		
		'0';

	-- branch 立即数扩展至32�	
	offset<=
		immOffset(15)&immOffset(15)&immOffset(15)&immOffset(15)&
		immOffset(15)&immOffset(15)&immOffset(15)&immOffset(15)&
		immOffset(15)&immOffset(15)&immOffset(15)&immOffset(15)&
		immOffset(15)&immOffset(15)&immOffset(15 downto 0)&"00";

	jmpPCAddr<=
		ebaseInput(31 downto 12)&X"180" when excReturn='0' and excOccur='1' and excTLB='1' and excNested='0' else
		ebaseInput(31 downto 12)&X"180" when excReturn='0' and excOccur='1' else
		epcInput when excReturn='1' and excOccur='1' else
		rsValue when jumpRegOrImm='1' else -- JUMP/Branch 寄存�
		pc4Input(31 downto 28)&immAddr&immOffset&"00" when branchOrJump="01" and jumpRegOrImm='0' else -- JUMP 立即�		
		pc4Input+offset when branchOrJump="10" and jumpRegOrImm='0' else --Branch 立即�		
		zero;
				
end Behavioral; 

