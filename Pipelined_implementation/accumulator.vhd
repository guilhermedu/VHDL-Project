library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
  generic (
    ADDR_BITS : integer range 2 to 8 := 4;
    DATA_BITS : integer range 4 to 32 := 8;
    DATA_BITS_LOG2 : integer range 1 to 4 := 3
  );
  port (
    clock      : in  std_logic;
    write_addr : in  std_logic_vector(ADDR_BITS-1 downto 0);
    write_inc  : in  std_logic_vector(DATA_BITS-1 downto 0);
    read_addr  : in  std_logic_vector(ADDR_BITS-1 downto 0);
    read_data  : out std_logic_vector(DATA_BITS-1 downto 0)
  );
end accumulator;

architecture structural of accumulator is

  --------------------------------------------------------------------------
  -- SINAIS ORIGINAIS
  --------------------------------------------------------------------------
  -- Registradores que capturam os sinais de entrada
  signal s_write_addr_stable : std_logic_vector(ADDR_BITS-1 downto 0);
  signal s_write_inc_stable  : std_logic_vector(DATA_BITS-1 downto 0);

  -- Valor que sai do somador (resultado da soma)
  signal s_value_to_write    : std_logic_vector(DATA_BITS-1 downto 0);

  -- Saída auxiliar de leitura da RAM
  signal s_aux_read_data     : std_logic_vector(DATA_BITS-1 downto 0);

  --------------------------------------------------------------------------
  -- NOVOS SINAIS DE PIPELINE
  --------------------------------------------------------------------------
  -- Stage 1: registradores
  signal s_stage1_read_data  : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_stage1_write_addr : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal s_stage1_write_inc  : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');

  -- Stage 2: registradores (resultado da soma e endereço)
  signal s_stage2_result     : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_stage2_write_addr : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');

  -- Detecção de “hazard”
  signal hazard_detected     : std_logic := '0';

begin
  ----------------------------------------------------------------------------
  -- 1) REGISTRADORES ORIGINAIS PARA (write_addr, write_inc)
  ----------------------------------------------------------------------------
  addr_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => ADDR_BITS
    )
    port map (
      clock => clock,
      d     => write_addr,           -- Endereço vindo de fora
      q     => s_write_addr_stable,  -- Endereço estabilizado
      en    => '1'
    );

  inc_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => DATA_BITS
    )
    port map (
      clock => clock,
      d     => write_inc,            -- Incremento vindo de fora
      q     => s_write_inc_stable,   -- Incremento estabilizado
      en    => '1'
    );

  ----------------------------------------------------------------------------
  -- 2) STAGE 1: LER DA RAM E GUARDAR NOS REGISTRADORES DE PIPELINE
  ----------------------------------------------------------------------------
  process (clock)
  begin
    if rising_edge(clock) then
      -- Lê da RAM via porta auxiliar e guarda no pipeline
      s_stage1_read_data  <= s_aux_read_data;

      -- Guarda os sinais write_addr e write_inc estabilizados
      s_stage1_write_addr <= s_write_addr_stable;
      s_stage1_write_inc  <= s_write_inc_stable;

      -- Detecta hazard: se o endereço que estou lendo (Stage 1) for igual ao que acabei de escrever (Stage 2)
      if (s_stage2_write_addr = s_write_addr_stable) then
        hazard_detected <= '1';
      else
        hazard_detected <= '0';
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- 3) STAGE 2: SOMAR E ESCREVER NA MEMÓRIA
  ----------------------------------------------------------------------------
  process (clock)
  begin
    if rising_edge(clock) then
      -- Se houver hazard, usar o valor mais recente
      if hazard_detected = '1' then
        s_stage2_result <= std_logic_vector(
                             unsigned(s_stage2_result) +
                             unsigned(s_stage1_write_inc)
                          );
      else
        -- Caso contrário, usar o valor lido do Stage 1
        s_stage2_result <= std_logic_vector(
                             unsigned(s_stage1_read_data) +
                             unsigned(s_stage1_write_inc)
                          );
      end if;

      -- Atualiza o endereço do Stage 2
      s_stage2_write_addr <= s_stage1_write_addr;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- 4) MEMÓRIA (TRIPLE PORT RAM)
  ----------------------------------------------------------------------------
  memory : entity work.triple_port_ram(behavioral)
    generic map (
      ADDR_BITS => ADDR_BITS,
      DATA_BITS => DATA_BITS
    )
    port map (
      clock          => clock,

      -- Porta de escrita
      write_addr     => s_stage2_write_addr,
      write_data     => s_stage2_result,

      -- Porta de leitura principal
      read_addr      => read_addr,
      read_data      => read_data,

      -- Porta auxiliar de leitura
      aux_read_addr  => s_write_addr_stable,
      aux_read_data  => s_aux_read_data
    );

end structural;
