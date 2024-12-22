library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter is
    Generic (
        DATA_WIDTH : integer := 16 -- Largura do vetor
    );
    Port (
        data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Entrada
        shift_amt: in  integer range 0 to DATA_WIDTH-1;         -- Quantidade total de deslocamento
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0) -- Saída deslocada
    );
end barrel_shifter;

architecture Behavioral of barrel_shifter is
    -- Função para calcular o log2
    function log2(n : integer) return integer is
        variable result : integer := 0;
        variable value  : integer := n;
    begin
        while value > 1 loop
            value := value / 2;
            result := result + 1;
        end loop;
        return result;
    end function;

    -- Tipo de array para estágios intermediários
    type stage_array is array (0 to log2(DATA_WIDTH)) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal stages : stage_array;

    -- Componente shift_slice
    component shift_slice
        Generic (
            SLICE_WIDTH : integer;
            SHIFT_AMOUNT : integer
        );
        Port (
            data_in  : in  std_logic_vector(SLICE_WIDTH-1 downto 0);
            shift_en : in  std_logic;
            data_out : out std_logic_vector(SLICE_WIDTH-1 downto 0)
        );
    end component;
begin
    -- Primeira etapa recebe a entrada
    stages(0) <= data_in;

    -- Gerar instâncias dos shift slices
    gen_slices: for i in 0 to log2(DATA_WIDTH) - 1 generate
        shift_slice_inst: shift_slice
            Generic map (
                SLICE_WIDTH => DATA_WIDTH,
                SHIFT_AMOUNT => 2**i
            )
            Port map (
                data_in  => stages(i),
                shift_en => std_logic'(shift_amt >= 2**i),
                data_out => stages(i+1)
            );
    end generate;

    -- Última etapa é a saída
    data_out <= stages(log2(DATA_WIDTH));
end Behavioral;
