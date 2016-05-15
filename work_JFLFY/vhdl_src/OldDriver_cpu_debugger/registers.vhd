----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:12 12/02/2015 
-- Design Name: 
-- Module Name:    registers - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.defines.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registers is
Port(
	-- 同步清零
	rst: in std_logic;
	-- 时钟信号
	clk: in std_logic;

	-- 来自于ins的寄存器�	
	rsIndex: in std_logic_vector(4 downto 0); 	-- 用于第一个输�
	rtIndex: in std_logic_vector(4 downto 0); 	-- 用于第二个输�	
	-- 来自于流水寄存器的目标寄存器�	
	rdIndex: in std_logic_vector(4 downto 0);
	
	-- "写回"信号, 来自于MEM/WB流水寄存�	
	regWrite: in std_logic;
	
	-- 要写回寄存器堆的�输入)
	
	rdInput: in std_logic_vector(31 downto 0);
	
	-- 以下(输出信号之前)用于做寄存器的数据转�	---- ex阶段写回寄存器号
	
	
	exRdWBIndex:in std_logic_vector(4 downto 0);
	---- mem阶段写回寄存器号
	
	memRdWBIndex:in std_logic_vector(4 downto 0);
	---- ex阶段返回结果
	
	exRdWBValue:in std_logic_vector(31 downto 0);
	---- mem阶段返回结果
	
	memRdWBValue:in std_logic_vector(31 downto 0);
	---- ex阶段是否写回
	
	exRegWrite:in std_logic;
	---- mem阶段是否写回
	
	memRegWrite:in std_logic;
	
	-- 输出 分别对应第一个操作数和第二个操作�	

	dbIndex: in std_logic_vector(4 downto 0);
	dbOutput: out std_logic_vector(31 downto 0);

	rsOutput: out std_logic_vector(31 downto 0);
	rtOutput: out std_logic_vector(31 downto 0)
);
end registers;

