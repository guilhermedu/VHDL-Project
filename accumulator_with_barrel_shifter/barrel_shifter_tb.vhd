library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture behavior of barrel_shifter_tb is

    -- Component Declaration do barrel_shifter
    component barrel_shifter
        generic (
            DATA_BITS_LOG2 : integer := 4
        );
        port (
            data_in  : in  std_logic_vector((2**DATA_BITS_LOG2)-1 downto 0);
            shift    : in  std_logic_vector(DATA_BITS_LOG2-1 downto 0);
            data_out : out std_logic_vector((2**DATA_BITS_LOG2)-1 downto 0)
        );
    end component;

    -- Constantes
    constant DATA_BITS_LOG2 : integer := 4;
    constant DATA_WIDTH     : integer := 2**DATA_BITS_LOG2;  -- 16 bits

    -- Sinais
    signal data_in     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal shift       : std_logic_vector(DATA_BITS_LOG2-1 downto 0) := (others => '0');
    signal data_out    : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    -- Instanciação do barrel_shifter
    uut: barrel_shifter
        generic map (
            DATA_BITS_LOG2 => DATA_BITS_LOG2
        )
        port map (
            data_in  => data_in,
            shift    => shift,
            data_out => data_out
        );

    -- Processo de estímulo
    stim_proc: process
    begin
        -- Test Case 1: Shift por 0 bits
        data_in <= "0000000000010010";  -- Valor: 18 (16 bits)
        shift   <= "0000";              -- Shift por 0 bits
        wait for 10 ns;

        -- Test Case 2: Shift por 1 bit (2^0 = 1)
        shift   <= "0001";              -- Shift por 1 bit
        wait for 10 ns;

        -- Test Case 3: Shift por 3 bits (2^0 + 2^1 = 3)
        shift   <= "0011";              -- Shift por 3 bits
        wait for 10 ns;

        -- Test Case 4: Shift por 4 bits (2^2 = 4)
        shift   <= "0100";              -- Shift por 4 bits
        wait for 10 ns;

        -- Test Case 5: Shift por 5 bits (2^2 + 2^0 = 5)
        shift   <= "0101";              -- Shift por 5 bits
        wait for 10 ns;

        -- Test Case 6: Shift por 7 bits (2^2 + 2^1 + 2^0 = 7)
        shift   <= "0111";              -- Shift por 7 bits
        wait for 10 ns;

        -- Test Case 7: Shift por 15 bits (2^3 + 2^2 + 2^1 + 2^0 = 15)
        shift   <= "1111";              -- Shift por 15 bits
        wait for 10 ns;

        -- Test Case 8: Shift por 8 bits (2^3 = 8)
        shift   <= "1000";              -- Shift por 8 bits
        wait for 10 ns;

        -- Test Case 9: Shift por 10 bits (2^3 + 2^1 = 10)
        shift   <= "1010";              -- Shift por 10 bits
        wait for 10 ns;

        -- Test Case 10: Shift por valor máximo
        data_in <= "0000000011111111";  -- Valor: 255
        shift   <= "1111";              -- Shift por 15 bits
        wait for 10 ns;

        -- Finaliza a simulação
        wait;
    end process;

end behavior;
