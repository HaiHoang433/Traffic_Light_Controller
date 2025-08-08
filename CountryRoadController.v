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

parameter [2:0] GREEN_CR = 3'b100;
parameter [2:0] YELLOW_CR = 3'b010;
parameter [2:0] RED_CR = 3'b001;
parameter T_Green = 8'd30; // Giá trị thời gian T
parameter t_Yellow = 8'd5;   // Giá trị thời gian t

wire [7:0] count_cr_minus;
  BCD_minus bcd_inst_n (
      .BCD_in (count_cr),
      .BCD_out(count_cr_minus)
  );

// Khai báo biến trạng thái và biến lưu trữ trạng thái hiện tại
reg [2:0] NextState, CurrentState;

// Gán giá trị trạng thái ban đầu
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        CurrentState <= RED_CR; // Khởi tạo trạng thái mặc định khi reset
    end else begin
        // Xác định trạng thái kế tiếp dựa trên trạng thái hiện tại và các tín hiệu đầu vào
        case (CurrentState)
            GREEN_CR: begin
                if (Timeout == 1) begin
                    NextState <= YELLOW_CR;
                    start_n <= 1;
                    color_cr <= 2'd1;
                    count_cr <= t_Yellow;
                end else begin 
                    count_cr <= count_cr_minus;
                    color_cr <= 2'd0;
                end
            end
            YELLOW_CR: begin
                if (timeout == 1) begin
                    NextState <= RED_CR;
                    enable_h <= 1; 
                    color_cr <= 2'd2;
                    count_cr <= T_Green + t_Yellow;
                end else begin
                    count_cr <= count_cr_minus;
                    color_cr <= 2'd1;
                end
            end
            RED_CR: begin
                if (enable_n) begin
                    NextState = GREEN_CR;
                    start_n = 1; 
                    color_cr <= 2'd0;
                    count_cr <= T_Green;
                end else begin
                    NextState <= RED_CR;
                    count_cr <= count_cr_minus;
                    color_cr <= 2'd2;
                end
            end
        endcase
    end
end

endmodule
