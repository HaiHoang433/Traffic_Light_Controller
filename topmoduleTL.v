module topmoduleTL(
    input wire clk,               // Clock input                    [CLK_50MHz]
    input wire rst_n,             // Reset input (active low)       [RST]
    input wire car_detected,      // Car detection input            [SW0]
    output reg [6:0] led0,             // LED unit of highway       [HEX0]
    output reg [6:0] led1,             // LED ten of highway        [HEX1]
    output reg [6:0] led2,             // LED unit of countryroad   [HEX2]
    output reg [6:0] led3,             // LED ten of countryroad    [HEX3]
    output reg [6:0] led4,             // LED light highway         [HEX4]
    output reg [6:0] led5              // LED light countryroad     [HEX5]
);

/*
giaimabaythanh GiaiMacount_h1(.data(count_h[3:0]), .led(led0_wire));  // LED unit of highway
giaimabaythanh GiaiMacount_h2(.data(count_h[7:4]), .led(led1_wire));  // LED ten of highway


wire [6:0] led2_wire;
wire [6:0] led3_wire;
giaimabaythanh GiaiMacount_cr1(.data(count_cr[3:0]), .led(led2_wire));  // LED unit of countryroad
giaimabaythanh GiaiMacount_cr2(.data(count_cr[7:4]), .led(led3_wire));  // LED ten of countryroad


wire [6:0] led4_wire;
wire [6:0] led5_wire;
giaimabaythanh GiaiMacolor_h1(.data(color_h[3:0]), .led(led4_wire));    // LED light highway
giaimabaythanh GiaiMacolor_cr2(.data(color_cr[3:0]), .led(led5_wire));  // LED light countryroad
*/

wire timeout;
wire Timeout;

wire enable_h;
wire start_h;
wire enable_n;
wire start_n;

wire [6:0] led0_wire;
wire [6:0] led1_wire;
wire [6:0] led2_wire;
wire [6:0] led3_wire;
wire [6:0] led4_wire;
wire [6:0] led5_wire;

parameter [2:0] GREEN = 3'b100;
parameter [2:0] YELLOW = 3'b010;
parameter [2:0] RED = 3'b001;
parameter T_Green = 8'd30; // Giá trị thời gian T
parameter t_Yellow = 8'd5;   // Giá trị thời gian t

wire [7:0] count_h;
wire [2:0] color_h;
wire [7:0] count_cr;
wire [2:0] color_cr;

// Instantiate the clock generator
clk_gen clk_generator(
    .clk(clk),
    .clk_1Hz()
);

// Instantiate the sensor module
Sensor sensor_inst(
    .car_detected(car_detected),
    .car()
);

/*
module Timer(
    input wire clk,
    input wire rst_n,
    input wire car_detected,
    output reg Timeout, 
    output reg timeout     
);
*/

// Instantiate the timer module
Timer timer_inst(
    .clk(clk),
    .rst_n(rst_n),
    .Timeout(Timeout),
    .timeout(timeout)
);

/*
module HighwayController(
    input wire clk,
    input wire rst_n,
    input wire car,
    input wire enable_h,
    input wire Timeout,
    input wire timeout,
    output reg enable_n,
    output reg start_h,
    output reg [7:0] count_h,
    output reg [2:0] color_h
);
*/

// Instantiate the HighwayController module
HighwayController highway_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .car(car_detected),
    .enable_h(enable_h),
    .Timeout(Timeout),
    .timeout(timeout),
    .enable_n(enable_n),
    .start_h(start_h),
	 .count_h(count_h),
	 .color_h(color_h)
);

/*
module CountryRoadController(
    input wire clk,
    input wire rst_n,
    input wire car,
    input wire enable_n,
    input wire Timeout,
    input wire timeout,
    output reg enable_h,
    output reg start_n,
    output reg [7:0] count_cr,
    output reg [2:0] color_cr
);
*/

// Instantiate the CountryRoadController module
CountryRoadController country_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .car(car_detected),
    .enable_n(enable_n),
    .Timeout(Timeout),
    .timeout(timeout),
    .enable_h(enable_h),
    .start_n(start_n),
	 .count_cr(count_cr),
	 .color_cr(color_cr)
);

// Instantiate the LED display module
hienthiled led_display(
	.count_h(count_h),
	.color_h(color_h),
	.count_cr(count_cr),
	.color_cr(color_cr),
    // count_h, color_h, count_cr, color_cr
    .led0(led0_wire),
    .led1(led1_wire),
    .led2(led2_wire),
    .led3(led3_wire),
    .led4(led4_wire),
    .led5(led5_wire)
);
always @(led0_wire or led1_wire or led2_wire or led3_wire or led4_wire or led5_wire) begin
    led0 <= led0_wire;
    led1 <= led1_wire;
    led2 <= led2_wire;
    led3 <= led3_wire;
    led4 <= led4_wire;
    led5 <= led5_wire;
end

endmodule