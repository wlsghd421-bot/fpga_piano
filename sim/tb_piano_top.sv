`timescale 1ns/1ps
// piano_top(버튼 정리 포함) 검증: 짧은 글리치 무시, 안정된 입력만 반영, 440 Hz 반주기 확인
module tb_piano_top;
    initial begin $dumpfile("wave.vcd"); $dumpvars(0, tb_piano_top); end
    reg clk=0, rst=1; always #5 clk=~clk;
    reg [7:0] key=0; wire piezo;
    piano_top #(.CLK_HZ(10000), .STABLE_CYCLES(5)) dut(clk,rst,key,piezo);
    integer i, edges, last, now, half;
    initial begin
        repeat(3) @(posedge clk); @(negedge clk); rst=0;
        // 글리치(2클록)는 무시되어야 한다
        @(negedge clk); key=8'h04; repeat(2) @(negedge clk); key=0;
        repeat(30) begin @(posedge clk); #1; if (piezo!==0) $fatal(1,"glitch passed"); end
        // 안정된 KEY6(440 Hz): 반주기 = 10000/(2*440)=11 클록
        @(negedge clk); key=8'h04;
        edges=0; last=0; half=0;
        for (i=0;i<400;i=i+1) begin
            @(posedge clk); #1; now=$time;
            if (i>0 && piezo!==prev) begin
                edges=edges+1;
                if (edges>=3 && edges<=6 && (now-last)!==11*10) $fatal(1,"half period %0d ns", now-last);
                last=now;
            end
            prev=piezo;
        end
        if (edges<6) $fatal(1,"too few edges %0d", edges);
        @(negedge clk); key=0; repeat(20) @(posedge clk); #1;
        if (piezo!==0) $fatal(1,"not silent");
        $display("PASS piano_top: glitch rejected, 440Hz half period=11 clk, silence");
        $finish;
    end
    reg prev=0;
    initial begin #200000; $fatal(1,"timeout"); end
endmodule
