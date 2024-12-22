library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture Behavioral of barrel_shifter_tb is
    constant DATA_WIDTH : integer := 16;

    -- Sinais de entrada e saída
    signal data_in  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal shift_amt: integer range 0 to DATA_WIDTH-1;
    signal data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Instância do Barrel Shifter
    component barrel_shifter
        Generic (
            DATA_WIDTH : integer
        );
        Port (
            data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            shift_amt: in  integer range 0 to DATA_WIDTH-1;
            data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
begin
    -- Instância do Barrel Shifter
    uut: barrel_shifter
        Generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        Port map (
            data_in => data_in,
            shift_amt => shift_amt,
            data_out => data_out
        );

    -- Processo de estímulo
    stim_proc: process
    begin
        -- Teste 1: Nenhum deslocamento
        data_in <= "1010101010101010";
        shift_amt <= 0;
        wait for 10 ns;

        -- Teste 2: Deslocar por 1
        shift_amt <= 1;
        wait for 10 ns;

        -- Teste 3: Deslocar por 2
        shift_amt <= 2;
        wait for 10 ns;

        -- Teste 4: Deslocar por 4
        shift_amt <= 4;
        wait for 10 ns;

        -- Teste 5: Deslocar por 8
        shift_amt <= 8;
        wait for 10 ns;

        -- Finaliza a simulação
        wait;
    end process;
end Behavioral;
