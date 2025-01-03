library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
  generic (
    ADDR_BITS       : integer range 2 to 8 := 4;
    DATA_BITS       : integer range 4 to 32 := 8;
    DATA_BITS_LOG2  : integer range 1 to 5 := 3
  );
  port (
    clock      : in  std_logic;
    write_addr : in  std_logic_vector(ADDR_BITS-1 downto 0);
    write_inc  : in  std_logic_vector(DATA_BITS-1 downto 0);
    read_addr  : in  std_logic_vector(ADDR_BITS-1 downto 0);
    read_data  : out std_logic_vector(DATA_BITS-1 downto 0)
  );
end entity;

architecture structural of accumulator is

  signal s_write_addr_stable : std_logic_vector(ADDR_BITS-1 downto 0);
  signal s_write_inc_stable  : std_logic_vector(DATA_BITS-1 downto 0);
  signal s_aux_read_data     : std_logic_vector(DATA_BITS-1 downto 0);
  signal s_stage1_read_data  : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_stage1_write_addr : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal s_stage1_write_inc  : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_stage2_result     : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
  signal s_stage2_write_addr : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal adder_a             : std_logic_vector(DATA_BITS-1 downto 0);
  signal adder_b             : std_logic_vector(DATA_BITS-1 downto 0);
  signal s_value_to_write    : std_logic_vector(DATA_BITS-1 downto 0);

begin

  addr_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => ADDR_BITS
    )
    port map (
      clock => clock,
      d     => write_addr,
      q     => s_write_addr_stable,
      en    => '1'
    );

  inc_reg : entity work.vector_register(behavioral)
    generic map (
      DATA_BITS => DATA_BITS
    )
    port map (
      clock => clock,
      d     => write_inc,
      q     => s_write_inc_stable,
      en    => '1'
    );

  process(clock)
    variable v_hazard : std_logic;
  begin
    if rising_edge(clock) then
      s_stage1_read_data  <= s_aux_read_data;
      s_stage1_write_addr <= s_write_addr_stable;
      s_stage1_write_inc  <= s_write_inc_stable;

      if (s_stage2_write_addr = s_write_addr_stable) then
        v_hazard := '1';
      else
        v_hazard := '0';
      end if;

      if v_hazard = '1' then
        adder_a <= s_stage2_result;
      else
        adder_a <= s_stage1_read_data;
      end if;
      adder_b <= s_stage1_write_inc;

      s_stage2_write_addr <= s_stage1_write_addr;
    end if;
  end process;

  adder : entity work.adder_n(structural)
    generic map (
      N => 2**DATA_BITS_LOG2
    )
    port map (
      a     => adder_a,
      b     => adder_b,
      c_in  => '0',
      s     => s_value_to_write,
      c_out => open
    );

  process (clock)
  begin
    if rising_edge(clock) then
      s_stage2_result <= s_value_to_write;
    end if;
  end process;

  memory : entity work.triple_port_ram(behavioral)
    generic map (
      ADDR_BITS => ADDR_BITS,
      DATA_BITS => DATA_BITS
    )
    port map (
      clock          => clock,
      write_addr     => s_stage2_write_addr,
      write_data     => s_stage2_result,
      read_addr      => read_addr,
      read_data      => read_data,
      aux_read_addr  => s_write_addr_stable,
      aux_read_data  => s_aux_read_data
    );

end structural;
