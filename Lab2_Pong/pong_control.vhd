----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:58 02/10/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong_control is
    Port ( clk 			: in  STD_LOGIC;
           reset 			: in  STD_LOGIC;
           up 				: in  STD_LOGIC;
           down 			: in  STD_LOGIC;
           v_completed	: in  STD_LOGIC;
           ball_x 		: out  unsigned (10 downto 0);
           ball_y 		: out  unsigned (10 downto 0);
           paddle_y 		 : out  unsigned (10 downto 0));
end pong_control;

architecture Behavioral of pong_control is

begin


end Behavioral;