architecture Behavioral of registers is
signal regs: regs32;
constant zero : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal rsAns:std_logic_vector(31 downto 0);-- 做数据转发之�做选择之前rs和rt的�
signal rtAns:std_logic_vector(31 downto 0);
begin
		rsOutput <= zero when (rsIndex = "00000") else
					exRdWBValue when (rsIndex = exRdWBIndex and exRegWrite = '1') else
					memRdWBValue when (rsIndex = memRdWBIndex and memRegWrite = '1') else
					rdInput when (rsIndex = rdIndex and regWrite = '1') else
					rsAns;
					
		rtOutput <= zero when (rtIndex = "00000") else
					exRdWBValue when (rtIndex = exRdWBIndex and exRegWrite = '1') else
					memRdWBValue when (rtIndex = memRdWBIndex and memRegWrite = '1') else
					rdInput when (rtIndex = rdIndex and regWrite = '1') else
					rtAns;

		dbOutput<=regs(conv_integer(dbIndex));

		with rsIndex select
		rsAns <= zero when "00000", 
					regs(1) when "00001",
					regs(2) when "00010",
					regs(3) when "00011",
					regs(4) when "00100",
					regs(5) when "00101",
					regs(6) when "00110",
					regs(7) when "00111",
					regs(8) when "01000",
					regs(9) when "01001",
					regs(10) when "01010",
					regs(11) when "01011",
					regs(12) when "01100",
					regs(13) when "01101",
					regs(14) when "01110",
					regs(15) when "01111",
					regs(16) when "10000",
					regs(17) when "10001",
					regs(18) when "10010",
					regs(19) when "10011",
					regs(20) when "10100",
					regs(21) when "10101",
					regs(22) when "10110",
					regs(23) when "10111",
					regs(24) when "11000",
					regs(25) when "11001",
					regs(26) when "11010",
					regs(27) when "11011",
					regs(28) when "11100",
					regs(29) when "11101",
					regs(30) when "11110",
					regs(31) when "11111";
	
	with rtIndex select
		rtAns <= zero when "00000", 
					regs(1) when "00001",
					regs(2) when "00010",
					regs(3) when "00011",
					regs(4) when "00100",
					regs(5) when "00101",
					regs(6) when "00110",
					regs(7) when "00111",
					regs(8) when "01000",
					regs(9) when "01001",
					regs(10) when "01010",
					regs(11) when "01011",
					regs(12) when "01100",
					regs(13) when "01101",
					regs(14) when "01110",
					regs(15) when "01111",
					regs(16) when "10000",
					regs(17) when "10001",
					regs(18) when "10010",
					regs(19) when "10011",
					regs(20) when "10100",
					regs(21) when "10101",
					regs(22) when "10110",
					regs(23) when "10111",
					regs(24) when "11000",
					regs(25) when "11001",
					regs(26) when "11010",
					regs(27) when "11011",
					regs(28) when "11100",
					regs(29) when "11101",
					regs(30) when "11110",
					regs(31) when "11111";
	
	-- 在上升沿写入
	process(clk) is
	begin
		case rst is 
			when '1' =>
				if (clk'event and clk = '1' and regWrite = '1') then
					case rdIndex is
						when "00000" => regs(0) <= zero;
						when "00001" => regs(1) <= rdInput;
						when "00010" => regs(2) <= rdInput;
						when "00011" => regs(3) <= rdInput;
						when "00100" => regs(4) <= rdInput;
						when "00101" => regs(5) <= rdInput;
						when "00110" => regs(6) <= rdInput;
						when "00111" => regs(7) <= rdInput;
						when "01000" => regs(8) <= rdInput;
						when "01001" => regs(9) <= rdInput;
						when "01010" => regs(10) <= rdInput;
						when "01011" => regs(11) <= rdInput;
						when "01100" => regs(12) <= rdInput;
						when "01101" => regs(13) <= rdInput;
						when "01110" => regs(14) <= rdInput;
						when "01111" => regs(15) <= rdInput;
						when "10000" => regs(16) <= rdInput;
						when "10001" => regs(17) <= rdInput;
						when "10010" => regs(18) <= rdInput;
						when "10011" => regs(19) <= rdInput;
						when "10100" => regs(20) <= rdInput;
						when "10101" => regs(21) <= rdInput;
						when "10110" => regs(22) <= rdInput;
						when "10111" => regs(23) <= rdInput;
						when "11000" => regs(24) <= rdInput;
						when "11001" => regs(25) <= rdInput;
						when "11010" => regs(26) <= rdInput;
						when "11011" => regs(27) <= rdInput;
						when "11100" => regs(28) <= rdInput;
						when "11101" => regs(29) <= rdInput;
						when "11110" => regs(30) <= rdInput;
						when "11111" => regs(31) <= rdInput;
						when others => --empty
					end case;
				end if;
			when others =>
				regs(0)  <= zero;
				regs(1)  <= zero;
				regs(2)  <= zero;
				regs(3)  <= zero;
				regs(4)  <= zero;
				regs(5)  <= zero;
				regs(6)  <= zero;
				regs(7)  <= zero;
				regs(8)  <= zero;
				regs(9)  <= zero;
				regs(10) <= zero;
				regs(11) <= zero;
				regs(12) <= zero;
				regs(13) <= zero;
				regs(14) <= zero;
				regs(15) <= zero;
				regs(16) <= zero;
				regs(17) <= zero;
				regs(18) <= zero;
				regs(19) <= zero;
				regs(20) <= zero;
				regs(21) <= zero;
				regs(22) <= zero;
				regs(23) <= zero;
				regs(24) <= zero;
				regs(25) <= zero;
				regs(26) <= zero;
				regs(27) <= zero;
				regs(28) <= zero;
				regs(29) <= zero;
				regs(30) <= zero;
				regs(31) <= zero;
		end case;
	end process;

end Behavioral;

