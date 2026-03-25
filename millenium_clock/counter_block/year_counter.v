module year_counter (
    input clk,
    input rst_n,
    input inc,         // tăng năm
    input dec,         // giảm năm
    output reg [3:0] digit0, digit1, digit2, digit3,
    output reg [13:0] year
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            year <= 14'd2025;
        end else begin
            if (inc) begin
                if (year == 9999) begin
                    year <= 1;  // 
                end else begin
                    year <= year + 1;
                end
            end else if (dec) begin
                if (year == 1) year <= 9999; // 
                else year <= year - 1;
            end
        end
    end

// Double Dabble chuyển year (14-bit) sang 4 digit BCD
integer i;
reg [29:0] shift_reg;  // đủ chỗ cho 14 bit dữ liệu + 16 bit BCD
always @(shift_reg) begin
    shift_reg = 30'd0;
    shift_reg[13:0] = year;
    for (i = 0; i < 14; i = i + 1) begin
        if (shift_reg[29:26] >= 5) shift_reg[29:26] = shift_reg[29:26] + 3; // nghìn
        if (shift_reg[25:22] >= 5) shift_reg[25:22] = shift_reg[25:22] + 3; // trăm
        if (shift_reg[21:18] >= 5) shift_reg[21:18] = shift_reg[21:18] + 3; // chục
        if (shift_reg[17:14] >= 5) shift_reg[17:14] = shift_reg[17:14] + 3; // đơn vị
        shift_reg = shift_reg << 1;
    end
    digit3 = shift_reg[29:26]; // nghìn
    digit2 = shift_reg[25:22]; // trăm
    digit1 = shift_reg[21:18]; // chục
    digit0 = shift_reg[17:14]; // đơn vị
end

endmodule