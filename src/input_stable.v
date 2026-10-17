`timescale 1ns/1ps
// 보드 버튼용 입력 정리: 2단 동기화 후 STABLE_CYCLES 클록 동안 같은 값이면 출력에 반영한다.
module input_stable #(parameter WIDTH=8, parameter STABLE_CYCLES=1_000_000)(
    input wire clk_50mhz, rst_p,
    input wire [WIDTH-1:0] raw,
    output reg [WIDTH-1:0] clean
);
    reg [WIDTH-1:0] s1, s2;
    reg [31:0] cnt [0:WIDTH-1];
    integer i;
    always @(posedge clk_50mhz) begin
        s1 <= raw; s2 <= s1;
        if (rst_p) begin
            clean <= 0;
            for (i=0;i<WIDTH;i=i+1) cnt[i] <= 0;
        end else begin
            for (i=0;i<WIDTH;i=i+1) begin
                if (s2[i] == clean[i]) cnt[i] <= 0;
                else if (cnt[i] >= STABLE_CYCLES-1) begin clean[i] <= s2[i]; cnt[i] <= 0; end
                else cnt[i] <= cnt[i] + 1;
            end
        end
    end
endmodule
