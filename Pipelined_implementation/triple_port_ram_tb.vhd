library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity triple_port_ram_tb is
end triple_port_ram_tb;

architecture testbench of triple_port_ram_tb is
  -- Constantes para configurar o teste
  constant ADDR_BITS : integer := 4;
  constant DATA_BITS : integer := 8;

  -- Sinais para estímulos
  signal clock        : std_logic := '0';
  signal write_addr   : std_logic_vector(ADDR_BITS-1 downto 0);
  signal write_data   : std_logic_vector(DATA_BITS-1 downto 0);
  signal read_addr    : std_logic_vector(ADDR_BITS-1 downto 0);
  signal read_data    : std_logic_vector(DATA_BITS-1 downto 0);
  signal aux_read_addr: std_logic_vector(ADDR_BITS-1 downto 0);
  signal aux_read_data: std_logic_vector(DATA_BITS-1 downto 0);
  signal write_inc : std_logic_vector(DATA_BITS-1 downto 0);


begin
  -- Instancia a unidade sob teste (UUT)
  uut: entity work.triple_port_ram(pipelined)
  generic map (
    ADDR_BITS => ADDR_BITS,
    DATA_BITS => DATA_BITS
  )
  port map (
    clock         => clock,
    write_addr    => write_addr,
    write_data    => write_data,
    write_inc     => write_inc, -- Incremento
    read_addr     => read_addr,
    read_data     => read_data,
    aux_read_addr => aux_read_addr,
    aux_read_data => aux_read_data
  );

  -- Gera o clock
  clock_gen: process
  begin
    while true loop
      clock <= '0';
      wait for 10 ns;
      clock <= '1';
      wait for 10 ns;
    end loop;
  end process;

  -- Estímulos
  stimulus: process
  begin
    -- Inicializa os sinais
    write_addr <= (others => '0');
    write_data <= (others => '0');
    read_addr  <= (others => '0');
    aux_read_addr <= (others => '0');

    -- Ciclo T=0: Escreve 42 no endereço 3
    wait for 20 ns; -- 1 ciclo de clock
    write_addr <= std_logic_vector(to_unsigned(3, ADDR_BITS));
    write_data <= std_logic_vector(to_unsigned(42, DATA_BITS));

    -- Ciclo T=1: Escreve 15 no endereço 3 (para testar bypass)
    wait for 20 ns; -- 1 ciclo de clock
    write_addr <= std_logic_vector(to_unsigned(3, ADDR_BITS));
    write_data <= std_logic_vector(to_unsigned(15, DATA_BITS));

    -- Ciclo T=2: Escreve 7 no endereço 4
    wait for 20 ns; -- 1 ciclo de clock
    write_addr <= std_logic_vector(to_unsigned(4, ADDR_BITS));
    write_data <= std_logic_vector(to_unsigned(7, DATA_BITS));

    -- Ciclo T=3: Leitura do endereço 3 (deve usar bypass para valor recente)
    wait for 20 ns;
    read_addr <= std_logic_vector(to_unsigned(3, ADDR_BITS));

    -- Ciclo T=4: Leitura do endereço 4
    wait for 20 ns;
    read_addr <= std_logic_vector(to_unsigned(4, ADDR_BITS));

    -- Ciclo T=5: Leitura do endereço 3 novamente (valor final no pipeline)
    wait for 20 ns;
    read_addr <= std_logic_vector(to_unsigned(3, ADDR_BITS));

    -- Finaliza o teste
    wait for 40 ns;
    assert false report "Test completed." severity note;
    wait;
  end process;

end testbench;
