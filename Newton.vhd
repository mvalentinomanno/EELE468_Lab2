library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Newton is

	generic(W_bits : positive := 30;
		F_bits : positive := 17;
		N_iterations : natural := 5);

	port(clk : in std_logic;
	     x : in std_logic_vector(W_bits-1 downto 0);
	     y0 : in std_logic_vector(W_bits-1 downto 0);
	     y : out std_logic_vector(W_bits-1 downto 0));

end entity;

architecture Newton_arch of Newton is

constant it5 : natural := N_iterations * 5; --delay 5 clockcycles to compensate for component lateny
type connections is array (natural range <>) of std_logic_vector(W_bits - 1 downto 0);
signal input_vector : connections(it5 downto 0);
signal yiteration_vector : connections(N_iterations downto 0);

component Iteration is
		generic (W_bits	      : positive := 30; -- word size
			 F_bits       : positive := 17;
			 N_iterations : positive); 
		port 	(clk	      : in std_logic;
			 x 	      : in std_logic_vector(W_bits - 1 downto 0);
			 y0	      : in std_logic_vector(W_bits - 1 downto 0);
			 y 	      : out std_logic_vector(W_bits - 1 downto 0));
	end component;	


begin
	yiteration_vector(0) <= y0;

	GEN_LOOP : for v in 0 to N_iterations generate
	
		ITERATION_0 : if v = 0 generate
			yiteration_vector(v) <= y0;
		end generate ITERATION_0;

		ITERATION_1 : if v = 1 generate
			Y1_CALC : Iteration generic map(W_bits => W_bits, F_bits => F_bits, N_iterations => N_iterations)
				port map(clk => clk, x => x, y0 => yiteration_vector(v - 1), y => yiteration_vector(v));
		end generate ITERATION_1;
	
		ITERATION_2 : if v > 1 generate
			YN_CALC : Iteration generic map(W_bits => W_bits, F_bits => F_bits, N_iterations => N_iterations)
				port map(clk => clk, x => input_vector(((v - 1)*5) - 1), y0 => yiteration_vector(v - 1), y => yiteration_vector(v));
		end generate ITERATION_2;


	end generate GEN_LOOP;


	INPUT_PIPELINE : process(clk)
		begin
			if(rising_edge(clk)) then
					input_vector(0) <= x;

					for it in 1 to it5 loop
						input_vector(it) <= input_vector(it-1);
					end loop;	
			end if;
		end process;
		
	y <= yiteration_vector(N_iterations);


end architecture;