
 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:31 11/04/2015 
-- Design Name: 
-- Module Name:    forCompile - Behavioral 
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use work.rom.ALL;

entity MMU is port(
	rst:in std_logic;
	clk:in std_logic;
	comclk:in std_logic;
	flashclk:in std_logic;

	paddrInput:in std_logic_vector(31 downto 0);
	writeValueInput:in std_logic_vector(31 downto 0);
	-- version for VGA
	vgaAddrOutput:out std_logic_vector(17 downto 0);
	vgaValueOutput:out std_logic_vector(7 downto 0);
	-- end

	isSB:in std_logic;
		-- only ram consider this ctrl signal
	memRead:in std_logic;
	memWrite:in std_logic;

	-- is determinated by only vaddr, not memRead and memWrite
	isRAM:in std_logic;
	isROM:in std_logic;
	isFlash:in std_logic;
	isCOM:in std_logic;
	isVGA:in std_logic;
	-- version for VGA
	VGAcanWrite:out std_logic;
	-- end
	isPS2:in std_logic;
	isPS2State:in std_logic;
	-- version for PS2
	PS2CanRead:out std_logic;
	PS2HasData:in std_logic;
	-- end
	isAEP:in std_logic;
	isCOMState:in std_logic;
	isDigit:in std_logic;
	isNONE:in std_logic;

	excOccur:in std_logic;
	
	dbOccur:in std_logic;
	
	valueOutput:out std_logic_vector(31 downto 0);

	comIntr:out std_logic;

   -- ports connected with ram
	baseram_addr:out std_logic_vector(19 downto 0);
	baseram_data:inout std_logic_vector(31 downto 0);
	baseram_ce:out std_logic;
	baseram_oe:out std_logic;
	baseram_we:out std_logic;
	extrram_addr:out std_logic_vector(19 downto 0);
	extrram_data:inout std_logic_vector(31 downto 0);
	extrram_ce:out std_logic;
	extrram_oe:out std_logic;
	extrram_we:out std_logic;

	
   flash_addr : out  STD_LOGIC_VECTOR (22 downto 0);
   flash_data : inout  STD_LOGIC_VECTOR (15 downto 0);
   flash_control_ce0: out std_logic;
   flash_control_ce1: out std_logic;
   flash_control_ce2: out std_logic;
   flash_control_byte: out std_logic;
   flash_control_vpen: out std_logic;
   flash_control_rp: out std_logic;
   flash_control_oe: out std_logic;
   flash_control_we: out std_logic;

	TxD:out std_logic;
	RxD:in std_logic;

	-- version for PS2
	asciiInput:in std_logic_vector(7 downto 0)

);
end MMU;

architecture Behavioral of MMU is

signal ZERO : std_logic ;

component ram port(
	clk:in std_logic;rst:in std_logic;ope_addr:in std_logic_vector(19 downto 0);
	write_data:in std_logic_vector(31 downto 0);read_data:out std_logic_vector(31 downto 0);
	ope_we:in std_logic;ope_ce1:in std_logic;ope_ce2:in std_logic;
	baseram_addr:out std_logic_vector(19 downto 0);baseram_data:inout std_logic_vector(31 downto 0);
	baseram_ce:out std_logic;baseram_oe:out std_logic;baseram_we:out std_logic;
	extrram_addr:out std_logic_vector(19 downto 0);extrram_data:inout std_logic_vector(31 downto 0);
	extrram_ce:out std_logic;extrram_oe:out std_logic;extrram_we:out std_logic
	);
end component;
component com Port (		
	clk:in std_logic;comclk:in std_logic;rst:in std_logic;is_read:in std_logic;is_write:in std_logic;
	TxD_data:in std_logic_vector(7 downto 0);RxD_data:out std_logic_vector(7 downto 0);
	RxD:in std_logic; TxD:out std_logic;readable:out std_logic;writable:out std_logic);
