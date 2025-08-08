module Sensor(
    input wire car_detected,
    output reg car
);

always @(car_detected) begin
    car = car_detected;
end

endmodule

