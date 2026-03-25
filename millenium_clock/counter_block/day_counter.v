// bộ đếm ngày
module day_counter (
    input clk, rst_n,
    input inc,
    input dec,
    input [3:0] month,
    input leap,
    output reg carry_day,
    output reg [3:0] ones, tens
);
    reg [5:0] max_day_in_month;
    reg [5:0] day;

    always @(month or leap) begin
        // xác định số ngày tối đa trong tháng
        case (month)
            4'd1, 4'd3, 4'd5, 4'd7, 4'd8, 4'd10, 4'd12: max_day_in_month = 6'd31;
            4'd4, 4'd6, 4'd9, 4'd11: max_day_in_month = 6'd30;
            4'd2: max_day_in_month = (leap) ? 6'd29 : 6'd28;
            default: max_day_in_month = 6'd31;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            day <= 1; carry_day <= 0;
        end else begin
            carry_day <= 0;
            if (inc) begin
                if (day == max_day_in_month) begin
                    day <= 1; carry_day <= 1;
                end else day <= day + 1;
            end else if (dec) begin
                if (day == 1) day <= max_day_in_month;
                else day <= day - 1;
            end
        end
    end

    always @(day) begin
        ones = 1; tens = 0; // reset
        if (day < 10) begin
            tens = 0;
            ones = day;
        end else if (day < 20) begin
            tens = 1;
            ones = day - 10;
        end else if (day < 30) begin
            tens = 2;
            ones = day - 20;
        end else if (day < 32) begin
            tens = 3;
            ones = day - 30;
        end 
    end
endmodule