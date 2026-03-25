// bộ đếm giờ
module hr_counter (
    input clk, rst_n,
    input inc,
    input dec,
    output reg carry_hr,
    output reg [3:0] ones, tens
);
    reg [4:0] hour;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hour <= 0; carry_hr <= 0;
        end else begin
            carry_hr <= 0;
            if (inc) begin
                if (hour == 23) begin
                    hour <= 0; carry_hr <= 1;
                end else hour <= hour + 1;
            end else if (dec) begin
                if (hour == 0) hour <= 23;
                else hour <= hour - 1;
            end
        end
    end

    always @(hour) begin
        ones = 0; tens = 0; // reset
        if (hour < 10) begin
            tens = 0;
            ones = hour;
        end else if (hour < 20) begin
            tens = 1;
            ones = hour - 10;
        end else begin
            tens = 2;
            ones = hour - 20;
        end
    end
endmodule