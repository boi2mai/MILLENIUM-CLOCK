module edit_field_selector (
    input clk, rst_n,
    input edit_enable, // tín hiệu bật chế độ chỉnh sửa
    input btn_next, // nút nhấn chuyển sang trường tiếp theo
    input btn_prev, // nút nhấn chuyển về trường trước
    output reg [1:0] edit_select // trường đang chỉnh sửa: 00 = 0 chỉnh sửa, 01 = s/d, 10 = m/m, 11 = h/y
);
    reg edit_enable_d; // giữ trạng thái trước đó của edit_enable

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        edit_select   <= 2'b00;
        edit_enable_d <= 0;
    end else begin
        edit_enable_d <= edit_enable;

        // khi vừa bật edit_enable lần đầu, đặt trường mặc định
        if (edit_enable && !edit_enable_d) begin
            edit_select <= 2'b01; // bắt đầu chỉnh sửa từ trường 01
        end
        // khi tắt edit_enable, reset về 00
        else if (!edit_enable) begin
            edit_select <= 2'b00;
        end
        // chỉ đổi trường khi nhấn nút, không ghi đè
        else if (btn_next && !btn_prev) begin
            case (edit_select)
                2'b01: edit_select <= 2'b10;
                2'b10: edit_select <= 2'b11;
                2'b11: edit_select <= 2'b01;
                default: edit_select <= 2'b01;
            endcase
        end else if (!btn_next && btn_prev) begin
            case (edit_select)
                2'b01: edit_select <= 2'b11;
                2'b10: edit_select <= 2'b01;
                2'b11: edit_select <= 2'b10;
                default: edit_select <= 2'b01;
            endcase
        end
    end
end
endmodule

        