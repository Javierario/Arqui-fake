----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2022 20:44:45
-- Design Name: 
-- Module Name: Multiplexor - Behavioral
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

entity Multiplexor is
    Port ( e0       : in  std_logic_vector (15 downto 0);   -- opción A,B:zero
	   e1       : in  std_logic_vector (15 downto 0);   -- opción A:uno o B:ram_data_out
	   e2       : in  std_logic_vector (15 downto 0);   -- opción A:nada, B:rom_data_out
	   e3       : in  std_logic_vector (15 downto 0);   -- opción A:RegA, B:RegB
           sel      : in  std_logic_vector (1 downto 0);    -- señal selector.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la selección.
end Multiplexor;

architecture Behavioral of Multiplexor is

begin

with sel select
    result <= e0 when "00",
	       e1 when "01",
	       e2 when "10",
           e3 when "11";

end Behavioral;

