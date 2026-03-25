// Code your design here
module clock_divider #(parameter clk_freq = 50000000)(
	input clk, rst_n,
  	output reg tick_1hz, 	// sóng 1hz (1s) => mỗi giây +1 => dùng để đếm
  	output reg tick_100hz, 	// f = 100hz => T = 10ms => xung 1 chu kì mỗi 10ms dùng để debounce phím khi nhấn
  							// debounce là để ấn 1 lần thì fpga hiểu là ấn đúng 1 lần chứ k nhầm thành nhiều lần (do cấu trúc cơ học của button)
  	output reg tick_blink 		// sóng vuông 2hz (0,5s) => tắt bật mỗi 0,25s 
);
    localparam clk_1hz = clk_freq/1;
    localparam clk_100hz = clk_freq/100; // tạo các xung clock riêng cho từng counter, khi counter đếm đủ -> trả về output tick = 1
    localparam clk_blink = clk_freq/4;
  
    reg [31:0] counter_1hz; // 32 bit đủ đếm từ 1 -> 50M
    reg [18:0] counter_100hz; // 19 bit đủ đếm từ 1 -> 500k
    reg [23:0] counter_blink; // 24 bit đủ đếm từ 1 -> 12,5M
    
  
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        counter_1hz <= 0; counter_100hz <= 0; counter_blink <= 0;
        tick_1hz <= 0; tick_100hz <= 0; tick_blink <= 0;
        end else begin
            //default cho các tick về 0 trừ blink
     	    tick_1hz <= 0; tick_100hz <= 0;
            // tạo xung clock 1s
            if (counter_1hz == clk_1hz -1) begin
          	    counter_1hz <= 0; tick_1hz <= 1;
            end else counter_1hz <= counter_1hz + 1;
            // tạo xung clock 10ms
            if (counter_100hz == clk_100hz -1) begin
          	    counter_100hz <= 0; tick_100hz <= 1;
            end else counter_100hz <= counter_100hz + 1;
            // tạo xung clock blink 1s
            if (counter_blink == clk_blink -1) begin
          	    counter_blink <= 0; tick_blink <= ~tick_blink;
            end else counter_blink <= counter_blink + 1;
        end
    end
endmodule
// module này tạo ra các xung clock riêng biệt để sử dụng cho các module khác
// tick_1hz: xung 1s dùng để đếm
// tick_100hz: xung 10ms dùng để debounce phím  

