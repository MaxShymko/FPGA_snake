library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.main_package.all;

entity snake_graph is
   port(
      clk, reset: std_logic;
      btn: std_logic_vector(3 downto 0);
      pixel_x, pixel_y: in std_logic_vector(9 downto 0);
      graph_on, bump_on: out std_logic;
      rgb: out std_logic_vector(2 downto 0);
      snake_body_out: out snake_body_type; -- debug
      move_counter_out: out unsigned(5 downto 0) -- debug
   );
end snake_graph;

architecture arch of snake_graph is
constant sq_size : integer := 8; -- square size
signal snake_length : unsigned(6 downto 0);
signal eat : coord;
signal snake_body : snake_body_type;
signal pix_x, pix_y : unsigned(9 downto 0);
signal move_counter : unsigned(5 downto 0); -- !!!!!
signal snake_head_next : coord;
signal snake_direction : direction_type;
signal snake_on, eat_on : std_logic;
signal snake_rgb, eat_rgb : std_logic_vector(2 downto 0);
begin
   snake_body_out <= snake_body; -- debug
   move_counter_out <= move_counter; -- debug

   REG: process(clk, reset)
   begin
      if reset = '1' then
         bump_on <= '0';
         snake_body <= (
            0 => (0 => to_unsigned(HD/sq_size/2, 7), 1 => to_unsigned(VD/sq_size/2, 7)),
            1 => (0 => to_unsigned(HD/sq_size/2, 7)+1, 1 => to_unsigned(VD/sq_size/2, 7)),
            2 => (0 => to_unsigned(HD/sq_size/2, 7)+2, 1 => to_unsigned(VD/sq_size/2, 7)), 
            others => (others => "0000000")
         );
         snake_length <= to_unsigned(3, 7);
         move_counter <= to_unsigned(0, 6);
         snake_head_next <= (0 => to_unsigned(HD/sq_size/2, 7), 1 => to_unsigned(VD/sq_size/2, 7));
         snake_direction <= left;
      end if;
      if (clk'event and clk = '1') then
         if(move_counter = MOVE_DELAY) then
            snake_body(0) <= snake_head_next;
            move_counter <= move_counter xor move_counter;
         else
            move_counter <= move_counter + 1;
         end if;
      end if;
   end process;

   NS: process(snake_body(0), move_counter)
   begin
      if(move_counter = to_unsigned(0, 6)) then
         -- upd all snake body sq
         for i in 0 to MAX_SNAKE_LENGTH-2 loop
            snake_body(i+1) <= snake_body(i);
         end loop;
         -- calculate next head coord; near edge - move to the opposite edge
         case snake_direction is
            when left => 
               if(snake_body(0)(0) = 0) then
                  snake_head_next(0) <= to_unsigned(HD/sq_size - 1, 7);
               else
                  snake_head_next(0) <= snake_head_next(0) - 1;
               end if;
            when up => 
               if(snake_body(0)(1) = 0) then
                  snake_head_next(1) <= to_unsigned(VD/sq_size - 1, 7);
               else
                  snake_head_next(1) <= snake_head_next(1) - 1;
               end if;
            when right => 
               if(snake_body(0)(0) = to_unsigned(HD/sq_size - 1, 7)) then
                  snake_head_next(0) <= to_unsigned(0, 7);
               else
                  snake_head_next(0) <= snake_head_next(0) + 1;
               end if;
            when down => 
               if(snake_body(0)(1) = to_unsigned(VD/sq_size - 1, 7)) then
                  snake_head_next(1) <= to_unsigned(0, 7);
               else
                  snake_head_next(1) <= snake_head_next(1) + 1;
               end if;
         end case;
      end if;
   end process;

   process(snake_head_next)
   begin 
      for i in 0 to MAX_SNAKE_LENGTH-1 loop
         if(i = snake_length) then
            exit;
         else
            if(snake_body(i)(0) = snake_head_next(0) and snake_body(i)(1) = snake_head_next(1)) then
               bump_on <= '1'; -- game over
            end if;
         end if;
      end loop; 
   end process;

   -- is snake in this region
   process(pix_x, pix_y)
   begin
      for i in 0 to MAX_SNAKE_LENGTH-1 loop
         if(i = snake_length) then
            exit;
         else
            if(pix_x >= snake_body(i)(0)*sq_size and pix_x < snake_body(i)(0)*sq_size+sq_size and
               pix_y >= snake_body(i)(1)*sq_size and pix_y < snake_body(i)(1)*sq_size+sq_size) then
               snake_on <= '1';
               exit;
            else
               snake_on <= '0';
            end if;
         end if;
      end loop;
   end process;

   pix_x <= unsigned(pixel_x);
   pix_y <= unsigned(pixel_y);

   snake_rgb <= "010"; -- green
   eat_rgb <= "100"; -- red

end arch;