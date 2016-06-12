--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 14.7
--  \   \         Application : sch2hdl
--  /   /         Filename : TOP2.vhf
-- /___/   /\     Timestamp : 12/05/2015 20:52:26
-- \   \  /  \
--  \___\/\___\
--
--Command: F:\xilinx\14.7\ISE_DS\ISE\bin\nt\unwrapped\sch2hdl.exe -intstyle ise -family spartan6 -flat -suppress -vhdl TOP2.vhf -w F:/vhdl/OldDriver_CPU/test_CPU/TOP2.sch
--Design Name: TOP2
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be
--    synthesized and simulated, but it should not be modified.
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.defines.all;
--library UNISIM;
--use UNISIM.Vcomponents.ALL;

entity CPU2_MUSER_TOP2 is
	 port ( clk,comclk             : in    std_logic;
					rst             : in    std_logic;
					valueInput      : in    std_logic_vector (31 downto 0);
					excOccur        : out   std_logic;
					isAEP           : out   std_logic;
					isCOM           : out   std_logic;
					isCOMState      : out   std_logic;
					isDigit         : out   std_logic;
					isFlash         : out   std_logic;
					isNone          : out   std_logic;
					isRAM           : out   std_logic;
					isROM           : out   std_logic;
					isSB            : out   std_logic;
					isVGA           : out   std_logic;
					memRead         : out   std_logic;
					memWrite        : out   std_logic;
					paddrInput      : out   std_logic_vector (31 downto 0);
					writeValueInput : out   std_logic_vector (31 downto 0);
					isPS2           : inout std_logic;
					isPS2State      : out   std_logic;
					comIntr			: in 	std_logic;


					Debug 			: out 	std_logic_vector (15 downto 0);

					dbMemWrite		: out   std_logic;
					dbMemInput		: out 	std_logic_vector(31 downto 0);

					dbOccur			: out   std_logic;
					U_TxD			: out 	std_logic;
					U_RxD			: in 	std_logic;
					-- version for PS2
					kbdIntr         : in    std_logic
					-- end
	);
end CPU2_MUSER_TOP2;

