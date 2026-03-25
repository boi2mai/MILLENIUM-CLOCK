// btn_handler.v
// debounce + rising edge detect
module btn_handler (
    input  clk,         // clock hệ thống 50MHz
    input  tick_100hz,  // clock chậm để debounce
    input  rst_n,
    input  btn_in,
    output reg btn_edge
);

    // --- synchronize theo tick_100hz để debounce ---
    reg btn_sync1, btn_sync2;
    always @(posedge tick_100hz or negedge rst_n) begin
        if (!rst_n) begin
            btn_sync1 <= 0;
            btn_sync2 <= 0;
        end else begin
            btn_sync1 <= btn_in;
            btn_sync2 <= btn_sync1;
        end
    end

    // --- debounce (~50ms) ---
    reg [3:0] stable_cnt;
    reg btn_debounced;
    always @(posedge tick_100hz or negedge rst_n) begin
        if (!rst_n) begin
            stable_cnt     <= 0;
            btn_debounced  <= 0;
        end else begin
            if (btn_sync2 == btn_debounced) begin
                stable_cnt <= 0;
            end else begin
                stable_cnt <= stable_cnt + 1;
                if (stable_cnt >= 4'd5) begin
                    btn_debounced <= btn_sync2;
                    stable_cnt    <= 0;
                end
            end
        end
    end

    // --- đồng bộ btn_debounced sang clk hệ thống ---
    reg btn_meta, btn_sys, btn_sys_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_meta   <= 0;
            btn_sys    <= 0;
            btn_sys_d  <= 0;
            btn_edge   <= 0;
        end else begin
            btn_meta  <= btn_debounced;
            btn_sys   <= btn_meta;
            btn_edge  <= btn_sys & ~btn_sys_d; // xung 1 clk hệ thống
            btn_sys_d <= btn_sys;
        end
    end

endmodule
// module này dùng để xử lý nút nhấn, bao gồm:
// - debounce: loại bỏ nhiễu tín hiệu do cơ học của nút nhấn
// - rising edge detect: phát hiện khi nút nhấn được nhấn xuống
// - đồng bộ tín hiệu nút nhấn với clock hệ thống