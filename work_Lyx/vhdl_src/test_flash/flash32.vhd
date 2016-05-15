library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- in operation need data_in, addr always correct, and is_read, is_write, is_erase not

entity flash32 is
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
end flash32;

architecture behavioral of flash32 is
	component flash is
	port(
		flash_state:out std_logic_vector(2 downto 0);

		clk,rst:in std_logic;
		is_read,is_write:in std_logic;
		addr:in std_logic_vector(31 downto 0);
		data_in:in std_logic_vector(15 downto 0);
		data_out:out std_logic_vector(15 downto 0);

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

	signal state:std_logic_vector(4 downto 0);
	signal state_cnt:std_logic_vector(2 downto 0);
	signal data16_in,data16_out:std_logic_vector(15 downto 0);
	signal addr_f16:std_logic_vector(31 downto 0);
	signal is_read_f16,is_write_f16:std_logic;
	signal data_out_reg:std_logic_vector(31 downto 0);
	signal busy_reg:std_logic;

begin
	flash32_state<=state;
	u0:flash port map(
		flash_state=>flash_state,

		clk=>clk,rst=>rst,is_read=>is_read_f16,is_write=>is_write_f16,addr=>addr_f16,
		data_in=>data16_in,data_out=>data16_out,

		flash_addr=>flash_addr,flash_data=>flash_data,flash_control_ce0=>flash_control_ce0,
		flash_control_ce1=>flash_control_ce1,flash_control_ce2=>flash_control_ce2,
		flash_control_byte=>flash_control_byte,flash_control_vpen=>flash_control_vpen,
		flash_control_rp=>flash_control_rp,flash_control_oe=>flash_control_oe,
		flash_control_we=>flash_control_we
	);
	data_out<=data_out_reg;
	busy<=busy_reg;

	process(clk,rst)
	begin
		if (clk'event and clk='0') then
			is_read_f16<='0';
			is_write_f16<='0';

			case state is
			when "00000"=>
				busy_reg<='0';
				if (is_read='1') then
					is_write_f16<='1';
					data16_in<=X"00FF";
					addr_f16<=X"00000000";

					busy_reg<='1';

					state<="00010";
					state_cnt<="000";
				end if;
				if (is_write='1') then
					is_write_f16<='1';
					data16_in<=X"0040";
					addr_f16<=addr;

					busy_reg<='1';

					state<="01000";
					state_cnt<="000";
				end if;
				if (is_erase='1') then
					is_write_f16<='1';
					data16_in<=X"0020";
					addr_f16<="0" & X"00" & addr(22 downto 17) & "0" & X"0000";

					busy_reg<='1';

					state<="10000";
					state_cnt<="000";
				end if;

			-- read
			when "00010"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_read_f16<='1';
					addr_f16<=addr;

					state<="00011";
					state_cnt<="000";
				end if;
			when "00011"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_read_f16<='1';
					addr_f16<=addr(31 downto 2) & "10";

					state<="00100";
					state_cnt<="000";
				end if;
			when "00100"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=0) then
					data_out_reg(15 downto 0)<=data16_out;
				end if;
				if (state_cnt=1) then
					state<="00101";
					state_cnt<="000";
				end if;
			when "00101"=>
				data_out_reg(31 downto 16)<=data16_out;
				state<="00000";
				state_cnt<="000";

			--write
			when "01000"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_write_f16<='1';
					data16_in<=data_in(15 downto 0);
					addr_f16<=addr;

					state<="01001";
					state_cnt<="000";
				end if;
			when "01001"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_read_f16<='1';
					addr_f16<=X"00000000";

					state<="01010";
					state_cnt<="000";
				end if;
			when "01010"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=2) then
					case data16_out(7) is
					when '0'=>
						is_read_f16<='1';
						addr_f16<=X"00000000";

						state<="01010";
					when '1'=>
						is_write_f16<='1';
						data16_in<=X"0040";
						addr_f16<=addr(31 downto 2) & "10";

						state<="01100";
					when others=>
					end case;
					state_cnt<="000";
				end if;
			when "01100"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_write_f16<='1';
					data16_in<=data_in(31 downto 16);
					addr_f16<=addr(31 downto 2) & "10";

					state<="01101";
					state_cnt<="000";
				end if;
			when "01101"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_read_f16<='1';
					addr_f16<=X"00000000";

					state<="01110";
					state_cnt<="000";
				end if;
			when "01110"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=2) then
					case data16_out(7) is
					when '0'=>
						is_read_f16<='1';
						addr_f16<=X"00000000";

						state<="01110";
					when '1'=>
						state<="00000";
					when others=>
					end case;

					state_cnt<="000";
				end if;

			--erase
			when "10000"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_write_f16<='1';
					data16_in<=X"00D0";
					addr_f16<="0" & X"00" & addr(22 downto 17) & "0" & X"0000";

					state<="10001";
					state_cnt<="000";
				end if;
			when "10001"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=1) then
					is_read_f16<='1';
					addr_f16<=X"00000000";

					state<="10010";
					state_cnt<="000";
				end if;
			when "10010"=>
				state_cnt<=state_cnt+1;
				if (state_cnt=2) then
					case data16_out(7) is
					when '0'=>
						is_read_f16<='1';
						addr_f16<=X"00000000";

						state<="10010";
					when '1'=>
						state<="00000";
					when others=>
					end case;

					state_cnt<="000";
				end if;

			when "11111"=>
			when others=>
			end case;
		end if;

		if (rst='0') then
			state<="00000";
			state_cnt<="000";
			is_read_f16<='0';
			is_write_f16<='0';
			addr_f16<=X"00000000";
			data16_in<=X"0070";
			data_out_reg<=X"00000000";
			busy_reg<='0';
		end if;
	end process;

end behavioral;
