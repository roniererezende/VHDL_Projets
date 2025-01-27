library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity exercicio_5_tb is

end exercicio_5_tb;

--a arquitetura
architecture behavioral of exercicio_5_tb is

	component exercicio_3
		generic (
			data_address_size : integer := 8
		);
	
		port(
			clk        : in std_logic;
			rst        : in std_logic;
			
			en_W_R     : in std_logic; -- 1 -> WRITE / 0 -> READ
			en_Out     : in std_logic;
		
			data_address_sel : in std_logic; -- 1 -> DATA / 0 -> ADDRESS
		
			data_address_io : inout std_logic_vector((data_address_size - 1) downto 0)
		);
	end component;

	signal rst : std_logic;
	signal clk : std_logic := '0';
	signal en_Out  : std_logic;
	signal en_W_R  : std_logic;
	signal data_address_sel : std_logic;
	signal data_address_io : std_logic_vector(7 downto 0);

	constant clk_period : time := 20 ns;

begin

	clk  <= not clk after 10 ns;
	rst <= '0', '1' after 10 ns;
	
	process
	begin
		--inicio do reset
		data_address_io <= (others=>'Z');
		en_Out  <= '0';
		en_W_R  <= '0';
		data_address_sel <= '0';
		wait until rst = '0';
		
		--espera uma borda para alinhar com o clock e ficar bonito.
		wait until rising_edge(clk);
		
		--escreve no endere�o 3, data = A4 (10100100)
		data_address_sel <= '1';
		--data_address_io <= (2 downto 0 => "011", others=>'0');
		data_address_io <= "00000011";
		wait until rising_edge(clk);
		data_address_sel <= '0';
		en_W_R  <= '1';
		data_address_io <= x"A4";
		wait until rising_edge(clk);
		
		--escreve no endere�o 4, data = A5 (10100100)
		data_address_sel <= '1';
		--data_address_io <= (2 downto 0 => "100", others=>'0');
		data_address_io <= "00000100";
		wait until rising_edge(clk);
		data_address_sel <= '0';
		en_W_R  <= '1';
		data_address_io <= x"A5";
		wait until rising_edge(clk);
		
		--para garantir, vou zerar todos os controles.
		en_Out  <= '0';
		en_W_R  <= '0';
		data_address_sel <= '0';
		data_address_io <= (others=>'Z');
		wait until rising_edge(clk);
		
		--leitura addr 3
		data_address_sel <= '1';
		--data_address_io <= (2 downto 0 => "011", others=>'0');
		data_address_io <= "00000011";
		wait until rising_edge(clk);
		en_Out  <= '1';
		--data_address_io <= (others=>'Z');	
		data_address_sel <= '0';
		--data_address_io <= (others=>'Z');
		wait until rising_edge(clk);
		
		--leitura addr 4
		data_address_sel <= '1';
		--data_address_io <= (2 downto 0 => "100", others=>'0');
		data_address_io <= "00000100";
		wait until rising_edge(clk);
		en_Out  <= '1';
		--data_address_io <= (others=>'Z');
		data_address_sel <= '0';
		--data_address_io <= (others=>'Z');
		wait until rising_edge(clk);
		
		wait;
	end process;

	dut : exercicio_3
		port map (
			rst => rst,
			clk => clk,
			data_address_io => data_address_io,
			en_Out  => en_Out,
			en_W_R  => en_W_R,
			data_address_sel => data_address_sel
		);	
end behavioral;
