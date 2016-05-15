----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:22 12/01/2015 
-- Design Name: 
-- Module Name:    TLB - Behavioral 
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

entity TLB is
Port(
	-- clk
	clk:in std_logic;
	-- reset
	rst:in std_logic;

	-- input
	dbOccur:in std_logic;
	dbVaddrInput:in std_logic_vector(31 downto 0);

	ifVaddrInput:in std_logic_vector(31 downto 0);
	memVaddrInput:in std_logic_vector(31 downto 0);
	entryhiInput:in std_logic_vector(31 downto 0);
	entrylo0Input:in std_logic_vector(31 downto 0);
	entrylo1Input:in std_logic_vector(31 downto 0);
	pagemaskInput:in std_logic_vector(31 downto 0);
	indexInput:in std_logic_vector(31 downto 0);
	randomInput:in std_logic_vector(31 downto 0);
	memRead:in std_logic;
	memWrite:in std_logic;
	isTLBWI:in std_logic;
	isTLBWR:in std_logic;
	isSB:in std_logic;
	stldLen:in std_logic_vector(1 downto 0);

	-- output
	paddrOutput:out std_logic_vector(31 downto 0);
	vaddrOutput:out std_logic_vector(31 downto 0);
	isRAM:out std_logic;
	isROM:out std_logic;
	isFlash:out std_logic;
	isCOM:out std_logic;
	isVGA:out std_logic;
	isPs2:out std_logic;
	-- version for keyboard
	isPS2State:out std_logic;
	-- end
	isAEP:out std_logic;
	isCOMState:out std_logic;
	isDigit:out std_logic;
	isNone:out std_logic;
	cntBubble:out std_logic_vector(4 downto 0);
	ifExcCode:out std_logic_vector(31 downto 0);
	memExcCode:out std_logic_vector(31 downto 0)
);
end TLB;

architecture Behavioral of TLB is
	signal inIsRAM:std_logic;
	signal inIsROM:std_logic;
	signal inIsFlash:std_logic;
	signal inIsCOM:std_logic;
	signal inIsVGA:std_logic;
	signal inIsPS2:std_logic;
	signal inIsAEP:std_logic;
	signal inIsCOMState:std_logic;
	signal inIsDigit:std_logic;
	signal inIsNONE:std_logic;
	signal inisPS2State:std_logic;
	type tlbArray is array (3 downto 0) of std_logic_vector(60 downto 0);
	signal tlbEntry:tlbArray;
		-- Standard : 	VPN2[125:107],ASID[106:99],PageMask[98:83],G[82],PFN[81:56],
		-- 				Flags{C[55:53],V[52],D[51]},PFN[50:25],Flags{C[4:2],V[1],D[0]}
		-- temporary:	VPN2[60:42],PFN[41:22],Flags{V[21]},PFN[20:1],Flags{V[0]}

	signal vaddrInput:std_logic_vector(31 downto 0):=X"00000000";
	--signal tlbmr:std_logic_vector(tlbLgN-1 downto 0);		for 16*tlbEntry
		-- (3:0)index of match TLB, (4) means if matched, lo0 or lo1
		-- (5) means whether there is a match or not

	signal tlb4Match:std_logic_vector(3 downto 0);
	signal tlb4Valid:std_logic_vector(3 downto 0);
	signal tlbIndex:std_logic_vector(1 downto 0);
	signal tlbValid:std_logic;

