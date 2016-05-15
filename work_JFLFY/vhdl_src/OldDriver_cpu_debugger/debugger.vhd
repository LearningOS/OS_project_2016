----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:22 12/01/2015 
-- Design Name: 
-- Module Name:    TLB - Behavioral 
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

entity debugger is
port(
	clk,comclk,rst:in std_logic;

	mem_input:in std_logic_vector(31 downto 0);
	reg_input:in std_logic_vector(31 downto 0);
	cp0_input:in std_logic_vector(31 downto 0);
	hilo_input:in std_logic_vector(63 downto 0);
	pc4_input:in std_logic_vector(31 downto 0);

	reg_idx:out std_logic_vector(4 downto 0);
	mem_addr:out std_logic_vector(31 downto 0);
	hard_break:out brk_arr;
	dbStep,dbCont:out std_logic;

	Debug:out std_logic_vector(15 downto 0);

	U_TxD:out std_logic;
	U_RxD:in std_logic
);
end debugger;

architecture behavioral of debugger is
	signal hard_break_reg:brk_arr;
	signal result:std_logic_vector(31 downto 0);

	signal rev_state,send_state:std_logic_vector(2 downto 0);


	signal com_is_read,com_is_write:std_logic;
	signal com_read_data,com_write_data:std_logic_vector(7 downto 0);
	signal com_readable,com_writable:std_logic;

	signal cmd:std_logic_vector(7 downto 0);
	signal param:std_logic_vector(31 downto 0);
	signal cmd_done,cpu_done,cpu_doing:std_logic;

	signal dbCont_reg,dbStep_reg:std_logic;

	component com Port (		
		clk:in std_logic;comclk:in std_logic;rst:in std_logic;is_read:in std_logic;is_write:in std_logic;
		TxD_data:in std_logic_vector(7 downto 0);RxD_data:out std_logic_vector(7 downto 0);
		RxD:in std_logic; TxD:out std_logic;readable:out std_logic;writable:out std_logic);
	end component;

begin
	Debug<=param(7 downto 0) & hard_break_reg(0)(7 downto 0);

	hard_break<=hard_break_reg;
	reg_idx<=param(4 downto 0);
	mem_addr<=param;
	dbCont<=dbCont_reg;
	dbStep<=dbStep_reg;
	
	u2:com port map(
		clk=>clk,comclk=>comclk,rst=>rst,is_read=>com_is_read,is_write=>com_is_write,
		TxD_data=>com_write_data,RxD_data=>com_read_data,
		readable=>com_readable,writable=>com_writable,TxD=>U_TxD,RxD=>U_RxD);

	process(clk,rst)
	begin
		if (clk'event and clk='1') then
			com_is_read<='0';
			cmd_done<='0';
			if (rev_state="101") then
				cmd_done<='1';
				rev_state<="000";
			end if;
			if (com_readable='1') then
				com_is_read<='1';
			end if;
			if (com_is_read='1') then
				case rev_state is
					when "000"=> cmd<=com_read_data;
					when "001"=> param(7 downto 0)<=com_read_data;
					when "010"=> param(15 downto 8)<=com_read_data;
					when "011"=> param(23 downto 16)<=com_read_data;
					when "100"=> param(31 downto 24)<=com_read_data;
					when others=>
				end case;
				case rev_state is
					when "000"=> 
						if (com_read_data(7)='0') then
							rev_state<="101";
						else
							rev_state<=rev_state+1;
						end if;
					when "101"=>
					when others=> 
						rev_state<=rev_state+1;
				end case;
			end if;
		end if;
		if (rst='0') then
			rev_state<="000";
			cmd<=X"00";
			param<=X"00000000";
			cmd_done<='0';
			com_is_read<='0';
		end if;
	end process;

	process(clk,rst)
	begin
		if (clk'event and clk='1') then
			com_is_write<='0';
			if (com_writable='1') then
				case send_state is
					when "001"=> com_write_data<=result(7 downto 0);
					when "010"=> com_write_data<=result(15 downto 8);
					when "011"=> com_write_data<=result(23 downto 16);
					when "100"=> com_write_data<=result(31 downto 24);
					when others=>
				end case;
				if (send_state/=0 and send_state<=4) then
					com_is_write<='1';
				end if;
				if (send_state/=0 and send_state<4) then
					send_state<=send_state+1;
				else
					send_state<="000";
				end if;
			end if;
			if (cpu_done='1') then
				send_state<="001";
			end if;
		end if;
		if (rst='0') then
			send_state<="000";
			com_write_data<=X"00";
			com_is_write<='0';
		end if;
	end process;

	process(clk,rst)
	begin
		if (clk'event and clk='1') then
			cpu_done<='0';
			dbCont_reg<='0';
			dbStep_reg<='0';

			if (cmd_done='1') then
				result<=X"00000000";
				case cmd is
					when X"8c"=> cpu_doing<='1';
					when others=> cpu_done<='1';
				end case;
				case cmd is
					when X"01"=>	-- stop
					when X"02"=>	-- continue
						dbCont_reg<='1';
					when X"03"=>	-- en_bp
					when X"04"=>	-- dis_bp
					when X"85"=>	-- set_bp
						hard_break_reg(0)<=param;
					when X"86"=>	-- read_reg
						result<=reg_input;
					when X"87"=>	-- read_cp0
						result<=cp0_input;
					when X"08"=>	-- read_hi
						result<=hilo_input(63 downto 32);
					when X"09"=>	-- read_lo
						result<=hilo_input(31 downto 0);
					when X"0a"=>	-- read_pc
						result<=pc4_input-4;
					when X"0b"=>	-- reset
					when X"8c"=>	-- read_mem

					when X"0d"=>	-- step
						dbStep_reg<='1';
					when X"0e"=>	-- query
					when others=>
				end case;
			end if;
			if (cmd=X"8c" and cpu_doing='1') then	-- without memFinish
				cpu_done<='1';
				cpu_doing<='0';
				result<=mem_input;
			end if;
		end if;
		if (rst='0') then
			hard_break_reg(0)<=X"B0000000";
			cpu_done<='0';
			cpu_doing<='0';

			dbCont_reg<='0';
			dbStep_reg<='0';
		end if;
	end process;

end behavioral;