library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity flash is
port(
    Debug:out std_logic_vector(15 downto 0);

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
end flash;

architecture behavioral of flash is
    signal state:std_logic_vector(2 downto 0);
    signal cnt:std_logic_vector(1 downto 0);
begin
    Debug<=X"0D3A";

    data_out<=flash_data;

    flash_control_ce0<='0';
    flash_control_ce1<='0';
    flash_control_ce2<='0';
    flash_control_byte<='1';
    flash_control_vpen<='1';
    flash_control_rp<='1';

    process(clk)
    begin
    if (clk'event and clk='0') then
        if (rst='0') then
            state<="000";
            cnt<=(others=>'0');
            flash_control_we<='1';
            flash_control_oe<='1';
        elsif (cnt>0) then
            cnt<=cnt-1;
        else
            case state is
            when "000"=>
                if (is_read='1' and is_write='1') then
                    state<="111";
                elsif (is_read='1') then
                    flash_data<=(others=>'Z');
                    flash_addr<=addr(22 downto 1) & '0';
                    flash_control_oe<='0';
                    cnt<="01";
                    state<="001";
                elsif (is_write='1') then
                    flash_data<=data_in;
                    flash_addr<=addr(22 downto 1) & '0';
                    flash_control_we<='0';
                    cnt<="01";
                    state<="010";
                end if;
            when "001"=>
                flash_control_oe<='1';
                cnt<="01";
                state<="000";
            when "010"=>
                flash_control_we<='1';
                cnt<="01";
                state<="000";
            when others=>
            end case;
        end if;
    end if;
    end process;
    
end behavioral;
