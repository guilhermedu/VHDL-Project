library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_tb is
end full_adder_tb;

architecture behavior of full_adder_tb is

  -- Component declaration for the Unit Under Test (UUT)
  component full_adder is
    port(
      a     : in  std_logic;
      b     : in  std_logic;
      c_in  : in  std_logic;
      s     : out std_logic;
      c_out : out std_logic
    );
  end component;

  -- Testbench signals
  signal tb_a     : std_logic := '0';
  signal tb_b     : std_logic := '0';
  signal tb_c_in  : std_logic := '0';
  signal tb_s     : std_logic;
  signal tb_c_out : std_logic;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: full_adder port map (
    a     => tb_a,
    b     => tb_b,
    c_in  => tb_c_in,
    s     => tb_s,
    c_out => tb_c_out
  );

  -- Stimulus process
  stim_proc: process
  begin
    -- Test case 1: 0 + 0 + 0
    tb_a <= '0'; tb_b <= '0'; tb_c_in <= '0';
    wait for 50 ps;

    -- Test case 2: 0 + 0 + 1
    tb_a <= '0'; tb_b <= '0'; tb_c_in <= '1';
    wait for 50 ps;

    -- Test case 3: 0 + 1 + 0
    tb_a <= '0'; tb_b <= '1'; tb_c_in <= '0';
    wait for 50 ps;

    -- Test case 4: 0 + 1 + 1
    tb_a <= '0'; tb_b <= '1'; tb_c_in <= '1';
    wait for 50 ps;

    -- Test case 5: 1 + 0 + 0
    tb_a <= '1'; tb_b <= '0'; tb_c_in <= '0';
    wait for 50 ps;

    -- Test case 6: 1 + 0 + 1
    tb_a <= '1'; tb_b <= '0'; tb_c_in <= '1';
    wait for 50 ps;

    -- Test case 7: 1 + 1 + 0
    tb_a <= '1'; tb_b <= '1'; tb_c_in <= '0';
    wait for 50 ps;

    -- Test case 8: 1 + 1 + 1
    tb_a <= '1'; tb_b <= '1'; tb_c_in <= '1';
    wait for 50 ps;

    -- End simulation
    wait;
  end process;

end behavior;
