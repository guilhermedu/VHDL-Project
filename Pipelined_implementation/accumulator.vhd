library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
  generic (
    ADDR_BITS : integer range 2 to 8 := 4;  -- Número de bits para endereços
    DATA_BITS : integer range 4 to 32 := 8; -- Número de bits para dados
    DATA_BITS_LOG2 : integer range 1 to 4 := 3 -- Log2(DATA_BITS)
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
  -- Sinais intermediários para pipeline
  signal s_write_addr_stage1 : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0'); -- Endereço no estágio 1
  signal s_write_inc_stage1  : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0'); -- Incremento no estágio 1
  signal s_aux_read_data     : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0'); -- Dado lido da RAM
  signal s_value_to_write    : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0'); -- Valor a ser escrito no estágio 2

  -- Registradores intermediários para pipeline
  signal reg_write_addr_stage2 : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0'); -- Endereço no estágio 2
  signal reg_value_stage2      : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0'); -- Valor estabilizado no estágio 2

  -- Controle de bypass
  signal bypass_enable : std_logic := '0'; -- Ativado se o endereço do estágio 1 for igual ao do estágio 2

begin
  -- Estágio 1: Leitura e estabilização
  addr_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => ADDR_BITS
    )
    port map (
      clock => clock,
      d     => write_addr,
      q     => s_write_addr_stage1,
      en    => '1'
    );

  inc_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => DATA_BITS
    )
    port map (
      clock => clock,
      d     => write_inc,
      q     => s_write_inc_stage1,
      en    => '1'
    );

  -- Verificar se o bypass é necessário
  process(clock)
  begin
    if rising_edge(clock) then
      if s_write_addr_stage1 = reg_write_addr_stage2 then
        bypass_enable <= '1';
      else
        bypass_enable <= '0';
      end if;
    end if;
  end process;

  -- RAM
  memory : entity work.triple_port_ram(behavioral)
    generic map (
      ADDR_BITS => ADDR_BITS,
      DATA_BITS => DATA_BITS
    )
    port map (
      clock          => clock,
      write_addr     => reg_write_addr_stage2, -- Estágio 2
      write_data     => reg_value_stage2,      -- Estágio 2
      read_addr      => read_addr,
      read_data      => read_data,
      aux_read_addr  => s_write_addr_stage1,   -- Leitura auxiliar no estágio 1
      aux_read_data  => s_aux_read_data        -- Valor lido diretamente da RAM
    );

  -- Seleção do dado lido (RAM ou bypass)
  process(clock)
  begin
    if rising_edge(clock) then
      if bypass_enable = '1' then
        -- Usa o valor mais recente do estágio 2
        s_aux_read_data <= reg_value_stage2;
      else
        -- Usa o valor lido da RAM diretamente
        s_aux_read_data <= s_aux_read_data; -- Valor correto vindo da RAM
      end if;
    end if;
  end process;

  -- Estágio 2: Soma e escrita
  adder : entity work.adder_n(structural)
    generic map (
      N => DATA_BITS
    )
    port map (
      a    => s_aux_read_data,       -- Valor lido da RAM ou bypass
      b    => s_write_inc_stage1,    -- Incremento estabilizado no estágio 1
      c_in => '0',                   -- Sem carry inicial
      s    => s_value_to_write,      -- Resultado da soma
      c_out => open                  -- Carry não utilizado
    );

  -- Estabilização dos valores no estágio 2
  process(clock)
  begin
    if rising_edge(clock) then
      reg_write_addr_stage2 <= s_write_addr_stage1; -- Estabiliza o endereço no estágio 2
      reg_value_stage2 <= s_value_to_write;        -- Estabiliza o valor calculado
    end if;
  end process;

end structural;
