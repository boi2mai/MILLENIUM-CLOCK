`timescale 1ns/1ns

module tb_control_controller;

    // Parameters
    parameter CLK_PERIOD = 20;  // 50MHz clock (20ns period)

    // Inputs
    reg clk;
    reg rst_n;
    reg sw_mode;
    reg sw_reset;  // Dù không dùng, giữ để khớp với module
    reg sw_edit_enable_raw;
    reg btn_next;
    reg btn_prev;
    reg btn_inc;
    reg btn_dec;

    // Outputs
    wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;

    // Instantiate the Unit Under Test (UUT)
    control_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .sw_mode(sw_mode),
        .sw_reset(sw_reset),
        .sw_edit_enable_raw(sw_edit_enable_raw),
        .btn_next(btn_next),
        .btn_prev(btn_prev),
        .btn_inc(btn_inc),
        .btn_dec(btn_dec),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5),
        .seg6(seg6),
        .seg7(seg7)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;  // Generate 50MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst_n = 0;
        sw_mode = 0;          // Start in time mode (smh)
        sw_edit_enable_raw = 0;
        sw_reset = 0;         // Không dùng, giữ 0
        btn_next = 0;
        btn_prev = 0;
        btn_inc = 0;
        btn_dec = 0;

        // Reset
        #50 rst_n = 1;  // Release reset after 50ns
        #100;           // Wait for stabilization

        // Test 1: Normal time mode (smh), no edit
        $display("Test 1: Normal time mode (smh), no edit");
        sw_mode = 0;
        sw_edit_enable_raw = 0;
        #1000;  // Let clock_divider generate ticks

        // Test 2: Enable edit mode, select seconds (edit_select=01), increment
        $display("Test 2: Edit mode, select seconds, increment");
        sw_edit_enable_raw = 1;
        // Simulate btn_next to select seconds (edit_select logic in edit_field_selector)
        btn_next = 1; #40 btn_next = 0;  // Pulse btn_next
        #100;
        btn_inc = 1; #40 btn_inc = 0;    // Pulse btn_inc to increment seconds
        #500;  // Wait to see effect on seg2, seg3

        // Test 3: Switch to date mode (dmy), select day (edit_select=01), increment
        $display("Test 3: Date mode (dmy), select day, increment");
        sw_mode = 1;
        sw_edit_enable_raw = 1;
        btn_next = 1; #40 btn_next = 0;  // Reset edit_select to start
        #100;
        btn_inc = 1; #40 btn_inc = 0;    // Pulse btn_inc to increment day
        #500;  // Wait to see effect on seg6, seg7

        // Test 4: Disable edit mode
        $display("Test 4: Disable edit mode");
        sw_edit_enable_raw = 0;
        #1000;  // Let it run normally

        // End simulation
        $display("Simulation finished at %t", $time);
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%t, sw_mode=%b, sw_edit=%b, seg0=%b, seg1=%b, seg2=%b, seg3=%b, seg4=%b, seg5=%b, seg6=%b, seg7=%b",
                 $time, sw_mode, sw_edit_enable_raw, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    end

endmodule