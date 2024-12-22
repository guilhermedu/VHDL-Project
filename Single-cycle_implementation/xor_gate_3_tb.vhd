library IEEE;
use IEEE.std_logic_1164.all;

entity xor_gate_3_tb is
end xor_gate_3_tb;

architecture behavior of xor_gate_3_tb is
  component xor_gate_3 is
    port(
      input0  : in  std_logic;
      input1  : in  std_logic;
      input2  : in  std_logic;
      output0 : out std_logic
    );
  end component;

  -- Testbench signals
  signal tb_input0  : std_logic := '0';
  signal tb_input1  : std_logic := '0';
  signal tb_input2  : std_logic := '0';
  signal tb_output0 : std_logic;

begin
  uut: xor_gate_3 port map (
    input0  => tb_input0,
    input1  => tb_input1,
    input2  => tb_input2,
    output0 => tb_output0
  );

  -- Stimulus process
  stim_proc: process
  begin
    -- Test case 1: All inputs are '0'
    tb_input0 <= '0';
    tb_input1 <= '0';
    tb_input2 <= '0';
    wait for 50 ps;

    -- Test case 2: One input is '1'
    tb_input0 <= '1';
    tb_input1 <= '0';
    tb_input2 <= '0';
    wait for 50 ps;

    -- Test case 3: Two inputs are '1'
    tb_input0 <= '1';
    tb_input1 <= '1';
    tb_input2 <= '0';
    wait for 50 ps;

    -- Test case 4: All inputs are '1'
    tb_input0 <= '1';
    tb_input1 <= '1';
    tb_input2 <= '1';
    wait for 50 ps;

    -- Test case 5: Alternating inputs
    tb_input0 <= '0';
    tb_input1 <= '1';
    tb_input2 <= '1';
    wait for 50 ps;

    -- Test case 6: Another alternating pattern
    tb_input0 <= '1';
    tb_input1 <= '0';
    tb_input2 <= '1';
    wait for 50 ps;

    -- Stop simulation
    wait;
  end process;

end behavior;
