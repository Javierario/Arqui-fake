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
 Port    ( entrada_1     : in  std_logic_vector (19 downto 0);   
           entrada_2     : in std_logic_vector (2 downto 0);             
           enableA       : out std_logic;                       
           enableB       : out std_logic;                      
           selA          : out std_logic_vector (1 downto 0);
           selB          : out std_logic_vector (1 downto 0);
           loadPC        : out std_logic;
           selALU        : out std_logic_vector(2 downto 0));        
end ControlUnit;

architecture Behavioral of ControlUnit is

begin


end Behavioral;
