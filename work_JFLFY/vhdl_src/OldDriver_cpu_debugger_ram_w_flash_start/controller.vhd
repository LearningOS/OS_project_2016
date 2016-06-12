----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:05:21 11/12/2015 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

-- 工作在ID�

entity controller is
Port(
	-- 输入的指令的字段
	-- 是否写CP0
	mc0:in std_logic;
	op:in std_logic_vector(5 downto 0);
	funct:in std_logic_vector(5 downto 0);
	-- 是否在延迟槽
	inDelaySlot:out std_logic;
	---- 软重�	
	--riskReset:in std_logic;
	-- 信号输出
	-- 哪种类型的跳�	--"00" 表示这不是一个跳转型指令
	--"01" 表示这是一�jump 信号
	--"10" 表示这是一�branch 信号
	--"11" 未定�	
	branchOrJump:out std_logic_vector(1 downto 0);
	-- 从寄存其中获得跳转地址,还是从立即数获得跳转地址 '1'表示reg
	jumpRegOrImm:out std_logic;
	-- 写回寄存器是�	
	writeBackReg:out std_logic_vector(1 downto 0);
	-- ALU的操作信�	--"0000" 表示 ALU 将进行左移运�	--"0001" 表示 ALU 将进行逻辑右移运算
	--"0010" 表示 ALU 将进行算术右移运�	--"0011" 表示 ALU 将进行减法运�	--"0100" 表示 ALU 将进行与运算
	--"0101" 表示 ALU 将进行或运算
	--"0110" 表示 ALU 将进行异或运�	--"0111" 表示 ALU 将进行或非运�	--"1000" 表示 ALU 将进行有符号小于运算
	--"1001" 表示 ALU 将进行无符号小于运算
	--"1010" 表示 ALU 将进�LUI 运算
	--"1011" 表示 ALU 将进行加法运�	
	aluOp:out std_logic_vector(3 downto 0);
	-- 对立即数进行何种类型的扩�'1' 表示符号扩展
	immExtend:out std_logic;
	-- 第二操作数选择: '1' 表示选择立即�	
	immOrRt:out std_logic;
	-- 移位时选择谁作为移位数 '1'表示移位立即�	
	slimmOrRs:out std_logic;
	---- ALU选择计算结果输出还是输出RPC? '1'选择RPC
	--rpcOrALU:out std_logic;
	-- HI, LO, RPC, ALUAns的选择
	-- 选择信号
	-- "00" 表示cp0
	-- "01" 表示hilo
	-- "10" 表示alu
	-- "11" 表示pc
	exSelect:out std_logic_vector(1 downto 0);
	---- HI,LO两个寄存器的读控�这个信号主要是给HI/LO模块输出做选择
	----"00" XXXXXXX
	----"01" 表示将选择 Lo 寄存器的�	----"10" 表示将选择 Hi 寄存器的�	----"11" 未定�	
	--hiloRead:out std_logic_vector(1 downto 0);
	hiloRead:out std_logic;
	-- 是否有读内存操作 '1'表示�	
	memRead:out std_logic;
	-- 是否有写内存操作 '1'表示�	
	memWrite:out std_logic;
	-- 针对load系列指令 对读出的半字/字节做何种扩�'1'表示符号扩展
	loadExMode:out std_logic;
	-- 针对load/store系列指令 声明读出的字节长�	-- 11 表示字节
	-- 10 表示半字
	-- 00 表示�	
	stldLen:out std_logic_vector(1 downto 0);
	-- 是否要写会寄存器 '1'表示要写�	
	regWrite:out std_logic;
	-- 是否写CP0
	cp0Write:out std_logic;
	-- HI, LO的读信号,'1'读HI,'0'读LO
	hiloWrite:out std_logic_vector(1 downto 0);
	-- 控制产生的异常码
	excCode:out std_logic_vector(31 downto 0);
	-- HI,LO两个寄存器的写控�	
	--"00" 表示不需要写 Hi/Lo 寄存�	
	--"01" 表示�aluInput 的值写�Lo 寄存�	
	--"10" 表示�aluInput 的值写�Hi 寄存�	
	--"11" 表示�hiInput �loInput 同时写入 Hi/Lo 寄存�
	-- new in version 6
	isTLBWI:out std_logic;
	isTLBWR:out std_logic;
	isSB:out std_logic
);
end controller;

