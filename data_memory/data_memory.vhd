library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use std.textio.all;

entity data_memory is
    port (
        clk, we, byte_en, sgn_en : in std_logic;
        address: in std_logic_vector(12 downto 0);
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0) := x"00000000"
    );
    
end data_memory;

architecture arch of data_memory is
    type mem is array (0 to 8191) of std_logic_vector(7 downto 0);

    impure function init_memory return mem is

        file text_file: TEXT open read_mode is "data.txt";
        variable text_line: line;
        variable mem_content: mem := (others => (others => '0'));
        variable mem_content_bit_vector: bit_vector(31 downto 0) := (others => '0');

    begin
    
        for i in 0 to 2047 loop
            if(not endfile(text_file)) then
                readline(text_file, text_line);
                read(text_line, mem_content_bit_vector);
                mem_content(i*4) := to_stdlogicvector(mem_content_bit_vector)(7 downto 0);
		mem_content(i*4+1) := to_stdlogicvector(mem_content_bit_vector)(15 downto 8);
		mem_content(i*4+2) := to_stdlogicvector(mem_content_bit_vector)(23 downto 16);
		mem_content(i*4+3) := to_stdlogicvector(mem_content_bit_vector)(31 downto 24);
            end if;
        end loop;
	return mem_content;
    end function;

    signal mem_ram : mem := init_memory;

begin
    process(address, clk, byte_en, sgn_en)
    begin
        if rising_edge(clk) then
            if we = '1' then
		if byte_en = '1' then
		    mem_ram(to_integer(unsigned(address))) <= datain(7 downto 0);
		else
       		    mem_ram(to_integer(unsigned(address(12 downto 2)))*4) <= datain(7 downto 0);
		    mem_ram(to_integer(unsigned(address(12 downto 2)))*4+1) <= datain(15 downto 8);
		    mem_ram(to_integer(unsigned(address(12 downto 2)))*4+2) <= datain(23 downto 16);
		    mem_ram(to_integer(unsigned(address(12 downto 2)))*4+3) <= datain(31 downto 24);
		end if;
            end if;
	end if;

        if byte_en = '1' then
	    if sgn_en = '1' then   
          	dataout <= std_logic_vector(resize(signed(mem_ram(to_integer(unsigned(address)))), 32));
	    else
		dataout <= std_logic_vector(resize(unsigned(mem_ram(to_integer(unsigned(address)))), 32));
	    end if;
	else
	    dataout <= mem_ram(to_integer(unsigned(address(12 downto 2)))*4+3) & mem_ram(to_integer(unsigned(address(12 downto 2)))*4+2) & 
			   mem_ram(to_integer(unsigned(address(12 downto 2)))*4+1) & mem_ram(to_integer(unsigned(address(12 downto 2)))*4);
        end if;
   end process;
end architecture ;