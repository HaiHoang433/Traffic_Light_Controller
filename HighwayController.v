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

// Định nghĩa trạng thái
parameter [2:0] GREEN_H = 3'b100;
parameter [2:0] YELLOW_H = 3'b010;
parameter [2:0] RED_H = 3'b001;
parameter T_Green = 8'd30; // Giá trị thời gian T
parameter t_Yellow = 8'd5;   // Giá trị thời gian t

wire [7:0] count_h_minus;
  BCD_minus bcd_inst_h (
      .BCD_in (count_h),
      .BCD_out(count_h_minus)
  );

// Khai báo biến lưu trữ trạng thái hiện tại
reg [2:0] NextState, CurrentState;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        CurrentState <= GREEN_H; // Khởi tạo trạng thái mặc định khi reset
    end else begin
        // Xác định trạng thái kế tiếp dựa trên trạng thái hiện tại và các tín hiệu đầu vào
        NextState <= CurrentState ;
        start_h <= 0; enable_n <= 0;
        case (CurrentState)
            GREEN_H: begin
                if (car == 0 && count_h == 2'd00) begin
                    NextState <= GREEN_H;
                    count_h <= T_Green;
                    color_h <= 2'd0; 
                end else begin 
                    count_h <= count_h_minus;   
                end

                if (car == 1 && Timeout == 1) begin
                    NextState <= YELLOW_H;
                    start_h <= 1;
                    count_h <= t_Yellow;
                    color_h <= 2'd1;
                end else begin
                    count_h <= count_h_minus;
                    color_h <= 2'd0;
                end
            end
            YELLOW_H: begin
                if (timeout == 1) begin
                    NextState <= RED_H;
                    enable_n <= 1; 
                    count_h <= T_Green + t_Yellow;
                    color_h <= 2'd2;
                end else begin
                    count_h <= count_h_minus;
                    color_h <= 2'd1;
                end
            end
            RED_H: begin
                if (enable_h) begin
                    NextState <= GREEN_H;
                    start_h <= 1; 
                    count_h <= T_Green;
                    color_h <= 2'd0;
                end else begin
                    count_h <= count_h_minus;
                    color_h <= 2'd2;
                end
            end
        endcase
    end
end

endmodule