architecture BEHAVIORAL of CPU2_MUSER_TOP2 is
	 signal MY_XLXN_0							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_1							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_2							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_3							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_4 							  : std_logic;
	 signal MY_XLXN_5 							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_6 							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_7 							  : std_logic_vector(63 downto 0);
	 signal MY_XLXN_8 							  : std_logic;
	 signal MY_XLXN_9 							  : std_logic_vector(4 downto 0);
	 signal MY_XLXN_10 							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_11 							  : brk_arr;
	 signal MY_XLXN_12							  : std_logic;
	 signal MY_XLXN_13 							  : std_logic;
	 signal MY_XLXN_14							  : std_logic_vector(31 downto 0);
	 signal MY_XLXN_15 							  : std_logic;
	 signal MY_XLXN_16 							  : std_logic;
	 
	 signal XLXN_126                      : std_logic;
	 signal XLXN_127                      : std_logic_vector (31 downto 0);
	 signal XLXN_131                      : std_logic;
	 signal XLXN_133                      : std_logic;
	 signal XLXN_134                      : std_logic_vector (31 downto 0);
	 signal XLXN_135                      : std_logic_vector (31 downto 0);
	 signal XLXN_136                      : std_logic_vector (31 downto 0);
	 signal XLXN_143                      : std_logic;
	 signal XLXN_144                      : std_logic_vector (4 downto 0);
	 signal XLXN_145                      : std_logic_vector (4 downto 0);
	 signal XLXN_147                      : std_logic;
	 signal XLXN_148                      : std_logic;
	 signal XLXN_149                      : std_logic;
	 signal XLXN_151                      : std_logic_vector (31 downto 0);
	 signal XLXN_152                      : std_logic_vector (4 downto 0);
	 signal XLXN_154                      : std_logic_vector (31 downto 0);
	 signal XLXN_155                      : std_logic_vector (31 downto 0);
	 signal XLXN_156                      : std_logic;
	 signal XLXN_157                      : std_logic_vector (5 downto 0);
	 signal XLXN_158                      : std_logic_vector (5 downto 0);
	 signal XLXN_163                      : std_logic;
	 signal XLXN_164                      : std_logic_vector (1 downto 0);
	 signal XLXN_166                      : std_logic;
	 signal XLXN_167                      : std_logic_vector (31 downto 0);
	 signal XLXN_168                      : std_logic_vector (31 downto 0);
	 signal XLXN_169                      : std_logic_vector (31 downto 0);
	 signal XLXN_170                      : std_logic_vector (15 downto 0);
	 signal XLXN_171                      : std_logic_vector (9 downto 0);
	 signal XLXN_172                      : std_logic_vector (3 downto 0);
	 signal XLXN_173                      : std_logic_vector (31 downto 0);
	 signal XLXN_174                      : std_logic_vector (31 downto 0);
	 signal XLXN_176                      : std_logic;
	 signal XLXN_178                      : std_logic;
	 signal XLXN_179                      : std_logic;
	 signal XLXN_180                      : std_logic;
	 signal XLXN_181                      : std_logic;
	 signal XLXN_182                      : std_logic;
	 signal XLXN_183                      : std_logic;
	 signal XLXN_184                      : std_logic;
	 signal XLXN_185                      : std_logic;
	 signal XLXN_186                      : std_logic;
	 signal XLXN_189                      : std_logic;
	 signal XLXN_190                      : std_logic;
	 signal XLXN_191                      : std_logic_vector (1 downto 0);
	 signal XLXN_192                      : std_logic_vector (4 downto 0);
	 signal XLXN_193                      : std_logic_vector (3 downto 0);
	 signal XLXN_194                      : std_logic_vector (1 downto 0);
	 signal XLXN_195                      : std_logic_vector (1 downto 0);
	 signal XLXN_196                      : std_logic_vector (1 downto 0);
	 signal XLXN_197                      : std_logic_vector (31 downto 0);
	 signal XLXN_198                      : std_logic_vector (31 downto 0);
	 signal XLXN_199                      : std_logic;
	 signal XLXN_200                      : std_logic;
	 signal XLXN_201                      : std_logic;
	 signal XLXN_202                      : std_logic_vector (31 downto 0);
	 signal XLXN_203                      : std_logic_vector (31 downto 0);
	 signal XLXN_205                      : std_logic;
	 signal XLXN_206                      : std_logic;
	 signal XLXN_207                      : std_logic;
	 signal XLXN_208                      : std_logic_vector (15 downto 0);
	 signal XLXN_209                      : std_logic_vector (3 downto 0);
	 signal XLXN_212                      : std_logic;
	 signal XLXN_213                      : std_logic_vector (31 downto 0);
	 signal XLXN_214                      : std_logic_vector (31 downto 0);
	 signal XLXN_215                      : std_logic_vector (1 downto 0);
	 signal XLXN_216                      : std_logic_vector (31 downto 0);
	 signal XLXN_217                      : std_logic_vector (31 downto 0);
	 signal XLXN_218                      : std_logic_vector (1 downto 0);
	 signal XLXN_219                      : std_logic;
	 signal XLXN_220                      : std_logic;
	 signal XLXN_222                      : std_logic;
	 signal XLXN_223                      : std_logic_vector (4 downto 0);
	 signal XLXN_225                      : std_logic_vector (4 downto 0);
	 signal XLXN_227                      : std_logic_vector (4 downto 0);
	 signal XLXN_228                      : std_logic_vector (31 downto 0);
	 signal XLXN_229                      : std_logic_vector (31 downto 0);
	 signal XLXN_231                      : std_logic;
	 signal XLXN_233                      : std_logic;
	 signal XLXN_234                      : std_logic_vector (31 downto 0);
	 signal XLXN_235                      : std_logic_vector (31 downto 0);
	 signal XLXN_236                      : std_logic_vector (31 downto 0);
	 signal XLXN_237                      : std_logic_vector (31 downto 0);
	 signal XLXN_238                      : std_logic_vector (1 downto 0);
	 signal XLXN_240                      : std_logic;
	 signal XLXN_241                      : std_logic;
	 signal XLXN_242                      : std_logic;
	 signal XLXN_243                      : std_logic;
	 signal XLXN_244                      : std_logic;
	 signal XLXN_245                      : std_logic_vector (31 downto 0);
	 signal XLXN_246                      : std_logic_vector (31 downto 0);
	 signal XLXN_247                      : std_logic_vector (31 downto 0);
	 signal XLXN_248                      : std_logic_vector (1 downto 0);
	 signal XLXN_249                      : std_logic_vector (1 downto 0);
	 signal XLXN_250                      : std_logic;
	 signal XLXN_251                      : std_logic;
	 signal XLXN_252                      : std_logic;
	 signal XLXN_256                      : std_logic;
	 signal XLXN_257                      : std_logic;
	 signal XLXN_258                      : std_logic_vector (31 downto 0);
	 signal XLXN_259                      : std_logic_vector (31 downto 0);
	 signal XLXN_260                      : std_logic_vector (31 downto 0);
	 signal XLXN_261                      : std_logic_vector (31 downto 0);
	 signal XLXN_262                      : std_logic_vector (31 downto 0);
	 signal XLXN_263                      : std_logic_vector (31 downto 0);
	 signal XLXN_264                      : std_logic_vector (31 downto 0);
	 signal XLXN_284                      : std_logic;
	 signal XLXN_285                      : std_logic;
	 signal XLXN_286                      : std_logic_vector (31 downto 0);
	 signal XLXN_294                      : std_logic_vector (4 downto 0);
	 signal XLXN_295                      : std_logic;
	 signal XLXN_296                      : std_logic_vector (1 downto 0);
	 signal XLXN_297                      : std_logic_vector (31 downto 0);
	 signal XLXN_298                      : std_logic_vector (31 downto 0);
	 signal XLXN_299                      : std_logic_vector (1 downto 0);
	 signal XLXN_300                      : std_logic;
	 signal XLXN_303                      : std_logic;
	 signal XLXN_310                      : std_logic_vector (31 downto 0);
	 signal XLXN_322                      : std_logic_vector (31 downto 0);
	 signal XLXN_323                      : std_logic_vector (31 downto 0);
	 signal XLXN_324                      : std_logic_vector (31 downto 0);
	 signal XLXN_325                      : std_logic_vector (31 downto 0);
	 signal XLXN_326                      : std_logic_vector (31 downto 0);
	 signal memRead_DUMMY                 : std_logic;
	 signal memWrite_DUMMY                : std_logic;
	 signal excOccur_DUMMY                : std_logic;
	 signal isSB_DUMMY                    : std_logic;
	 signal XLXI_10_interrupt0_openSignal : std_logic;
	 signal XLXI_10_interrupt1_openSignal : std_logic;
	 signal XLXI_10_interrupt2_openSignal : std_logic;
	 signal XLXI_10_interrupt3_openSignal : std_logic;
	 signal XLXI_10_interrupt4_openSignal : std_logic;
	 signal XLXI_10_interrupt5_openSignal : std_logic;
	 signal XLXI_10_interrupt6_openSignal : std_logic;
	 component insFetcher
			port ( 		 clk           : in    std_logic;
						 rst           : in    std_logic;
						 jmpFlag       : in    std_logic;
						 riskPreserve  : in    std_logic;
						 mmuPreserve   : in    std_logic;
						 jmpPCAddr     : in    std_logic_vector (31 downto 0);
						 excCodeTrans  : in    std_logic_vector (31 downto 0);
						 inStrTrans    : in    std_logic_vector (31 downto 0);
						 excCode       : out   std_logic_vector (31 downto 0);
						 inStr         : out   std_logic_vector (31 downto 0);
						 pc4Output     : out   std_logic_vector (31 downto 0);
						 pcVaddrOutput : out   std_logic_vector (31 downto 0);
						 excOccur      : in    std_logic);
	 end component;

	 component IFID
			port (		 clk              : in    std_logic;
						 rst              : in    std_logic;
						 excOccur         : in    std_logic;
						 excDelayInput    : in    std_logic;
						 riskPreserve     : in    std_logic;
						 instrInput       : in    std_logic_vector (31 downto 0);
						 pc4Input         : in    std_logic_vector (31 downto 0);
						 excCodeInput     : in    std_logic_vector (31 downto 0);
						 mc0Output        : out   std_logic;
						 excDelayOutput   : out   std_logic;
						 intDisableOutput : out   std_logic;
						 opOutput         : out   std_logic_vector (5 downto 0);
						 rsOutput         : out   std_logic_vector (4 downto 0);
						 rtOutput         : out   std_logic_vector (4 downto 0);
						 rdOutput         : out   std_logic_vector (4 downto 0);
						 functOutput      : out   std_logic_vector (5 downto 0);
						 immOffsetOutput  : out   std_logic_vector (15 downto 0);
						 immAddrOutput    : out   std_logic_vector (9 downto 0);
						 brcType          : out   std_logic_vector (3 downto 0);
						 pc4Output        : out   std_logic_vector (31 downto 0);
						 excCodeOutput    : out   std_logic_vector (31 downto 0);
						 mmuPreserve      : in    std_logic);
	 end component;

	 component riskJudge
			port ( 		 memRead      : in    std_logic;
						 rsIndex      : in    std_logic_vector (4 downto 0);
						 rtIndex      : in    std_logic_vector (4 downto 0);
						 exRdIndex    : in    std_logic_vector (4 downto 0);
						 ctrlReset    : out   std_logic;
						 riskPreserve : out   std_logic);
	 end component;

	 component foreBranch
			port (		 jumpRegOrImm : in    std_logic;
						 excOccur     : in    std_logic;
						 excReturn    : in    std_logic;
						 pc4Input     : in    std_logic_vector (31 downto 0);
						 rsValue      : in    std_logic_vector (31 downto 0);
						 rtValue      : in    std_logic_vector (31 downto 0);
						 immOffset    : in    std_logic_vector (15 downto 0);
						 immAddr      : in    std_logic_vector (9 downto 0);
						 branchOrJump : in    std_logic_vector (1 downto 0);
						 brcType      : in    std_logic_vector (3 downto 0);
						 ebaseInput   : in    std_logic_vector (31 downto 0);
						 epcInput     : in    std_logic_vector (31 downto 0);
						 jmpFlag      : out   std_logic;
						 jmpPCAddr    : out   std_logic_vector (31 downto 0);
						 excTLB       : in    std_logic;
						 excNested    : in    std_logic);
	 end component;

	 component multi
			port ( 		 
						multiSel:in std_logic;
						rsAbsValue:in std_logic_vector(31 downto 0);
						rtAbsValue:in std_logic_vector(31 downto 0);
						hiOutput:out std_logic_vector(31 downto 0);
						loOutput:out std_logic_vector(31 downto 0));
	 end component;

	 component ALU
			port ( 		 immExtend : in    std_logic;
						 immOrRt   : in    std_logic;
						 slimmOrRs : in    std_logic;
						 rsInput   : in    std_logic_vector (31 downto 0);
						 rtInput   : in    std_logic_vector (31 downto 0);
						 immInput  : in    std_logic_vector (15 downto 0);
						 aluOP     : in    std_logic_vector (3 downto 0);
						 aluOutput : out   std_logic_vector (31 downto 0));
	 end component;

	 component CP0
			port ( 		 rst            : in    std_logic;
						 clk            : in    std_logic;
						 interrupt0     : in    std_logic;
						 interrupt1     : in    std_logic;
						 interrupt2     : in    std_logic;
						 interrupt3     : in    std_logic;
						 interrupt4     : in    std_logic;
						 interrupt5     : in    std_logic;
						 interrupt6     : in    std_logic;
						 interrupt7     : in    std_logic;
						 memCP0Write    : in    std_logic;
						 cp0Write       : in    std_logic;
						 excp0Write     : in    std_logic;
						 excOccur       : in    std_logic;
						 excDelayInput  : in    std_logic;
						 excNested      : in    std_logic;
						 rdIndexInput   : in    std_logic_vector (4 downto 0);
						 memValueInput  : in    std_logic_vector (31 downto 0);
						 memIndexInput  : in    std_logic_vector (4 downto 0);
						 wbValueInput   : in    std_logic_vector (31 downto 0);
						 wbIndexInput   : in    std_logic_vector (4 downto 0);
						 exValueInput   : in    std_logic_vector (31 downto 0);
						 excCode        : in    std_logic_vector (31 downto 0);
						 excEPCInput    : in    std_logic_vector (31 downto 0);
						 timeIntr       : out   std_logic;
						 rdValueOutput  : out   std_logic_vector (31 downto 0);
						 ebaseOutput    : out   std_logic_vector (31 downto 0);
						 epcOutput      : out   std_logic_vector (31 downto 0);
						 causeOutput    : out   std_logic_vector (31 downto 0);
						 statusOutput   : out   std_logic_vector (31 downto 0);
						 entryHiOutput  : out   std_logic_vector (31 downto 0);
						 entryLo0Output : out   std_logic_vector (31 downto 0);
						 entryLo1Output : out   std_logic_vector (31 downto 0);
						 pageMaskOutput : out   std_logic_vector (31 downto 0);
						 indexOutput    : out   std_logic_vector (31 downto 0);
						 randomOutput   : out   std_logic_vector (31 downto 0);

						 dbIndex		: in 	std_logic_vector (4 downto 0);
						 dbOutput 		: out 	std_logic_vector (31 downto 0);
						 
						 excBadVaddrInput:out	std_logic_vector (31 downto 0)

			);
	 end component;

	 component exSelecter
			port ( 		 cp0Input  : in    std_logic_vector (31 downto 0);
						 hiloInput : in    std_logic_vector (31 downto 0);
						 aluInput  : in    std_logic_vector (31 downto 0);
						 pc4Input  : in    std_logic_vector (31 downto 0);
						 exSelect  : in    std_logic_vector (1 downto 0);
						 exResult  : out   std_logic_vector (31 downto 0)
			);
	 end component;

	 component HiLo
			port ( 		 rst             : in    std_logic;
						 clk             : in    std_logic;
						 hiloRead        : in    std_logic;
						 hiInput         : in    std_logic_vector (31 downto 0);
						 loInput         : in    std_logic_vector (31 downto 0);
						 hiloWrite       : in    std_logic_vector (1 downto 0);
						 hiMEMInput      : in    std_logic_vector (31 downto 0);
						 loMEMInput      : in    std_logic_vector (31 downto 0);
						 hiloMEMWrite    : in    std_logic_vector (1 downto 0);

						 dbOutput 		: out 	std_logic_vector (63 downto 0);

						 hiloValueOutput : out   std_logic_vector (31 downto 0)
			);
	 end component;

	 component EXMEM
			port ( 		 clk              : in    std_logic;
						 rst              : in    std_logic;
						 excOccur         : in    std_logic;
						 excDelayInput    : in    std_logic;
						 memReadInput     : in    std_logic;
						 memWriteInput    : in    std_logic;
						 loadExModeInput  : in    std_logic;
						 regWriteInput    : in    std_logic;
						 cp0WriteInput    : in    std_logic;
						 intDisableInput  : in    std_logic;
						 exResultInput    : in    std_logic_vector (31 downto 0);
						 rtValueInput     : in    std_logic_vector (31 downto 0);
						 wbIndexInput     : in    std_logic_vector (4 downto 0);
						 hiCalcInput      : in    std_logic_vector (31 downto 0);
						 loCalcInput      : in    std_logic_vector (31 downto 0);
						 pc4Input         : in    std_logic_vector (31 downto 0);
						 idexExcCodeInput : in    std_logic_vector (31 downto 0);
						 ldstLenInput     : in    std_logic_vector (1 downto 0);
						 hiloWriteInput   : in    std_logic_vector (1 downto 0);
						 excDelayOutput   : out   std_logic;
						 memReadOutput    : out   std_logic;
						 memWriteOutput   : out   std_logic;
						 loadExModeOutput : out   std_logic;
						 regWriteOutput   : out   std_logic;
						 cp0WriteOutput   : out   std_logic;
						 intDisableOutput : out   std_logic;
						 exResultOutput   : out   std_logic_vector (31 downto 0);
						 rtValueOutput    : out   std_logic_vector (31 downto 0);
						 wbIndexOutput    : out   std_logic_vector (4 downto 0);
						 hiWBOutput       : out   std_logic_vector (31 downto 0);
						 loWBOutput       : out   std_logic_vector (31 downto 0);
						 pc4Output        : out   std_logic_vector (31 downto 0);
						 excCodeOutput    : out   std_logic_vector (31 downto 0);
						 ldstLenOutput    : out   std_logic_vector (1 downto 0);
						 hiloWriteOutput  : out   std_logic_vector (1 downto 0);
						 mmuPreserve      : in    std_logic;
						 mmuReset         : in    std_logic;
						 isSBInput        : in    std_logic;
						 isSBOutput       : out   std_logic);
	 end component;

	 component TLB
			port ( 		 clk           : in    std_logic;
						 rst           : in    std_logic;
						 memRead       : in    std_logic;
						 memWrite      : in    std_logic;
						 isTLBWI       : in    std_logic;
						 isTLBWR       : in    std_logic;
						 
						 dbOccur:in std_logic;
						 dbVaddrInput:in std_logic_vector(31 downto 0);

						 ifVaddrInput  : in    std_logic_vector (31 downto 0);
						 memVaddrInput : in    std_logic_vector (31 downto 0);
						 entryhiInput  : in    std_logic_vector (31 downto 0);
						 entrylo0Input : in    std_logic_vector (31 downto 0);
						 entrylo1Input : in    std_logic_vector (31 downto 0);
						 pagemaskInput : in    std_logic_vector (31 downto 0);
						 indexInput    : in    std_logic_vector (31 downto 0);
						 randomInput   : in    std_logic_vector (31 downto 0);
						 isRAM         : out   std_logic;
						 isROM         : out   std_logic;
						 isFlash       : out   std_logic;
						 isCOM         : out   std_logic;
						 paddrOutput   : out   std_logic_vector (31 downto 0);
						 cntBubble     : out   std_logic_vector (4 downto 0);
						 ifExcCode     : out   std_logic_vector (31 downto 0);
						 memExcCode    : out   std_logic_vector (31 downto 0);
						 isSB          : in    std_logic;
						 stldLen       : in    std_logic_vector (1 downto 0);
						 isVGA         : out   std_logic;
						 isPs2         : out   std_logic;
						 isAEP         : out   std_logic;
						 isCOMState    : out   std_logic;
						 isDigit       : out   std_logic;
						 isNone        : out   std_logic;
						 vaddrOutput   : out   std_logic_vector(31 downto 0);
						 --version for PS2
						 isPS2State    : out   std_logic
			);
	 end component;

	 component exceptionMod
			port ( 		 excDelayInput     : in    std_logic;
						 intDisable        : in    std_logic;
						 exmemExcCodeInput : in    std_logic_vector (31 downto 0);
						 mmuExcCodeInput   : in    std_logic_vector (31 downto 0);
						 statusInput       : in    std_logic_vector (31 downto 0);
						 causeInput        : in    std_logic_vector (31 downto 0);
						 pc4Input          : in    std_logic_vector (31 downto 0);
						 excDelayOutput    : out   std_logic;
						 excOccur          : out   std_logic;
						 excReturn         : out   std_logic;
						 excCode           : out   std_logic_vector (31 downto 0);
						 pc4Output         : out   std_logic_vector (31 downto 0);
						 excTLB            : out   std_logic;
						 excNested         : out   std_logic;
						 vaddrInput		 : in 	std_logic_vector(31 downto 0);

						 clk,rst:in std_logic;
					 	 dbCont,dbStep:in std_logic;
						 hard_break:in brk_arr;
						 dbOccur:out std_logic;

						 badvaddrOutput		 : out 	std_logic_vector(31 downto 0)
			);
	 end component;

	 component MEMWB
			port ( 		 rst 			  : in 	  std_logic;
						 clk              : in    std_logic;
						 memReadInput     : in    std_logic;
						 loadExModeInput  : in    std_logic;
						 regWriteInput    : in    std_logic;
						 cp0WriteInput    : in    std_logic;
						 excOccur         : in    std_logic;
						 mmuReset         : in    std_logic;
						 aluResultInput   : in    std_logic_vector (31 downto 0);
						 mmuResultInput   : in    std_logic_vector (31 downto 0);
						 wbIndexInput     : in    std_logic_vector (4 downto 0);
						 hiWBInput        : in    std_logic_vector (31 downto 0);
						 loWBInput        : in    std_logic_vector (31 downto 0);
						 ldstLenInput     : in    std_logic_vector (1 downto 0);
						 hiloWriteInput   : in    std_logic_vector (1 downto 0);
						 memReadOutput    : out   std_logic;
						 loadExModeOutput : out   std_logic;
						 regWriteOutput   : out   std_logic;
						 cp0WriteOutput   : out   std_logic;
						 aluResultOutput  : out   std_logic_vector (31 downto 0);
						 mmuResultOutput  : out   std_logic_vector (31 downto 0);
						 wbIndexOutput    : out   std_logic_vector (4 downto 0);
						 hiWBOutput       : out   std_logic_vector (31 downto 0);
						 loWBOutput       : out   std_logic_vector (31 downto 0);
						 ldstLenOutput    : out   std_logic_vector (1 downto 0);
						 hiloWriteOutput  : out   std_logic_vector (1 downto 0));
	 end component;

	 component wbController
			port ( 		 wbSrc       : in    std_logic;
						 extendModel : in    std_logic;
						 aluRdValue  : in    std_logic_vector (31 downto 0);
						 mmuRdValue  : in    std_logic_vector (31 downto 0);
						 loadLen     : in    std_logic_vector (1 downto 0);
						 insResult   : out   std_logic_vector (31 downto 0));
	 end component;

	 component consRisk
			port ( 		 clk           : in    std_logic;
						 rst           : in    std_logic;
						 cntBubble     : in    std_logic_vector (4 downto 0);
						 stateGeqZero  : out   std_logic;
						 stateGeqOne   : out   std_logic;
						 stateEqualOne : out   std_logic);
	 end component;

	 component controller
			port ( 		 mc0          : in    std_logic;
						 op           : in    std_logic_vector (5 downto 0);
						 funct        : in    std_logic_vector (5 downto 0);
						 inDelaySlot  : out   std_logic;
						 jumpRegOrImm : out   std_logic;
						 immExtend    : out   std_logic;
						 immOrRt      : out   std_logic;
						 slimmOrRs    : out   std_logic;
						 hiloRead     : out   std_logic;
						 memRead      : out   std_logic;
						 memWrite     : out   std_logic;
						 loadExMode   : out   std_logic;
						 regWrite     : out   std_logic;
						 cp0Write     : out   std_logic;
						 branchOrJump : out   std_logic_vector (1 downto 0);
						 writeBackReg : out   std_logic_vector (1 downto 0);
						 aluOp        : out   std_logic_vector (3 downto 0);
						 exSelect     : out   std_logic_vector (1 downto 0);
						 stldLen      : out   std_logic_vector (1 downto 0);
						 hiloWrite    : out   std_logic_vector (1 downto 0);
						 isTLBWI      : out   std_logic;
						 isTLBWR      : out   std_logic;
						 isSB         : out   std_logic;
						 excCode      : out   std_logic_vector (31 downto 0));
	 end component;

	 component IDEX
			port ( 		 rst              : in    std_logic;
						 clk 			  : in 	  std_logic;
						 riskReset        : in    std_logic;
						 immExtendInput   : in    std_logic;
						 immOrRtInput     : in    std_logic;
						 slimmOrRsInput   : in    std_logic;
						 hiloReadInput    : in    std_logic;
						 memReadInput     : in    std_logic;
						 memWriteInput    : in    std_logic;
						 loadExModeInput  : in    std_logic;
						 regWriteInput    : in    std_logic;
						 cp0WriteInput    : in    std_logic;
						 excOccur         : in    std_logic;
						 excDelayInput    : in    std_logic;
						 intDisableInput  : in    std_logic;
						 rsValueInput     : in    std_logic_vector (31 downto 0);
						 rtValueInput     : in    std_logic_vector (31 downto 0);
						 immInput         : in    std_logic_vector (15 downto 0);
						 pc4Input         : in    std_logic_vector (31 downto 0);
						 wbRtOrRdOrRa     : in    std_logic_vector (1 downto 0);
						 rtIndexInput     : in    std_logic_vector (4 downto 0);
						 rdIndexInput     : in    std_logic_vector (4 downto 0);
						 aluOpInput       : in    std_logic_vector (3 downto 0);
						 exSelectInput    : in    std_logic_vector (1 downto 0);
						 ldstLenInput     : in    std_logic_vector (1 downto 0);
						 hiloWriteInput   : in    std_logic_vector (1 downto 0);
						 ifidExcCodeInput : in    std_logic_vector (31 downto 0);
						 ctrlExcCodeInput : in    std_logic_vector (31 downto 0);
						 immExtendOutput  : out   std_logic;
						 immOrRtOutput    : out   std_logic;
						 slimmOrRsOutput  : out   std_logic;
						 hiloReadOutput   : out   std_logic;
						 memReadOutput    : out   std_logic;
						 memWriteOutput   : out   std_logic;
						 loadExModeOutput : out   std_logic;
						 regWriteOutput   : out   std_logic;
						 cp0WriteOutput   : out   std_logic;
						 excDelayOutput   : out   std_logic;
						 intDisableOutput : out   std_logic;
						 multiSelOutput   : out   std_logic; 	-- new 7.0
						 rsValueOutput    : out   std_logic_vector (31 downto 0);
						 rsAbsValueOutput : out   std_logic_vector (31 downto 0);	-- new 7.0
						 rtValueOutput    : out   std_logic_vector (31 downto 0);
						 rtAbsValueOutput : out   std_logic_vector (31 downto 0);	-- new 7.0
						 immOutput        : out   std_logic_vector (15 downto 0);
						 pc4Output        : out   std_logic_vector (31 downto 0);
						 rdIndexOutput    : out   std_logic_vector (4 downto 0);
						 wbIndexoutput    : out   std_logic_vector (4 downto 0);
						 aluOpOutput      : out   std_logic_vector (3 downto 0);
						 exSelectOutput   : out   std_logic_vector (1 downto 0);
						 ldstLenOutput    : out   std_logic_vector (1 downto 0);
						 hiloWriteOutput  : out   std_logic_vector (1 downto 0);
						 excCodeOutput    : out   std_logic_vector (31 downto 0);
						 isSBInput        : in    std_logic;
						 mmuPreserve      : in    std_logic;
						 isSBOutput       : out   std_logic);
	 end component;

	 component registers
			port ( 		 rst          : in    std_logic;
						 clk          : in    std_logic;
						 regWrite     : in    std_logic;
						 exRegWrite   : in    std_logic;
						 memRegWrite  : in    std_logic;
						 rsIndex      : in    std_logic_vector (4 downto 0);
						 rtIndex      : in    std_logic_vector (4 downto 0);
						 rdIndex      : in    std_logic_vector (4 downto 0);
						 rdInput      : in    std_logic_vector (31 downto 0);
						 exRdWBIndex  : in    std_logic_vector (4 downto 0);
						 memRdWBIndex : in    std_logic_vector (4 downto 0);
						 exRdWBValue  : in    std_logic_vector (31 downto 0);
						 memRdWBValue : in    std_logic_vector (31 downto 0);


						dbIndex: in std_logic_vector(4 downto 0);
						dbInput: in std_logic_vector(31 downto 0);
						dbRegWrite: in std_logic;
						dbOutput: out std_logic_vector(31 downto 0);

						 rsOutput     : out   std_logic_vector (31 downto 0);
						 rtOutput     : out   std_logic_vector (31 downto 0)

			);
	 end component;

	 component debugger port(
	 	clk,comclk,rst:in std_logic;

	 	Debug:out std_logic_vector(15 downto 0);

		mem_input:in std_logic_vector(31 downto 0);
		reg_input:in std_logic_vector(31 downto 0);
		cp0_input:in std_logic_vector(31 downto 0);
		hilo_input:in std_logic_vector(63 downto 0);
		pc4_input:in std_logic_vector(31 downto 0);
		
		dbOccur:in std_logic;

		v_output:out std_logic_vector(31 downto 0);
		mem_write:out std_logic;
		reg_write:out std_logic;

		reg_idx:out std_logic_vector(4 downto 0);
		mem_addr:out std_logic_vector(31 downto 0);
		hard_break:out brk_arr;
		dbStep,dbCont:out std_logic;

		U_TxD:out std_logic;
		U_RxD:in std_logic
	 );
	 end component;

