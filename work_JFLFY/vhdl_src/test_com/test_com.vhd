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
 
ENTITY test_com IS

	PORT(
		rst : IN  std_logic;
		clk50 : IN  std_logic;
		clk11 : IN std_logic;
   		
   		TxD:out std_logic;
   		RxD:in std_logic;
			
		Debug : OUT std_logic_vector(15 downto 0)
		);
		  
END test_com;
 
ARCHITECTURE behavior OF test_com IS 
	signal clk:std_logic;
	signal comclk:std_logic;
	signal count:std_logic_vector(1 downto 0);

	signal Debug_buf:std_logic_vector(15 downto 0);
	signal state:std_logic_vector(2 downto 0);
	signal state_pause:std_logic_vector(2 downto 0);

	signal check:std_logic_vector(2 downto 0);

	signal com_is_read:std_logic;
	signal com_is_write:std_logic;
	signal com_state:std_logic_vector(1 downto 0);
	signal com_read_data:std_logic_vector(7 downto 0);
	signal com_write_data:std_logic_vector(7 downto 0);

	component com Port (		
		clk:in std_logic;comclk:in std_logic;rst:in std_logic;is_read:in std_logic;is_write:in std_logic;
		TxD_data:in std_logic_vector(7 downto 0);RxD_data:out std_logic_vector(7 downto 0);
		RxD:in std_logic; TxD:out std_logic;readable:out std_logic;writable:out std_logic);
	end component;

BEGIN
	--TxD<=RxD;
	--Debug<=(others=>'1');

	process(clk50)
	begin
	if (clk50'event and clk50='1') then
		count<=count+1;
	end if;
	end process;
	clk<=count(0);
	--clk<=clk11;
	comclk<=clk11;

	u2:com port map(
		clk=>clk,comclk=>comclk,rst=>rst,is_read=>com_is_read,is_write=>com_is_write,
		TxD_data=>com_write_data,RxD_data=>com_read_data,
		readable=>com_state(1),writable=>com_state(0),TxD=>TxD,RxD=>RxD);

	Debug<="11"&state&check&Debug_buf(7 downto 0);

	process(clk)
	begin
	if (clk'event and clk='0') then
		if (rst='0') then
			com_is_read<='0';
			com_is_write<='0';
			com_write_data<="00000000";
			Debug_buf<=X"FF00";
			check<="000";
			state<="100";
		else
			com_is_read<='0';
			com_is_write<='0';
			case state is
			when "100"=>
				if (com_state(1)='1') then
					com_is_read<='1';
					state<="000";
				end if;
			when "000"=>
				state<="001";
			when "001"=>
				Debug_buf<=X"FF"&com_read_data;
				com_write_data<=com_read_data;
				state<="010";

				--if (check/=com_read_data(2 downto 0)) then
				--	if(check+1=com_read_data(2 downto 0))then
				--		check<=check+2;
				--	else
				--		state<="110";
				--	end if;
				--else 
				--	check<=check+1;
				--end if;
			when "010"=>
				if (com_state(0)='1') then
					com_is_write<='1';
					state<="011";
				end if;
			when "011"=>
				state<="100";
			when "110"=>
				--if (com_read_data/=check-1) then
				--	Debug_buf<=X"FFFF";
				--end if;
				--if (state_pause/="111") then
				--	state_pause<=state_pause+1;
				--else 
				--	if (com_state(0)='1') then
				--		com_is_write<='1';
				--		state<="011";
				--	end if;
				--end if;
			--when "011"=>
				--com_write_data<="00100100";
				--state_pause<="000";
				--state<="111";
			when "111"=>
			--	if (state_pause/="111") then
			--		state_pause<=state_pause+1;
			--	else 
			--		if (com_state(0)='1') then
			--			com_is_write<='1';
			--			state<="100";
			--		end if;
			--	end if;
			when others=>
				--empty;
			end case;
		end if;
	end if;
	end process;

END;
