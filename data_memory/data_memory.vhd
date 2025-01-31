library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use std.textio.all;

entity data_memory is
    port (
        we, re: in std_logic;
        addr: in std_logic_vector(11 downto 0);
        data_in: in std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0) := x"00000000"
    );
    
end data_memory;

architecture arch of data_memory is
    type mem is array (0 to 4095) of std_logic_vector(31 downto 0);
    signal andress: integer := 0;

    impure function init_memory return mem is

        file text_file: TEXT open read_mode is "data.txt";
        variable text_line: line;
        variable mem_content: mem;
        variable mem_content_bit_vector: bit_vector(31 downto 0) := (others => '0');

    begin
    
        for i in 0 to 4095 loop
            if(not endfile(text_file)) then
                readline(text_file, text_line);
                read(text_line, mem_content_bit_vector);
                mem_content(i) := to_stdlogicvector(mem_content_bit_vector);
            end if;
        end loop;

    end function;

    signal mem_ram : mem := init_memory;

begin
    process(we, re)
    begin
        if we = '1' then
            mem_ram(to_integer(unsigned(addr))) <= data_in;
        end if;

        if re = '1' then
            data_out <= mem_ram(to_integer(unsigned(addr)));
        end if;
    end process;
end architecture ;