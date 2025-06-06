library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity xRegs is
    port (
        clk, wren : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in signed(31 downto 0);
        ro1, ro2 : out signed(31 downto 0)
    );
    
end xRegs;

architecture arch of xRegs is

    type registers is array(0 to 31) of signed(31 downto 0);
    signal bank: registers := (others => (others => '0'));
    
begin

    process (bank, rs1, rs2)
    begin
        ro1 <= bank(to_integer(unsigned(rs1)));
        ro2 <= bank(to_integer(unsigned(rs2)));
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if (wren = '1') and (rd /= "00000") then
                bank(to_integer(unsigned(rd))) <= data;
            end if;
            bank(0) <= (others => '0'); 
        end if;
    end process;

end architecture ;