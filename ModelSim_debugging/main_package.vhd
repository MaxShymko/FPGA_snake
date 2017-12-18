library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package main_package is
	constant MAX_SNAKE_LENGTH : integer := 100;

	constant MOVE_DELAY : integer := 2; 

	-- VGA 640-by-480 sync parameters
	constant HD: integer:=640; --horizontal display area
	constant HF: integer:=16 ; --h. front porch
	constant HB: integer:=48 ; --h. back porch
	constant HR: integer:=96 ; --h. retrace
	constant VD: integer:=480; --vertical display area
	constant VF: integer:=10;  --v. front porch
	constant VB: integer:=33;  --v. back porch
	constant VR: integer:=2;   --v. retrace


	type coord is array(natural range 0 to 1) of unsigned(6 downto 0); -- 0 - X, 1 - Y
	type snake_body_type is array(natural range 0 to MAX_SNAKE_LENGTH-1) of coord;
	type direction_type is (left, up, right, down);

end main_package;

package body main_package is



end main_package;