end component;


    COMPONENT flash
    PORT(
			  clk : in  STD_LOGIC;
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
    END COMPONENT;

	signal state:std_logic_vector(1 downto 0):="00";

	signal ram_ope_addr:std_logic_vector(19 downto 0);
	signal ram_write_data:std_logic_vector(31 downto 0);
	signal ram_read_data:std_logic_vector(31 downto 0);
	signal ram_ope_we:std_logic;
	signal ram_ope_ce1:std_logic:='0';
	signal ram_ope_ce2:std_logic:='0';
	signal ram_sb_buf:std_logic_vector(31 downto 0):=X"00000000";

	signal com_is_read:std_logic:='0';
	signal com_is_write:std_logic:='0';
	signal com_read_data:std_logic_vector(7 downto 0);
	signal com_write_data:std_logic_vector(7 downto 0);
	signal com_state:std_logic_vector(1 downto 0);

	signal ramValueOutput:std_logic_vector(31 downto 0);
	signal romValueOutput:std_logic_vector(31 downto 0);
	signal comStateOutput:std_logic_vector(31 downto 0);
	signal comValueOutput:std_logic_vector(31 downto 0);
	signal flashValueOutput:std_logic_vector(31 downto 0);

begin
u1:ram port map(
	clk=>clk,rst=>rst,ope_ce1=>ram_ope_ce1,ope_ce2=>ram_ope_ce2,ope_addr=>ram_ope_addr,write_data=>ram_write_data,
	read_data=>ram_read_data,ope_we=>ram_ope_we,
	baseram_addr=>baseram_addr,baseram_data=>baseram_data,baseram_ce=>baseram_ce,
	baseram_oe=>baseram_oe,baseram_we=>baseram_we,
	extrram_addr=>extrram_addr,extrram_data=>extrram_data,extrram_ce=>extrram_ce,
	extrram_oe=>extrram_oe,extrram_we=>extrram_we
	);
u2:com port map(
	clk=>clk,comclk=>comclk,rst=>rst,is_read=>com_is_read,is_write=>com_is_write,
	TxD_data=>com_write_data,RxD_data=>com_read_data,
	readable=>com_state(1),writable=>com_state(0),TxD=>TxD,RxD=>RxD);	-- 0:writable 1:readable

u3: flash PORT MAP (
          clk => flashclk,
			 rst => rst,
          mmu_addr => paddrInput(22 downto 1),
          data_in => X"0000",
          data_out => flashValueOutput,
          mmu_read_enable => isFlash,
          write_enable => ZERO,
          erase_enable => ZERO,
          flash_addr => flash_addr,
          flash_data => flash_data,
          flash_control_ce0 => flash_control_ce0,
          flash_control_ce1 => flash_control_ce1,
          flash_control_ce2 => flash_control_ce2,
          flash_control_byte => flash_control_byte,
          flash_control_vpen => flash_control_vpen,
          flash_control_rp => flash_control_rp,
			 flash_control_we => flash_control_we,
			 flash_control_oe => flash_control_oe
        );

	valueOutput<=
		ramValueOutput when isRAM='1' else
		flashValueOutput when isFlash='1' else
		comValueOutput when isCOM='1' else
		comStateOutput when isCOMState='1' else
		romValueOutput when isROM='1' else
		-- version for VGA
		writeValueInput when isVGA='1' else
		-- end
		-- version for PS2
		(X"000000" & asciiInput) when isPS2='1' else
		("0000000000000000000000000000000" & PS2HasData) when isPS2State='1' else
		--("000000000000000000000000" & asciiInput) when isPS2='1' else
		-- end
		(others=>'0');
	comIntr<=com_state(1);

	-- ==========RAM========== 
	ram_ope_addr<=paddrInput(21 downto 2);
	ram_ope_ce1<=not paddrInput(22) and (isRAM and not excOccur);	-- ram1
	ram_ope_ce2<=paddrInput(22) and (isRAM and not excOccur);		-- ram2
	ram_ope_we<=
		'1' when dbOccur='1' else
		not memWrite or isSB when state="00" else 	--notice that IF should be considered
		'0';	-- is SB stage 2

	ram_write_data<=
		writeValueInput when state="00" else
		ram_sb_buf;
	ramValueOutput<=ram_read_data;

	-- version for VGA
		vgaAddrOutput <= paddrInput(19 downto 2);
		vgaValueOutput <= writeValueInput(7 downto 0);
		VGAcanWrite <= isVGA;
	-- end

	--version for PS2
	PS2CanRead <= isPS2;
	-- end

	process(clk)
	begin
	if(clk'event and clk='1') then -- rsing edge to identify SB immediately
		if (rst='0') then
			state<="00"; -- already think twice
		else
			case state is
			when "00"=>
				if (isSB='1'and excOccur='0') then	-- exception occur need to cancel the SB state machine
					case paddrInput(1 downto 0) is
					when "00"=>
						ram_sb_buf<=ramValueOutput(31 downto 8)&writeValueInput(7 downto 0);
					when "01"=>
						ram_sb_buf<=ramValueOutput(31 downto 16)&writeValueInput(7 downto 0)&ramValueOutput(7 downto 0);
					when "10"=>
						ram_sb_buf<=ramValueOutput(31 downto 24)&writeValueInput(7 downto 0)&ramValueOutput(15 downto 0);
					when "11"=>
						ram_sb_buf<=writeValueInput(7 downto 0)&ramValueOutput(23 downto 0);
					when others=>
					end case;
					state<="01";
				else
					state<="00";
				end if;
			when "01"=>
				state<="00";
			when others=>
			end case;
		end if;
	end if;
	end process;

	-- ==========COM==========
	com_is_read<=isCOM and memRead and not dbOccur;	-- here we think that IF will not use COM
	com_is_write<=isCOM and memWrite and not dbOccur;
		-- regardless of SB
	com_write_data<=writeValueInput(7 downto 0) when com_is_write='1' else X"00";
	comValueOutput<=X"000000"&com_read_data when com_is_read='1' else X"00000000";

	comStateOutput<=X"0000000"&"00"&com_state(1 downto 0) when isCOMState='1' and memRead='1' else X"00000000";
		-- is read only

	-- ==========ROM==========
	romValueOutput<=
		boot_rom(conv_integer(paddrInput(10 downto 2))) when memWrite='0' or dbOccur='1' else
		X"00000000";


	ZERO <= '0';
end Behavioral;