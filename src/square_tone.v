`timescale 1ns/1ps
// 사각파 생성. 반주기 클록 수는 8개 음에 대해 컴파일 시점에 계산한 상수 표로 선택한다.
// (원본의 CLK_HZ/(2*frequency_hz) 조합 나눗셈은 50 MHz에서 타이밍을 만족하지 못해 상수 표로 대체)
module square_tone #(parameter CLK_HZ=50_000_000)(
    input wire clk_50mhz, rst_p,
    input wire [31:0] frequency_hz,
    output reg tone
);
    reg [31:0] count, previous_hz;
    reg [31:0] half_cycles;
    always @* begin
        case (frequency_hz)
            262: half_cycles = CLK_HZ / (2 * 262);
            294: half_cycles = CLK_HZ / (2 * 294);
            330: half_cycles = CLK_HZ / (2 * 330);
            349: half_cycles = CLK_HZ / (2 * 349);
            392: half_cycles = CLK_HZ / (2 * 392);
            440: half_cycles = CLK_HZ / (2 * 440);
            494: half_cycles = CLK_HZ / (2 * 494);
            523: half_cycles = CLK_HZ / (2 * 523);
            default: half_cycles = 1;
        endcase
    end
    always @(posedge clk_50mhz) begin
        if(rst_p) begin count<=0; tone<=0; previous_hz<=0; end
        else if(frequency_hz==0 || frequency_hz!=previous_hz) begin
            count<=0; tone<=0; previous_hz<=frequency_hz;
        end
        else if(count >= half_cycles-1) begin count<=0; tone<=~tone; end
        else count<=count+1;
    end
endmodule
