----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2022 21:39:22
-- Design Name: 
-- Module Name: Reg_PC - Behavioral
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
use IEEE.std_logic_unsigned.all;

entity Reg_PC is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           loadPC   : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (11 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (11 downto 0));  -- Señales de salida de datos.
end Reg_PC;

architecture Behavioral of Reg_PC is

signal pc : std_logic_vector(11 downto 0) := (others => '0'); -- Señales del registro. Parten en 0.

begin

pc_prosses : process (clock, clear)        -- Proceso sensible a clock y clear.
        begin
          if (clear = '1') then             -- Si clear = 1
            pc <= (others => '0');         -- Carga 0 en el registro.
          elsif (rising_edge(clock)) then   -- Si flanco de subida de clock.
            if (loadPC = '1') then            -- Si clear = 0, load = 1.
                pc <= datain;              -- Carga la entrada de datos en el registro.
            elsif (up = '1') then           -- Si clear = 0,load = 0 y up = 1.
                pc <= pc + 1;             -- Incrementa el registro en 1.
            elsif (down = '1') then         -- Si clear = 0,load = 0, up = 0 y down = 1. 
                pc <= pc - 1;             -- Decrementa el registro en 1.          
            end if;
          end if;
        end process;
        
dataout <= pc;                             -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;