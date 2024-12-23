library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity triple_port_ram_tb is
end triple_port_ram_tb;

architecture behavior of triple_port_ram_tb is

  -- Component declaration for the Unit Under Test (UUT)
  component triple_port_ram is
    generic(
      ADDR_BITS : integer range 2 to 16;
      DATA_BITS : integer range 1 to 32
    );
    port(
      clock           : in std_logic;
      write_addr      : in std_logic_vector(ADDR_BITS-1 downto 0);
      write_data      : in std_logic_vector(DATA_BITS-1 downto 0);
      read_addr       : in std_logic_vector(ADDR_BITS-1 downto 0);
      read_data       : out std_logic_vector(DATA_BITS-1 downto 0);
      aux_read_addr   : in std_logic_vector(ADDR_BITS-1 downto 0);
      aux_read_data   : out std_logic_vector(DATA_BITS-1 downto 0)
    );
  end component;

  -- Testbench constants and signals
  constant ADDR_BITS : integer := 4;
  constant DATA_BITS : integer := 8;

  signal tb_clock         : std_logic := '0';
  signal tb_write_addr    : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal tb_write_data    : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal tb_read_addr     : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal tb_read_data     : std_logic_vector(DATA_BITS-1 downto 0);
  signal tb_aux_read_addr : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal tb_aux_read_data : std_logic_vector(DATA_BITS-1 downto 0);

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: triple_port_ram
    generic map(
      ADDR_BITS => ADDR_BITS,
      DATA_BITS => DATA_BITS
    )
    port map(
      clock         => tb_clock,
      write_addr    => tb_write_addr,
      write_data    => tb_write_data,
      read_addr     => tb_read_addr,
      read_data     => tb_read_data,
      aux_read_addr => tb_aux_read_addr,
      aux_read_data => tb_aux_read_data
    );

  -- Clock generation process
  clock_process: process
  begin
    while true loop
      tb_clock <= '0';
      wait for 10 ns;
      tb_clock <= '1';
      wait for 10 ns;
    end loop;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Test case 1: Write data to address 0 and read back
    tb_write_addr <= "0000";
    tb_write_data <= "10101010";
    wait for 20 ns;

    tb_read_addr <= "0000";
    wait for 20 ns;

    -- Test case 2: Write data to address 1 and read from aux port
    tb_write_addr <= "0001";
    tb_write_data <= "11001100";
    wait for 20 ns;

    tb_aux_read_addr <= "0001";
    wait for 20 ns;

    -- Test case 3: Write data to address 2 and read asynchronously
    tb_write_addr <= "0010";
    tb_write_data <= "11110000";
    wait for 20 ns;

    tb_aux_read_addr <= "0010";
    wait for 20 ns;

    -- Test case 4: Write data to address 15 and read back
    tb_write_addr <= "1111";
    tb_write_data <= "00001111";
    wait for 20 ns;

    tb_read_addr <= "1111";
    wait for 20 ns;

    -- End simulation
    wait;
  end process;

end behavior;
