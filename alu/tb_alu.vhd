library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture arch of tb_alu is

    signal opcode: std_logic_vector(3 downto 0);
    signal A, B: signed(31 downto 0);
    signal result: signed(31 downto 0);
    signal flag: std_logic;

    component ulaRV 
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in signed(31 downto 0);
            Z : out signed(31 downto 0);
            cond : out std_logic
        );  
    end component;

begin

    gerador: ulaRV port map (
        opcode => opcode, 
        A => A,
        B => B,
        Z => result,
        cond => flag
    );

    process
    begin
        opcode <= "0000"; -- ADD (pos)
        A <= x"00000001";
        B <= x"00000020";
        wait for 10 ns;

        opcode <= "0000"; -- ADD (zero)
        A <= x"00000000";
        B <= x"00000000";
        wait for 10 ns;

        opcode <= "0001"; -- SUB (neg)
        A <= x"00000001";
        B <= x"00000020";
        wait for 10 ns;

        opcode <= "0010"; -- AND
        A <= x"0000000F";
        B <= x"000000F0";
        wait for 10 ns;

        opcode <= "0011"; -- OR
        A <= x"0000000F";
        B <= x"000000F0";
        wait for 10 ns;

        opcode <= "0100"; -- XOR
        A <= x"0000000F";
        B <= x"000000F0";
        wait for 10 ns;

        opcode <= "0101"; -- SLL
        A <= x"00000001";
        B <= x"00000003";
        wait for 10 ns;

        opcode <= "0110"; -- SRL
        A <= x"00000004";
        B <= x"00000002";
        wait for 10 ns;

        opcode <= "0111"; -- SRA
        A <= x"FEFFFFF0";
        B <= x"00000001";
        wait for 10 ns;

        opcode <= "1000"; -- SLT
        A <= x"00000020";
        B <= x"00000001";
        wait for 10 ns;

        opcode <= "1001"; -- SLTU
        A <= x"00000020";
        B <= x"00000001";
        wait for 10 ns;

        opcode <= "1010"; -- SGE
        A <= x"00000001";
        B <= x"00000020";
        wait for 10 ns;

        opcode <= "1011"; -- SGEU
        A <= x"00000001";
        B <= x"00000020";
        wait for 10 ns;

        opcode <= "1100"; -- SEQ
        A <= x"00000001";
        B <= x"00000001";
        wait for 10 ns;

        opcode <= "1101"; -- SNE
        A <= x"00000001";
        B <= x"00000020";
        wait for 10 ns;
        wait;
    end process;

end architecture;
    