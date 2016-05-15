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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exceptionMod is
Port(

	exmemExcCodeInput:in std_logic_vector(31 downto 0);
	mmuExcCodeInput:in std_logic_vector(31 downto 0);
	statusInput:in std_logic_vector(31 downto 0);
	causeInput:in std_logic_vector(31 downto 0);
	
	-- 延迟槽传�	
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

	-- 中断禁止
	intDisable:in std_logic;
	-- PC + 4 传�	
	pc4Input:in std_logic_vector(31 downto 0);
	pc4Output:out std_logic_vector(31 downto 0);
	
	vaddrInput:in std_logic_vector(31 downto 0);	-- for BadVaddr
	badvaddrOutput:out std_logic_vector(31 downto 0)

);
end exceptionMod;

architecture Behavioral of exceptionMod is
	constant zero:std_logic_vector(31 downto 0):=X"00000000";
	signal realInterupt:std_logic_vector(7 downto 0):="00000000";
	signal inExcCode:std_logic_vector(31 downto 0):=X"00000000";
begin

	-- just translation
	--badvaddrOutput<=vaddrInput;
	badvaddrOutput<=pc4Input-4 when exmemExcCodeInput/=zero else vaddrInput;	-- this signal is undefined in most cases.
	pc4Output<=pc4Input;
	excDelayOutput<=excDelayInput;
	excCode<=inExcCode;
	realInterupt<=causeInput(15 downto 8) and statusInput(15 downto 8);

	-- is to CP0 to determinate 
	inExcCode<=
		exmemExcCodeInput when exmemExcCodeInput/=zero else 
		mmuExcCodeInput when mmuExcCodeInput/=zero else
		-- if Interupt is not allow, this expression is wrong but lead to no erro in other modulars
		-- so we use it to save time and simplify expression
		zero(30 downto 0)&'1' when realInterupt/="00000000" else zero;

	excOccur<=
		'1' when (intDisable='0' and statusInput(1)='0' and statusInput(0)='1' and realInterupt/="00000000") or
						mmuExcCodeInput/=zero or exmemExcCodeInput/=zero else '0';

	excReturn<='1' when exmemExcCodeInput(30)='1' else '0';			--ERET:30
	excTLB<='1' when (inExcCode(3) or inExcCode(2))='1' else '0';   	--TLBL:2 TLBS:3

	-- excNested<='1' when statusInput(1)='1' else '0';

	-- ver 6.1 --
	excNested <= '1' when statusInput(1)='1' and exmemExcCodeInput(30)/='1' else '0';

end Behavioral;

