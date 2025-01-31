library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity mux is
    port (
        A, B : in std_logic_vector(31 downto 0);
        S : in std_logic;
        C : out std_logic_vector(31 downto 0)
    );
    
end mux;

architecture arch of mux is
    
begin

    process (A, B, S)
    begin
        if S = '0' then
            C <= A;
        else
            C <= B;
        end if;
    end process;

end architecture ;