// bộ đếm tháng
module month_counter (
    input clk, rst_n,
    input inc,
    input dec,
    output reg carry_mon,
    output reg [3:0] month,
    output reg [3:0] ones, tens
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            month <= 1; carry_mon <= 0;
        end else begin
            carry_mon <= 0;
            if (inc) begin
                if (month == 12) begin
                    month <= 1; carry_mon <= 1;
                end else begin
                    month <= month + 1; carry_mon <= 0;
                end
            end else if (dec) begin
                if (month == 1) month <= 12;
                else month <= month - 1;
            end
        end
    end

    always @(month) begin
        ones = 1; tens = 0; // reset
        if (month < 10) begin
            tens = 0;
            ones = month;
        end else begin
            tens = 1;
            ones = month - 10;
        end
    end
endmodule