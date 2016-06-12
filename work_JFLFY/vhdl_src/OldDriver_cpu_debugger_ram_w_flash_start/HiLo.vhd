----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:40 11/04/2015 
-- Design Name: 
-- Module Name:    HiLo - Behavioral 
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

-- HI/LO寄存器 工作在EXE阶段 是一个时序逻辑电路
-- 在这部分中 同时并入了HI/LO/ALU选择器

entity HiLo is
Port(
	-- 是否清零
	rst:in std_logic;
	-- 时钟信号
	clk:in std_logic;
	-- 来自HI/LO两个寄存器的读入信号 用于选择(在EXE阶段读入)
	hiInput:in std_logic_vector(31 downto 0);
	loInput:in std_logic_vector(31 downto 0);
	-- HI/LO写入控制信号
	hiloWrite:in std_logic_vector(1 downto 0);
	-- 来自MEM阶段的转发
	hiMEMInput:in std_logic_vector(31 downto 0);
	loMEMInput:in std_logic_vector(31 downto 0);
	hiloMEMWrite:in std_logic_vector(1 downto 0);
	-- 输出选择信号
	hiloRead:in std_logic;
	-- 最终输出结果
	dbOutput:out std_logic_vector(63 downto 0);

	hiloValueOutput:out std_logic_vector(31 downto 0)
);
end HiLo;

architecture Behavioral of HiLo is
-- 隐藏在内部的HI/LO寄存器实体
signal HI:std_logic_vector(31 downto 0);
signal LO:std_logic_vector(31 downto 0);
constant zero:std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
begin
	dbOutput<=HI & LO;

	-- 数据转发部分
	hiloValueOutput <= 
					hiMEMInput when (hiloRead = '1' and hiloMEMWrite(1) = '1') else
					loMEMInput when (hiloRead = '0' and hiloMEMWrite(0) = '1') else
					hiInput when (hiloRead = '1' and hiloWrite(1) = '1') else
					loInput when (hiloRead = '0' and hiloWrite(0) = '1') else
					HI when (hiloRead = '1') else
					LO when (hiloRead = '0') else
					zero;
	process(clk)
	begin
		-- HI/LO写入:与MULT, MTHI, MTLO三条指令相关
		if (clk'event and clk = '1')then
			case rst is
				when '1' =>
				case hiloWrite is
					when "10" => HI <= hiInput;
					when "01" => LO <= loInput;
					when "11" => HI <= hiInput; LO <= loInput;
					when others => --empty
				end case;
				when others =>
					-- HI <= zero; LO <= zero;
					HI <= zero;
					LO <= zero;
			end case;
		end if;
	end process;
end Behavioral;

