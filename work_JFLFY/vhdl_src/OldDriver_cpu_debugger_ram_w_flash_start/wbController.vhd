----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:24:42 11/04/2015 
-- Design Name: 
-- Module Name:    wbController - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wbController is

Port(
	-- ������ź�
	aluRdValue: in std_logic_vector(31 downto 0);
	mmuRdValue: in std_logic_vector(31 downto 0);
	-- ѡ��д�ص����� ��Ϊ'0'����ALUд��
	wbSrc: in std_logic;
	-- �߼���չ������չ '1' Ϊ�߼���չ
	extendModel: in std_logic;
	-- ��ʵ��ȡ�����ݾ����Ǽ�λ "10" �����ֽ� "01"����� "00"��һ���ֽ�
	loadLen: in std_logic_vector(1 downto 0);
	-- �������
	insResult:out std_logic_vector(31 downto 0)
	-- ���ڴ�ĵ�ַ��ĩ��λ this variable has been aluRdValue
	-- addrLo:in std_logic_vector(1 downto 0)

	-- TODO: rewrite the logic of this module.
);

end wbController;

architecture Behavioral of wbController is
	signal extBit:std_logic;
	signal mmuValueRearr:std_logic_vector(31 downto 0);
begin
	mmuValueRearr<=
		mmuRdValue when aluRdValue(1 downto 0)="00" else
		X"000000"&mmuRdValue(15 downto 8) when aluRdValue(1 downto 0)="01" else
		X"0000"&mmuRdValue(31 downto 16) when aluRdValue(1 downto 0)="10" else
		X"000000"&mmuRdValue(31 downto 24) when aluRdValue(1 downto 0)="11" else
		X"00000000";	-- impossible

	with loadLen(0) select
	extBit<=
		 mmuValueRearr(15) and extendModel when '0',
		 mmuValueRearr(7) and extendModel when '1';

	insResult<=
		aluRdValue when wbSrc='0' else
		mmuRdValue when loadLen="00" else 	-- both of mmuRdValue and mmuValueRearr can use here, we choose the faster one
		extBit&extBit&extBit&extBit&extBit&extBit&extBit&extBit&
		extBit&extBit&extBit&extBit&extBit&extBit&extBit&extBit&
		mmuValueRearr(15 downto 0) when loadLen="10" else
		extBit&extBit&extBit&extBit&extBit&extBit&extBit&extBit&
		extBit&extBit&extBit&extBit&extBit&extBit&extBit&extBit&
		extBit&extBit&extBit&extBit&extBit&extBit&extBit&extBit&
		mmuValueRearr(7 downto 0) when loadLen="11" else
		X"00000000";	--impossible;

end Behavioral;

