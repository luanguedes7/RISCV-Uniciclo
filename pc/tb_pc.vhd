library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all;

entity tb_pc is
end tb_pc;

architecture arch of tb_pc is

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal pc_in : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.pc
    port map (
        clk => clk,
        rst => rst,
        pc_in => pc_in,
        pc_out => pc_out
    );

-- Clock process
process
begin
    while now < 200 ns loop
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end loop;
    wait;
end process;

-- Stimulus process
process
begin
    -- Test reset condition
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    
    -- Test sequential behavior
    pc_in <= x"00000010";
    wait for CLK_PERIOD;
    
    pc_in <= x"00000020";
    wait for CLK_PERIOD;
    
    pc_in <= x"00000030";
    wait for CLK_PERIOD;
    
    -- Activate reset mid-sequence
    rst <= '1';
    wait for CLK_PERIOD;
    rst <= '0';
    
    -- Continue testing
    pc_in <= x"00000040";
    wait for CLK_PERIOD;
    
    -- Finish simulation
    wait;
end process;

end architecture;
    