begin
	 dbMemInput <= MY_XLXN_14;
	 dbMemWrite <= MY_XLXN_16;
	 dbOccur <= MY_XLXN_8;
	 excOccur <= excOccur_DUMMY;
	 isSB <= isSB_DUMMY;
	 memRead <= memRead_DUMMY;
	 memWrite <= memWrite_DUMMY;

	 XLXI_1 : insFetcher
			port map (clk=>clk,
								excCodeTrans(31 downto 0)=>XLXN_310(31 downto 0),
								excOccur=>excOccur_DUMMY,
								inStrTrans(31 downto 0)=>valueInput(31 downto 0),
								jmpFlag=>XLXN_126,
								jmpPCAddr(31 downto 0)=>XLXN_127(31 downto 0),
								mmuPreserve=>XLXN_201,
								riskPreserve=>XLXN_131,
								rst=>rst,
								excCode(31 downto 0)=>XLXN_136(31 downto 0),
								inStr(31 downto 0)=>XLXN_134(31 downto 0),
								pcVaddrOutput(31 downto 0)=>XLXN_258(31 downto 0),
								pc4Output(31 downto 0)=>XLXN_135(31 downto 0));

	 XLXI_2 : IFID
			port map (clk=>clk,
								excCodeInput(31 downto 0)=>XLXN_136(31 downto 0),
								excDelayInput=>XLXN_133,
								excOccur=>excOccur_DUMMY,
								instrInput(31 downto 0)=>XLXN_134(31 downto 0),
								mmuPreserve=>XLXN_201,
								pc4Input(31 downto 0)=>XLXN_135(31 downto 0),
								riskPreserve=>XLXN_131,
								rst=>rst,
								brcType(3 downto 0)=>XLXN_172(3 downto 0),
								excCodeOutput(31 downto 0)=>XLXN_198(31 downto 0),
								excDelayOutput=>XLXN_189,
								functOutput(5 downto 0)=>XLXN_158(5 downto 0),
								immAddrOutput(9 downto 0)=>XLXN_171(9 downto 0),
								immOffsetOutput(15 downto 0)=>XLXN_170(15 downto 0),
								intDisableOutput=>XLXN_190,
								mc0Output=>XLXN_156,
								opOutput(5 downto 0)=>XLXN_157(5 downto 0),
								pc4Output(31 downto 0)=>XLXN_167(31 downto 0),
								rdOutput(4 downto 0)=>XLXN_192(4 downto 0),
								rsOutput(4 downto 0)=>XLXN_144(4 downto 0),
								rtOutput(4 downto 0)=>XLXN_145(4 downto 0));

	 XLXI_3 : riskJudge
			port map (exRdIndex(4 downto 0)=>XLXN_152(4 downto 0),
								memRead=>XLXN_143,
								rsIndex(4 downto 0)=>XLXN_144(4 downto 0),
								rtIndex(4 downto 0)=>XLXN_145(4 downto 0),
								ctrlReset=>XLXN_199,
								riskPreserve=>XLXN_131);

	 XLXI_6 : foreBranch
			port map (branchOrJump(1 downto 0)=>XLXN_164(1 downto 0),
								brcType(3 downto 0)=>XLXN_172(3 downto 0),
								ebaseInput(31 downto 0)=>XLXN_173(31 downto 0),
								epcInput(31 downto 0)=>XLXN_174(31 downto 0),
								excNested=>XLXN_233,
								excOccur=>excOccur_DUMMY,
								excReturn=>XLXN_166,
								excTLB=>XLXN_176,
								immAddr(9 downto 0)=>XLXN_171(9 downto 0),
								immOffset(15 downto 0)=>XLXN_170(15 downto 0),
								jumpRegOrImm=>XLXN_163,
								pc4Input(31 downto 0)=>XLXN_167(31 downto 0),
								rsValue(31 downto 0)=>XLXN_168(31 downto 0),
								rtValue(31 downto 0)=>XLXN_169(31 downto 0),
								jmpFlag=>XLXN_126,
								jmpPCAddr(31 downto 0)=>XLXN_127(31 downto 0));

	 XLXI_8 : multi
			port map (			multiSel=>MY_XLXN_4,
								rsAbsValue=>MY_XLXN_2,	
								rtAbsValue=>MY_XLXN_3,
								hiOutput(31 downto 0)=>XLXN_245(31 downto 0),
								loOutput(31 downto 0)=>XLXN_246(31 downto 0));

	 XLXI_9 : ALU
			port map (aluOP(3 downto 0)=>XLXN_209(3 downto 0),
								immExtend=>XLXN_205,
								immInput(15 downto 0)=>XLXN_208(15 downto 0),
								immOrRt=>XLXN_206,
								rsInput(31 downto 0)=>XLXN_202(31 downto 0),
								rtInput(31 downto 0)=>XLXN_203(31 downto 0),
								slimmOrRs=>XLXN_207,
								aluOutput(31 downto 0)=>XLXN_236(31 downto 0));

	 XLXI_10 : CP0
			port map (clk=>clk,
								cp0Write=>XLXN_220,
								excCode(31 downto 0)=>XLXN_228(31 downto 0),
								excDelayInput=>XLXN_222,
								excEPCInput(31 downto 0)=>XLXN_229(31 downto 0),
								excNested=>XLXN_233,
								excOccur=>excOccur_DUMMY,
								excp0Write=>XLXN_243,
								exValueInput(31 downto 0)=>XLXN_203(31 downto 0),
								interrupt0=>XLXI_10_interrupt0_openSignal,
								interrupt1=>XLXI_10_interrupt1_openSignal,
								interrupt2=>XLXI_10_interrupt2_openSignal,
								interrupt3=>XLXI_10_interrupt3_openSignal,
								interrupt5=>XLXI_10_interrupt5_openSignal,
								interrupt7=>XLXN_231,
								memCP0Write=>XLXN_219,
								memIndexInput(4 downto 0)=>XLXN_225(4 downto 0),
								memValueInput(31 downto 0)=>XLXN_155(31 downto 0),
								rdIndexInput(4 downto 0)=>XLXN_223(4 downto 0),
								rst=>rst,

								dbIndex=>MY_XLXN_9,dbOutput=>MY_XLXN_6,

								wbIndexInput(4 downto 0)=>XLXN_227(4 downto 0),
								wbValueInput(31 downto 0)=>XLXN_297(31 downto 0),	-- new 7.0
								causeOutput(31 downto 0)=>XLXN_324(31 downto 0),
								ebaseOutput(31 downto 0)=>XLXN_173(31 downto 0),
								entryHiOutput(31 downto 0)=>XLXN_259(31 downto 0),
								entryLo0Output(31 downto 0)=>XLXN_260(31 downto 0),
								entryLo1Output(31 downto 0)=>XLXN_261(31 downto 0),
								epcOutput(31 downto 0)=>XLXN_174(31 downto 0),
								indexOutput(31 downto 0)=>XLXN_263(31 downto 0),
								pageMaskOutput(31 downto 0)=>XLXN_262(31 downto 0),
								randomOutput(31 downto 0)=>XLXN_264(31 downto 0),
								rdValueOutput(31 downto 0)=>XLXN_234(31 downto 0),
								statusOutput(31 downto 0)=>XLXN_325(31 downto 0),
								timeIntr=>XLXN_231,
								excBadVaddrInput=>MY_XLXN_1,

								interrupt4=>comIntr,
								-- version for PS2
								interrupt6=>kbdIntr

			);

	 XLXI_11 : exSelecter
			port map (aluInput(31 downto 0)=>XLXN_236(31 downto 0),
								cp0Input(31 downto 0)=>XLXN_234(31 downto 0),
								exSelect(1 downto 0)=>XLXN_238(1 downto 0),
								hiloInput(31 downto 0)=>XLXN_235(31 downto 0),
								pc4Input(31 downto 0)=>XLXN_237(31 downto 0),
								exResult(31 downto 0)=>XLXN_154(31 downto 0));

	 XLXI_12 : HiLo
			port map (clk=>clk,
								hiInput(31 downto 0)=>XLXN_213(31 downto 0),
								hiloMEMWrite(1 downto 0)=>XLXN_218(1 downto 0),
								hiloRead=>XLXN_212,
								hiloWrite(1 downto 0)=>XLXN_215(1 downto 0),
								hiMEMInput(31 downto 0)=>XLXN_216(31 downto 0),
								loInput(31 downto 0)=>XLXN_214(31 downto 0),
								loMEMInput(31 downto 0)=>XLXN_217(31 downto 0),
								rst=>rst,
								dbOutput=>MY_XLXN_7,
								hiloValueOutput(31 downto 0)=>XLXN_235(31 downto 0));

	 XLXI_13 : EXMEM
			port map (clk=>clk,
								cp0WriteInput=>XLXN_243,
								excDelayInput=>XLXN_240,
								excOccur=>excOccur_DUMMY,
								exResultInput(31 downto 0)=>XLXN_154(31 downto 0),
								hiCalcInput(31 downto 0)=>XLXN_245(31 downto 0),
								hiloWriteInput(1 downto 0)=>XLXN_249(1 downto 0),
								idexExcCodeInput(31 downto 0)=>XLXN_247(31 downto 0),
								intDisableInput=>XLXN_244,
								isSBInput=>XLXN_252,
								ldstLenInput(1 downto 0)=>XLXN_248(1 downto 0),
								loadExModeInput=>XLXN_242,
								loCalcInput(31 downto 0)=>XLXN_246(31 downto 0),
								memReadInput=>XLXN_143,
								memWriteInput=>XLXN_241,
								mmuPreserve=>XLXN_250,
								mmuReset=>XLXN_251,
								pc4Input(31 downto 0)=>XLXN_237(31 downto 0),
								regWriteInput=>XLXN_148,
								rst=>rst,
								rtValueInput(31 downto 0)=>XLXN_203(31 downto 0),
								wbIndexInput(4 downto 0)=>XLXN_152(4 downto 0),
								cp0WriteOutput=>XLXN_219,
								excCodeOutput(31 downto 0)=>XLXN_286(31 downto 0),
								excDelayOutput=>XLXN_284,
								exResultOutput(31 downto 0)=>XLXN_155(31 downto 0),
								hiloWriteOutput(1 downto 0)=>XLXN_218(1 downto 0),
								hiWBOutput(31 downto 0)=>XLXN_216(31 downto 0),
								intDisableOutput=>XLXN_285,
								isSBOutput=>isSB_DUMMY,
								ldstLenOutput(1 downto 0)=>XLXN_296(1 downto 0),
								loadExModeOutput=>XLXN_295,
								loWBOutput(31 downto 0)=>XLXN_217(31 downto 0),
								memReadOutput=>memRead_DUMMY,
								memWriteOutput=>memWrite_DUMMY,
								pc4Output(31 downto 0)=>XLXN_323(31 downto 0),
								regWriteOutput=>XLXN_149,
								rtValueOutput(31 downto 0)=>writeValueInput(31 downto 0),
								wbIndexOutput(4 downto 0)=>XLXN_225(4 downto 0));

	 XLXI_14 : TLB
			port map (clk=>clk,
								entryhiInput(31 downto 0)=>XLXN_259(31 downto 0),
								entrylo0Input(31 downto 0)=>XLXN_260(31 downto 0),
								entrylo1Input(31 downto 0)=>XLXN_261(31 downto 0),


								dbOccur=>MY_XLXN_8,dbVaddrInput=>MY_XLXN_10,

								ifVaddrInput(31 downto 0)=>XLXN_258(31 downto 0),
								indexInput(31 downto 0)=>XLXN_263(31 downto 0),
								isSB=>isSB_DUMMY,
								isTLBWI=>XLXN_256,
								isTLBWR=>XLXN_257,
								memRead=>memRead_DUMMY,
								memVaddrInput(31 downto 0)=>XLXN_155(31 downto 0),
								memWrite=>memWrite_DUMMY,
								pagemaskInput(31 downto 0)=>XLXN_262(31 downto 0),
								randomInput(31 downto 0)=>XLXN_264(31 downto 0),
								rst=>rst,
								stldLen(1 downto 0)=>XLXN_296(1 downto 0),
								cntBubble(4 downto 0)=>XLXN_294(4 downto 0),
								ifExcCode(31 downto 0)=>XLXN_310(31 downto 0),
								isAEP=>isAEP,
								isCOM=>isCOM,
								isCOMState=>isCOMState,
								isDigit=>isDigit,
								isFlash=>isFlash,
								isNone=>isNone,
								isPs2=>isPS2,
								isRAM=>isRAM,
								isROM=>isROM,
								isVGA=>isVGA,
								memExcCode(31 downto 0)=>XLXN_326(31 downto 0),
								paddrOutput(31 downto 0)=>paddrInput(31 downto 0),
								vaddrOutput=>MY_XLXN_0,
								isPS2State=>isPS2State
			);

	 XLXI_16 : exceptionMod
			port map (
								clk=>clk,rst=>rst,
								causeInput(31 downto 0)=>XLXN_324(31 downto 0),
								excDelayInput=>XLXN_284,
								exmemExcCodeInput(31 downto 0)=>XLXN_286(31 downto 0),
								intDisable=>XLXN_285,
								mmuExcCodeInput(31 downto 0)=>XLXN_326(31 downto 0),
								pc4Input(31 downto 0)=>XLXN_323(31 downto 0),
								statusInput(31 downto 0)=>XLXN_325(31 downto 0),
								excCode(31 downto 0)=>XLXN_228(31 downto 0),
								excDelayOutput=>XLXN_222,
								excNested=>XLXN_233,

								dbCont=>MY_XLXN_13,dbStep=>MY_XLXN_12,
								hard_break=>MY_XLXN_11,
								dbOccur=>MY_XLXN_8,

								excOccur=>excOccur_DUMMY,
								excReturn=>XLXN_166,
								excTLB=>XLXN_176,
								pc4Output(31 downto 0)=>XLXN_229(31 downto 0),
								vaddrInput=>MY_XLXN_0,
								badvaddrOutput=>MY_XLXN_1
			);

	 XLXI_18 : MEMWB
			port map (aluResultInput(31 downto 0)=>XLXN_155(31 downto 0),
								clk=>clk,
								cp0WriteInput=>XLXN_219,
								excOccur=>excOccur_DUMMY,
								hiloWriteInput(1 downto 0)=>XLXN_218(1 downto 0),
								hiWBInput(31 downto 0)=>XLXN_216(31 downto 0),
								ldstLenInput(1 downto 0)=>XLXN_296(1 downto 0),
								loadExModeInput=>XLXN_295,
								loWBInput(31 downto 0)=>XLXN_217(31 downto 0),
								memReadInput=>memRead_DUMMY,
								mmuReset=>XLXN_250,
								mmuResultInput(31 downto 0)=>valueInput(31 downto 0),
								regWriteInput=>XLXN_149,
								rst=>rst,
								wbIndexInput(4 downto 0)=>XLXN_225(4 downto 0),
								aluResultOutput(31 downto 0)=>XLXN_297(31 downto 0),
								cp0WriteOutput=>XLXN_220,
								hiloWriteOutput(1 downto 0)=>XLXN_215(1 downto 0),
								hiWBOutput(31 downto 0)=>XLXN_213(31 downto 0),
								ldstLenOutput(1 downto 0)=>XLXN_299(1 downto 0),
								loadExModeOutput=>XLXN_300,
								loWBOutput(31 downto 0)=>XLXN_214(31 downto 0),
								memReadOutput=>XLXN_303,
								mmuResultOutput(31 downto 0)=>XLXN_298(31 downto 0),
								regWriteOutput=>XLXN_147,
								wbIndexOutput(4 downto 0)=>XLXN_227(4 downto 0));

	 XLXI_19 : wbController
			port map (aluRdValue(31 downto 0)=>XLXN_297(31 downto 0),
								extendModel=>XLXN_300,
								loadLen(1 downto 0)=>XLXN_299(1 downto 0),
								mmuRdValue(31 downto 0)=>XLXN_298(31 downto 0),
								wbSrc=>XLXN_303,
								insResult(31 downto 0)=>XLXN_151(31 downto 0));

	 XLXI_20 : consRisk
			port map (clk=>clk,
								cntBubble(4 downto 0)=>XLXN_294(4 downto 0),
								rst=>rst,
								stateEqualOne=>XLXN_251,
								stateGeqOne=>XLXN_250,
								stateGeqZero=>XLXN_201);

	 XLXI_21 : controller
			port map (funct(5 downto 0)=>XLXN_158(5 downto 0),
								mc0=>XLXN_156,
								op(5 downto 0)=>XLXN_157(5 downto 0),
								aluOp(3 downto 0)=>XLXN_193(3 downto 0),
								branchOrJump(1 downto 0)=>XLXN_164(1 downto 0),
								cp0Write=>XLXN_186,
								excCode(31 downto 0)=>XLXN_197(31 downto 0),
								exSelect(1 downto 0)=>XLXN_194(1 downto 0),
								hiloRead=>XLXN_181,
								hiloWrite(1 downto 0)=>XLXN_196(1 downto 0),
								immExtend=>XLXN_178,
								immOrRt=>XLXN_179,
								inDelaySlot=>XLXN_133,
								isSB=>XLXN_200,
								isTLBWI=>XLXN_256,
								isTLBWR=>XLXN_257,
								jumpRegOrImm=>XLXN_163,
								loadExMode=>XLXN_184,
								memRead=>XLXN_182,
								memWrite=>XLXN_183,
								regWrite=>XLXN_185,
								slimmOrRs=>XLXN_180,
								stldLen(1 downto 0)=>XLXN_195(1 downto 0),
								writeBackReg(1 downto 0)=>XLXN_191(1 downto 0));

	 XLXI_22 : IDEX
			port map (aluOpInput(3 downto 0)=>XLXN_193(3 downto 0),
								clk=>clk,
								cp0WriteInput=>XLXN_186,
								ctrlExcCodeInput(31 downto 0)=>XLXN_197(31 downto 0),
								excDelayInput=>XLXN_189,
								excOccur=>excOccur_DUMMY,
								exSelectInput(1 downto 0)=>XLXN_194(1 downto 0),
								hiloReadInput=>XLXN_181,
								hiloWriteInput(1 downto 0)=>XLXN_196(1 downto 0),
								ifidExcCodeInput(31 downto 0)=>XLXN_198(31 downto 0),
								immExtendInput=>XLXN_178,
								immInput(15 downto 0)=>XLXN_170(15 downto 0),
								immOrRtInput=>XLXN_179,
								intDisableInput=>XLXN_190,
								isSBInput=>XLXN_200,
								ldstLenInput(1 downto 0)=>XLXN_195(1 downto 0),
								loadExModeInput=>XLXN_184,
								memReadInput=>XLXN_182,
								memWriteInput=>XLXN_183,
								mmuPreserve=>XLXN_201,
								pc4Input(31 downto 0)=>XLXN_167(31 downto 0),
								rdIndexInput(4 downto 0)=>XLXN_192(4 downto 0),
								regWriteInput=>XLXN_185,
								riskReset=>XLXN_199,
								rst=>rst,
								rsValueInput(31 downto 0)=>XLXN_168(31 downto 0),
								rtIndexInput(4 downto 0)=>XLXN_145(4 downto 0),
								rtValueInput(31 downto 0)=>XLXN_169(31 downto 0),
								slimmOrRsInput=>XLXN_180,
								wbRtOrRdOrRa(1 downto 0)=>XLXN_191(1 downto 0),
								aluOpOutput(3 downto 0)=>XLXN_209(3 downto 0),
								cp0WriteOutput=>XLXN_243,
								excCodeOutput(31 downto 0)=>XLXN_247(31 downto 0),
								excDelayOutput=>XLXN_240,
								exSelectOutput(1 downto 0)=>XLXN_238(1 downto 0),
								hiloReadOutput=>XLXN_212,
								hiloWriteOutput(1 downto 0)=>XLXN_249(1 downto 0),
								immExtendOutput=>XLXN_205,
								immOrRtOutput=>XLXN_206,
								immOutput(15 downto 0)=>XLXN_208(15 downto 0),
								intDisableOutput=>XLXN_244,
								isSBOutput=>XLXN_252,
								ldstLenOutput(1 downto 0)=>XLXN_248(1 downto 0),
								loadExModeOutput=>XLXN_242,
								memReadOutput=>XLXN_143,
								memWriteOutput=>XLXN_241,
								pc4Output(31 downto 0)=>XLXN_237(31 downto 0),
								rdIndexOutput(4 downto 0)=>XLXN_223(4 downto 0),
								regWriteOutput=>XLXN_148,
								multiSelOutput=>MY_XLXN_4,	-- new 7.0
								rsValueOutput(31 downto 0)=>XLXN_202(31 downto 0),
								rsAbsValueOutput=>MY_XLXN_2,	-- new 7.0
								rtValueOutput(31 downto 0)=>XLXN_203(31 downto 0),
								rtAbsValueOutput=>MY_XLXN_3,	-- new 7.0
								slimmOrRsOutput=>XLXN_207,
								wbIndexoutput(4 downto 0)=>XLXN_152(4 downto 0));

	 XLXI_23 : registers
			port map (clk=>clk,
								exRdWBIndex(4 downto 0)=>XLXN_152(4 downto 0),
								exRdWBValue(31 downto 0)=>XLXN_154(31 downto 0),
								exRegWrite=>XLXN_148,
								memRdWBIndex(4 downto 0)=>XLXN_225(4 downto 0),
								memRdWBValue(31 downto 0)=>XLXN_155(31 downto 0),
								memRegWrite=>XLXN_149,
								rdIndex(4 downto 0)=>XLXN_227(4 downto 0),
								rdInput(31 downto 0)=>XLXN_151(31 downto 0),
								regWrite=>XLXN_147,
								rsIndex(4 downto 0)=>XLXN_144(4 downto 0),
								rst=>rst,
								rtIndex(4 downto 0)=>XLXN_145(4 downto 0),

								dbIndex=>MY_XLXN_9,dbOutput=>MY_XLXN_5,
								dbInput=>MY_XLXN_14,dbRegWrite=>MY_XLXN_15,

								rsOutput(31 downto 0)=>XLXN_168(31 downto 0),
								rtOutput(31 downto 0)=>XLXN_169(31 downto 0)
			);
	XLXI_24:debugger port map(
		Debug=>Debug,
		clk=>clk,comclk=>comclk,rst=>rst,mem_input=>valueInput,reg_input=>MY_XLXN_5,cp0_input=>MY_XLXN_6,
		hilo_input=>MY_XLXN_7,pc4_input=>XLXN_229,reg_idx=>MY_XLXN_9,
		mem_addr=>MY_XLXN_10,hard_break=>MY_XLXN_11,dbStep=>MY_XLXN_12,dbCont=>MY_XLXN_13,
		U_TxD=>U_TxD,U_RxD=>U_RxD,
		v_output=>MY_XLXN_14,reg_write=>MY_XLXN_15,dbOccur=>MY_XLXN_8,mem_write=>MY_XLXN_16
	);

end BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.defines.all;
--library UNISIM;
--use UNISIM.Vcomponents.ALL;

entity TOP2 is
	 port (
					clkin         : in    std_logic;
					ps2clk		  : in	 std_logic;
					rst           : in    std_logic;
					baseram_addr  : out   std_logic_vector (19 downto 0);
					baseram_ce    : out   std_logic;
					baseram_oe    : out   std_logic;
					baseram_we    : out   std_logic;
					extrram_addr  : out   std_logic_vector (19 downto 0);
					extrram_ce    : out   std_logic;
					extrram_oe    : out   std_logic;
					extrram_we    : out   std_logic;
					state_out_MMU : out   std_logic_vector (2 downto 0);
					state_out_RAM : out   std_logic_vector (2 downto 0);
					baseram_data  : inout std_logic_vector (31 downto 0);
					extrram_data  : inout std_logic_vector (31 downto 0);
					
					
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

					Debug 		  : out 	std_logic_vector (15 downto 0);

	 				TxD			  : out   std_logic;
	 				RxD			  : in   std_logic;
	 				U_TxD		  : out   std_logic;
	 				U_RxD		  : in   std_logic;
					
					-- version for VGA
						rOut:out std_logic_vector(2 downto 0);
						gOut:out std_logic_vector(2 downto 0);
						bOut:out std_logic_vector(2 downto 0);
						hs:out std_logic;
						vs:out std_logic;
					-- end

					-- version for PS2
						kbd_enb_hi: in std_logic;
						kbd_enb_lo: in std_logic;
						kbd_data: in std_logic_vector(3 downto 0)
					-- end

	 );
