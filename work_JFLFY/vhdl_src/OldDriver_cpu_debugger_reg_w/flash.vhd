library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity flash is
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           mmu_addr : in  STD_LOGIC_VECTOR (21 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (31 downto 0);
           
           mmu_read_enable: in std_logic;
           write_enable: in std_logic;
           erase_enable: in std_logic;
           
           flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
           flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           flash_control_ce0: out std_logic;
           flash_control_ce1: out std_logic;
           flash_control_ce2: out std_logic;
           flash_control_byte: out std_logic;
           flash_control_vpen: out std_logic;
           flash_control_rp: out std_logic;
           flash_control_oe: out std_logic;
           flash_control_we: out std_logic
          );
end flash;

architecture Behavioral of flash is

signal read_enable: std_logic;
signal read_lock: std_logic;
signal addr: STD_LOGIC_VECTOR(21 downto 0);

begin
    flash_control_ce0 <= '0';
    flash_control_ce1 <= '0';
    flash_control_ce2 <= '0';
    flash_control_byte <= '1';
    flash_control_vpen <= '1';
    flash_control_rp <= '1';
    
    process (clk)
    variable state: integer := 0;
    begin
    if (clk'event and clk = '1') then
        if (rst='0') then
            read_enable<='0';
            read_lock<='0';
				state:=0;
            flash_control_oe <= '1';
            flash_control_we <= '1';
            flash_data <= (others => 'Z');
        else 
            if (mmu_read_enable='1') then
					if (read_lock='0') then
						read_enable<='1';
						read_lock<='1';
						addr<=mmu_addr;
					end if;
            else
                read_lock<='0';
            end if;
				
				
            case (state) is
                -- initial state
                -- priority: read > write > erase
                -- read states: 0x, write states: 1x, erase states: 2x, wait states: 3x
                when 0 =>
                    if (read_enable = '1') then
                    -- read state 0
                        flash_control_we <= '0';
                        flash_data <= X"00FF";
                        state := 1;
                    else
                        state := 0;
                    end if;
                -- read state 1
                when 1 =>
                    flash_control_we <= '1';
                    state := 2;
                -- read state 2
                when 2 =>
                    flash_data <= (others => 'Z');
                    state := 3;
                -- read state 3
                when 3 =>
                    flash_control_oe <= '0';
                    flash_addr <= addr & '0';
                    state := 4;
                -- read state 4
                when 4 =>
                    data_out(15 downto 0) <= flash_data;
                    flash_control_oe <= '1';
                    state := 5;


                -- read state 5
                when 5 =>
                    flash_control_we <= '0';
                    flash_data <= X"00FF";
                    state := 6;
                -- read state 6
                when 6 =>
                    flash_control_we <= '1';
                    state := 7;
                -- read state 7
                when 7 =>
                    flash_data <= (others => 'Z');
                    state := 8;
                -- read state 8
                when 8 =>
                    flash_control_oe <= '0';
                    flash_addr <= addr(21 downto 1) & "10";
                    state := 9;
                -- read state 9
                when 9 =>
                    data_out(31 downto 16) <= flash_data;
                    flash_control_oe <= '1';
                    state := 0;
                    
                    
                when others =>
                    state := 0;
            end case;
        end if;
    end if;
    end process;

end Behavioral;

