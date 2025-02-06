
library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity control is
    port (
	opcode : in std_logic_vector(6 downto 0);
	branch : out std_logic;
	mem_read : out std_logic;
	mem_to_reg : out std_logic;
	alu_op : out std_logic_vector(1 downto 0);
	mem_write : out std_logic;
	alu_src: out std_logic;
	reg_write: out std_logic;
	reg_write_src : out std_logic_vector(1 downto 0)
    );
end control;

architecture arc of control is
begin
    process (opcode) is
    begin
	case opcode is
	    when "0110011" => -- R type
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "11";
		mem_write <= '0';
		alu_src <= '0';
		reg_write <= '1';
		reg_write_src <= "00";
	    when "0010011" => -- I type (logic)
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "10";
		mem_write <= '0';
		alu_src <= '1';
		reg_write <= '1';
		reg_write_src <= "00";
	    when "0000011" => -- I type (load)
		branch <= '0';
		mem_read <= '1';
		mem_to_reg <= '1';
		alu_op <= "00";
		mem_write <= '0';
		alu_src <= '1';
		reg_write <= '1';
		reg_write_src <= "00";
	    when "1100111" => -- I type (jaur)
		branch <= '1';
		mem_read <= '1';
		mem_to_reg <= '1';
		alu_op <= "00";
		mem_write <= '0';
		alu_src <= '1';
		reg_write <= '1';
		reg_write_src <= "11";
	    when "0100011" => -- S type
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "00";
		mem_write <= '1';
		alu_src <= '1';
		reg_write <= '0';
		reg_write_src <= "00";
	    when "1100011" => -- SB type
		branch <= '1';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "10";
		mem_write <= '0';
		alu_src <= '0';
		reg_write <= '0';
		reg_write_src <= "00";
	    when "0110111" => -- U type (lui)
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "00";
		mem_write <= '0';
		alu_src <= '0';
		reg_write <= '1';
		reg_write_src <= "01";
	    when "0010111" => -- U type (aiupc)
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "00";
		mem_write <= '0';
		alu_src <= '0';
		reg_write <= '1';
		reg_write_src <= "10";
	when others =>
		branch <= '0';
		mem_read <= '0';
		mem_to_reg <= '0';
		alu_op <= "00";
		mem_write <= '0';
		alu_src <= '0';
		reg_write <= '0';
		reg_write_src <= "00";
	end case;
    end process;

end arc;

