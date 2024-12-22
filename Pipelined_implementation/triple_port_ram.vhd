library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity triple_port_ram is
  generic
  (
    ADDR_BITS : integer range 2 to 16;
    DATA_BITS : integer range 1 to 32
  );
  port
  (
    clock         : in std_logic;
    write_addr    : in std_logic_vector(ADDR_BITS-1 downto 0);
    write_data    : in std_logic_vector(DATA_BITS-1 downto 0);
    write_inc     : in std_logic_vector(DATA_BITS-1 downto 0); -- Incremento
    read_addr     : in std_logic_vector(ADDR_BITS-1 downto 0);
    read_data     : out std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
    aux_read_addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    aux_read_data : out std_logic_vector(DATA_BITS-1 downto 0) := (others => '0')
  );
end triple_port_ram;

architecture pipelined of triple_port_ram is
  -- Tipo de memória e registro da RAM
  type ram_t is array(0 to 2**ADDR_BITS-1) of std_logic_vector(DATA_BITS-1 downto 0);
  signal ram : ram_t := (others => (others => '0'));

  -- Registros intermediários para o pipeline
  signal s_read_data_reg : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_addr_reg      : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal s_sum_reg       : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');

  -- Controle de escrita
  signal write_enable : std_logic := '0';
begin
  -- Estágio 1: Leitura
  process(clock)
  begin
    if rising_edge(clock) then
      s_read_data_reg <= ram(to_integer(unsigned(write_addr))); -- Lê o dado da RAM
      s_addr_reg <= write_addr; -- Salva o endereço para o próximo estágio
    end if;
  end process;

  -- Estágio 2: Soma
  process(clock)
  begin
    if rising_edge(clock) then
      s_sum_reg <= std_logic_vector(unsigned(s_read_data_reg) + unsigned(write_inc)); -- Calcula a soma
      write_enable <= '1'; -- Habilita escrita no próximo ciclo
    end if;
  end process;

  -- Estágio 3: Escrita
  process(clock)
  begin
    if rising_edge(clock) then
      if write_enable = '1' then
        ram(to_integer(unsigned(s_addr_reg))) <= s_sum_reg; -- Escreve na RAM
        write_enable <= '0'; -- Desabilita escrita após o uso
      end if;
    end if;
  end process;

  -- Porta de leitura (sincronizada com pipeline)
  process(clock)
  begin
    if rising_edge(clock) then
      read_data <= ram(to_integer(unsigned(read_addr))); -- Atualiza dado lido
    end if;
  end process;

  -- Lógica de bypass para leitura auxiliar (aux_read_data)
  process(clock)
  begin
    if rising_edge(clock) then
      if write_addr = aux_read_addr then
        aux_read_data <= s_sum_reg; -- Usa valor mais recente do pipeline
      else
        aux_read_data <= ram(to_integer(unsigned(aux_read_addr))); -- Valor direto da RAM
      end if;
    end if;
  end process;

end pipelined;
