`timescale 1ns/1ps
// 보드 시연용 최상위: KEY01~KEY08(HIGH 활성)을 정리해 piano에 연결한다.
module piano_top #(parameter CLK_HZ=50_000_000, parameter STABLE_CYCLES=1_000_000)(
    input wire clk_50mhz, rst_p,
    input wire [7:0] key,
    output wire piezo
);
    wire [7:0] key_clean;
    input_stable #(.WIDTH(8), .STABLE_CYCLES(STABLE_CYCLES)) u_stable(clk_50mhz, rst_p, key, key_clean);
    piano #(.CLK_HZ(CLK_HZ)) u_piano(clk_50mhz, rst_p, key_clean, piezo);
endmodule
