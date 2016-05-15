library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity test_flash is
port(
	clk50,rst:std_logic;
	spd:in std_logic_vector(4 downto 0);
	Debug:out std_logic_vector(15 downto 0);

	flash_addr:out std_logic_vector(22 downto 0);
	flash_data:inout std_logic_vector(15 downto 0);
	flash_control_ce0:out std_logic;
	flash_control_ce1:out std_logic;
	flash_control_ce2:out std_logic;
	flash_control_byte:out std_logic;
	flash_control_vpen:out std_logic;
	flash_control_rp:out std_logic;
	flash_control_oe:out std_logic;
	flash_control_we:out std_logic
);
end test_flash;

architecture behavioral of test_flash is
	component flash32 is
	port(
		flash_state:out std_logic_vector(2 downto 0);
		flash32_state:out std_logic_vector(4 downto 0);

		clk,rst:in std_logic;
		is_read,is_write,is_erase:in std_logic;
		addr:in std_logic_vector(31 downto 0);
		data_in:in std_logic_vector(31 downto 0);
		data_out:out std_logic_vector(31 downto 0);
		busy:out std_logic;

		flash_addr:out std_logic_vector(22 downto 0);
		flash_data:inout std_logic_vector(15 downto 0);
		flash_control_ce0:out std_logic;
		flash_control_ce1:out std_logic;
		flash_control_ce2:out std_logic;
		flash_control_byte:out std_logic;
		flash_control_vpen:out std_logic;
		flash_control_rp:out std_logic;
		flash_control_oe:out std_logic;
		flash_control_we:out std_logic
	);
	end component;

	signal count:std_logic_vector(31 downto 0);
	signal clk:std_logic;

	signal is_read,is_write,is_erase:std_logic;
	signal addr,data_in,data_out:std_logic_vector(31 downto 0);
	signal busy,busy0:std_logic;

	signal state:std_logic_vector(3 downto 0);
	signal statei:std_logic_vector(31 downto 0);
begin
	process(clk50)
	begin
		if (clk50'event and clk50='1') then
			count<=count+1;
		end if;
	end process;
	--clk<=count(20);
	clk<=count(conv_integer(spd));
	--clk<=clk50;

	u0:flash32 port map(
		--flash32_state=>Debug(8 downto 4),flash_state=>Debug(11 downto 9),

		clk=>clk,rst=>rst,is_read=>is_read,is_write=>is_write,is_erase=>is_erase,
		addr=>addr,data_in=>data_in,data_out=>data_out,busy=>busy,

		flash_addr=>flash_addr,flash_data=>flash_data,flash_control_ce0=>flash_control_ce0,
		flash_control_ce1=>flash_control_ce1,flash_control_ce2=>flash_control_ce2,
		flash_control_byte=>flash_control_byte,flash_control_vpen=>flash_control_vpen,
		flash_control_rp=>flash_control_rp,flash_control_oe=>flash_control_oe,
		flash_control_we=>flash_control_we
	);

	--Debug(15 downto 12)<="1100";
	Debug(15 downto 12)<=statei(3 downto 0);
	Debug(11 downto 4)<=data_out(7 downto 0);
	Debug(3 downto 0)<=state;

	process(clk,rst)
	begin
		if (clk'event and clk='0') then
			is_read<='0';
			is_write<='0';
			is_erase<='0';
			case state is
			when "0000"=>
				if (busy0='1') then
					busy0<='0';
				end if;
				if (busy='0' and busy0='0') then
					busy0<='1';
					is_erase<='1';
					addr<=X"00000000";

					state<="0001";
					statei<=X"00000000";
				end if;
			when "0001"=>
				if (busy0='1') then
					busy0<='0';
				end if;
				if (busy='0' and busy0='0') then
					busy0<='1';
					is_write<='1';
					data_in<=statei;
					--addr<=statei(29 downto 0) & "00";
					addr<=X"0002" & statei(13 downto 0) & "00";

					statei<=statei+1;
					if (statei=1000) then
						state<="0010";
						statei<=X"00000000";
					end if;
				end if;
			when "0010"=>
				if (busy0='1') then
					busy0<='0';
				end if;
				if (busy='0' and busy0='0') then
					busy0<='1';
					is_read<='1';
					--addr<=statei(29 downto 0) & "00";
					addr<=X"0002" & statei(13 downto 0) & "00";
					if (statei>0 and data_out/=statei-1) then
						state<="1111";
					end if;

					statei<=statei+1;
					if (statei=1000) then
						state<="1110";
						statei<=X"00000000";
					end if;
				end if;

			when "1110"=>
			when "1111"=>

			when others=>
			end case;
		end if;

		if (rst='0') then
			state<="0000";
			statei<=X"00000000";
			is_read<='0';
			is_write<='0';
			is_erase<='0';
			busy0<='0';
		end if;
	end process;
	
end behavioral;