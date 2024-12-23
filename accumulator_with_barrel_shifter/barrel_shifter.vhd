library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter is
    generic (
        DATA_BITS_LOG2 : integer := 4  -- log2(DATA_WIDTH)
    );
    port (
        data_in  : in  std_logic_vector((2**DATA_BITS_LOG2)-1 downto 0);
        shift    : in  std_logic_vector(DATA_BITS_LOG2-1 downto 0);
        data_out : out std_logic_vector((2**DATA_BITS_LOG2)-1 downto 0)
    );
end barrel_shifter;

architecture behavioral of barrel_shifter is
begin
    process(data_in, shift)
        variable temp_data_var : unsigned((2**DATA_BITS_LOG2)-1 downto 0);
    begin
        temp_data_var := unsigned(data_in);
        temp_data_var := temp_data_var sll to_integer(unsigned(shift));
        data_out <= std_logic_vector(temp_data_var);
    end process;
end behavioral;