end TOP2;

architecture BEHAVIORAL of TOP2 is
	 signal clk 				   : std_logic;
	 signal clk3M125:std_logic;
	 signal clk1M5625:std_logic;
	 signal clk50M				   : std_logic;
	 --signal clk25M				   : std_logic;
	 --signal clk12M5				   : std_logic;
	 --signal clk6M25				   : std_logic;
	 --signal clk20M				   : std_logic;
	 --signal clk30M				   : std_logic;
	 --signal clk35M				   : std_logic;
	 --signal clk40M				   : std_logic;
	 signal count				   : std_logic_vector(9 downto 0);


	 signal dbOccur:std_logic;
	 signal dbMemWrite:std_logic;
	 signal dbMemInput:std_logic_vector(31 downto 0);

	 signal MY_XLXN_OPEN_0		   : std_logic;
	 signal MY_XLXN_OPEN_1		   : std_logic;
	 signal MY_XLXN_OPEN_2		   : std_logic;
	 signal MY_XLXN_OPEN_3		   : std_logic;
	 signal MY_XLXN_OPEN_4		   : std_logic;
	 signal MY_XLXN_OPEN_5		   : std_logic;

	 signal XLXN_4                 : std_logic;
	 signal XLXN_5                 : std_logic;
	 signal XLXN_6                 : std_logic;
	 signal XLXN_7                 : std_logic;
	 signal XLXN_8                 : std_logic;
	 signal XLXN_9                 : std_logic;
	 signal XLXN_10                : std_logic;
	 signal XLXN_11                : std_logic;
	 signal XLXN_12                : std_logic;
	 signal XLXN_13                : std_logic;
	 signal XLXN_14                : std_logic;
	 signal XLXN_15                : std_logic;
	 signal XLXN_16                : std_logic;
	 signal XLXN_17                : std_logic;
	 signal XLXN_18                : std_logic_vector (31 downto 0);
	 signal XLXN_19                : std_logic_vector (31 downto 0);
	 signal XLXN_20                : std_logic_vector (31 downto 0);
	 signal XLXI_2_beat_openSignal : std_logic;
	 signal XLXN_MY_0			   : std_logic;
	 
	 	-- version for VGA 
	
	signal vgaAddrO2I : std_logic_vector(17 downto 0);
	signal vgaValueO2I : std_logic_vector(7 downto 0);
	signal VGAcanWriteO2I : std_logic;
	
	component VGA_module
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
	end component;
	-- end

	component CPU2_MUSER_TOP2
		port ( rst             : in    std_logic;
					 valueInput      : in    std_logic_vector (31 downto 0);
					 isPS2           : inout std_logic;
					 memRead         : out   std_logic;
					 memWrite        : out   std_logic;
					 isSB            : out   std_logic;
					 isRAM           : out   std_logic;
					 isROM           : out   std_logic;
					 isFlash         : out   std_logic;
					 isCOM           : out   std_logic;
					 isVGA           : out   std_logic;
					 isAEP           : out   std_logic;
					 isCOMState      : out   std_logic;
					 isDigit         : out   std_logic;
					 isNone          : out   std_logic;
					 paddrInput      : out   std_logic_vector (31 downto 0);
					 writeValueInput : out   std_logic_vector (31 downto 0);
					 excOccur        : out   std_logic;
					 clk,comclk      : in    std_logic;

					Debug 			: out 	std_logic_vector (15 downto 0);

					dbMemWrite		: out   std_logic;
					dbMemInput		: out 	std_logic_vector(31 downto 0);

				 	 dbOccur		: out   std_logic;
					 U_TxD			: out 	std_logic;
					 U_RxD			: in 	std_logic;

					 comIntr		 : in 	 std_logic;
					 -- version for PS2
					 kbdIntr         : in    std_logic;
					 isPS2State      : out   std_logic);
	end component;

	component MMU
		port ( 		 clk             : in    std_logic;
					 comclk			 : in 	 std_logic;
					 flashclk		 : in std_logic;
					 rst             : in    std_logic;
					 isSB            : in    std_logic;
					 memRead         : in    std_logic;
					 memWrite        : in    std_logic;
					 isRAM           : in    std_logic;
					 isROM           : in    std_logic;
					 isFlash         : in    std_logic;
					 isCOM           : in    std_logic;
					 isVGA           : in    std_logic;
					 -- version for VGA
					 VGAcanWrite     : out    std_logic;
					 -- end
					 isPS2           : in    std_logic;
					 -- version for PS2
					 PS2CanRead      : out   std_logic;
					 -- end
					 isAEP           : in    std_logic;
					 isCOMState      : in    std_logic;
					 isDigit         : in    std_logic;
					 isNone          : in    std_logic;

					 dbOccur		 : in    std_logic;
					 dbMemWrite:in std_logic;
					 dbMemInput:in std_logic_vector(31 downto 0);

					 excOccur        : in    std_logic;
					 paddrInput      : in    std_logic_vector (31 downto 0);
					 writeValueInput : in    std_logic_vector (31 downto 0);
					 baseram_data    : inout std_logic_vector (31 downto 0);
					 extrram_data    : inout std_logic_vector (31 downto 0);
					 baseram_ce      : out   std_logic;
					 baseram_oe      : out   std_logic;
					 baseram_we      : out   std_logic;
					 extrram_ce      : out   std_logic;
					 extrram_oe      : out   std_logic;
					 extrram_we      : out   std_logic;
					 valueOutput     : out   std_logic_vector (31 downto 0);
					 baseram_addr    : out   std_logic_vector (19 downto 0);
					 extrram_addr    : out   std_logic_vector (19 downto 0);

					
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
					
					 TxD			 : out   std_logic;
					 RxD 			 : in 	 std_logic;
					 comIntr 		 : out 	 std_logic;
					 --version for VGA
						vgaAddrOutput:out std_logic_vector(17 downto 0);
						vgaValueOutput:out std_logic_vector(7 downto 0);
					 --end
					 -- version for PS2
					 	asciiInput:in std_logic_vector(7 downto 0);
					 	isPS2State:in std_logic;
					 	PS2HasData:in std_logic
					 -- end

		);
	end component;
	 
	--component clkGen
	--port
	-- (-- Clock in ports
	--  CLK_IN1           : in     std_logic;
	--  -- Clock out ports
	--  CLK_OUT1          : out    std_logic;
	--  CLK_OUT2          : out    std_logic;
	--  CLK_OUT3          : out    std_logic;
	--  -- Status and control signals
	--  RESET             : in     std_logic;
	--  LOCKED            : out    std_logic
	-- );
	--end component;

	-- version for PS2
	signal isPS2StateTrans : std_logic;
	signal PS2CanReadO2I: std_logic;
	signal intReq2CPU: std_logic;
	signal ascii2MMU: std_logic_vector(7 downto 0);
	component ps2_module
	Port(
		sysclk:in std_logic;
		clk:in std_logic;
		rst:in std_logic;

		intAck:in std_logic;
		intReqOutput:out std_logic;
		asciiOutput:out std_logic_vector(7 downto 0);

		enHi:in std_logic;
		enLo:in std_logic;

		kbdDataInput:in std_logic_vector(3 downto 0)
	);
	end component;
	-- end

	-- for debug
	signal stateForDebug: std_logic_vector(1 downto 0) := "00";

