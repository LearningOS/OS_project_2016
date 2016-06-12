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
    signal stateF,stateR,state:std_logic_vector(2 downto 0);
    signal flash_control_oeF,flash_control_oeR:std_logic;
    signal flash_control_weF,flash_control_weR:std_logic;

    signal cnt:std_logic_vector(3 downto 0);
    signal lv:std_logic_vector(7 downto 0);
begin
    Debug<=X"0" & cnt & lv;

    state<=stateF xor stateR;
    flash_control_we<=flash_control_weF xor flash_control_weR;
    flash_control_oe<=flash_control_oeF xor flash_control_oeR;
    data_out<=flash_data;

    flash_control_ce0<='0';
    flash_control_ce1<='0';
    flash_control_ce2<='0';
    flash_control_byte<='1';
    flash_control_vpen<='1';
    flash_control_rp<='1';

    process(clk)
    begin
    if (clk'event and clk='1') then
        if (rst='0') then
            stateR<="000" xor stateF;
            flash_control_weR<='1' xor flash_control_weF;
            flash_control_oeR<='1' xor flash_control_oeF;
            --cnt<="0000";
        else
            case state is
            when "001"=>
                flash_control_oeR<='1' xor flash_control_oeF;
                stateR<="000" xor stateF;
            when "010"=>
                --cnt<=cnt+1;
                flash_control_weR<='1' xor flash_control_weF;
                stateR<="000" xor stateF;
            when others=>
            end case;
        end if;
    end if;
    end process;

    process(clk)
    begin
    if (clk'event and clk='0') then
        case state is
        when "000"=>
            if (is_read='1' and is_write='1') then
                stateF<="111" xor stateR;
            elsif (is_read='1') then
                flash_data<=(others=>'Z');
                flash_addr<=addr(22 downto 1) & '0';
                flash_control_oeF<='0' xor flash_control_oeR;
                stateF<="001" xor stateR;
            elsif (is_write='1') then
                flash_data<=data_in;
                --lv<=data_in(7 downto 0);
                flash_addr<=addr(22 downto 1) & '0';
                flash_control_weF<='0' xor flash_control_weR;
                stateF<="010" xor stateR;
            end if;
        when others=>
        end case;
    end if;
    end process;
    
end behavioral;
