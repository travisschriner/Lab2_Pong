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
type states is ( top_hit, right_hit, bottom_hit, paddle_hit, left_hit);

signal ball_x_pos, ball_y_pos, paddle_y_pos, ball_x_next, ball_y_next, paddle_y_next, count, count_next, speed : unsigned (10 downto 0);
signal y_dist, x_dist : STD_LOGIC;
signal state_reg, state_next : states;


begin

	--output buffer
	process(clk, reset)
	begin
		if(reset ='1') then
			ball_x_pos <= "00000010000";
			ball_y_pos <= "00000010000";
			paddle_y_pos <= (others => '0');
			count <= (others => '0');
		elsif( rising_edge(clk)) then
			ball_x_pos <= ball_x_next;
			ball_y_pos <= ball_y_next;
			paddle_y_pos <= paddle_y_next;
			count <= count_next;
		end if;
	end process;
	
	count_next <= (others => '0') when count = speed+1
						else count+1 when rising_edge(v_completed)
						else count;
	
	--state reg	
	process(clk, reset)
	begin
		if(reset = '1') then
			state_reg <= top_hit;
		elsif(rising_edge(clk)) then
			state_reg <= state_next;
		end if;
	end process;
		
	
	
	
	paddle_y_next <= paddle_y_pos+5 when rising_edge(up) and paddle_y_pos > 5 else 
						  paddle_y_pos-5 when rising_edge(down) and paddle_y_pos < 380 else	
						  paddle_y_pos;
	
	-- state machine
	process(ball_x_next, ball_y_next, paddle_y_next)
	begin
		
			
			if(ball_y_next <= 0) then
				state_next <= top_hit;
			elsif(ball_y_next >= 480) then
				state_next <= bottom_hit;
			elsif(ball_x_next >= 640) then
				state_next <= right_hit;
			elsif(ball_x_next <= 0) then
				state_next <= left_hit;
			elsif( ball_x_next <= 25 and ball_y_next > paddle_y_next and ball_y_next < (paddle_y_next+100)) then
				state_next <= paddle_hit;
			else
				state_next <= top_hit;
			end if;
		
	end process;
	
	--ball speed setting based off switch
	speed <= "00100101100" when (SW7 = '1') else "01001011000";
	
	
	
	
	

	
	
	
	--output
	ball_x 	<= ball_x_pos;
	ball_y 	<= ball_y_pos;
	paddle_y <= paddle_y_pos;
	


end Behavioral;

