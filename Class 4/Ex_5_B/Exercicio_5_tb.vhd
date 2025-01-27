library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity Exercicio_5_tb  is

end Exercicio_5_tb ;

--a arquitetura
architecture behavioral of Exercicio_5_tb  is

	component Exercicio_3
		generic (
			data_size    : integer := 8; 
			address_size : integer := 8
		);
		port(
			clk      : in std_logic;
			rst      : in std_logic;
			
			en_W_R   : in std_logic; -- 1 -> WRITE / 0 -> READ
			en_Out   : in std_logic; -- 1 -> ENABLE  / 0 -> DISABLE
		
			data_io  : inout std_logic_vector((data_size - 1) downto 0);
			in_address  : in std_logic_vector((address_size - 1) downto 0);
		
			out_address : in std_logic_vector((address_size - 1) downto 0)
		);
	end component;

	constant data_size : integer := 8;
	constant address_size : integer := 3;

	signal clk : std_logic := '0';
	signal rst : std_logic;
	signal en_W_R : std_logic := '1';
	signal en_Out : std_logic := '1';
	signal data_io : std_logic_vector((data_size - 1) downto 0);
	signal in_address : std_logic_vector((address_size - 1) downto 0);
	signal out_address : std_logic_vector((address_size - 1) downto 0);

begin
	clk <= not clk after 10 ns;
	rst <= '0', '1' after 40 ns;

	process

	begin
		data_io <= (others=>'Z');
		en_Out <= '0';
		en_W_R <= '0';
		wait until rst = '1';
		wait until rising_edge(clk);

		--escreve no endere�o 3, data = A4 (10100100)
		in_address <= "011";
		wait until rising_edge(clk);	
		en_W_R <= '1';
		data_io <= x"A4";
		wait until rising_edge(clk);

		--escreve no endere�o 4, data = A5 (10100100)
		in_address <= "100";
		wait until rising_edge(clk);
		en_W_R <= '1';
		data_io <= x"A5";
		wait until rising_edge(clk);
	
		en_Out <= '0';
		en_W_R <= '0';
		data_io <= (others=> 'Z');
		wait until rising_edge(clk);
		
		--leitura addr 3
		out_address <= "011";
		en_Out <= '1';
		data_io <= (others=> 'Z');
		wait until rising_edge(clk);
		
		wait until rising_edge(clk);
		--leitura addr 4
		out_address <= "100";
		en_Out <= '1';
		data_io <= (others=> 'Z');
		wait until rising_edge(clk);
		
		wait;

	end process;

	ram_u : Exercicio_3
		generic  map(
			data_size    => data_size, 
			address_size => address_size
		)

		port map (
			clk => clk,
			rst => rst,
			en_W_R => en_W_R,
			en_Out => en_Out,
			data_io => data_io, 
			in_address  => in_address,
			out_address => out_address 
		);

	
end behavioral;
