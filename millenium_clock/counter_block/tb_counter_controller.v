`timescale 1ns/1ps

module tb_counter_controller_overflow;

    reg clk, rst_n;
    reg tick_1hz;
    reg edit_enable;
    reg [3:0] edit_select;
    reg inc, dec;

    wire [3:0] sec_ones, sec_tens;
    wire [3:0] min_ones, min_tens;
    wire [3:0] hr_ones, hr_tens;
    wire [3:0] day_ones, day_tens;
    wire [3:0] mon_ones, mon_tens;
    wire [3:0] yr0, yr1, yr2, yr3;

    // DUT
    counter_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_1hz(tick_1hz),
        .edit_enable(edit_enable),
        .edit_select(edit_select),
        .inc(inc),
        .dec(dec),
        .sec_ones(sec_ones), .sec_tens(sec_tens),
        .min_ones(min_ones), .min_tens(min_tens),
        .hr_ones(hr_ones), .hr_tens(hr_tens),
        .day_ones(day_ones), .day_tens(day_tens),
        .mon_ones(mon_ones), .mon_tens(mon_tens),
        .yr0(yr0), .yr1(yr1), .yr2(yr2), .yr3(yr3)
    );

    // clock 10ns
    always #5 clk = ~clk;

    // task tạo xung tick 1Hz
    task tick;
        begin
            tick_1hz = 1;
            #10;
            tick_1hz = 0;
            #10;
        end
    endtask

    initial begin
    $monitor("Time=%0t | %0d/%0d/%0d %0d:%0d:%0d", 
             $time, dut.year, dut.month, dut.day, 
             dut.hour, dut.minute, dut.second);
    end

    initial begin
        $dumpfile("counter_overflow.vcd");
        $dumpvars(0, tb_counter_controller_overflow);

        // reset
        clk = 0;
        rst_n = 0;
        tick_1hz = 0;
        edit_enable = 0;
        inc = 0; dec = 0; edit_select = 0;
        #20;
        rst_n = 1;

        $display("=== Test Overflow ===");

        // --- 1. Kiểm tra overflow seconds ---
        $display("[SEC] Kiểm tra 59->00");
        repeat(59) tick(); // từ 00 lên 59
        tick(); // nhảy từ 59 -> 00
        $display("sec=%d%d, min=%d%d", sec_tens, sec_ones, min_tens, min_ones);

        // --- 2. Kiểm tra overflow minutes ---
        $display("[MIN] Kiểm tra 59->00");
        repeat(59*60) tick(); // chạy đủ 59 phút
        tick();
        $display("min=%d%d, hr=%d%d", min_tens, min_ones, hr_tens, hr_ones);

        // --- 3. Kiểm tra overflow hours ---
        $display("[HOUR] Kiểm tra 23->00");
        repeat(23*3600) tick(); // chạy đủ 23 giờ
        tick();
        $display("hr=%d%d, day=%d%d", hr_tens, hr_ones, day_tens, day_ones);

        // --- 4. Kiểm tra overflow days (ví dụ tháng 1 có 31 ngày) ---
        $display("[DAY] Kiểm tra cuối tháng -> sang tháng mới");
        repeat(31*24*3600) tick(); // chạy đủ 31 ngày
        tick();
        $display("day=%d%d, mon=%d%d", day_tens, day_ones, mon_tens, mon_ones);

        // --- 5. Kiểm tra overflow months ---
        $display("[MON] Kiểm tra 12->01");
        repeat(12*31*24*3600) tick(); // giả sử chạy cả năm
        tick();
        $display("mon=%d%d, year=%d%d%d%d", mon_tens, mon_ones, yr3, yr2, yr1, yr0);

        $finish;
    end

endmodule
