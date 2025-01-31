library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity pc is
    port (
        pc_in : in std_logic_vector(31 downto 0);
        clk, rst : in std_logic;
        pc_out : out std_logic_vector(31 downto 0)
    );
    
end pc;

architecture arch of pc is
    
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pc_out <= x"00000000";
            else
                pc_out <= pc_in;
            end if;
        end if;
    end process;

end architecture ;