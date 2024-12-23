library IEEE;
use IEEE.std_logic_1164.all;

entity and_gate_2_tb is
end and_gate_2_tb;

architecture behavior of and_gate_2_tb is

  -- Component declaration for the Unit Under Test (UUT)
  component and_gate_2 is
    port(
      input0  : in  std_logic;
      input1  : in  std_logic;
      output0 : out std_logic
    );
  end component;

  -- Testbench signals
  signal tb_input0  : std_logic := '0';
  signal tb_input1  : std_logic := '0';
  signal tb_output0 : std_logic;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: and_gate_2 port map (
    input0  => tb_input0,
    input1  => tb_input1,
    output0 => tb_output0
  );

  -- Stimulus process
  stim_proc: process
  begin
    -- Test case 1: Both inputs are '0'
    tb_input0 <= '0';
    tb_input1 <= '0';
    wait for 50 ps;

    -- Test case 2: First input is '1', second is '0'
    tb_input0 <= '1';
    tb_input1 <= '0';
    wait for 50 ps;

    -- Test case 3: First input is '0', second is '1'
    tb_input0 <= '0';
    tb_input1 <= '1';
    wait for 50 ps;

    -- Test case 4: Both inputs are '1'
    tb_input0 <= '1';
    tb_input1 <= '1';
    wait for 50 ps;

    -- End of simulation
    wait;
  end process;

end behavior;
