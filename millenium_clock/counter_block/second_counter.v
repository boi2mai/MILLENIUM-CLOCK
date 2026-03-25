// bộ đếm giây
module sec_counter (
    input clk, rst_n,
    input inc, // tăng
    input dec, // giảm
    output reg carry_sec, // xung báo cho phút
    output reg [3:0] ones, tens
);
    reg [5:0] sec;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec <= 0; carry_sec <= 0;
        end else begin
            carry_sec <= 0;
            if (inc) begin
                if (sec == 59) begin
                    sec <= 0; carry_sec <= 1;
                end else sec <= sec + 1;
            end else if (dec) begin
                if (sec == 0) sec <= 59;
                else sec <= sec - 1;
            end
        end
    end
    always @(sec) begin
        ones = 0; tens = 0; // reset
        if (sec < 10) begin
            tens = 0;
            ones = sec;
        end else if (sec < 20) begin
            tens = 1;
            ones = sec - 10;
        end else if (sec < 30) begin
            tens = 2;
            ones = sec - 20;
        end else if (sec < 40) begin
            tens = 3;
            ones = sec - 30;
        end else if (sec < 50) begin
            tens = 4;
            ones = sec - 40;
        end else begin
            tens = 5;
            ones = sec - 50;
        end
    end
endmodule