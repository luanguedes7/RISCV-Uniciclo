
library ieee ;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity unicycle_riscv is
    port (
	clk : in std_logic;
	pc_rst : in std_logic
    );
end unicycle_riscv;

architecture arch of unicycle_riscv is
    constant WSIZE : natural := 32;

    signal pc_in : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
    signal pc_out : std_logic_vector(WSIZE-1 downto 0);
    component pc is
    	port (
            pc_in : in std_logic_vector(31 downto 0);
            clk, rst : in std_logic;
            pc_out : out std_logic_vector(31 downto 0)
    	);
    end component;

    signal instr : std_logic_vector(WSIZE-1 downto 0) := (others => '0');

    component instruction_memory is
    	port (
            data_in : in std_logic_vector(11 downto 0);
            data_out : out std_logic_vector(31 downto 0)
    	);
    end component;

    constant four : std_logic_vector(WSIZE-1 downto 0) := std_logic_vector(to_signed(4, WSIZE));
    signal next_pc : std_logic_vector(WSIZE-1 downto 0);
    signal immediate : signed(WSIZE-1 downto 0);
    signal pc_branch : std_logic_vector(WSIZE-1 downto 0);

    component adder is
    port (
        A, B : in std_logic_vector(31 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
    end component;
    
    signal branch_or_jump : std_logic := '0';

   component mux is
    	port (
            A, B : in std_logic_vector(31 downto 0);
            S : in std_logic;
            C : out std_logic_vector(31 downto 0)
        );
    end component;

    signal branch : std_logic;
    signal mem_read : std_logic;
    signal mem_to_reg : std_logic;
    signal alu_op : std_logic_vector(1 downto 0);
    signal mem_write : std_logic;
    signal alu_src : std_logic;
    signal reg_write : std_logic;
    signal reg_write_src : std_logic_vector(1 downto 0);
    signal mem_byte_en : std_logic;
    signal mem_sgn_en : std_logic;

    component control is
    port (
	opcode : in std_logic_vector(6 downto 0);
	func3 : in std_logic_vector(2 downto 0);
	branch : out std_logic;
	mem_read : out std_logic;
	mem_to_reg : out std_logic;
	alu_op : out std_logic_vector(1 downto 0);
	mem_write : out std_logic;
	alu_src: out std_logic;
	reg_write: out std_logic;
	reg_write_src : out std_logic_vector(1 downto 0);
	mem_byte_en : out std_logic;
	mem_sgn_en : out std_logic
    );
    end component;

    signal xReg_data : std_logic_vector(WSIZE-1 downto 0);
    signal ro1 : signed(WSIZE-1 downto 0);
    signal ro2 : signed(WSIZE-1 downto 0);

    component xRegs is
    	port (
            clk, wren : in std_logic;
            rs1, rs2, rd : in std_logic_vector(4 downto 0);
            data : in signed(31 downto 0);
            ro1, ro2 : out signed(31 downto 0)
	);
    end component;
    
    component genImm32 is
    	port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
	);
    end component;

    signal alu_opcode : std_logic_vector(3 downto 0);

    component alu_control is
    	port (
            alu_control : in std_logic_vector(1 downto 0);
            funct3: in std_logic_vector(2 downto 0);
            funct7: in std_logic_vector(6 downto 0);
            control_out : out std_logic_vector(3 downto 0)
	);
    end component;
 
    signal alu_B : std_logic_vector(WSIZE-1 downto 0);
    signal cond : std_logic;
    signal alu_out : std_logic_vector(WSIZE-1 downto 0);

    component ulaRV is
    	generic (WSIZE : natural := 32);
    	port (
	    opcode : in std_logic_vector(3 downto 0);
	    A, B : in std_logic_vector(WSIZE-1 downto 0);
	    Z : out std_logic_vector(WSIZE-1 downto 0);
            cond : out std_logic
	);
    end component;

    signal mem_data_out : std_logic_vector(WSIZE-1 downto 0);
    signal reg_write_data : std_logic_vector(WSIZE-1 downto 0);

    component data_memory is
    	port (
            clk, we, byte_en, sgn_en : in std_logic;
            address: in std_logic_vector(12 downto 0);
            datain: in std_logic_vector(31 downto 0);
            dataout: out std_logic_vector(31 downto 0) := x"00000000"
    	);
    end component;

    component mux4 is
        port (
            A, B, C, D : in std_logic_vector(31 downto 0);
            S : in std_logic_vector(1 downto 0);
            X : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    pc_reg : pc
    port map (
	clk => clk,
	pc_in => pc_in,
	rst => pc_rst,
	pc_out => pc_out
    );
    
    intr_mem : instruction_memory
    port map (
	data_in => pc_out(11 downto 0),
	data_out => instr
    );

    next_pc_adder : adder
    port map (
	A => pc_out,
	B => four,
	S => next_pc
    );

    pc_branch_adder : adder
    port map (
	A => pc_out,
	B => std_logic_vector(immediate),
	S => pc_branch
    );

    pc_mux : mux
    port map (
	A => next_pc,
   	B => pc_branch,
        S => branch_or_jump,
    	C => pc_in
    );

    ctrl : control
    port map (
       	opcode => instr(6 downto 0),
	func3 => instr(14 downto 12),
      	branch => branch,
     	mem_read => mem_read,
	mem_to_reg => mem_to_reg,
   	alu_op => alu_op,
	mem_write => mem_write,
	alu_src => alu_src,
	reg_write => reg_write,
	reg_write_src => reg_write_src,
	mem_byte_en => mem_byte_en,
	mem_sgn_en => mem_sgn_en
    );

    reg_bank : xRegs
    port map (
	clk => clk,
	wren => reg_write,
	rs1 => instr(19 downto 15),
	rs2 => instr(24 downto 20),
  	rd => instr(11 downto 7),
	data => signed(xReg_data),
	ro1 => ro1,
	ro2 => ro2
    );

    gen_imm : genImm32
    port map (
	instr => instr,
	imm32 => immediate
    );

    alu_mux : mux
    port map (
	A => std_logic_vector(ro2),
	B => std_logic_vector(immediate),
	S => alu_src,
	C => alu_B
    );

    alu_ctr : alu_control
    port map (
	alu_control => alu_op,
	funct3 => instr(14 downto 12),
	funct7 => instr(31 downto 25),	control_out => alu_opcode
    );

    alu : ulaRV
    port map (
	opcode => alu_opcode,
  	A => std_logic_vector(ro1),
	B => alu_B,
	Z => alu_out,
	cond => cond
    );

    data_mem : data_memory
    port map(
	clk => clk,
	we => mem_write,
	byte_en => mem_byte_en,
	sgn_en => mem_sgn_en,
	address => alu_out(12 downto 0),
	datain => std_logic_vector(ro2),
	dataout => mem_data_out
    );
    
    data_mem_mux : mux
    port map (
	A => alu_out,
	B => mem_data_out,
	S => mem_to_reg,
	C => reg_write_data
   );

    process (branch, cond, reg_write_src) is
    begin
        branch_or_jump <= (branch and cond) or (reg_write_src(0) and reg_write_src(1)); 
    end process;

    xReg_data_mux : mux4
    port map (
	A => reg_write_data,
	B => std_logic_vector(immediate),
	C => pc_branch,
	D => next_pc,
	S => reg_write_src,
	X => xReg_data
    );


end arch;