begin

	vaddrInput<=dbVaddrInput when dbOccur='1' else 
		ifVaddrInput when (memRead or memWrite)='0' else memVaddrInput;
	vaddrOutput<=vaddrInput;
	-- not only this
	inIsRAM<=not(inIsPS2State or inIsROM or inIsFlash or inIsCOM or inIsVGA or inIsPS2 or inIsAEP or inIsCOMState or inIsDigit or inIsNONE);
	inIsROM<='1' when "1011"<=vaddrInput(31 downto 28) and vaddrInput(31 downto 12)<X"B0001" else '0';
	inIsFlash<='1' when "1011111"<=vaddrInput(31 downto 25) and vaddrInput(31 downto 24)<X"BF" else '0';
	inIsCOM<='1' when vaddrInput=X"BFD003F8" else '0';
	-- inIsVGA<='0';
	-- version for VGA
	inIsVGA <= '1' when '0'&X"BA000000" <= '0'&vaddrInput and '0'&vaddrInput <= '0'&X"BA096000" else '0';
	-- end
	-- version for PS2
	inIsPS2<='1' when vaddrInput = X"AF000000" and memRead = '1' else '0';
	inIsPS2State<='1'  when vaddrInput = X"AF000004" and memRead = '1' else '0';
	-- end
	inIsAEP<='0';
	inIsCOMState<='1' when X"BFD003F8"<vaddrInput and vaddrInput<X"BFD00400" else '0';
	inIsDigit<='0';
	inIsNONE<='1' when ((X"80"&'1'<=vaddrInput(31 downto 23) and vaddrInput(31 downto 29)<"101") or
					   (X"A0"&'1'<=vaddrInput(31 downto 23) and vaddrInput(31 downto 30)/="11")) and
					   (inIsROM or inIsFlash or inIsCOM or inIsVGA or inIsPS2 or inIsAEP or inIsCOMState or inIsDigit or inIsPS2State)='0' else '0';

	--isRAM<=inIsRAM;	-- quartus 10.9ns
	isRAM<=inIsRAM or inIsFlash;
		-- dirty trick
	isROM<=inIsROM;
	--isFlash<=inIsFlash;
	isFlash<='0';
		-- dirty trick
	isCOM<=inIsCOM;
	isVGA<=inIsVGA;
	isPS2<=inIsPS2;
	isPS2State <= inIsPS2State;
	isAEP<=inIsAEP;
	isCOMState<=inIsCOMState;
	isDigit<=inIsDigit;
	isNONE<=inIsNONE;
	
	cntBubble<=	
		"11111" when dbOccur='1' else
		"11000" when inISFlash='1' else
		"00010" when isSB='1' else
			-- must be MEM
		"00001" when (memRead or memWrite)='1' else
		"00000";

	tlb4Match(0)<='1' when tlbEntry(0)(60 downto 42)=vaddrInput(31 downto 13) else '0';
	tlb4Match(1)<='1' when tlbEntry(1)(60 downto 42)=vaddrInput(31 downto 13) else '0';
	tlb4Match(2)<='1' when tlbEntry(2)(60 downto 42)=vaddrInput(31 downto 13) else '0';
	tlb4Match(3)<='1' when tlbEntry(3)(60 downto 42)=vaddrInput(31 downto 13) else '0';
	with vaddrInput(12) select
		tlb4Valid(0)<=tlbEntry(0)(0) when '0',tlbEntry(0)(21) when '1';
	with vaddrInput(12) select
		tlb4Valid(1)<=tlbEntry(1)(0) when '0',tlbEntry(1)(21) when '1';
	with vaddrInput(12) select
		tlb4Valid(2)<=tlbEntry(2)(0) when '0',tlbEntry(2)(21) when '1';
	with vaddrInput(12) select
		tlb4Valid(3)<=tlbEntry(3)(0) when '0',tlbEntry(3)(21) when '1';
	tlbIndex(0)<=tlb4Match(1) or tlb4Match(3);
	tlbIndex(1)<=tlb4Match(2) or tlb4Match(3);
	tlbValid<=tlb4Valid(conv_integer(tlbIndex)) and tlb4Match(conv_integer(tlbIndex));

			-- when VPN2:tlb_i=tlb_j and both of them are available
			-- this expression will be inaccurate
			-- but this is impossible when OS are running without error


	-- even though if a mem fetch need mutil-period, excCode will calc more than one time
	-- but all of them are same, so if we set the intDisable, no exception will occur in some state!="00"
	ifExcCode<=
		X"00000000" when (memRead or memWrite)='1' else 	-- not this stage, return no exception
		X"00000010" when (vaddrInput(1 downto 0) and "11")/="00" or inIsNONE='1' else 	-- ADEL 4
			-- consider none
		-- need not map
		X"00000000"	when '1'=vaddrInput(31) and vaddrInput(31 downto 30)/="11" else
		X"00000004" when tlbValid='0' else X"00000000";				-- TLBL 2
	memExcCode<=
		X"00000000" when (memRead or memWrite)='0' else 	-- not this stage, return no exception
		-- distinguish lw, lh, lb
		X"00000010" when ((vaddrInput(1 downto 0) and not stldLen)/="00" or inIsNONE='1') and memRead='1' else 	-- ADEL 4
			-- stldLen: lw:"00" lh:"10" lb:"11" 
			-- consider none
		X"00000020" when ((vaddrInput(1 downto 0) and not stldLen)/="00" or inIsNONE='1') and memWrite='1' else 	-- ADES 5
		-- need not map
		X"00000000"	when '1'=vaddrInput(31) and vaddrInput(31 downto 30)/="11" else
		X"00000004" when tlbValid='0' and memRead='1' else 						-- TLBL 2
		X"00000008" when tlbValid='0' and memWrite='1' else X"00000000";		-- TLBS 3
	
		-- ADE is prior to TLB, because we can kill the process


	-- * downto|to and conv_integer, the bit order
	paddrOutput<=
		vaddrInput-X"B0000000" when inIsROM='1' else -- need change for Rom
		vaddrInput-X"BE000000"+X"00200000" when inIsFlash='1' else 
		-- vaddrInput-X"B0000000" when inIsROM='1' else -- need change for Rom
		-- vaddrInput-X"BE000000" when inIsFlash='1' else 
		-- kseg0,kseg1
		-- version for VGA
		-- vaddrInput - X"BA000000" when inIsVGA = '1'else
		-- end
		-- version for PS2
		-- (others => '0') when inIsPS2 = '1' else
		-- end
		'0'&vaddrInput(30 downto 0) when '1'=vaddrInput(31) and vaddrInput(31 downto 29)<"101" else
		"000"&vaddrInput(28 downto 0) when "101"<=vaddrInput(31 downto 29) and vaddrInput(31 downto 30)/="11" else
		-- no match don't care
		--X"00000000" when tlbValid='0' else
		--	TLB mapping
		tlbEntry(conv_integer(tlbIndex))(20 downto 1) & vaddrInput(11 downto 0) when vaddrInput(12)='0' else
		tlbEntry(conv_integer(tlbIndex))(41 downto 22) & vaddrInput(11 downto 0);


	-- quartus 3.19ns
	-- write in falling edge need wbController work in half period
	-- if a exception occur, may leed to fatal TLB error because of its writing is in the ID. 
	-- But we believe software will not challenge it
	process(clk)
	variable ii:integer range 0 to 3;
	begin
	if (clk'event and clk='0') then
		if (rst='0') then
			for i in 0 to 3 loop
				tlbEntry(i)(60 downto 42)<=conv_std_logic_vector(i,19);
				tlbEntry(i)(0)<='0';
				tlbEntry(i)(21)<='0';
			end loop;
		elsif ((isTLBWR or isTLBWI)='1') then
			if (isTLBWI='1') then
				ii:=conv_integer(indexInput(1 downto 0));
			else 
				ii:=conv_integer(randomInput(1 downto 0));
			end if;
			tlbEntry(ii)(60 downto 42)<=entryhiInput(31 downto 13);
			-- ? lo0 and lo1 who is first
			tlbEntry(ii)(20 downto 1)<=entrylo0Input(25 downto 6);
			tlbEntry(ii)(0)<=entrylo0Input(1);
			tlbEntry(ii)(41 downto 22)<=entrylo1Input(25 downto 6);
			tlbEntry(ii)(21)<=entrylo1Input(1);
		end if;
	end if;
	end process;

end Behavioral;