architecture Behavioral of controller is
constant special: std_logic_vector(5 downto 0) := "000000";
constant cp0:std_logic_vector(5 downto 0) := "010000";
constant RI:std_logic_vector(31 downto 0) := "00000000000000000000010000000000";
constant zero:std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
constant SYSCALL : std_logic_vector (31 downto 0) := "00000000000000000000000100000000";
constant ERET : std_logic_vector (31 downto 0) := "01000000000000000000000000000000";
begin
	
	inDelaySlot <= '1' when ((op = special and funct = "001000")
							or (op = special and funct = "001001")
							or (op = "000010")
							or (op = "000011")) else
					'1' when ((op = "000100")
							or (op = "000111")
							or (op = "000110")
							or (op = "000101")
							or (op = "000001")) else
					'0';
	cp0Write <= mc0 when  op = cp0 else '0';
	branchOrJump <= "01" when ((op = special and funct = "001000")
								or (op = special and funct = "001001")
								or (op = "000010")
								or (op = "000011")) else
					"10" when ((op = "000100")
									or (op = "000111")
									or (op = "000110")
									or (op = "000101")
									or (op = "000001")) else
					"00";
	jumpRegOrImm <= '1' when ((op = special and funct = "001000")
					or (op = special and funct = "001001")) else
						'0';
	writeBackReg <= "01" when ((op = "001100")
							or (op = "001110")
							or (op = "001111")
							or (op = "001101")
							or (op = "001001")
							or (op = "001010")
							or (op = "001011")
							or (op = "100000")
							or (op = "100100")
							or (op = "100101")
							or (op = "100011")
							or (op = cp0 and mc0 = '0')) else
					"11" when (op = "000011") else		-- jalr is "rd"
					"10";
						
	aluOp <= 
		"1100" when ((op = cp0 and mc0 = '1')) else
		"0000" when ((op = special and funct = "000000") --左移
							or (op = special and funct = "000100")) else
		"0001" when ((op = special and funct = "000010") --逻辑右移
							or (op = special and funct = "000110")) else
		"0010" when ((op = special and funct = "000011") --算术右移
							or (op = special and funct = "000111")) else
		"0011" when ((op = special and funct = "100011")) else --减法
		"0100" when ((op = special and funct = "100100") -- 与运�								
		or (op = "001100")) else
		"0101" when ((op = special and funct = "100101") -- 或运�								
		or (op = "001101")) else
		"0110" when ((op = special and funct = "100110") -- 异或运算
						or (op = "001110")) else
		"0111" when ((op = special and funct = "100111")) else -- 或非运算
		"1000" when ((op = special and funct = "101010") -- 有符号比�								
		or (op = "001010")) else
		"1001" when ((op = special and funct = "101011") -- 无符号比�								
		or (op = "001011")) else
		"1010" when ((op = "001111")) else -- 读取立即�LUI)
		"1011";
	immExtend <= 
		'1' when ((op = "001001")
			or (op = "001010")
			or (op = "001011")
			or (op = "100000")
			or (op = "100100")
			or (op = "100101")
			or (op = "100011")
			or (op = "101000")
			or (op = "101011" or op = "101001")) else
		'0';
	immOrRt <=  
		'1' when ((op = "001100")
			or (op = "001110")
			or (op = "001111")
			or (op = "001101")
			or (op = "001001")
			or (op = "001010")
			or (op = "001011")
			or (op = "100000")
			or (op = "100100")
			or (op = "100101")
			or (op = "100011")
			or (op = "101000")
			or (op = "101011" or op = "101001")) else
		'0';
	slimmOrRs <= 
		'1' when ((op = special and funct = "000000")
			or (op = special and funct = "000010")
			or (op = special and funct = "000011")) else
		'0';
	exSelect <= "00" when ((op = cp0 and mc0 = '0')) else
				"01" when ((op = special and (funct = "010000" or funct = "010010"))) else
				"11" when ((op = special and funct = "001001")
						or (op = "000011")) else
				"10";
	hiloWrite <= 
		"11" when ((op = special and funct = "011000")) else
		"10" when ((op = special and funct = "010001")) else
		"01" when ((op = special and funct = "010011")) else
		"00";
	hiloRead <= '1' when ((op = special and funct = "010000")) else
				'0';
	memRead <= 
		'1' when ((op = "100000")
			or (op = "100100")
			or (op = "100101")
			or (op = "100011")) else
		'0';
	memWrite <= 
		'1' when ((op = "101000")
			or (op = "101011" or op = "101001")) else
		'0';
	loadExMode <= 
		'1' when ((op = "100000")) else
		'0';
	stldLen <= 
		"11" when ((op = "100000")
			or (op = "100100")
			or (op = "101000")) else
		"10" when ((op = "100101")) else
		"00";
	regWrite <= 
		'1' when ((op = special and funct = "100100")
			or (op = special and funct = "100101")
			or (op = special and funct = "100110")
			or (op = special and funct = "100111")
			or (op = "001100")
			or (op = "001110")
			or (op = "001111")
			or (op = "001101")
			or (op = special and funct = "000000")
			or (op = special and funct = "000010")
			or (op = special and funct = "000011")
			or (op = special and funct = "000100")
			or (op = special and funct = "000110")
			or (op = special and funct = "000111")
			or (op = special and funct = "010000")
			or (op = special and funct = "010010")
			or (op = special and funct = "100001")
			or (op = special and funct = "100011")
			or (op = special and funct = "101010")
			or (op = special and funct = "101011")
			or (op = "001001")
			or (op = "001010")
			or (op = "001011")
			or (op = special and funct = "001001")
			or (op = "000011")
			or (op = "100000")
			or (op = "100100")
			or (op = "100101")
			or (op = "100011")
			or (op = cp0 and mc0 = '0')) else
		'0';
	
	excCode <= 
		SYSCALL when ((op = special and funct = "001100")) else
		ERET	when ((op = cp0 and funct = "011000")) else
		zero when ((op = special and funct = "100100")
			or (op = special and funct = "100101")
			or (op = special and funct = "100110")
			or (op = special and funct = "100111")
			or (op = "001100")
			or (op = "001110")
			or (op = "001111")
			or (op = "001101")
			or (op = special and funct = "000000")
			or (op = special and funct = "000010")
			or (op = special and funct = "000011")
			or (op = special and funct = "000100")
			or (op = special and funct = "000110")
			or (op = special and funct = "000111")
			or (op = special and funct = "010000")
			or (op = special and funct = "010010")
			or (op = special and funct = "010001")
			or (op = special and funct = "010011")
			or (op = special and funct = "100001")
			or (op = special and funct = "100011")
			or (op = special and funct = "101010")
			or (op = special and funct = "101011")
			or (op = special and funct = "011000")
			or (op = "001001")
			or (op = "001010")
			or (op = "001011")
			or (op = special and funct = "001000")
			or (op = special and funct = "001001")
			or (op = "000010")
			or (op = "000011")
			or (op = "000100")
			or (op = "000111")
			or (op = "000110")
			or (op = "000101")
			or (op = "000001")
			or (op = "100000")
			or (op = "100100")
			or (op = "100101")
			or (op = "100011")
			or (op = "101000")
			or (op = "101011" or op = "101001")
			or (op = cp0)
			or (op = special and funct = "001100")
			or (op = "101111")
			or (op = cp0 and funct = "X00010")
			or (op = cp0 and funct = "X00110")) else
		RI;

	-- cpu v6*****
	isSB <='1' when (op="101000" or op="101001") else '0';	--sh
	isTLBWI<='1' when (op=cp0 and funct="000010") else '0';
	isTLBWR<='1' when (op=cp0 and funct="000110") else '0';

end Behavioral;

