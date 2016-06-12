----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:31 11/04/2015 
-- Design Name: 
-- Module Name:    riskJudge - Behavioral 
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

-- 本模块工作在ID阶段
entity riskJudge is
Port(
	-- rs寄存器号
	rsIndex:in std_logic_vector(4 downto 0);
	-- rt寄存器号
	rtIndex:in std_logic_vector(4 downto 0);
	-- ID_EX阶段指令是否需要使用MMU('1'表示使用),在这里表示是否有load
	-- 换句话说,即上一条指令是否是load
	memRead:in std_logic;
	-- ID_EX指令需要写回的寄存器号
	exRdIndex:in std_logic_vector(4 downto 0);
	
	-- 输出部分 事实上二者是同时变化的
	-- reset Controller '0' 表示将之后阶段置为气泡
	ctrlReset:out std_logic;
	-- 是否锁住IF_ID,和PC '0'表示需要锁住
	riskPreserve:out std_logic
);
end riskJudge;

architecture Behavioral of riskJudge is
begin
	-- 清零时默认不锁住
	ctrlReset <='1' when memRead = '1' and (exRdIndex = rsIndex or exRdIndex = rtIndex) and exRdIndex /= "00000" else
				'0';
	riskPreserve <=	'1' when memRead = '1' and (exRdIndex = rsIndex or exRdIndex = rtIndex) and exRdIndex /= "00000" else
					'0';
					
end Behavioral;

