library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity alu_control is
    port (
        alu_control : in std_logic_vector(1 downto 0);
        funct3: in std_logic_vector(2 downto 0);
        funct7: in std_logic_vector(6 downto 0);
        control_out : out std_logic_vector(3 downto 0)
    );
    
end alu_control;

architecture arch of alu_control is

begin
    process(alu_control, funct3, funct7)
    begin
        case alu_control is
            when "00" => -- lw/sw [add]
                control_out <= "0000";

            when "01" => -- beq/bne [sub]
                case funct3 is
                    when "000" =>
                        control_out <= "1100"; -- ==
                    when "001" =>
                        control_out <= "1101"; -- !=
                    when "100" =>
                        control_out <= "1000"; -- A < B signed
                    when "101" =>
                        control_out <= "1010"; -- A >= B signed
                    when "110" =>
                        control_out <= "1001"; -- A < B unsigned
                    when "111" =>
                        control_out <= "1011"; -- A >= B unsigned
                    when others =>
                        control_out <= "1111"; -- nop
                end case;

            when "10" => -- logical-arithmetic
                case funct3 is
                    when "000" =>
                        control_out <= "0000"; -- ADD
                    when "010" =>
                        control_out <= "1000"; -- A < B signed
                    when "011" =>
                        control_out <= "1001"; -- A < B unsigned
                    when "100" =>
                        control_out <= "0100"; -- A XOR B
                    when "110" =>
                        control_out <= "0011"; -- A OR B
                    when "111" =>
                        control_out <= "0010"; -- A AND B
                    when "001" =>
                        control_out <= "0101"; -- A << B 
                    when "101" =>
                        if funct7(5) = '0' then
                            control_out <= "0110"; -- SRL 
                        else
                            control_out <= "0111"; -- SRA 
                        end if;
                    when others =>
                        control_out <= "1111"; -- nop
                end case;

            when "11" => 
                case funct3 is
                    when "000" =>
                        if funct7(5) = '0' then
                            control_out <= "0000"; -- ADD
                        else
                            control_out <= "0001"; -- SUB
                        end if;
                    when "010" =>
                        control_out <= "1000"; -- A < B signed
                    when "011" =>
                        control_out <= "1001"; -- A < B unsigned
                    when "100" =>
                        control_out <= "0100"; -- A XOR B
                    when "110" =>
                        control_out <= "0011"; -- A OR B
                    when "111" =>
                        control_out <= "0010"; -- A AND B
                    when "001" =>
                        control_out <= "0101"; -- A << B 
                    when "101" =>
                        if funct7(5) = '0' then
                            control_out <= "0110"; -- SRL 
                        else
                            control_out <= "0111"; -- SRA 
                        end if;
                    when others =>
                        control_out <= "1111"; -- nop
                end case;
            
            when others =>
                control_out <= "1111"; -- nop
        end case;
    end process;
end architecture ;