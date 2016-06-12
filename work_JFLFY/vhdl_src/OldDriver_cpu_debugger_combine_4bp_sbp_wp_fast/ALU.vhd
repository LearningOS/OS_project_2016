library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
port(
	-- 第一个操作数
	rsInput:in std_logic_vector(31 downto 0);
	-- 第二个操作数
	rtInput:in std_logic_vector(31 downto 0);
	-- 立即数(其中包括了rd(15 downto 11),shamt(10 downto 6),funct(5 downto 0))
	immInput:in std_logic_vector(15 downto 0);
	---- PC加4输入
	--pcInput:in std_logic_vector(31 downto 0);
	
	-- 算术控制信号 ---- 解决进行何种运算
	--"0000" 表示 ALU 将进行左移运算
	--"0001" 表示 ALU 将进行逻辑右移运算
	--"0010" 表示 ALU 将进行算术右移运算
	--"0011" 表示 ALU 将进行减法运算
	--"0100" 表示 ALU 将进行与运算
	--"0101" 表示 ALU 将进行或运算
	--"0110" 表示 ALU 将进行异或运算
	--"0111" 表示 ALU 将进行或非运算
	--"1000" 表示 ALU 将进行有符号小于运算
	--"1001" 表示 ALU 将进行无符号小于运算
	--"1010" 表示 ALU 将进行 LUI 运算
	--"1011" 表示 ALU 将进行加法运算
	aluOP:in std_logic_vector(3 downto 0);
	-- 如何扩展立即数 置为'1'表示符号扩展
	immExtend:in std_logic;
	-- 第二个计算参数来自寄存器还是立即数? 置为'1'表示来自立即数
	immOrRt:in std_logic;
	-- 立即数还是寄存器移位 置为'1'则以5位立即数作为SL(移位数)
	slimmOrRs:in std_logic;
	
	-- 是否需要送出RPC(即PC+8)的值(用于JARA指令)? 置为'1'则送出RPC的值
	-- rpcOrALU:in std_logic;
	
	-- 最终输出
	aluOutput:out std_logic_vector(31 downto 0)
);
end ALU;

architecture Behavioral of ALU is
	-- 使用的立即数
	signal imm:std_logic_vector(31 downto 0);
	-- 移位数
	signal slNum:std_logic_vector(4 downto 0);
	-- rs - rt的结果(即指令SUBU的计算结果)
	signal subNum:std_logic_vector(32 downto 0);
	-- 第二个操作数用于加,和所有位运算
	signal secNum:std_logic_vector(31 downto 0);
	signal extbit:std_logic;
	signal aluCmpResult:std_logic_vector(31 downto 0);
	signal aluAriResult:std_logic_vector(31 downto 0);	--no use
begin
	with immExtend select
	extbit<=
		immInput(15) when '1',
		'0' when '0';
	imm<=extbit&extbit&extbit&extbit&extbit&extbit&extbit&extbit&
		extbit&extbit&extbit&extbit&extbit&extbit&extbit&extbit&immInput(15 downto 0);
	with immOrRt select
	secNum<=
		imm when '1',
		rtInput when '0';
	subNum<=('0'&rsInput)-('0'&secNum);
	with slimmOrRs select
	slNum<=
		immInput(10 downto 6) when '1',
		rsInput(4 downto 0) when '0';

	aluCmpResult<=
		X"00000001" when 
			(aluOp(0)='0' and ((subNum(31)='1' and rsInput(31)=secNum(31)) or (rsInput(31)='1' and secNum(31)='0'))) or 
			(aluOp(0)='1' and subNum(32)='1') else 
		X"00000000";

	with aluOp select
	aluOutput<=
		secNum when "1100",
		rsInput+secNum when "1011",
		subNum(31 downto 0) when "0011",
		to_stdlogicvector(to_bitvector(rtInput) sll to_integer(unsigned(slNum))) when "0000",
		to_stdlogicvector(to_bitvector(rtInput) sra to_integer(unsigned(slNum))) when "0010",
		to_stdlogicvector(to_bitvector(rtInput) srl to_integer(unsigned(slNum))) when "0001",
		rsInput and secNum when "0100",
		rsInput or secNum when "0101",
		rsInput xor secNum when "0110",
		rsInput nor secNum when "0111",
		immInput&X"0000" when "1010",
		aluCmpResult when "1000",
		aluCmpResult when "1001",
		(others=>'0') when others;

end Behavioral;