--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:32:39 12/03/2015
-- Design Name:   
-- Module Name:   C:/CPU/MMU/testMMU.vhd
-- Project Name:  MMU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MMU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY com_plat IS
	PORT(
		rst : IN  std_logic;
		clk50 : IN  std_logic;
		clk11 : IN std_logic;
   		
   		TxD:out std_logic;
   		RxD:in std_logic;

   		U_TxD:out std_logic;
   		U_RxD:in std_logic;
			
		Debug : OUT std_logic_vector(15 downto 0)
		);
END com_plat;
 
ARCHITECTURE behavior OF com_plat IS 
	signal clk:std_logic;
	signal comclk:std_logic;
	signal count:std_logic_vector(1 downto 0);

	signal ob_is_read,ob_is_write,pc_is_read,pc_is_write:std_logic;
	signal ob_write_data,ob_read_data,pc_write_data,pc_read_data:std_logic_vector(7 downto 0);
	signal ob_state,pc_state:std_logic_vector(1 downto 0);

	signal st_pc,st_ob:std_logic_vector(1 downto 0);

	component com Port (		
		clk:in std_logic;comclk:in std_logic;rst:in std_logic;is_read:in std_logic;is_write:in std_logic;
		TxD_data:in std_logic_vector(7 downto 0);RxD_data:out std_logic_vector(7 downto 0);
		RxD:in std_logic; TxD:out std_logic;readable:out std_logic;writable:out std_logic);
	end component;

BEGIN
	process(clk50)
	begin
	if (clk50'event and clk50='1') then
		count<=count+1;
	end if;
	end process;
	clk<=count(0);
	comclk<=clk11;

	u0:com port map(
		clk=>clk,comclk=>comclk,rst=>rst,is_read=>ob_is_read,is_write=>ob_is_write,
		TxD_data=>ob_write_data,RxD_data=>ob_read_data,
		readable=>ob_state(1),writable=>ob_state(0),TxD=>TxD,RxD=>RxD);

	u1:com port map(
		clk=>clk,comclk=>comclk,rst=>rst,is_read=>pc_is_read,is_write=>pc_is_write,
		TxD_data=>pc_write_data,RxD_data=>pc_read_data,
		readable=>pc_state(1),writable=>pc_state(0),TxD=>U_TxD,RxD=>U_RxD);

	Debug<=X"0000";

	process(clk,rst)
	begin

	if(clk'event and clk='0') then
		ob_is_write<='0';
		ob_is_read<='0';
		pc_is_write<='0';
		pc_is_read<='0';
		case st_pc is
		when "00"=>
			if (pc_state(1)='1') then
				pc_is_read<='1';
				st_pc<="01";
			end if;
		when "01"=>
			if (ob_state(0)='1') then
				ob_write_data<=pc_read_data;
				ob_is_write<='1';
				st_pc<="00";
			end if;
		when others=>
		end case;

		case st_ob is
		when "00"=>
			if (ob_state(1)='1') then
				ob_is_read<='1';
				st_ob<="01";
			end if;
		when "01"=>
			if (pc_state(0)='1') then
				pc_write_data<=ob_read_data;
				pc_is_write<='1';
				st_ob<="00";
			end if;
		when others=>
		end case;
	end if;
	if(rst='0') then
		ob_is_write<='0';
		ob_is_read<='0';
		pc_is_write<='0';
		pc_is_read<='0';
		st_pc<="00";
		st_ob<="00";
	end if;
	end process;

END;
