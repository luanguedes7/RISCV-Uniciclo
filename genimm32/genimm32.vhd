library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.alC

entity genImm32 is
    port (
        instr : in std_logic_vector(31 downto 0);
        imm32 : out signed(31 downto 0)
    );
end genImm32;

architecture arch of genImm32 is

    signal opcode: unsigned(7 downto 0);
    signal funct3: unsigned(2 downto 0);
    signal tipo_i_instr: unsigned(3 downto 0);
    signal imm32I: signed(31 downto 0);
    signal bit30: std_logic;

begin
    opcode <= resize(unsigned(instr(6 downto 0)), 8);
    funct3 <= unsigned(instr(14 downto 12));
    bit30 <= instr(30); 
    tipo_i_instr <= bit30 & funct3;

    with tipo_i_instr select
    imm32I <=
        resize(signed(instr(24 downto 20)), 32) when "1101",
        resize(signed(instr(31 downto 20)), 32) when others;

    with opcode select
    imm32 <=
        to_signed(0, 32) when x"33", -- Instru��o R_type
        imm32I when x"03" | x"13" | x"67", -- Instru��o I_type
        resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32) when x"23", -- Instru��o S_type
        resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32) when x"63", -- Instru��o SB_type
        resize(signed(instr(31 downto 12) & x"000"), 32) when x"37", -- Instru��o U_type
        resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32) when x"6F", -- Instru��o UJ_type
	to_signed(0, 32) when others; -- Instru��o R_type

end architecture ;