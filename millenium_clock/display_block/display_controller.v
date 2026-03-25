module display_controller (
    // dữ liệu bcd từ counter_controller
    input  [3:0] sec_ones, sec_tens,
    input  [3:0] min_ones, min_tens,
    input  [3:0] hr_ones,  hr_tens,
    input  [3:0] day_ones, day_tens,
    input  [3:0] mon_ones, mon_tens,
    input  [3:0] yr0, yr1, yr2, yr3,

    // điều khiển hiển thị
    input        mode,           // 0: smh, 1: dmy
    input  [7:0] blink_mask,     // từ blink_selector

    // xuất ra led 7 đoạn
    output [6:0] seg_data0, seg_data1, seg_data2, seg_data3,
    output [6:0] seg_data4, seg_data5, seg_data6, seg_data7
);

    // wires cho các digit bcd
    wire [3:0] dig0, dig1, dig2, dig3, dig4, dig5, dig6, dig7;
    // wires cho mã 7 thanh trước khi áp dụng blink
    wire [6:0] seg_raw0, seg_raw1, seg_raw2, seg_raw3;
    wire [6:0] seg_raw4, seg_raw5, seg_raw6, seg_raw7;

    // chọn dữ liệu bcd cho từng digit
    digit_selector u_digit_selector (
        .sec_ones(sec_ones), .sec_tens(sec_tens),
        .min_ones(min_ones), .min_tens(min_tens),
        .hr_ones(hr_ones),   .hr_tens(hr_tens),
        .day_ones(day_ones), .day_tens(day_tens),
        .mon_ones(mon_ones), .mon_tens(mon_tens),
        .yr0(yr0), .yr1(yr1), .yr2(yr2), .yr3(yr3),
        .mode(mode),
        .dig0(dig0), .dig1(dig1), .dig2(dig2), .dig3(dig3),
        .dig4(dig4), .dig5(dig5), .dig6(dig6), .dig7(dig7)
    );

    // giải mã từng digit sang 7 thanh
    bcd_to_7seg u_seg0 (.data(dig0), .seg_data(seg_raw0));
    bcd_to_7seg u_seg1 (.data(dig1), .seg_data(seg_raw1));
    bcd_to_7seg u_seg2 (.data(dig2), .seg_data(seg_raw2));
    bcd_to_7seg u_seg3 (.data(dig3), .seg_data(seg_raw3));
    bcd_to_7seg u_seg4 (.data(dig4), .seg_data(seg_raw4));
    bcd_to_7seg u_seg5 (.data(dig5), .seg_data(seg_raw5));
    bcd_to_7seg u_seg6 (.data(dig6), .seg_data(seg_raw6));
    bcd_to_7seg u_seg7 (.data(dig7), .seg_data(seg_raw7));


    // áp dụng blink_mask từng digit
    blink_mask_applier u_blink (
        .blink_mask(blink_mask),

        .seg_data_in0(seg_raw0), 
        .seg_data_in1(seg_raw1),
        .seg_data_in2(seg_raw2), 
        .seg_data_in3(seg_raw3),
        .seg_data_in4(seg_raw4), 
        .seg_data_in5(seg_raw5),
        .seg_data_in6(seg_raw6), 
        .seg_data_in7(seg_raw7),

        .seg_data_out0(seg_data0), 
        .seg_data_out1(seg_data1),
        .seg_data_out2(seg_data2), 
        .seg_data_out3(seg_data3),
        .seg_data_out4(seg_data4), 
        .seg_data_out5(seg_data5),
        .seg_data_out6(seg_data6), 
        .seg_data_out7(seg_data7)
    );


endmodule
