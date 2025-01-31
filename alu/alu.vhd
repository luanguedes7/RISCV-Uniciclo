library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all;

entity alu is
    port (
        opcode : in std_logic_vector(3 downto 0);
        A, B : in std_logic_vector(31 downto 0);
        Z : out std_logic_vector(31 downto 0);
        cond : out std_logic
        );

end alu;

architecture arch of alu is

    signal result : signed(31 downto 0) := (others => '0');
    signal flag : std_logic := "0";
    type operations is (OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SRA,
    OP_SLT, OP_SLTU, OP_SGE, OP_SGEU, OP_SEQ, OP_SNE);
    signal operation: operations;
    
begin

    with opcode select
        operation <=
            OP_ADD when "0000",
            OP_SUB when "0001",
            OP_AND when "0010",
            OP_OR when "0011",
            OP_XOR when "0100",
            OP_SLL when "0101",
            OP_SRL when "0110",
            OP_SRA when "0111",
            OP_SLT when "1000",
            OP_SLTU when "1001",
            OP_SGE when "1010",
            OP_SGEU when "1011",
            OP_SEQ when "1100",
            SNE_ when "1101";

    process (A, B, operation)
    begin
        case operation is
            when OP_ADD =>
                result <= (others => '0');
                result <= A + B;
                flag <= '0';

            when OP_SUB =>
                result <= (others => '0');
                result <= A - B;
                flag <= '0';

            when OP_AND =>
                result <= (others => '0');
                result <= A and B;
                flag <= '0';

            when OP_OR =>
                result <= (others => '0');
                result <= A or B;
                flag <= '0';

            when OP_XOR =>
                result <= (others => '0');
                result <= A xor B;
                flag <= '0';

            when OP_SLL =>
                result <= (others => '0');
                result <= A sll to_integer(unsigned(B(4 downto 0)));
                flag <= '0';

            when OP_SRL =>
                result <= (others => '0');
                result <= A srl to_integer(unsigned(B(4 downto 0)));
                flag <= '0';

            when OP_SRA =>
                result <= (others => '0');
                result <= shift_right(A, to_integer(unsigned(B(4 downto 0))));
                flag <= '0';

            when OP_SLT =>
                if A < B then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when OP_SLTU =>
                if unsigned(A) < unsigned(B) then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when OP_SGE =>
                if A >= B then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when OP_SGEU =>
                if unsigned(A) >= unsigned(B) then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when OP_SEQ =>
                if A = B then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when SNE_ =>
                if A /= B then
                    result <= (others => '0');
                    result(0) <= '1';
                    flag <= '1';
                else
                    result <= (others => '0');
                    flag <= '0';
                end if;

            when others =>
                result <= (others => '0');
                flag <= '0';
        end case;
    end process;

    Z <= result;
    cond <= flag;

end architecture ;
    