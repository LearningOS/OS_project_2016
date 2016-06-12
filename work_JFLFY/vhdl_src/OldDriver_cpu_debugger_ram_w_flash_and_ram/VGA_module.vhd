----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:58:37 12/17/2015 
-- Design Name: 
-- Module Name:    VGA_module - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_module is
Port(
	clk:in std_logic;
	rst:in std_logic;
	canWrite:in std_logic;
	
	vgaAddrInput:in std_logic_vector(17 downto 0);
	write_data:in std_logic_vector(7 downto 0);
	
	-- output
	rOut:out std_logic_vector(2 downto 0);
	gOut:out std_logic_vector(2 downto 0);
	bOut:out std_logic_vector(2 downto 0);
	hs:out std_logic;
	vs:out std_logic
);
end VGA_module;

architecture Behavioral of VGA_module is
constant fakeAddr : std_logic_vector(20 downto 0) := (others => '1');
	
	signal x: std_logic_vector(10 downto 0) := (others => '0');
	signal y: std_logic_vector(9 downto 0) := (others => '0');
	signal hst : std_logic;
	signal vst : std_logic;
	signal rAns, gAns, bAns : std_logic_vector(2 downto 0); 
	
	signal real_Addr : std_logic_vector(17 downto 0) := (others => '0');
	signal RGB : std_logic_vector(7 downto 0);
	
	component vga_mem
	Port(
		ena : IN STD_LOGIC;
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 downto 0);
		addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		clkb : IN STD_LOGIC;
		addrb : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	end component;
begin
	--real_Addr <= -- to_stdlogicvector( to_integer(unsigned(y)) * 1040 - 1 )
	--				("0" & y & "0000000000") + ("0000000" & y & "0000") + x - 1
	--				when canWrite = '1' else
	--				fakeAddr;

	real_Addr <= y(9 downto 1) & x(9 downto 1)
				when y<600 and x<800 else
					(others => '1');
					
	rAns <= RGB(7 downto 5);
	gAns <= RGB(4 downto 2);
	bAns <= "111" when RGB(1 downto 0)="11" else
			"101" when RGB(1 downto 0)="10" else
			"010" when RGB(1 downto 0)="01" else
			"000" when RGB(1 downto 0)="00" else
			"000";

	u0:vga_mem
	port map(
		ena => canWrite,
		clka => clk,
		wea => "1",
		addra => vgaAddrInput,
		dina => write_data,
		clkb => clk,
		addrb => real_Addr,
		doutb => RGB
	);

	-- for x change :
	process(clk, rst)
	begin
		if rst = '0' then
			x <= (others => '0');
		elsif CLK'event and CLK = '1' then
			if x = 1039 then
				x <= (others => '0');
			else
				x <= x + 1;
			end if;
		end if;
	end process;
	
	-- for y change :
	process (CLK, rst)
	begin
		if rst = '0' then
			y <= (others => '0');
		elsif CLK'event and CLK = '1' then
			if x = 1039 then
				if y = 665 then
					y <= (others => '0');
				else
					y <= y + 1;
				end if;
			end if;
		end if;
	end process;
	
	-- produce H signal : 
	process (CLK, rst)
	begin
		if rst = '0' then
			hst <= '1';
		elsif CLK'event and CLK = '1' then
			if x >= 856 and x < 976 then
				hst <= '0';
			else
				hst <= '1';
			end if;
		end if;
	end process;
 
	-- produce V signal : 
	process (CLK, rst)
	begin
		if rst = '0' then
			vst <= '1';
		elsif CLK'event and CLK = '1' then
			if y >= 637 and y< 643 then
				vst <= '0';
			else
				vst <= '1';
			end if;
		end if;
	end process;

	-- H signal : 
	process (CLK, rst)
	begin
		if rst = '0' then
			hs <= '0';
		elsif CLK'event and CLK = '1' then
			hs <=  hst;
		end if;
	end process;

	-- V signal :
	process (CLK, rst)
	begin
		if rst = '0' then
			vs <= '0';
		elsif CLK'event and CLK='1' then
			vs <=  vst;
		end if;
	end process;
	 
	-- color output
	process (hst, vst, rAns, gAns, bAns, x, y)	--色彩输出
	begin
		if hst = '1' and vst = '1'then
			rOut <= rAns;
			gOut <= gAns;
			bOut <= bAns;
		else
			rOut <= (others => '0');
			gOut <= (others => '0');
			bOut <= (others => '0');
		end if;
	end process;
end Behavioral;

