----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    12:00:29 01/31/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity pixel_gen is
    port ( row      : in unsigned(10 downto 0);
           column   : in unsigned(10 downto 0);
           blank    : in std_logic;
			  SW7		  : in STD_LOGIC;
			  SW1      : in STD_LOGIC;
           r        : out std_logic_vector(7 downto 0);
           g        : out std_logic_vector(7 downto 0);
           b        : out std_logic_vector(7 downto 0));
end pixel_gen;


architecture Behavioral of pixel_gen is
signal r_sig, g_sig, b_sig : std_logic_vector(7 downto 0);

begin

	process(row, blank, column, SW7, SW1)
	begin
		if(blank = '0') then
			
			if(SW7 = '0' and SW1 = '0') then
					if (row > 400) then 
						r <= (others => '1');
						g <= (others => '1');
						b <= (others => '0');
					elsif (column < 220) then
							r <= (others => '1');
							g <= (others => '0');
							b <= (others => '0');
					elsif (column <440) then
							r <= (others => '0');
							g <= (others => '1');
							b <= (others => '0');
					else
							r <= (others => '0');
							g <= (others => '0');
							b <= (others => '1');
					end if;
					
			elsif(SW7 = '1' and SW1 = '0') then
					if (row > 400) then 
							r <= (others => '1');
							g <= (others => '1');
							b <= (others => '1');
					elsif (column < 220) then
							r <= (others => '0');
							g <= (others => '0');
							b <= (others => '0');
					elsif (column <440) then
							r <= (others => '0');
							g <= (others => '1');
							b <= (others => '0');
					else
							r <= (others => '1');
							g <= (others => '0');
							b <= (others => '1');
					end if;
			elsif(SW7 = '0' and SW1 = '1') then
					if (row > 400) then 
							r <= (others => '0');
							g <= (others => '1');
							b <= (others => '0');
					elsif (column < 220) then
							r <= (others => '1');
							g <= (others => '0');
							b <= (others => '1');
					elsif (column <440) then
							r <= (others => '0');
							g <= (others => '1');
							b <= (others => '0');
					else
							r <= (others => '1');
							g <= (others => '0');
							b <= (others => '1');
					end if;
					
			elsif(SW7 = '1' and SW1 = '1') then
					if (row > 400) then 
							r <= (others => '1');
							g <= (others => '1');
							b <= (others => '1');
					elsif (column < 220) then
							r <= (others => '0');
							g <= (others => '0');
							b <= (others => '0');
					elsif (column <440) then
							r <= (others => '0');
							g <= (others => '1');
							b <= (others => '0');
					else
							r <= (others => '1');
							g <= (others => '1');
							b <= (others => '0');
					end if;
			end if;
		else
			r <= (others => '0');
			g <= (others => '0');
			b <= (others => '0');
		end if;
				
	end process;
	
end Behavioral;

