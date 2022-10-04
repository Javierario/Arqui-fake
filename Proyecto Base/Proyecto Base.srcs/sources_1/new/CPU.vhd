library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0);
           dis : out STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is

----------------
-- COMPONENTES --
----------------

component ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           selALU   : in  std_logic_vector (2 downto 0);   -- Selector de la operaciÛn.
           c        : out std_logic;                       -- SeÒal de 'carry'.
           z        : out std_logic;                       -- SeÒal de 'zero'.
           n        : out std_logic;                       -- SeÒal de 'nagative'.
           result   : out std_logic_vector (16 downto 0));  -- Resultado de la operaciÛn.
end component;

component ControlUnit is
    Port ( opcode       : in  std_logic_vector (19 downto 0);   -- Opcode
           czn        : in  std_logic_vector (2 downto 0);   -- status.
           enableA   : out std_logic;   			      -- Reg A
           enableB   : out std_logic;                       -- Reg B
           selA      : out std_logic_vector (1 downto 0);   -- Mux A
           selB      : out std_logic_vector (1 downto 0);   -- Mux B
           loadPC    : out std_logic;  				-- 
	    selALU	 : out std_logic_vector (2 downto 0);  -- Op ALU
	    w    	 : out std_logic);  				-- Escribir RAM
end component;

component Reg is
	Port ( clock    : in  std_logic;                        -- SeÒal del clock (reducido).
           clear    : in  std_logic;                        -- SeÒal de reset.
           load     : in  std_logic;                        -- SeÒal de carga.
           up       : in  std_logic;                        -- SeÒal de subida.
           down     : in  std_logic;                        -- SeÒal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- SeÒales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- SeÒales de salida de datos.
end component;

-- PC y Status?
component Status is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in std_logic_vector (2 downto 0);     -- bits czn
           dataout  : out std_logic_vector (2 downto 0));  -- Señales de salida de datos.
end component;

component Multiplexor is
    Port ( e0       : in  std_logic_vector (15 downto 0);   -- opción A,B:zero
	    e1       : in  std_logic_vector (15 downto 0);   -- opción A:uno o B:ram_data_out
	    e2       : in  std_logic_vector (15 downto 0);   -- opción A:nada, B:rom_data_out
	    e3       : in  std_logic_vector (15 downto 0);   -- opción A:RegA, B:RegB
           sel      : in  std_logic_vector (1 downto 0);    -- señal selector.
	    result   : out std_logic_vector (15 downto 0));  -- Resultado de la selección.
end component;

component Reg_PC is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           loadPC   : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (11 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (11 downto 0));  -- Señales de salida de datos.
end component;

----------------
--   CABLES   --
----------------

-- Reg A Mux A
signal rega_to_muxa: std_logic_vector(15 downto 0); 
-- Reg B Mux B
signal regb_to_muxb: std_logic_vector(15 downto 0);
-- zero y uno a los Mux?
--signal zero_to_muxa: std_logic_vector(15 downto 0);
--signal zero_to_muxb: std_logic_vector(15 downto 0);
--signal one_to_muxa: std_logic_vector(15 downto 0);
-- Mux A ALU
signal muxa_to_alu: std_logic_vector(15 downto 0); 
-- Mux B ALU
signal muxb_to_alu: std_logic_vector(15 downto 0); 
-- ALU a Status x3
signal alu_to_status_c: std_logic;
signal alu_to_status_z: std_logic;
signal alu_to_status_n: std_logic;
-- Status a Control Unit
signal status_to_control: std_logic_vector(2 downto 0);
-- RAM out a Mux B
--signal ram_to_muxb: std_logic_vector(15 downto 0);
-- ROM out a Mux B
--signal rom_to_muxb: std_logic_vector(15 downto 0);
-- PC a ROM address
--signal pc_to_rom: std_logic_vector(11 downto 0);
-- ROM a Control Unit
signal rom_to_control: std_logic_vector(19 downto 0);   
-- ROM out a PC
signal rom_to_pc: std_logic_vector(11 downto 0);        ----CUAL ES ESTE? 
-- ROM data out a RAM address ???
signal rom_to_ram: std_logic_vector(11 downto 0);       ----- ?????
-- ALU result a RAM_datain
--signal alu_to_ram: std_logic_vector(15 downto 0);       
-- PC a RAM Address
--signal pc_to_ram: std_logic;                 ----revisar
-- clear a PC, Status, Reg A, Reg B
--signal clear_to_pc: std_logic;            ------ESTAS CON CLEAR FALTA CONECTARLAS CON ALGO
--signal clear_to_status: std_logic; --
--signal clear_to_rega: std_logic;  --
--signal clar_to_regb: std_logic; --
-- Control unit enableA a Reg A
signal control_enablea_to_rega: std_logic; -- where in rega
-- Control unit enableB a Reg B
signal control_enableb_to_regb: std_logic;
-- Control unit selA a Mux A
signal control_sela_to_muxa: std_logic_vector(1 downto 0);
-- Control unit selB a Mux B
signal control_selb_to_muxb: std_logic_vector(1 downto 0);
-- Control Unit loadPC a PC
signal control_loadpc_to_pc: std_logic;
-- Control Unit selALU a ALU
signal control_selalu_to_alu: std_logic_vector(2 downto 0);
-- w control unit a write RAM
signal control_w_to_ram: std_logic;   ---MISMO problem

signal alu_result: std_logic_vector(15 downto 0);

