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

architecture Behavioral of com is
	signal state:std_logic_vector(1 downto 0);	-- state

	signal RxD_data_buffer:std_logic_vector(7 downto 0);
	signal TxD_data_buffer:std_logic_vector(7 downto 0);
	signal TxD_start:std_logic:='0';
	signal TxD_busy:std_logic:='0';
	signal RxD_data_ready:std_logic:='0';

	signal TxD_ready:std_logic:='0';
	signal TxD_ready0:std_logic:='0';
	signal TxD_ready1:std_logic:='0';

	signal RxD_idle:std_logic:='1';
	signal RxD_endofpacket:std_logic:='0';

	signal readable_buf:std_logic;
	signal readable_buf0:std_logic;
	signal readable_buf1:std_logic;
	signal writable_buf:std_logic;


component async_transmitter
    port(clk:in std_logic;TxD_start:in std_logic;TxD_data:in std_logic_vector(7 downto 0);TxD:out std_logic;TxD_busy: out std_logic);
end component;
component async_receiver
    port(clk:in std_logic;RxD:in std_logic;RxD_data_ready:out std_logic;RxD_data:out std_logic_vector(7 downto 0);
    	RxD_endofpacket:out std_logic;RxD_idle:out std_logic);
end component;

begin
	u3:async_receiver port map(clk=>comclk,RxD=>RxD,RxD_data_ready=>RxD_data_ready,RxD_data=>RxD_data_buffer,
		RxD_endofpacket=>RxD_endofpacket,RxD_idle=>RxD_idle);  
	u4:async_transmitter port map(clk=>comclk,Txd=>TxD,TxD_start=>TxD_start,TxD_data=>TxD_data_buffer,Txd_busy=>Txd_busy);
	
	readable<=readable_buf;
	writable<=writable_buf;
	readable_buf<=readable_buf0 xor readable_buf1;
	writable_buf<=not Txd_busy;
	TxD_ready<=TxD_ready0 xor TxD_ready1;

	process(comclk)
	begin
	if(comclk'event and comclk='0') then	-- use 50M for save data_ready
		if (RxD_data_ready='1') then
			readable_buf0<='1' xor readable_buf1;
		end if;
		if (TxD_ready='1') then
			TxD_start<='1';
			TxD_ready1<='0' xor TxD_ready0;
		else
			TxD_start<='0';
		end if;
	end if;
	end process;

	process(clk)
	begin
	if(clk'event and clk='0') then	-- we need half of clock to prepare data
		if (rst='0') then 
			readable_buf1<='0' xor readable_buf0;
		else 
			if (is_read='1' and readable_buf='1') then
				-- actually last time then data is ready, but _readable is not send
				-- OS is waitting for readable, the delay is ok
				RxD_data<=RxD_data_buffer;
				readable_buf1<='0' xor readable_buf0;
			end if;

			-- read and write is independent

			if (is_write='1' and writable_buf='1') then
				TxD_data_buffer<=TxD_data;
				TxD_ready0<='1' xor TxD_ready1;
			end if;
		end if;
	end if;
	end process;

end Behavioral;

