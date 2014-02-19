----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    09:56:58 02/10/2014 
-- Module Name:    pong_control - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity pong_control is
    Port ( clk 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           up 				: in  STD_LOGIC;
           down 			: in  STD_LOGIC;
			  SW7          : in  STD_LOGIC;
			  v_completed	: in  STD_LOGIC;
           ball_x 		: out  unsigned (10 downto 0);
           ball_y 		: out  unsigned (10 downto 0);
           paddle_y 		: out  unsigned (10 downto 0));
end pong_control;

architecture Behavioral of pong_control is

	
type state_type is (idle, right_hit, left_hit, bottom_hit, top_hit, 
							paddle_bounce_upper, paddle_bounce_lower);
signal state_reg, state_next : state_type;
signal up_signal, down_signal : std_logic;
signal paddle_y_next, paddle_y_reg : unsigned(10 downto 0);
signal count, count_next : unsigned(10 downto 0);
signal ball_x_reg, ball_x_next, ball_y_reg, ball_y_next : unsigned(10 downto 0);
signal y_dir, x_dir, y_dir_reg, x_dir_reg, stop, stop_reg: std_logic;
signal speed : natural;
begin



	--speed check
	process (SW7, clk)
	begin
		if (SW7 = '1') then
			speed <= 500;
		else
			speed <= 1000;
		end if;
	end process;

--ball counter
	count_next <= count + 1 when count < to_unsigned(speed, 11) and v_completed = '1' else
					    (others => '0') when count >= to_unsigned(speed, 11) else
					    count;

	process(clk, reset)
	begin
		if reset = '1' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			count <= count_next;
		end if;
	end process;

--State Register
process(clk, reset)
begin
	if reset = '1' then
		state_reg <= idle;
	elsif rising_edge(clk) then
		state_reg <= state_next;
	end if;
end process;

--output buffer
process(clk, reset)
	begin
		if (reset = '1') then
			ball_x_reg <= "00000000010";
			ball_y_reg <= "00000000011";
			x_dir_reg <= '0';
			y_dir_reg <= '0';
			stop_reg	 <= '0';
		elsif (rising_edge(clk)) then
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next;
			x_dir_reg <= x_dir;
			y_dir_reg <= y_dir;
			stop_reg  <= stop;
		end if;
	end process;

--next-state logic
	process(state_next, state_reg, ball_x_reg, ball_y_reg, paddle_y_reg)
	begin
	
	
		state_next <= state_reg;
		
		
	if (count >= speed) then

		case state_reg is
			when idle =>
			
				if (ball_x_reg >= 625) then
					state_next <= right_hit;
				elsif (ball_x_reg <= 1) then
					state_next <= left_hit;
				end if;
				
				if	(ball_y_reg >= 479) then
					state_next <= bottom_hit;
				elsif (ball_y_reg <= 1) then
					state_next <= top_hit;
				end if;
				
				--paddle hit logic
				if (ball_x_reg <=20 and ball_y_reg >= paddle_y_reg and ball_y_reg <= paddle_y_reg+100) then
					if (ball_y_reg >= (paddle_y_reg + 50)
							 and ball_y_reg <= (paddle_y_reg + 100)) then
						state_next <= paddle_bounce_lower;
					elsif (ball_y_reg >= paddle_y_reg and ball_y_reg < (paddle_y_reg + 50)) then
						state_next <= paddle_bounce_upper;
					end if;
				end if;
			when right_hit =>	
				state_next <= idle;
			when left_hit =>
				state_next <= idle;
			when bottom_hit =>
				state_next <= idle;
			when top_hit =>
				state_next <= idle;
			when paddle_bounce_upper =>
				state_next <= idle;
			when paddle_bounce_lower =>
				state_next <= idle;
		end case;

	end if;

	end process;

--output logic
	process(state_next, count)
	begin
	
	
	
		--initializes states
		ball_x_next <= ball_x_reg;
		ball_y_next <= ball_y_reg;
		x_dir <= x_dir_reg;
		y_dir <= y_dir_reg;
		stop <= stop_reg;
		
		
	if (count >= speed) then
		case state_next is
			when idle =>
				if (stop_reg = '0') then
				
					if (x_dir_reg = '0') then
						ball_x_next <= ball_x_reg + 1;
					elsif (x_dir_reg = '1') then
						ball_x_next <= ball_x_reg - 1;
					end if;
					
					
					if (y_dir_reg = '0') then
						ball_y_next <= ball_y_reg + 1;
					elsif (y_dir_reg ='1') then
						ball_y_next <= ball_y_reg - 1;
					end if;
				end if;
				
				
			when right_hit =>
				x_dir <= '1';
			when left_hit =>
				stop <= '1';
			when bottom_hit =>
				y_dir <= '1';
			when top_hit =>
				y_dir <= '0';
			when paddle_bounce_upper =>
				x_dir <= '0';
				y_dir <= '1';
			when paddle_bounce_lower =>
				x_dir <= '0';
				y_dir <= '0';
		end case;
	end if;

	end process;








--output
ball_x <= ball_x_reg;
ball_y <= ball_y_reg;







--================================================================
--!!!!!!!!!!!!!!!!!!!!!!!PADDLE MOVEMENT!!!!!!!!!!!!!!!!!!!!!!!!!!
--================================================================


--paddle flip flop
process(clk, reset)
begin
		if (reset = '1') then
			paddle_y_reg <= (others => '0');
		elsif rising_edge(clk) then
			paddle_y_reg <= paddle_y_next;
		end if;

end process;




process (up, down, paddle_y_reg, count, paddle_y_next)
begin
	paddle_y_next <= paddle_y_reg;

	if(count = 200 or count = 400) then
		if (paddle_y_next < 0) then
			paddle_y_next <= (others => '0');
		elsif (up ='1' and  down = '0' and paddle_y_next > 1) then
			paddle_y_next <= paddle_y_reg - 1;	
		elsif (up = '0' and down = '1' and paddle_y_next < 380) then
			paddle_y_next <= paddle_y_reg + 1;
		end if;
	end if;	

end process;

paddle_y <= paddle_y_reg;	
end Behavioral;

