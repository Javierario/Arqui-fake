library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           selALU   : in  std_logic_vector (2 downto 0);   -- Selector de la operación. --mantenemos los 3 bits de esto
           c        : out std_logic;                       -- Señal de 'carry'.
           z        : out std_logic;                       -- Señal de 'zero'.
           n        : out std_logic;                       -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end ALU;

architecture Behavioral of ALU is

component Adder16 is
    Port ( a  : in  std_logic_vector (15 downto 0);
           b  : in  std_logic_vector (15 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0);
           co : out std_logic);
end component;

signal alu_result   : std_logic_vector(15 downto 0);
signal s_adder   : std_logic_vector(15 downto 0);
signal b_temp   : std_logic_vector(15 downto 0);
signal co_adder   : std_logic;
signal ci_temp   : std_logic;

begin

-- Sumador/Restaror
with selALU select
    ci_temp <= '1' when "001",
               '0' when others;
with selALU select
    b_temp <= not(b) when "001",
              b      when others;
                  
-- Resultado de la Operación
               
with selALU select
    alu_result <= s_adder     when "000", -- suma
                  s_adder     when "001", -- resta copmletaar de aqui para abajo
                  a and b     when "010", -- and
                  a or b      when "011", -- or
                  a xor b     when "100", -- xor
                  not a       when "101", -- not
                  '0' & a(15 downto 1)     when "110", -- shr
                  a(14 downto 0) & '0'     when "111"; -- shl
                  
result  <= alu_result;

inst_Adder: Adder16 port map(
        a      =>a,
        b      =>b_temp,
        ci     =>ci_temp,
        s      =>s_adder,
        co     =>co_adder
        );
-- Flags c z n
with selALU select
    c <= co_adder when "000",
         co_adder  when "001",
          '0'     when "010",
           '0'     when "011",
            '0'     when "100",
            '0'    when "101",
         a(0)     when "110",
         a(15)     when "111"; --REVISAR SI ESTO ESTÁ BIEN la verdad no estamos seguros :(

with alu_result select
    z <= '1' when "0000000000000000",
         '0'  when others;

with selALU select
    n <= not(co_adder) when "001",
        '0' when others;
    
end Behavioral;

