library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity adder is
    port (
        A, B : in std_logic_vector(31 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
    
end adder;

architecture arch of adder is
    
begin
    
    S <= std_logic_vector(unsigned(A) + unsigned(B));

end architecture ;