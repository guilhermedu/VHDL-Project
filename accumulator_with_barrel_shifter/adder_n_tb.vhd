library IEEE;
use IEEE.std_logic_1164.all;

entity adder_n_tb is
end adder_n_tb;

architecture behavior of adder_n_tb is

  -- Component declaration for the Unit Under Test (UUT)
  component adder_n is
    generic(
      N : positive := 8
    );
    port(
      a     : in  std_logic_vector(N-1 downto 0);
      b     : in  std_logic_vector(N-1 downto 0);
      c_in  : in  std_logic;
      s     : out std_logic_vector(N-1 downto 0);
      c_out : out std_logic
    );
  end component;

  -- Testbench constants and signals
  constant N : positive := 8;
  signal tb_a     : std_logic_vector(N-1 downto 0) := (others => '0');
  signal tb_b     : std_logic_vector(N-1 downto 0) := (others => '0');
  signal tb_c_in  : std_logic := '0';
  signal tb_s     : std_logic_vector(N-1 downto 0);
  signal tb_c_out : std_logic;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: adder_n
    generic map(
      N => N
    )
    port map(
      a     => tb_a,
      b     => tb_b,
      c_in  => tb_c_in,
      s     => tb_s,
      c_out => tb_c_out
    );

  -- Stimulus process
  stim_proc: process
  begin
    -- Test case 1: Add two zeros
    tb_a <= "00000000";
    tb_b <= "00000000";
    tb_c_in <= '0';
    wait for 100 ps;

    -- Test case 2: Add 1 + 1 with no carry in
    tb_a <= "00000001";
    tb_b <= "00000001";
    tb_c_in <= '0';
    wait for 100 ps;

    -- Test case 3: Add 1 + 1 with carry in
    tb_a <= "00000001";
    tb_b <= "00000001";
    tb_c_in <= '1';
    wait for 100 ps;

    -- Test case 4: Add 255 + 1 (overflow case)
    tb_a <= "11111111";
    tb_b <= "00000001";
    tb_c_in <= '0';
    wait for 100 ps;

    -- Test case 5: Add 128 + 128 (carry out case)
    tb_a <= "10000000";
    tb_b <= "10000000";
    tb_c_in <= '0';
    wait for 100 ps;

    -- Test case 6: Add 85 + 85 (binary pattern)
    tb_a <= "01010101";
    tb_b <= "01010101";
    tb_c_in <= '0';
    wait for 100 ps;

    -- End simulation
    wait;
  end process;

end behavior;
