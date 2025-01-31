library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all;

entity tb_xRegs is
end tb_xRegs;

architecture arch of tb_xRegs is

    signal clk, wren: std_logic;
    signal rs1, rs2, rd: std_logic_vector(4 downto 0);
    signal data: signed(31 downto 0);
    signal ro1, ro2 : signed(31 downto 0);

    component xRegs 
        port (
            clk, wren : in std_logic;
            rs1, rs2, rd : in std_logic_vector(4 downto 0) := (others => '0');
            data : in signed(31 downto 0) := (others => '0');
            ro1, ro2 : out signed(31 downto 0)
        );  
    end component;

begin

    gerador: xRegs port map (
        clk => clk, 
        wren => wren,
        rs1 => rs1,
        rs2 => rs2,
        rd => rd,
        data => data,
        ro1 => ro1,
        ro2 => ro2
    );

    process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns / 2;
            clk <= '1';
            wait for 10 ns / 2;
        end loop;
    end process;

    process
    begin
        -- Preenche o banco de registradores com uma sequência de valores
        for i in 1 to 31 loop
            wren <= '1';
            rd <= std_logic_vector(to_unsigned(i, 5)); -- Registrador i
            data <= to_signed(i * 10, 32); 
            wait for 10 ns;
        end loop;
        wren <= '0';

        -- Verifica se os valores escritos estão corretos
        for i in 1 to 31 loop
            rs1 <= std_logic_vector(to_unsigned(i, 5)); -- Registrador i
            rs2 <= std_logic_vector(to_unsigned(i, 5)); -- Registrador i
            wait for 10 ns;

            assert ro1 = to_signed(i * 10, 32) and ro2 = to_signed(i * 10, 32)
                report "Erro: Valor lido do registrador " & integer'image(i) & " está incorreto!" severity failure;
        end loop;

        -- Verifica registrador zero
        wren <= '1';
        rd <= "00000"; 
        data <= to_signed(12345, 32); 
        wait for 10 ns;
        wren <= '0';

        rs1 <= "00000"; 
        rs2 <= "00000"; 
        wait for 10 ns;

        assert ro1 = 0 and ro2 = 0
            report "Erro: Registrador 0 foi alterado, mas deveria permanecer zero!" severity failure;

        -- Finalização do teste
        report "Todos os testes foram concluídos com sucesso!" severity note;
        wait;
    end process;


end architecture;
    