library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity tb_genImm32 is
end tb_genImm32;

architecture arch of tb_genImm32 is

    signal instrucao : std_logic_vector(31 downto 0);
    signal dado_imediato_gerado : signed(31 downto 0);

    component genImm32 
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );  
    end component;

begin

    gerador: genImm32 port map (
        instr => instrucao, 
        imm32 => dado_imediato_gerado
    );

    process
    begin
        instrucao <= x"000002b3";
        wait for 10ns;
        instrucao <= x"01002283";
        wait for 10ns;
        instrucao <= x"f9c00313";
        wait for 10ns;
        instrucao <= x"fff2c293";
        wait for 10ns;
        instrucao <= x"16200313";
        wait for 10ns;
        instrucao <= x"01800067";
        wait for 10ns;
        instrucao <= x"40a3d313";
        wait for 10ns;
        instrucao <= x"00002437";
        wait for 10ns;
        instrucao <= x"02542e23";
        wait for 10ns;
        instrucao <= x"fe5290e3";
        wait for 10ns;
        instrucao <= x"00c000ef";
        wait;
    end process;

end architecture;
    
