module control_controller (
    input        clk, rst_n,
    // switches
    input        sw_mode,
    input        sw_reset,// bỏ đi, nối tạm chân khác
    input        sw_edit_enable_raw,
    // buttons raw
    input        btn_next,
    input        btn_prev,
    input        btn_inc,
    input        btn_dec,
    // outputs
    output [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7  
);

    // ================= CLOCK DIVIDER =================
    wire tick_1hz, tick_100hz, tick_blink;
    clock_divider #(.clk_freq(50000000)) u_div (
        .clk(clk), .rst_n(rst_n),
        .tick_1hz(tick_1hz),
        .tick_100hz(tick_100hz),
        .tick_blink(tick_blink)
    );

    // ================= BUTTON HANDLER =================
    wire btn_next_edge, btn_prev_edge, btn_inc_edge, btn_dec_edge;
    btn_handler u_btn_next (.clk(clk), .rst_n(rst_n), .tick_100hz(tick_100hz), .btn_in(btn_next), .btn_edge(btn_next_edge));
    btn_handler u_btn_prev (.clk(clk), .rst_n(rst_n), .tick_100hz(tick_100hz), .btn_in(btn_prev), .btn_edge(btn_prev_edge));
    btn_handler u_btn_inc  (.clk(clk), .rst_n(rst_n), .tick_100hz(tick_100hz), .btn_in(btn_inc),  .btn_edge(btn_inc_edge));
    btn_handler u_btn_dec  (.clk(clk), .rst_n(rst_n), .tick_100hz(tick_100hz), .btn_in(btn_dec),  .btn_edge(btn_dec_edge));

    // ================= EDIT FIELD SELECT =================
    wire [1:0] edit_select; 
    edit_field_selector u_edit (
        .clk(clk), .rst_n(rst_n),
        .edit_enable(sw_edit_enable_raw),
        .btn_next(btn_next_edge),
        .btn_prev(btn_prev_edge),
        .edit_select(edit_select)
    );

    // ================= COUNTER CONTROLLER =================
    wire [3:0] sec_ones, sec_tens;
    wire [3:0] min_ones, min_tens;
    wire [3:0] hr_ones, hr_tens;
    wire [3:0] day_ones, day_tens;
    wire [3:0] mon_ones, mon_tens;
    wire [3:0] yr0, yr1, yr2, yr3;
    counter_controller u_counter (
        .clk(clk), .rst_n(rst_n),
        .tick_1hz(tick_1hz),
        .edit_enable(sw_edit_enable_raw),
        .inc(btn_inc_edge),
        .dec(btn_dec_edge),
        .edit_select(edit_select),
        .mode(sw_mode),
        .sec_ones(sec_ones), .sec_tens(sec_tens),
        .min_ones(min_ones), .min_tens(min_tens),
        .hr_ones(hr_ones), .hr_tens(hr_tens),
        .day_ones(day_ones), .day_tens(day_tens),
        .mon_ones(mon_ones), .mon_tens(mon_tens),
        .yr0(yr0), .yr1(yr1), .yr2(yr2), .yr3(yr3)
    );

    // ================= BLINK SELECTOR =================
    wire [7:0] blink_mask; 
    blink_selector u_blink (
        .tick_blink(tick_blink), .rst_n(rst_n),
        .blink_enable(sw_edit_enable_raw),
        .edit_select(edit_select),
        .mode(sw_mode), 
        .blink_mask(blink_mask)
    );

    // ================= DISPLAY CONTROLLER =================
    display_controller u_disp (
        .sec_ones(sec_ones), .sec_tens(sec_tens),
        .min_ones(min_ones), .min_tens(min_tens),
        .hr_ones(hr_ones), .hr_tens(hr_tens),
        .day_ones(day_ones), .day_tens(day_tens),
        .mon_ones(mon_ones), .mon_tens(mon_tens),
        .yr0(yr0), .yr1(yr1), .yr2(yr2), .yr3(yr3),
        .mode(sw_mode),
        .blink_mask(blink_mask),
        .seg_data0(seg0),
        .seg_data1(seg1),
        .seg_data2(seg2),
        .seg_data3(seg3),
        .seg_data4(seg4),
        .seg_data5(seg5),
        .seg_data6(seg6),
        .seg_data7(seg7)
    );

endmodule
