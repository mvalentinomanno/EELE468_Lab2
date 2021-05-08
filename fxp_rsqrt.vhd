--Michael Valentino-Manno
--Lab 1 fpx_rsqrt
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fxp_rsqrt is

	generic(W_bits : positive := 30;
		F_bits : positive := 17;
		N_iterations : natural);

	port(clk : in std_logic;
	     x : in std_logic_vector(W_bits-1 downto 0);
	     y : out std_logic_vector(W_bits-1 downto 0));

end entity;

architecture fxp_rsqrt_arch of fxp_rsqrt is

        signal Y0_newton, Y0T : std_logic_vector(W_bits - 1 downto 0) := (others => '0');
	signal x1, x2, x3, x4, x5, x6, x7, x8 : std_logic_vector(W_bits - 1 downto 0);

	component find_y0 is
		generic (W_bits	      : positive := 30; -- word size
			 F_bits       : positive := 17); -- frac bits
		port 	(clk	      : in std_logic;
			 x 	      : in std_logic_vector(W_bits - 1 downto 0);
			 y0 	      : out std_logic_vector(W_bits - 1 downto 0));
	end component;	

	component Newton is
		generic (W_bits	      : positive := 30; -- word size
			 F_bits       : positive := 17;
			 N_iterations : natural); -- frac bits
		port 	(clk	      : in std_logic;
			 x 	      : in std_logic_vector(W_bits - 1 downto 0);
			 y0	      : in std_logic_vector(W_bits - 1 downto 0);
			 y 	      : out std_logic_vector(W_bits - 1 downto 0));
	end component;	

begin

	GUESS : find_y0 generic map(W_bits => W_bits, F_bits => F_bits)
			port map(clk => clk, x => x, y0 => Y0_newton);

	DELAY : process(clk)
		begin
			if(rising_edge(clk)) then
				x1 <= x;
				x2 <= x1;
				x3 <= x2;
				x4 <= x3;
				x5 <= x4;
				x6 <= x5;
				x7 <= x6;
				x8 <= x7;
			end if;
		end process;

	NEWTONS : Newton generic map(W_bits => W_bits, F_bits => F_bits, N_iterations => N_iterations)
			 port map(clk => clk, x => x8, y0 => Y0_newton, y => y);

end architecture;