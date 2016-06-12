----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:31:08 12/20/2015 
-- Design Name: 
-- Module Name:    ps2_module - Behavioral 
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

entity ps2_module is
Port(
	sysclk:in std_logic;
	clk:in std_logic;
	rst:in std_logic;

	intAck:in std_logic;
	intReqOutput:out std_logic;
	asciiOutput:out std_logic_vector(7 downto 0);

	enHi:in std_logic;
	enLo:in std_logic;

	kbdDataInput:in std_logic_vector(3 downto 0)
);
end ps2_module;

architecture Behavioral of ps2_module is

signal intReq: std_logic := '0';
signal recvDataLo: std_logic_vector(3 downto 0) := (others => '0');
signal recvData: std_logic_vector(7 downto 0) := (others => '0');
signal recvDataLast : std_logic_vector(7 downto 0) := (others => '0');
signal nowPressed: std_logic_vector(7 downto 0) := (others => '0');
signal shiftPressed:std_logic;
signal isBreak :std_logic;
signal ascii:std_logic_vector(7 downto 0);

begin
	intReqOutput <= intReq;
	isBreak <= '1' when recvDataLast = X"F0" else '0';
	recvData <= kbdDataInput & recvDataLo;
	asciiOutput <= ascii;

	process(sysclk)
	begin
		if sysclk'event and sysclk='1' then
			if intReq = '1' and intAck = '1' then
				intReq <= '0';
			end if;
			if rst = '0' then
				ascii <= (others => '0');
				intReq <= '0';
			elsif intReq = '0' and nowPressed /= X"00" and nowPressed(7) = '0' then
				intReq <= '1';
				ascii <= shiftPressed & nowPressed(6 downto 0);
			end if;
		end if;
	end process;


	process(clk)
	begin
		if clk'event and clk = '1' then
			nowPressed <= (others => '0');
			if rst = '0' then
				shiftPressed <= '0';
				recvDataLo <= (others => '0');
				recvDataLast <= (others => '0');
			else
				if enLo = '1' then
					recvDataLo <= kbdDataInput;
				elsif enHi = '1' then
					recvDataLast <= recvData;
					if recvData = X"12" or recvData = X"59" then
						shiftPressed <= not isBreak;
					elsif isBreak = '0' then
						nowPressed <= recvData;
					end if;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

