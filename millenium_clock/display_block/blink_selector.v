module blink_selector (
    input tick_blink, rst_n,
    input blink_enable, // =1 khi đang chỉnh sửa
    input [1:0] edit_select,  // chọn trường lớn (giây, phút, giờ, ...)
    input mode,               // 0: smh, 1: dmy
    output reg [7:0] blink_mask // mặt nạ cho 8 digit
);

    reg blink_state;

    // đảo blink_state theo tick_blink
    always @(posedge tick_blink or negedge rst_n) begin
        if (!rst_n)
            blink_state <= 1'b0;
        else
            blink_state <= ~blink_state;
    end

    // tạo mặt nạ blink
    always @(blink_enable or edit_select or blink_state) begin
        blink_mask = 8'b11111111; // mặc định tất cả sáng
        if (blink_enable && blink_state == 1'b0) begin
            if (mode == 1'b0) begin // smh
                case (edit_select)
                    2'b01: blink_mask[3:2] = 2'b00; // giây: digit2, digit3 tắt
                    2'b10: blink_mask[5:4] = 2'b00; // phút: digit4, digit5 tắt
                    2'b11: blink_mask[7:6] = 2'b00; // giờ: digit6, digit7 tắt
                    default: ; // không chỉnh
                endcase
            end else begin // DMY
                case (edit_select)
                    2'b01: blink_mask[7:6] = 2'b00; // ngày: digit6, digit7 tắt
                    2'b10: blink_mask[5:4] = 2'b00; // tháng: digit4, digit5 tắt
                    2'b11: blink_mask[3:0] = 4'b0000; // năm: digit0-3 tắt
                    default: ;
                endcase
            end
        end
    end
endmodule