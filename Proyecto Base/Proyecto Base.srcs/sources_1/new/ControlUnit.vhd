----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2022 21:00:19
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
 Port    ( opcode     : in  std_logic_vector (19 downto 0);   
           czn        : in std_logic_vector (2 downto 0);             
           enableA       : out std_logic;                       
           enableB       : out std_logic;                      
           selA          : out std_logic_vector (1 downto 0);
           selB          : out std_logic_vector (1 downto 0);
           loadPC        : out std_logic;
           selALU        : out std_logic_vector(2 downto 0); 
           w             : out std_logic);    
end ControlUnit;

architecture Behavioral of ControlUnit is

signal result: std_logic_vector (10 downto 0);
signal flag_result   : std_logic_vector(10 downto 0);

signal final_result  : std_logic_vector(10 downto 0);
signal z: std_logic;
--signal c: std_logic;
--signal n: std_logic;

begin
with opcode select
result <=       "00111000000"	when "00000000000000000000",
                "11000100000"	when "00000000000000000001",
                "00101000000"	when "00000000000000000010",
                "00100100000"	when "00000000000000000011",
                "00011000000"	when "00000000000000000100",
                "00010100000"	when "00000000000000000101",
                "11000000001"	when "00000000000000000110",
                "00110000001"	when "00000000000000000111",
                "11111000000"	when "00000000000000001000",
                "11110100000"	when "00000000000000001001",
                "11101000000"	when "00000000000000001010",
                "11100100000"	when "00000000000000001011",
                "11011000000"	when "00000000000000001100",
                "11010100000"	when "00000000000000001101",
                "11110000001"	when "00000000000000001110",
                "11111000010"	when "00000000000000001111",
                "11110100010"	when "00000000000000010000",
                "11101000010"	when "00000000000000010001",
                "11100100010"	when "00000000000000010010",
                "11011000010"	when "00000000000000010011",
                "11010100010"	when "00000000000000010100",
                "11110000011"	when "00000000000000010101",
                "11111000100"	when "00000000000000010110",
                "11110100100"	when "00000000000000010111",
                "11101000100"	when "00000000000000011000",
                "11100100100"	when "00000000000000011001",
                "11011000100"	when "00000000000000011010",
                "11010100100"	when "00000000000000011011",
                "11110000101"	when "00000000000000011100",
                "11111000110"	when "00000000000000011101",
                "11110100110"	when "00000000000000011110",
                "11101000110"	when "00000000000000011111",
                "11100100110"	when "00000000000000100000",
                "11011000110"	when "00000000000000100001",
                "11010100110"	when "00000000000000100010",
                "11110000111"	when "00000000000000100011",
                "11111001000"	when "00000000000000100100",
                "11110101000"	when "00000000000000100101",
                "11101001000"	when "00000000000000100110",
                "11100101000"	when "00000000000000100111",
                "11011001000"	when "00000000000000101000",
                "11010101000"	when "00000000000000101001",
                "11110001001"	when "00000000000000101010",
                "11001001010"	when "00000000000000101011",
                "11000101010"	when "00000000000000101100",
                "11000001011"	when "00000000000000101101",
                "11001001110"	when "00000000000000101110",
                "11000101110"	when "00000000000000101111",
                "11000001111"	when "00000000000000110000",
                "11001001100"	when "00000000000000110001",
                "11000101100"	when "00000000000000110010",
                "11000001101"	when "00000000000000110011",
                "11001000000"	when "00000000000000110100",
                "00110100000"	when "00000000000000110101",
                "00000000001"	when "00000000000000110110",
                "11000000010"	when "00000000000000110111",
                "11110000010"	when "00000000000000111000",
                "11100000010"	when "00000000000000111001",
                "11010000010"	when "00000000000000111010",
                "00000010000"	when "00000000000000111011",
                "00000010000"	when "00000000000000111100",
                "00000010000"	when "00000000000000111101",
                "00000000000"   when "00000000000000111110", 
                --DUDOSA LEGALIDAD
                "00000000000" when others;
                
                
z <= czn(1); -- agregar in

with z select
flag_result <= "00000010000" when '0', --JNE, loadPC
		       "00000010000" when '1'; --JEQ, loadPC

with opcode select
	final_result <= flag_result when "00000000000000111100", -- si quiero JEQ
			   flag_result when "00000000000000111101", -- si quiero JNE
			   result when others; 				-- altiro
enableA <= final_result(4); --out std_logic;                       
enableB <= final_result(5);      --out std_logic;                      
selA <= final_result(1 downto 0);      --out std_logic_vector (1 downto 0);
selB <= final_result(3 downto 2);      --out std_logic_vector (1 downto 0);
loadPC <= final_result(6);     --out std_logic;
selALU <= final_result(9 downto 7);       --out std_logic_vector(2 downto 0));  
w <= final_result(10); 
  
end Behavioral;
