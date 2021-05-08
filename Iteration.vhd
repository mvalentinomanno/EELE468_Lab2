library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Iteration is

	generic(W_bits : positive := 30;
		F_bits : positive := 17;
		N_iterations : natural);

	port(clk : in std_logic;
	     x : in std_logic_vector(W_bits-1 downto 0);
	     y0 : in std_logic_vector(W_bits - 1 downto 0);
	     y : out std_logic_vector(W_bits-1 downto 0));

end entity;

architecture Iteration_arch of Iteration is

	signal xy2,three_minx : unsigned(W_bits*3 - 1 downto 0);
	signal y2 : unsigned(W_bits*2 - 1 downto 0);
	signal numerator,YN : unsigned(W_bits * 4 - 1 downto 0);
	constant three_uns : unsigned(W_bits*3 - 1 downto 0) := ((F_bits*3 + 1) downto (F_bits*3) => '1', others => '0');
	signal x1 : unsigned(W_bits - 1 downto 0) := (others => '0');
	signal y1, y22, y3 : std_logic_vector(W_bits - 1 downto 0);


begin

	DELAY : process(clk) 
		begin
			if(rising_edge(clk)) then
				x1 <= unsigned(x);
				
				y1 <= y0;
				y22 <= y1;
				y3 <= y22;

			end if;
		end process;

	calculate : process(clk)
		begin
			if(rising_edge(clk)) then
				y2 <= unsigned(y0) * unsigned(y0);
				xy2 <= x1 * y2;
				three_minx <= three_uns - xy2;
				numerator <= unsigned(y3) * three_minx;
				YN <= shift_right(numerator,1);
			end if;
		end process;
	y <= std_logic_vector(YN(80 downto 51));
				
				

end architecture;