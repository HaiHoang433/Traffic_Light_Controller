module hienthiled
(
    input wire [7:0] count_h,   
    input wire [7:0] count_cr,
    input wire [2:0] color_h,
    input wire [2:0] color_cr, 
    output wire [6:0] led0,  
    output wire [6:0] led1,  
    output wire [6:0] led2,  
    output wire [6:0] led3,  
    output wire [6:0] led4,  
    output wire [6:0] led5  
);

wire [6:0] led0_wire;
wire [6:0] led1_wire;
giaimabaythanh GiaiMacount_h1(.data(count_h[3:0]), .led(led0_wire));  // LED unit of highway
giaimabaythanh GiaiMacount_h2(.data(count_h[7:4]), .led(led1_wire));  // LED ten of highway


wire [6:0] led2_wire;
wire [6:0] led3_wire;
giaimabaythanh GiaiMacount_cr1(.data(count_cr[3:0]), .led(led2_wire));  // LED unit of countryroad
giaimabaythanh GiaiMacount_cr2(.data(count_cr[7:4]), .led(led3_wire));  // LED ten of countryroad


wire [6:0] led4_wire;
wire [6:0] led5_wire;
giaimabaythanh GiaiMacolor_h1(.data(color_h[2:0]), .led(led4_wire));    // LED light highway
giaimabaythanh GiaiMacolor_cr2(.data(color_cr[2:0]), .led(led5_wire));  // LED light countryroad

assign led5 = led5_wire;
assign led4 = led4_wire;
assign led3 = led3_wire;
assign led2 = led2_wire;
assign led1 = led1_wire;
assign led0 = led0_wire;

endmodule