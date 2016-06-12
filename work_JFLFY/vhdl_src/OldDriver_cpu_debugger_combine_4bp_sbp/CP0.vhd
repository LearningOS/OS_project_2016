----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:22:47 11/18/2015 
-- Design Name: 
-- Module Name:    CP0 - Behavioral 
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
use work.defines.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CP0 is
Port(
	-- 同步清零
	rst:in std_logic;
	-- 时钟
	clk:in std_logic;
	-- 中断pending
	-- interrupt:in std_logic_vector(7 downto 0);
	
	interrupt0:in std_logic; -- 0号中�	
	interrupt1:in std_logic; -- 1号中�	
	interrupt2:in std_logic; -- 2号中�	
	interrupt3:in std_logic; -- 3号中�	
	interrupt4:in std_logic; -- 4号中�	
	interrupt5:in std_logic; -- 5号中�	
	interrupt6:in std_logic; -- 6号中�	
	interrupt7:in std_logic; -- 7号中�	
	-- 需要读出的寄存器�	
	rdIndexInput:in std_logic_vector(4 downto 0);
	
	-- 用于mem级的回写

	memValueInput:in std_logic_vector(31 downto 0); -- 这部分可以用来作为badAddr

	memIndexInput:in std_logic_vector(4 downto 0);
	memCP0Write:in std_logic;
	
	-- 用于wb级的回写和时钟跳变回�
	wbValueInput:in std_logic_vector(31 downto 0);
	wbIndexInput:in std_logic_vector(4 downto 0);
	cp0Write:in std_logic;

	-- for exe write back
	exValueInput:in std_logic_vector(31 downto 0);
	excp0Write:in std_logic;

	-- 是否发生异常
	excOccur:in std_logic;

	-- 异常�	
	excCode:in std_logic_vector(31 downto 0);
	
	-- 是否处于延迟�	
	excDelayInput:in std_logic;
	excEPCInput:in std_logic_vector(31 downto 0);
	excBadVaddrInput:in std_logic_vector(31 downto 0);
	
	-- update in version 6
	excNested:in std_logic;

	-- TODO : deal the logic with excNested

	-- CP0的输�	
	timeIntr:out std_logic;
	rdValueOutput:out std_logic_vector(31 downto 0);
	ebaseOutput:out std_logic_vector(31 downto 0);
	epcOutput:out std_logic_vector(31 downto 0);
	causeOutput:out std_logic_vector(31 downto 0);
	statusOutput:out std_logic_vector(31 downto 0);

	dbIndex:in std_logic_vector(4 downto 0);
	dbOutput:out std_logic_vector(31 downto 0);

	entryHiOutput:out std_logic_vector(31 downto 0);
	entryLo0Output:out std_logic_vector(31 downto 0);
	entryLo1Output:out std_logic_vector(31 downto 0);
	pageMaskOutput:out std_logic_vector(31 downto 0);
	indexOutput:out std_logic_vector(31 downto 0);
	randomOutput:out std_logic_vector(31 downto 0)
	
);
end CP0;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- IMPORTENT : IP(4) is set '0' for test, not interrupt4


architecture Behavioral of CP0 is
	signal regs: regs32;
		-- ramdom : reg 1
		-- BadAddr : reg 8
		-- count : regs 9
		-- compare : regs 11
		-- status : regs 12
		-- Cause : regs 13
		-- EBase : regs 15
		-- IP in Cause(15:8)
		-- BD in Cause(31)
		-- Exception in Cause(6:2)
		-- EPC -- 14
		--------------
		-- index : 0
		-- entryHi : 10
		-- entryLo0 : 2
		-- entryLo1 : 3
		-- pageMask : 5
	constant zero:std_logic_vector(31 downto 0):=X"00000000";

	signal rdAns:std_logic_vector (31 downto 0);
	signal epc:std_logic_vector(31 downto 0);
	signal excCause:std_logic_vector(4 downto 0):="00000";
	signal IP:std_logic_vector(5 downto 0):="000000";
	signal exIndexInput:std_logic_vector(4 downto 0);
	signal wbCP0Write:std_logic;
