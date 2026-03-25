// tính toán năm nhuận
module leap_year_detector (
    input [13:0] year, 
    input [3:0] dvi, chuc, nghin, tram, // BCD digits for year
    output wire leap
);
 

    wire [7:0] binary_nghin_tram ;



    bcd2bin_2digit bcd2bin (
        .nghin(nghin), 
        .tram(tram), // ghép 2 digit BCD thành 2 digit binary
        .binary(binary_nghin_tram)
    );

    wire div4   = (year[1:0] == 2'b00); // khi 2 bit cuối của cnt_100 = 0 thì những bit sau đó là bội của 4 => chia hết cho 4
    wire div100 = (dvi == 0 && chuc == 0);          // chia hết cho 100
    wire div400 = (dvi == 0 && chuc == 0 && binary_nghin_tram[1:0] == 2'b00);         // chia hết cho 400
  
    assign leap = (div4 && !div100) || div400; // năm nhuận nếu chia hết cho 4 nhưng không chia hết cho 100, hoặc chia hết cho 400
endmodule

module bcd2bin_2digit (
    input  wire [3:0]nghin,  
    input  [3:0]tram,            // 2 digit BCD: [7:4] = tens, [3:0] = ones
    output [7:0] binary     // binary output (0–99)
);
    assign binary = (nghin * 4'd10) + tram ;

endmodule