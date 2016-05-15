----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:20:55 11/04/2015 
-- Design Name: 
-- Module Name:    com - Behavioral 
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

entity com is 
Port (		
	clk:in std_logic;
	comclk:in std_logic;
	rst:in std_logic;

	is_read:in std_logic;
	is_write:in std_logic;
	TxD_data:in std_logic_vector(7 downto 0);
	RxD_data:out std_logic_vector(7 downto 0);

	readable:out std_logic;
	writable:out std_logic;

	-- ==========for TOP==========
	RxD:in std_logic; 
	TxD:out std_logic
);
end com;

architecture behavioral of com is

component async_transmitter
    port(clk:in std_logic;TxD_start:in std_logic;TxD_data:in std_logic_vector(7 downto 0);TxD:out std_logic;TxD_busy: out std_logic);
end component;
component async_receiver
    port(clk:in std_logic;RxD:in std_logic;RxD_data_ready:out std_logic;RxD_data:out std_logic_vector(7 downto 0);
    	RxD_endofpacket:out std_logic;RxD_idle:out std_logic);
end component;

signal RxD_data_ready:std_logic;
signal RxD_data_reg:std_logic_vector(7 downto 0);
signal TxD_start,Txd_busy:std_logic;
signal TxD_data_reg:std_logic_vector(7 downto 0);
signal RxD_data_out:std_logic_vector(7 downto 0);

signal readable_reg,writable_reg:std_logic;

signal TxD_start_psyn_s,TxD_start_psyn_t0,TxD_start_psyn_t1,TxD_start_psyn_t2:std_logic;
signal TxD_start_wait:std_logic;
signal TxD_data_prepare:std_logic;
signal TxD_data_s,TxD_data_reg0,TxD_data_reg1:std_logic_vector(7 downto 0);
signal TxD_busy_dsyn_t0,TxD_busy_dsyn_t1,TxD_busy_dsyn_t2:std_logic;

signal RxD_data_reg0,RxD_data_reg1:std_logic_vector(7 downto 0);
signal RxD_data_ready_dsyn_t0,RxD_data_ready_dsyn_t1,RxD_data_ready_dsyn_t2:std_logic;

begin
	u3:async_receiver port map(clk=>comclk,RxD=>RxD,RxD_data_ready=>RxD_data_ready,RxD_data=>RxD_data_reg);  
	u4:async_transmitter port map(clk=>comclk,Txd=>TxD,TxD_start=>TxD_start,TxD_data=>TxD_data_reg,TxD_busy=>TxD_busy);

	readable<=readable_reg;
	writable<=writable_reg;
	RxD_data<=RxD_data_out;

	process(comclk,rst)
	begin
		if(comclk'event and comclk='0') then
			TxD_start_psyn_t0<=TxD_start_psyn_s;
			TxD_start_psyn_t1<=TxD_start_psyn_t0;
			TxD_start_psyn_t2<=TxD_start_psyn_t1;
			TxD_data_reg0<=TxD_data_s;
			TxD_data_reg1<=TxD_data_reg0;

			if(TxD_start_psyn_t2/=TxD_start_psyn_t1) then
				TxD_start_wait<='1';
				TxD_data_reg<=TxD_data_reg1;
			end if;
			if(TxD_start_wait='1') then
				TxD_start<='1';
				TxD_start_wait<='0';
			end if;
			if(TxD_start='1') then
				TxD_start<='0';
			end if;
		end if;
		if(rst='0') then
			TxD_start<='0';
			TxD_start_wait<='0';
			TxD_start_psyn_t0<='0';
			TxD_start_psyn_t1<='0';
			TxD_start_psyn_t2<='0';
			TxD_data_reg0<=X"00";
			TxD_data_reg1<=X"00";
			TxD_data_reg<=X"00";
		end if;
	end process;

	process(clk,rst)
	begin
		if(clk'event and clk='0') then
			TxD_busy_dsyn_t0<=TxD_busy;
			TxD_busy_dsyn_t1<=TxD_busy_dsyn_t0;
			TxD_busy_dsyn_t2<=TxD_busy_dsyn_t1;
			if(is_write='1' and writable_reg='1') then
				TxD_data_prepare<='1';
				TxD_data_s<=TxD_data;
				writable_reg<='0';
			end if;
			if(TxD_data_prepare='1') then
				TxD_data_prepare<='0';
				TxD_start_psyn_s<=not TxD_start_psyn_s;
			end if;
			if(TxD_busy_dsyn_t2='1' and TxD_busy_dsyn_t1='0') then
				writable_reg<='1';
			end if;
		end if;
		if(rst='0') then
			writable_reg<='1';
			TxD_start_psyn_s<='0';
			TxD_busy_dsyn_t0<='0';
			TxD_busy_dsyn_t1<='0';
			TxD_busy_dsyn_t2<='0';
			TxD_data_s<=X"00";
			TxD_data_prepare<='0';
		end if;
	end process;

	process(clk,rst)
	begin
		if(clk'event and clk='0') then
			RxD_data_ready_dsyn_t0<=RxD_data_ready;
			RxD_data_ready_dsyn_t1<=RxD_data_ready_dsyn_t0;
			RxD_data_ready_dsyn_t2<=RxD_data_ready_dsyn_t1;
			RxD_data_reg0<=RxD_data_reg;
			RxD_data_reg1<=RxD_data_reg0;
			if(RxD_data_ready_dsyn_t2='0' and RxD_data_ready_dsyn_t1='1') then
				readable_reg<='1';
				RxD_data_out<=RxD_data_reg1;
			end if;
			if(is_read='1' and readable_reg='1') then
				readable_reg<='0';
			end if;
		end if;
		if(rst='0') then
			RxD_data_ready_dsyn_t0<='0';
			RxD_data_ready_dsyn_t1<='0';
			RxD_data_ready_dsyn_t2<='0';
			RxD_data_reg0<=X"00";
			RxD_data_reg1<=X"00";
			RxD_data_out<=X"00";
			readable_reg<='0';
		end if;
	end process;

end behavioral;