set_property SRC_FILE_INFO {cfile:c:/Users/catal/Documents/GitHub/FPGA-Image-Processing/vga_over_uart/vga_over_uart.gen/sources_1/ip/clk_wiz_1/clk_wiz_1.xdc rfile:../../../vga_over_uart.gen/sources_1/ip/clk_wiz_1/clk_wiz_1.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
