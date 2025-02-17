library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaRV is
    generic (WSIZE : natural := 32);
    port (
	opcode : in std_logic_vector(3 downto 0);
	A, B : in std_logic_vector(WSIZE-1 downto 0);
	Z : out std_logic_vector(WSIZE-1 downto 0);
        cond : out std_logic);
end ulaRV;

architecture rtl of ulaRV is
    signal a32 : std_logic_vector(WSIZE-1 downto 0);

begin
    Z <= a32;    
    process (A, B, opcode) is
    begin
	cond <= '0';
	a32 <= (others => '0');
	case opcode is
	    when "0000" => a32 <= std_logic_vector( signed(A) + signed(B) ); -- ADD
	    when "0001" => a32 <= std_logic_vector( signed(A) - signed(B) ); -- SUB
	    when "0010" => a32 <= A AND B; -- AND
	    when "0011" => a32 <= A OR B; -- OR
	    when "0100" => a32 <= A XOR B; -- XOR
	    when "0101" => a32 <= A sll to_integer(unsigned(B)); -- SLL
	    when "0110" => a32 <= A srl to_integer(unsigned(B)); -- SRL
	    when "0111" => a32 <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B)))); -- SRA
	    when "1000" =>  if ( signed(A) < signed(B)) then 
			        cond <= '1';
				a32(0) <= '1'; 
			    else 
				cond <= '0'; 
				a32(0) <= '0';
			    end if; --SLT
	    when "1001" =>  if ( unsigned(A) < unsigned(B)) then 
				cond <= '1'; 
				a32(0) <= '1'; 
			    else 
				cond <= '0';
				a32(0) <= '0';  
			    end if; --SLTU
	    when "1010" =>  if ( signed(A) >= signed(B)) then 
				cond <= '1';
				a32(0) <= '1';  
			    else 
				cond <= '0'; 
				a32(0) <= '0'; 
			    end if; -- SGE
	    when "1011" =>  if ( unsigned(A) >= unsigned(B)) then 
				cond <= '1';
				a32(0) <= '1';  
			    else 
				cond <= '0';
				a32(0) <= '0';  
			    end if; --SGEU
	    when "1100" =>  if ( A = B) then 
				cond <= '1';
				a32(0) <= '1';  
			    else 
				cond <= '0';
				a32(0) <= '0';  
			    end if; --SEQ
	    when "1101" =>  if ( A /= B) then 
				cond <= '1';
				a32(0) <= '1';  
			    else 
				cond <= '0';
				a32(0) <= '0';  
			    end if; --SNE
	    when others => cond <= '0';
	end case;
    end process;
end rtl;