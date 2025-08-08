module Timer(
    input wire clk,
    input wire rst_n,
    input wire car_detected,
    output reg Timeout, 
    output reg timeout     
);
parameter T_Green = 2'd30;
parameter t_Yellow = 2'd05;
reg [7:0] count;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= T_Green;
        Timeout <= 0;
    end else begin
        if (car_detected == 0 && count <= T_Green) begin
	        Timeout <= 0;
	        count <= count - 2'd01;
            if (count == 2'd00) begin
                count <= T_Green;
            end
        end

	    if (car_detected == 1 && count <= T_Green) begin 
	        Timeout <= 1;
            count <= count - 2'd01;
            timeout <= 1;	    
            if (count == 2'd00 && timeout == 1 && Timeout == 1) begin
                count <= t_Yellow;
                if (count > 2'd00) begin
                    count <= count - 2'd01;
                    if (count == 2'd00) begin
                        count <= t_Yellow + T_Green;
                        if (count > 2'd00) begin
                            count <= count - 2'd01;
                            if (count == 2'd00) begin
                                count <= T_Green;
                            end
                        end
                    end
                end
            end
        end 
    end
end
endmodule
