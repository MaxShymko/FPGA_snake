vsim -novopt test
add wave clk reset bump_on snake_body_out move_counter_out
force clk 0 0, 1 25 -repeat 50
run 10000