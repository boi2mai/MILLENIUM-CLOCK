module digit_selector (
    input [3:0] sec_ones, sec_tens, min_ones, min_tens, hr_ones, hr_tens, day_ones, day_tens, mon_ones, mon_tens, yr0, yr1, yr2, yr3,
    input mode,
    output reg [3:0] dig0, dig1, dig2, dig3, dig4, dig5, dig6, dig7
);
    // mode == 0 => display smh, otherwise display dmy
    always @(mode) begin
        if (!mode) begin
        dig7 = hr_tens; dig6 = hr_ones;  dig5 = min_tens; dig4 = min_ones; dig3 = sec_tens; dig2 = sec_ones;
        // dig1 và dig0 gán là 4'b1111 để trùng với default trong seven_segment_decoder => tắt
        dig1 = 4'b1111; dig0 = 4'b1111;
        end else begin
        dig7 = day_tens; dig6 = day_ones;  dig5 = mon_tens; dig4 = mon_ones; dig3 = yr3; dig2 = yr2; dig1 = yr1; dig0 = yr0;
        end
    end
endmodule
      