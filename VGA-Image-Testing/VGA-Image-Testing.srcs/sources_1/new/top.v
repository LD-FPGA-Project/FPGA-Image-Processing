`timescale 1ns / 1ps
`default_nettype none

module top
(
    input wire i_top_clk,
    input wire i_top_rst,
    input wire switch_reverse,
    input wire start_grayscale, 
    input wire start_inverse, 
    
    output wire [3:0] o_top_vga_red,
    output wire [3:0] o_top_vga_green,
    output wire [3:0] o_top_vga_blue,
    output wire       o_top_vga_vsync,
    output wire       o_top_vga_hsync
);

    wire w_clk25m; 
    clk_wiz_0 clock_gen (.clk_in1(i_top_clk), .clk_out1(w_clk25m)); 

    wire w_rst_btn_db; 
    wire w_rst_btn_gr;
    reg r1_rstn_clk25m, r2_rstn_clk25m; 

    debouncer #(.DELAY(240_000)) top_btn_db (.i_clk(i_top_clk), .i_btn_in(~i_top_rst), .o_btn_db(w_rst_btn_db));
   

    always @(posedge w_clk25m or negedge w_rst_btn_db) begin
        if (!w_rst_btn_db) 
            {r2_rstn_clk25m, r1_rstn_clk25m} <= 2'b00;
        else
            {r2_rstn_clk25m, r1_rstn_clk25m} <= {r1_rstn_clk25m, 1'b1};
    end
    
    


    wire [9:0] x, y;  
    wire [11:0] pixel_data;
    wire [11:0] pixel_data_grayscale;
    wire [11:0] pixel_data_invert;

    image_bram image_pixels(.clk(w_clk25m), .addr((y*320)+x), .data_out(pixel_data), .switch(switch_reverse));
    gray_scale make_gray(.clk(w_clk25m), .pixel_data(pixel_data), .data_out(pixel_data_grayscale));
    invert_colors inverse(.clk(w_clk25m), .pixel_data(pixel_data), .data_out(pixel_data_invert));
    reg [11:0] pixel;
    
always @(posedge w_clk25m) begin
    pixel <= pixel_data;
    
    
    if (start_grayscale) begin
        pixel <= pixel_data_grayscale; 
    end
    

    if (start_inverse) begin
        pixel <=  pixel_data_invert;
    end
end
    
    vga_top display_interface (
        .i_clk25m(w_clk25m),
        .i_rstn_clk25m(r2_rstn_clk25m),
        .i_pixel_data(pixel),
        .o_VGA_red(o_top_vga_red),
        .o_VGA_green(o_top_vga_green),
        .o_VGA_blue(o_top_vga_blue),
        .o_VGA_vsync(o_top_vga_vsync),
        .o_VGA_hsync(o_top_vga_hsync),
        .o_VGA_x(x), 
        .o_VGA_y(y),
        .o_VGA_video()
    );

endmodule
