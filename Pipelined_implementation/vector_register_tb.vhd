library IEEE;
use IEEE.std_logic_1164.all;

entity vector_register_tb is
end vector_register_tb;

architecture behavior of vector_register_tb is

  -- Component declaration for the Unit Under Test (UUT)
  component vector_register is
    generic(
      DATA_BITS : integer range 1 to 32 := 4
    );
    port(
      clock : in std_logic;
      d     : in std_logic_vector(DATA_BITS-1 downto 0);
      q     : out std_logic_vector(DATA_BITS-1 downto 0);
      en    : in std_logic
    );
  end component;

  -- Testbench signals
  constant DATA_BITS : integer := 4;
  signal tb_clock : std_logic := '0';
  signal tb_d     : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal tb_q     : std_logic_vector(DATA_BITS-1 downto 0);
  signal tb_en    : std_logic := '0';

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: vector_register
    generic map(
      DATA_BITS => DATA_BITS
    )
    port map(
      clock => tb_clock,
      d     => tb_d,
      q     => tb_q,
      en    => tb_en
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
    -- Test case 1: Enable is '0', no data should be loaded
    tb_d <= "0001";
    tb_en <= '0';
    wait for 40 ns;

    -- Test case 2: Enable is '1', data should be loaded
    tb_en <= '1';
    tb_d <= "0010";
    wait for 40 ns;

    -- Test case 3: Change data while enabled
    tb_d <= "0100";
    wait for 40 ns;

    -- Test case 4: Disable enable, data should not change
    tb_en <= '0';
    tb_d <= "1000";
    wait for 40 ns;

    -- End simulation
    wait;
  end process;

end behavior;