begin

	--MY_XLXI_1 : clkGen
 -- 	port map(
 --   CLK_IN1 => clkin,
 --   CLK_OUT1 => clk50M,
 --   CLK_OUT2 => clk3M125,
 --   CLK_OUT3 => clk1M5625,
 --   RESET  => MY_XLXN_OPEN_0,
 --   LOCKED => MY_XLXN_OPEN_1);

 	process(clkin)
 	begin
 	if(clkin'event and clkin='1')then
 		count<=count+1;
 	end if;
 	end process;

 	clk3M125<=count(3);
 	clk1M5625<=count(4);

	clk<=clk3M125;

	-- version for PS2
		ps2: ps2_module
		port map(
			sysclk => clk,
			clk => ps2clk,
			rst => rst,
			intAck => PS2CanReadO2I,
			intReqOutput => intReq2CPU,
			asciiOutput => ascii2MMU,
			enHi => kbd_enb_hi,
			enLo => kbd_enb_lo,
			kbdDataInput => kbd_data
		);
	-- end

	-- version for VGA
		XLXI_0 : VGA_module
		port map (
				clk => clk50M,
				rst => rst,

				canWrite => VGAcanWriteO2I,
				vgaAddrInput => vgaAddrO2I,
				write_data => vgaValueO2I,
				
				-- output
				rOut => rOut,
				gOut => gOut,
				bOut => bOut,
				hs => hs,
				vs => vs
			);
		-- end

	 XLXI_1 : CPU2_MUSER_TOP2
			port map (clk=>clk,comclk=>clk1M5625,
								rst=>rst,
								valueInput(31 downto 0)=>XLXN_20(31 downto 0),
								excOccur=>XLXN_6,
								isAEP=>XLXN_13,
								isCOM=>XLXN_11,
								isCOMState=>XLXN_14,
								isDigit=>XLXN_15,
								isFlash=>XLXN_10,
								isNone=>XLXN_16,
								isRAM=>XLXN_8,
								isROM=>XLXN_9,
								isSB=>XLXN_7,
								isVGA=>XLXN_12,
								memRead=>XLXN_4,
								memWrite=>XLXN_5,
								paddrInput(31 downto 0)=>XLXN_19(31 downto 0),
								writeValueInput(31 downto 0)=>XLXN_18(31 downto 0),
								isPS2=>XLXN_17,

								Debug=>Debug,

								dbMemInput=>dbMemInput,
								dbMemWrite=>dbMemWrite,
					 			dbOccur=>dbOccur,
					 			U_RxD=>U_RxD,
					 			U_TxD=>U_TxD,

								comIntr=>XLXN_MY_0,
								-- version for PS2
								kbdIntr=>intReq2CPU,
								isPS2State=>isPS2StateTrans
								-- end
			);

	 XLXI_2 : MMU
			port map (
								clk=>clk,
								rst=>rst,
								comclk=>clk1M5625,
								flashclk=>clk1M5625,

								dbMemInput=>dbMemInput,
								dbMemWrite=>dbMemWrite,
					 			dbOccur=>dbOccur,

								excOccur=>XLXN_6,
								isAEP=>XLXN_13,
								isCOM=>XLXN_11,
								isCOMState=>XLXN_14,
								isDigit=>XLXN_15,
								isFlash=>XLXN_10,
								isNone=>XLXN_16,
								isPS2=>XLXN_17,
								-- version for PS2
								PS2CanRead=>PS2CanReadO2I,
								-- end
								isRAM=>XLXN_8,
								isROM=>XLXN_9,
								isSB=>XLXN_7,
								isVGA=>XLXN_12,
								-- version for VGA
								VGAcanWrite=>VGAcanWriteO2I,
								-- end
								memRead=>XLXN_4,
								memWrite=>XLXN_5,
								paddrInput(31 downto 0)=>XLXN_19(31 downto 0),
								writeValueInput(31 downto 0)=>XLXN_18(31 downto 0),
								baseram_addr(19 downto 0)=>baseram_addr(19 downto 0),
								baseram_ce=>baseram_ce,
								baseram_oe=>baseram_oe,
								baseram_we=>baseram_we,
								extrram_addr(19 downto 0)=>extrram_addr(19 downto 0),
								extrram_ce=>extrram_ce,
								extrram_oe=>extrram_oe,
								extrram_we=>extrram_we,
								valueOutput(31 downto 0)=>XLXN_20(31 downto 0),
								baseram_data(31 downto 0)=>baseram_data(31 downto 0),
								extrram_data(31 downto 0)=>extrram_data(31 downto 0),



								flash_addr => flash_addr,
								flash_data => flash_data,
								flash_control_ce0 => flash_control_ce0,
								flash_control_ce1 => flash_control_ce1,
								flash_control_ce2 => flash_control_ce2,
								flash_control_byte => flash_control_byte,
								flash_control_vpen => flash_control_vpen,
								flash_control_rp => flash_control_rp,
								flash_control_we => flash_control_we,
								flash_control_oe => flash_control_oe,

								TxD=>TxD,
								RxD=>RxD,
								comIntr=>XLXN_MY_0,
								-- version for VGA
								vgaAddrOutput => vgaAddrO2I,
								vgaValueOutput => vgaValueO2I,
								-- end
								-- version for PS2
								asciiInput => ascii2MMU,
								PS2HasData => intReq2CPU,
								isPS2State => isPS2StateTrans
			);

end BEHAVIORAL;


