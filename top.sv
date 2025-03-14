module top (
    input  logic            clk,
    input  logic            rst_n,

	output logic [4:0]  	lcd_r,
	output logic [5:0]  	lcd_g,
	output logic [4:0]  	lcd_b,
    output logic          	lcd_de,
    output logic         	lcd_hsync,
    output logic         	lcd_vsync,
    output logic         	lcd_clk,
	output logic 			lcd_bl,

	output logic [11:0]		lcd_xpos,
	output logic [11:0]		lcd_ypos,
	output logic [23:0] 	lcd_data
);

assign lcd_bl = 1'b1 ;

parameter para = 8 ;

/* verilator lint_off UNUSED */
wire [23:0] lcd_rgb  ;
// wire [23:0] lcd_data ;
/* verilator lint_on UNUSED */

assign lcd_r[4:0] = lcd_rgb[4+ para*2:para*2];
assign lcd_g[5:0] = lcd_rgb[5+ para*1:para*1];
assign lcd_b[4:0] = lcd_rgb[4+ para*0:para*0];

// wire	[11:0]	lcd_xpos;		
// wire	[11:0]	lcd_ypos;		

lcd_ctrl lcd_ctrl_inst (
	.clk        (clk)    ,      //lcd clock
	.rst_n      (rst_n)      ,      //sync reset
	.lcd_data   (lcd_data)   ,      //lcd data
	.lcd_clk    (lcd_clk)    ,      //lcd pixel clock
	.lcd_hs     (lcd_hsync)  ,	    //lcd horizontal sync
	.lcd_vs     (lcd_vsync)  ,	    //lcd vertical sync
	.lcd_de     (lcd_de)     ,	    //lcd display enable; 1:Display Enable Signal;0: Disable Ddsplay
	.lcd_rgb    (lcd_rgb)    ,      //lcd display data
	.lcd_xpos   (lcd_xpos)   ,      //lcd horizontal coordinate
	.lcd_ypos   (lcd_ypos)		    //lcd vertical coordinate
);

lcd_data lcd_data_inst( 
	.clk(clk),	
	.rst_n(rst_n),	
	.lcd_xpos(lcd_xpos),	//lcd horizontal coordinate
	.lcd_ypos(lcd_ypos),	//lcd vertical coordinate
	
	.lcd_data(lcd_data)	    //lcd data
);

endmodule