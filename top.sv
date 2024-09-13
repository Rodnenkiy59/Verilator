module top(
    input logic clk,
    input logic reset,
    output logic [7:0] counter
);

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 8'd0;
    end else begin
        counter <= counter + 8'd1;
    end
end

endmodule
