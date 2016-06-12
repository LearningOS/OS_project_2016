library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


	
entity ram is port(
	clk:in std_logic;
	rst:in std_logic;
		 
	ope_addr:in std_logic_vector(19 downto 0);
	write_data:in std_logic_vector(31 downto 0);
	read_data:out std_logic_vector(31 downto 0);
	ope_we:in std_logic;
	ope_ce1:in std_logic;
	ope_ce2:in std_logic;
	 
	baseram_addr:out std_logic_vector(19 downto 0);
	baseram_data:inout std_logic_vector(31 downto 0);
	baseram_ce:out std_logic;
	baseram_oe:out std_logic;
	baseram_we:out std_logic;
	 
	extrram_addr:out std_logic_vector(19 downto 0);
	extrram_data:inout std_logic_vector(31 downto 0);
	extrram_ce:out std_logic;
	extrram_oe:out std_logic;
	extrram_we:out std_logic	 
);
end ram;

architecture Behavioral of ram is
	signal state:std_logic_vector(2 downto 0);
	signal stateR:std_logic_vector(2 downto 0);
	signal stateF:std_logic_vector(2 downto 0):="000";
	signal baseram_oeR:std_logic;
	signal baseram_weR:std_logic;
	signal extrram_oeR:std_logic;
	signal extrram_weR:std_logic;
	signal baseram_oeF:std_logic;
	signal baseram_weF:std_logic;
	signal extrram_oeF:std_logic;
	signal extrram_weF:std_logic;
begin
	baseram_addr<=ope_addr;
	extrram_addr<=ope_addr;
	read_data<=		-- need ope_ce hold on before next clock coming
		baseram_data when ope_ce1='1' else
		extrram_data when ope_ce2='1' else X"00000000"; 
		
	state<=stateR xor stateF;
	baseram_oe<=baseram_oeR xor baseram_oeF;
	baseram_we<=baseram_weR xor baseram_weF;
	extrram_oe<=extrram_oeR xor extrram_oeF;
	extrram_we<=extrram_weR xor extrram_weF;
	
	process(clk)
	begin
	if (clk'event and clk='1') then
		if (rst='0') then
			baseram_data<=(others=>'Z');
			baseram_ce<='0';	-- always on
			baseram_oeR<=not baseram_oeF;	-- read
			baseram_weR<=not baseram_weF;	-- write
			extrram_data<=(others=>'Z');
			extrram_ce<='0';
			extrram_oeR<=not extrram_oeF;
			extrram_weR<=not extrram_weF;
			stateR<="010" xor stateF;
		else
			case state is
			when "010"=>	-- self-boot
				stateR<=stateF;
			when "001"=>	--	ram1 read
				baseram_oeR<=not baseram_oeR;
				stateR<=stateF;
			when "011"=>	--	ram1 write
				baseram_weR<=not baseram_weR;
				stateR<=stateF;
			when "101"=>	--	ram2 read
				extrram_oeR<=not extrram_oeR;
				stateR<=stateF;
			when "111"=>	--	ram2 write
				extrram_weR<=not extrram_weR;
				stateR<=stateF;
			when "100"=>	-- suspend a period
				stateR<=stateF;
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
			if (ope_ce1='1') then
				if (ope_we='1') then
					-- read ram1
					baseram_data<=(others=>'Z');
					baseram_oeF<=baseram_oeR;
					stateF<="001" xor stateR;
				else
					-- write ram1
					baseram_data<=write_data;
					baseram_weF<=baseram_weR;
					stateF<="011" xor stateR;
				end if;
			elsif (ope_ce2='1') then 
				if (ope_we='1') then
					-- read ram2
					extrram_data<=(others=>'Z');
					extrram_oeF<=extrram_oeR;
					stateF<="101" xor stateR;
				else
					-- write ram2
					extrram_data<=write_data;
					extrram_weF<=extrram_weR;
					stateF<="111" xor stateR;
				end if;
			else
				stateF<="100" xor stateR;
			end if;
		when others=>
		end case;
	end if;
	end process;

end Behavioral;

