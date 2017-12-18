library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.main_package.all;
entity test is
end test;

architecture arch of test is

signal clk: std_logic;
signal reset : std_logic := '1';
signal hsync, vsync : std_logic;
signal video_on, p_tick : std_logic;
signal pixel_x, pixel_y : std_logic_vector(9 downto 0);

signal btn : std_logic_vector(3 downto 0);
signal graph_on, bump_on : std_logic := '1';
signal rgb : std_logic_vector(2 downto 0);
signal snake_body_out : snake_body_type;
signal move_counter_out : unsigned(5 downto 0);
begin

	reset <= '0' when clk'event and clk = '1';
	bump_on <= '0';
	
	vga_sync_unit: entity work.vga_sync port map (clk, reset, hsync, vsync, video_on, p_tick, pixel_x, pixel_y);
	
	snake_graph_unit: entity work.snake_graph port map (
		clk=>clk, reset=>reset,
    	btn=>btn,
		pixel_x=>pixel_x, pixel_y=>pixel_y,
		graph_on=>graph_on, bump_on=>bump_on,
		rgb=>rgb,
		snake_body_out=>snake_body_out,
		move_counter_out=>move_counter_out
	); 


end arch;
