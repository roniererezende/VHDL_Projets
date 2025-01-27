library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity RAM_Input_Output_Address_Input_Output_Gate_tb  is

end RAM_Input_Output_Address_Input_Output_Gate_tb ;

--a arquitetura
architecture behavioral of RAM_Input_Output_Address_Input_Output_Gate_tb is

	component RAM_Input_Output_Address_Input_Output_Gate
		generic (
			data_size    : integer := 8; 
			address_size : integer := 8
		);
		port(
			clk      : in std_logic;
			rst      : in std_logic;
			
			en_W_R      : in std_logic; -- 1 -> WRITE / 0 -> READ
		
			input_data  : in std_logic_vector((data_size - 1) downto 0);
			in_address  : in std_logic_vector((address_size - 1) downto 0);
		
			out_address : in std_logic_vector((address_size - 1) downto 0);
		 
			output_data : out std_logic_vector((data_size - 1) downto 0)
		);
	end component;

	constant data_size : integer := 8;
	constant address_size : integer := 3;

	signal clk : std_logic := '0';
	signal rst : std_logic;
	signal en_W_R : std_logic := '1';
	signal input_data : std_logic_vector((data_size - 1) downto 0);
	signal in_address : std_logic_vector((address_size - 1) downto 0);
	signal out_address : std_logic_vector((address_size - 1) downto 0);
	signal output_data : std_logic_vector((data_size - 1) downto 0);

begin

	clk <= not clk after 10 ns;
	rst <= '0', '1' after 40 ns;
	
	process
	begin
		--inicio do reset
		input_data <= (others=>'Z');
		in_address <= "000";
		en_W_R <= '1';
		wait until rst = '1';
		
		--espera uma borda para alinhar com o clock e ficar bonito.
		wait until rising_edge(clk);
		
		--escreve no endere�o 3, data = A4 (10100100)
		input_data <= (2 downto 0 => "011", others=>'0');
		wait until rising_edge(clk);
		en_W_R <= '1';
		in_address <= "011";
		wait until rising_edge(clk);
		
		--escreve no endere�o 4, data = A5 (10100100)
		input_data <= (2 downto 0 => "100", others=>'0');
		wait until rising_edge(clk);
		en_W_R <= '1';
		in_address <= "100";
		wait until rising_edge(clk);
	
		--para garantir, vou zerar todos os controles.
		en_W_R <= '0';
		input_data <= (others=>'Z');
		wait until rising_edge(clk);
		
		--leitura addr 3
		en_W_R <= '0';
		out_address <= "011";
		wait until rising_edge(clk);
		
		--leitura addr 4
		en_W_R <= '0';
		out_address <= "100";
		wait until rising_edge(clk);
		
		wait;
	end process;

	ram_u : RAM_Input_Output_Address_Input_Output_Gate
		generic  map(
			data_size    => data_size, 
			address_size => address_size
		)

		port map (
			clk => clk,
			rst => rst,
			en_W_R => en_W_R,
			input_data => input_data, 
			in_address  => in_address,
			out_address => out_address, 
			output_data => output_data
		);

	
end behavioral;