signal czn_juntos: std_logic_vector(2 downto 0);

begin

-- inicio declaracion comportamientos
----------------
-- CONEXIONES --
----------------

-- Reg A Mux A

-- Reg B Mux B

-- zero y uno a los Mux?

-- Mux A ALU
-- Mux B ALU
-- ALU a Status x3
-- Status a Control Unit
-- RAM out a Mux B
-- ROM out a Mux B
-- PC a ROM address
-- ROM a Control Unit
-- ROM out a PC
-- ROM data out a RAM address ???
-- ALU result a RAM_datain
-- PC a RAM Address
-- clear a PC, Status, Reg A, Reg B
-- Control unit enableA a Reg A
-- Control unit enableB a Reg B
-- Control unit selA a Mux A
-- Control unit selB a Mux B
-- Control Unit loadPC a PC
-- Control Unit selALU a ALU
-- w control unit a write RAM



----------------
-- INSTANCIAS --
----------------

-- Instancia ALU

inst_alu: ALU port map(
           a        => muxa_to_alu,   -- Primer operando.
           b        => muxb_to_alu,   -- Segundo operando.
           selALU   => control_selalu_to_alu,   -- Selector de la operaciÛn.
           c        => alu_to_status_c,                      -- SeÒal de 'carry'.
           z        => alu_to_status_z,                    -- SeÒal de 'zero'.
           n        => alu_to_status_n,                       -- SeÒal de 'nagative'.
           result   => alu_result -- Resultado de la operaciÛn.
);

-- Instancia Control Unit

inst_controlunit: ControlUnit port map(
           opcode        => rom_dataout(35 downto 16),    -- Opcode
           czn        => status_to_control,  -- status.
           enableA    => control_enablea_to_rega,  			      -- Reg A
           enableB    => control_enableb_to_regb,                      -- Reg B
           selA       => control_sela_to_muxa,   -- Mux A
           selB       => control_selb_to_muxb,   -- Mux B
           loadPC     => control_loadpc_to_pc,  				-- 
	       selALU	  => control_selalu_to_alu,  -- Op ALU
	       w    	  => ram_write  				-- Escribir RAM
);

-- Instancia Reg A
inst_reg_a : Reg port map(
	       clock    => clock,                        -- SeÒal del clock (reducido).
           clear    => clear,                        -- SeÒal de reset.
           load     => control_enablea_to_rega,                        -- SeÒal de carga.
           up       => '0',                         -- SeÒal de subida.
           down     => '0',                         -- SeÒal de bajada.
           datain   => alu_result,    -- SeÒales de entrada de datos.
           dataout  => rega_to_muxa  -- SeÒales de salida de datos.
);
-- Instancia Reg B
inst_reg_b : Reg port map(
	       clock    => clock,                        -- SeÒal del clock (reducido).
           clear    => clear,                        -- SeÒal de reset.
           load     => control_enableb_to_regb,                        -- SeÒal de carga.
           up       => '0',                         -- SeÒal de subida.
           down     => '0',                         -- SeÒal de bajada.
           datain   => alu_result,    -- SeÒales de entrada de datos.
           dataout  => regb_to_muxb -- SeÒales de salida de datos.
);

-- Instancia PC --esta hecha como REG------------
inst_Reg_PC : Reg_PC port map(
	       clock    => clock,                        -- SeÒal del clock (reducido).
           clear    => clear,                        -- SeÒal de reset.
           loadPC     => control_loadpc_to_pc,                        -- SeÒal de carga.
           up       => '1',                         -- SeÒal de subida.
           down     => '0',                         -- SeÒal de bajada.
           datain   => rom_dataout(35 downto 24),    -- SeÒales de entrada de datos.
           dataout  => rom_address   -- SeÒales de salida de datos.
);

-- Instancia Status

czn_juntos(2)<=alu_to_status_c;
czn_juntos(1)<=alu_to_status_z;
czn_juntos(0)<=alu_to_status_n;

inst_status : Status port map(
           clock    => clock,                       -- Señal del clock (reducido).
           clear    => clear,                        -- Señal de reset.
           load     => '1',                        -- Señal de carga.
           up       => '0',                        -- Señal de subida.
           down     => '0',                       -- Señal de bajada.
           datain   => czn_juntos,     -- bits czn
           dataout  => status_to_control    -- Señales de salida de datos.
);

-- Instancia Mux A

inst_mux_a : Multiplexor port map(
        e0        => "0000000000000000",  -- opción A,B:zero
	    e1        => "0000000000000001",   -- opción A:uno o B:ram_data_out
	    e2        => "0000000000000000",   -- opción A:nada, B:rom_data_out
	    e3        => rega_to_muxa,   -- opción A:RegA, B:RegB
        sel       => control_sela_to_muxa,    -- señal selector.
	    result    => muxa_to_alu  -- Resultado de la selección.
);

-- Instancia Mux B
inst_mux_b : Multiplexor port map(
        e0        => "0000000000000000",   -- opción A,B:zero
	    e1        => ram_dataout,   -- opción A:uno o B:ram_data_out
	    e2        => rom_dataout,   -- opción A:nada, B:rom_data_out
	    e3        => regb_to_muxb,   -- opción A:RegA, B:RegB
        sel       => control_selb_to_muxb,    -- señal selector.
	    result    => muxb_to_alu  -- Resultado de la selección.
);

ram_datain <= alu_result;

end Behavioral;

