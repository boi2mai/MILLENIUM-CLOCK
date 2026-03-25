// bộ đếm phút
module min_counter (
    input clk, rst_n,
    input inc,
    input dec,
    output reg carry_min,
    output reg [3:0] ones, tens
);
    reg [5:0] min;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min <= 0; carry_min <= 0;
        end else begin
            carry_min <= 0;
            if (inc) begin
                if (min == 59) begin
                    min <= 0; carry_min <= 1;
                end else min <= min + 1;
            end else if (dec) begin
                if (min == 0) min <= 59;
                else min <= min - 1;
            end
        end
    end

    always @(min) begin
        ones = 0; tens = 0; // reset
        if (min < 10) begin
            tens = 0;
            ones = min;
        end else if (min < 20) begin
            tens = 1;
            ones = min - 10;
        end else if (min < 30) begin
            tens = 2;
            ones = min - 20;
        end else if (min < 40) begin
            tens = 3;
            ones = min - 30;
        end else if (min < 50) begin
            tens = 4;
            ones = min - 40;
        end else begin
            tens = 5;
            ones = min - 50;
        end
    end
endmodule