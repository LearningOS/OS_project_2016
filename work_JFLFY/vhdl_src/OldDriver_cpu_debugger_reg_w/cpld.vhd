----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:05:44 12/20/2015 
-- Design Name: 
-- Module Name:    cpld - Behavioral 
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

entity cpld is
Port(
	clk:in std_logic;

	pass_TxD:in std_logic;
	pass_RxD:out std_logic;
	RxD:in std_logic;
	TxD:out std_logic;

	ps2_clk:in std_logic;
	ps2_data:in std_logic;

	enHi:out std_logic;
	enLo:out std_logic;

	kbd_data:out std_logic_vector(3 downto 0)
);
end cpld;

architecture Behavioral of cpld is

	component ps2_controller
	port(
		clk:in std_logic;
		rst:in std_logic;

		intAck: in std_logic;
		intReq: out std_logic;

		enHi:in std_logic;
		enLo:in std_logic;

		lightHi:out std_logic_vector(0 to 6);
		lightLo:out std_logic_vector(0 to 6);

		kdb_data:in std_logic_vector(3 downto 0)
	);
	end component;

begin
	TxD <= pass_TxD;
	pass_RxD <= RxD;

	ps2: ps2_controller
	port map(
		clk => ps2_clk,
		kbd_data => kbd_data,
	);

end Behavioral;

--module cpld(


--	ps2 usp2(.clk(clk50M),
--		.ps2_clk(ps2_clk), .ps2_data(ps2_data),
--		.kbd_enb_hi(kbd_enb_hi), .kbd_enb_lo(kbd_enb_lo),
--		.kbd_data(kbd_data));

--endmodule
