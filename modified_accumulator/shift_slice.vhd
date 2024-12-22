library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_slice is
    Generic (
        SLICE_WIDTH : integer := 16;  -- Largura do vetor
        SHIFT_AMOUNT : integer := 1   -- Quantidade fixa de deslocamento
    );
    Port (
        data_in  : in  std_logic_vector(SLICE_WIDTH-1 downto 0); -- Entrada
        shift_en : in  std_logic;                               -- Habilita o deslocamento
        data_out : out std_logic_vector(SLICE_WIDTH-1 downto 0) -- Saída
    );
end shift_slice;

architecture Behavioral of shift_slice is
begin
    process(data_in, shift_en)
    begin
        if shift_en = '1' then
            -- Deslocar o vetor
            data_out <= data_in(SLICE_WIDTH-1 downto SHIFT_AMOUNT) & std_logic_vector((others => '0'));
        else
            -- Sem deslocamento
            data_out <= data_in;
        end if;
    end process;
end Behavioral;
