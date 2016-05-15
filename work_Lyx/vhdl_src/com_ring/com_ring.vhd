--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:32:39 12/03/2015
-- Design Name:   
-- Module Name:   C:/CPU/MMU/testMMU.vhd
-- Project Name:  MMU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MMU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY com_ring IS

	PORT(
   		TxD:out std_logic;
   		RxD:in std_logic;

   		U_TxD:out std_logic;
   		U_RxD:in std_logic;
			
		Debug : OUT std_logic_vector(15 downto 0)
		);
		  
END com_ring;
 
ARCHITECTURE behavior OF com_ring IS

BEGIN
	TxD<=RxD;
	U_TxD<=U_RxD;
	Debug<=(others=>'1');
END;