begin

	-- 在这个地�需要考虑对不可写的寄存器的转�	-- 对于1� 9号寄存器, 不可转发
	-- 对于Cause(13�寄存� 部分不可转发
	-- 由于此处的输�	

	dbOutput<=regs(conv_integer(dbIndex));

	rdValueOutput<=
		memValueInput when (memIndexInput = rdIndexInput and memCP0Write = '1' and 
			rdIndexInput /= "00001" and rdIndexInput /= "01001" and rdIndexInput /= "01101") else
		-- cpu v6*****
		-- IP(1:0) is r/w able
		memValueInput(31 downto 16) & IP & memValueInput(9 downto 0)
			when (memIndexInput = rdIndexInput and memCP0Write = '1' and rdIndexInput = "01101") else
		wbValueInput when (wbIndexInput = rdIndexInput and cp0Write = '1' and 
			rdIndexInput /= "00001" and rdIndexInput /= "01001" and rdIndexInput /= "01101") else
		-- cpu v6*****
		wbValueInput(31 downto 16) & IP & wbValueInput(9 downto 0)
			when (wbIndexInput = rdIndexInput and CP0Write = '1' and rdIndexInput = "01101") else
		rdAns;

	-- 数据转发(只对wb级做转发)
	-- 对于以下的几个寄存器, 需要考虑在异常发生的时候的转发
	statusOutput <= wbValueInput when (wbIndexInput = "01100" and cp0Write = '1') else regs(12);
	-- cpu v6*****
	causeOutput <= 	wbValueInput(31 downto 16) & IP & wbValueInput(9 downto 0) 
						when (wbValueInput = "01101" and cp0Write = '1') else
					regs(13);


	-- 之所以不转发EPC, 是因为ERET的情况不需要转发EPC(因为ERET不是真正的异� 不应该写入EPC)
	-- 但真正异常的情况, 并不需要EPC, 而是需要ebase, 因此不对epc做转�
	epcOutput <= wbValueInput when (wbIndexInput = "01110" and cp0Write = '1') else regs(14);
	ebaseOutput <= wbValueInput when (wbValueInput = "01111" and cp0Write = '1') else regs(15);

	-- tlbw in ID falling edge hence transmission of EX
	-- all of the transmit input has a short delay, so we can tlbw at falling edge
	entryhiOutput<=		-- entryhi:10
		exValueInput when exIndexInput="01010" and exCP0Write='1' else 
		memValueInput when memIndexInput="01010" and memCP0Write='1' else
		wbValueInput when wbIndexInput="01010" and wbCP0Write='1' else regs(10);
	entrylo0Output<=	-- entrylo0:2
		exValueInput when exIndexInput="00010" and exCP0Write='1' else 
		memValueInput when memIndexInput="00010" and memCP0Write='1' else
		wbValueInput when wbIndexInput="00010" and wbCP0Write='1' else regs(2);
	entrylo1Output<=	-- entrylo1:3
		exValueInput when exIndexInput="00011" and exCP0Write='1' else 
		memValueInput when memIndexInput="00011" and memCP0Write='1' else
		wbValueInput when wbIndexInput="00011" and wbCP0Write='1' else regs(3);
	pagemaskOutput<=X"00000000"; -- no real operation in this version
	indexOutput<=		-- index:0
		exValueInput when exIndexInput="00000" and exCP0Write='1' else 
		memValueInput when memIndexInput="00000" and memCP0Write='1' else
		wbValueInput when wbIndexInput="00000" and wbCP0Write='1' else regs(0);
	randomOutput<=regs(1);	-- random:1, read only, need not transmit

-- inside signal --
	exIndexInput<=rdIndexInput;
	wbCP0Write<=cp0Write;
	-- IP<=interrupt7&interrupt6&interrupt5&interrupt4&interrupt3&interrupt2;

	-- ver 6.1
	-- temporarily: before joining up COM1_IRQ, set the IP(2) with '0'

	IP<=interrupt7&interrupt6&"0"&interrupt4&"00";
	--IP <= interrupt7&"00000";

	-- temporarily ends

	epc<=excEPCInput-4 when excDelayInput='0' else excEPCInput-8;
	rdAns<=regs(conv_integer('0'&rdIndexInput));	-- not full
	excCause<=
		"00000" when excCode(0)='1' else
		"00010" when excCode(2)='1' else
		"00011" when excCode(3)='1' else 
		"00100" when excCode(4)='1' else
		"00101" when excCode(5)='1' else
		"01000" when excCode(8)='1' else
		"01010" when excCode(10)='1' else
		"11111";

	process(clk) is
	begin
	if (clk'event and clk = '1') then
		case rst is 
		when '0' =>
			regs(0)<=zero;-- index
			regs(1)<=zero;-- ramdom
			regs(2)<=zero;-- entryLo0
			regs(3)<=zero;-- entryLo1
			regs(5)<=zero;-- pageMask
			regs(8)<=zero;-- BadAddr
			regs(9)<=zero;-- count
			regs(10)<=zero;-- entryHi
			regs(11)<=zero;-- compare :0 means no timeintr
			regs(12)<=X"00400010";-- status :BEV(22)=1, UM(4)=1
			regs(13)<=zero;-- cause
			regs(14)<=zero;-- EPC
			regs(15)<=X"80000000";-- EBase : the most significant bit ensure it is in the kseg0

			regs(4)<=zero;regs(6)<=zero;regs(7)<=zero;regs(16)<=zero;regs(17)<=zero;regs(18)<=zero;
			regs(19)<=zero;regs(20)<=zero;regs(21)<=zero;regs(22)<=zero;regs(23)<=zero;regs(24)<=zero;
			regs(25)<=zero;regs(26)<=zero;regs(27)<=zero;regs(28)<=zero;regs(29)<=zero;regs(30)<=zero;regs(31)<=zero;
			timeIntr <= '0';

		when others =>
			regs(1)(0)<=regs(1)(31);
			regs(1)(1)<=regs(1)(0);
			regs(1)(2)<=regs(1)(1) xor regs(1)(31);
			regs(1)(3)<=regs(1)(2);
			regs(1)(4)<=regs(1)(3) xor regs(1)(31);
			regs(1)(5)<=regs(1)(4);
			regs(1)(6)<=regs(1)(5) xor regs(1)(31);
			regs(1)(7)<=regs(1)(6);
			regs(1)(8)<=regs(1)(7);
			regs(1)(9)<=regs(1)(8) xor regs(1)(31);
			regs(1)(10)<=regs(1)(9);
			regs(1)(11)<=regs(1)(10);
			regs(1)(12)<=regs(1)(11) xor regs(1)(31);
			regs(1)(13)<=regs(1)(12);
			regs(1)(14)<=regs(1)(13);
			regs(1)(15)<=regs(1)(14);
			regs(1)(16)<=regs(1)(15) xor regs(1)(31);
			regs(1)(17)<=regs(1)(16);
			regs(1)(18)<=regs(1)(17) xor regs(1)(31);
			regs(1)(19)<=regs(1)(18);
			regs(1)(20)<=regs(1)(19) xor regs(1)(31);
			regs(1)(21)<=regs(1)(20);
			regs(1)(22)<=regs(1)(21) xor regs(1)(31);
			regs(1)(23)<=regs(1)(22);
			regs(1)(24)<=regs(1)(23);
			regs(1)(25)<=regs(1)(24);
			regs(1)(26)<=regs(1)(25);
			regs(1)(27)<=regs(1)(26) xor regs(1)(31);
			regs(1)(28)<=regs(1)(27) xor regs(1)(31);
			regs(1)(29)<=regs(1)(28) xor regs(1)(31);
			regs(1)(30)<=regs(1)(29);
			regs(1)(31)<=regs(1)(30) xor regs(1)(31);
			regs(9)<=regs(9)+1;-- count
			regs(13)(15 downto 10)<=IP;-- cause(IP)
			if (regs(9)=regs(11) and regs(11)/=zero)then
				timeIntr <= '1';
			end if;
			if (cp0Write = '1')then
				case wbIndexInput is
					when "00000" => regs(0) <= wbValueInput;
					-- random can't write
					when "00010" => regs(2) <= wbValueInput;
					when "00011" => regs(3) <= wbValueInput;
					when "00100" => regs(4) <= wbValueInput;
					when "00101" => regs(5) <= wbValueInput;
					when "00110" => regs(6) <= wbValueInput;
					when "00111" => regs(7) <= wbValueInput;
					when "01000" => regs(8) <= wbValueInput;
					-- count can't write
					when "01010" => regs(10) <= wbValueInput;
					-- register compare can be written
					when "01011" => 
						regs(11) <= wbValueInput;
						timeIntr <= '0';
					when "01100" => regs(12) <= wbValueInput;
					when "01111" => regs(15) <= wbValueInput;
					when "10000" => regs(16) <= wbValueInput;
					when "10001" => regs(17) <= wbValueInput;
					when "10010" => regs(18) <= wbValueInput;
					when "10011" => regs(19) <= wbValueInput;
					when "10100" => regs(20) <= wbValueInput;
					when "10101" => regs(21) <= wbValueInput;
					when "10110" => regs(22) <= wbValueInput;
					when "10111" => regs(23) <= wbValueInput;
					when "11000" => regs(24) <= wbValueInput;
					when "11001" => regs(25) <= wbValueInput;
					when "11010" => regs(26) <= wbValueInput;
					when "11011" => regs(27) <= wbValueInput;
					when "11100" => regs(28) <= wbValueInput;
					when "11101" => regs(29) <= wbValueInput;
					when "11110" => regs(30) <= wbValueInput;
					when "11111" => regs(31) <= wbValueInput;
					-- cpu v6*****
					-- IP(1:0) is r/w able
					when "01101" => 
						regs(13)(31 downto 16) <= wbValueInput(31 downto 16); 
						regs(13)(9 downto 0) <= wbValueInput(9 downto 0);
					when "01110" => regs(14) <= wbValueInput;
					when others => -- empty
				end case;
			end if;
			-- for logic order, this block must be behind the general CP0 write.
			-- The four special registers should be treated specially
			-- this change don't need transmit because of next period CPU is flushed
			-- the absence of transmission of EPC is due to other reasons
			if (excOccur='1') then
				if (excCode(30)='1') then-- ERET
					regs(12)(1)<='0';
				else
					-- here: memValueInput is the address for I/O of memory

					-- cpu v6*****
					-- handle_tlbmiss will use regs(8)
					if (excCode(2)='1' or excCode(3)='1' or excCode(4)='1' or excCode(5)='1')then
						regs(8)<=excBadVaddrInput;
					end if;
					-- cpu v6*****
					-- entryHi(VP2) needs change
					if (excCode(2)='1' or excCode(3)='1')then
						regs(10)(31 downto 13)<=memValueInput(31 downto 13);
					end if;
					regs(12)(1)<='1';
					regs(13)(31)<=excDelayInput;
					regs(13)(6 downto 2)<=excCause;
					-- cpu v6*****
					-- if state is in the exception, we must hold the epc, or lead to no addr to ereturn.
					if (excNested='0' and excCode(30)/='1') then
						regs(14)<=epc;
					end if;
				end if;
			end if;
		end case;
	end if;
	end process;
	
end Behavioral;

