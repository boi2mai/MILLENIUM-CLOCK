module counter_controller (
    input clk,
    input rst_n,
    input tick_1hz,            // xung 1Hz từ clock divider
    input edit_enable,
    input mode,         // 1 = chế độ chỉnh sửa
    input [1:0] edit_select,   // chọn trường chỉnh sửa
    input inc, dec,            // nút tăng/giảm khi chỉnh

    // xuất dữ liệu BCD cho display
    output [3:0] sec_ones, sec_tens,
    output [3:0] min_ones, min_tens,
    output [3:0] hr_ones, hr_tens,
    output [3:0] day_ones, day_tens,
    output [3:0] mon_ones, mon_tens,
    output [3:0] yr0, yr1, yr2, yr3
);

    // carry signal giữa các counter
    wire carry_sec, carry_min, carry_hr, carry_day, carry_mon, leap;
    wire [3:0] month;
    wire [13:0] year;

// sec
sec_counter u_sec (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? tick_1hz : (edit_enable && mode==1'b0 && edit_select==2'b01 && inc)),
    .dec(edit_enable && mode==1'b0 && edit_select==2'b01 && dec),
    .carry_sec(carry_sec),
    .ones(sec_ones),
    .tens(sec_tens)
);

// min
min_counter u_min (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? carry_sec : (edit_enable && mode==1'b0 && edit_select==2'b10 && inc)),
    .dec(edit_enable && mode==1'b0 && edit_select==2'b10 && dec),
    .carry_min(carry_min),
    .ones(min_ones),
    .tens(min_tens)
);

// hr
hr_counter u_hr (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? carry_min : (edit_enable && mode==1'b0 && edit_select==2'b11 && inc)),
    .dec(edit_enable && mode==1'b0 && edit_select==2'b11 && dec),
    .carry_hr(carry_hr),
    .ones(hr_ones),
    .tens(hr_tens)
);

// day
day_counter u_day (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? carry_hr : (edit_enable && mode==1'b1 && edit_select==2'b01 && inc)),
    .dec(edit_enable && mode==1'b1 && edit_select==2'b01 && dec),
    .month(month),
    .leap(leap),
    .carry_day(carry_day),
    .ones(day_ones),
    .tens(day_tens)
);

// month
month_counter u_month (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? carry_day : (edit_enable && mode==1'b1 && edit_select==2'b10 && inc)),
    .dec(edit_enable && mode==1'b1 && edit_select==2'b10 && dec),
    .carry_mon(carry_mon),
    .month(month),
    .ones(mon_ones),
    .tens(mon_tens)
);
// leap year detection
leap_year_detector u_leap (
    .year(year),
    .dvi(yr0), 
    .chuc(yr1),
    .nghin(yr2), // lấy năm từ BCD
    .tram(yr3), // lấy năm từ BCD
    .leap(leap)
);

// year
year_counter u_year (
    .clk(clk),
    .rst_n(rst_n),
    .inc((!edit_enable) ? carry_mon : (edit_enable && mode==1'b1 && edit_select==2'b11 && inc)),
    .dec(edit_enable && mode==1'b1 && edit_select==2'b11 && dec),
    .digit0(yr0),
    .digit1(yr1),
    .digit2(yr2),
    .digit3(yr3),
    .year(year)

);

endmodule
