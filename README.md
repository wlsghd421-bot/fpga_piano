# fpga_piano — STM32_1 FPGA 실습 ① 피아노

전기전자컴퓨터실험설계2 · 박진홍(2023440049) · 2026-10-19 예비

- 보드: Combo II-DLD-Base (Spartan-7 `xc7s75fgga484-1`), 클록 50 MHz
- 시뮬레이션 최상위: `tb` (`sim/tb_piano.sv`), 보드용 최상위: `piano_top`
- 소스: `src/` (`note_select`, `square_tone`, `piano`, `input_stable`, `piano_top`), XDC: `constraints/piano.xdc`

## 결과
| 항목 | 결과 |
|---|---|
| Icarus 시뮬레이션 | `PASS piano: all 8 tones, silence, multiple keys, reset` (4,796,000 ps) |
| `piano_top` 시뮬레이션 (`tb_piano_top`) | `PASS piano_top: glitch rejected, 440Hz half period=11 clk, silence` |
| Vivado 합성·구현·비트스트림 | 성공, Critical Warning 0, Error 0 |
| 타이밍 (50 MHz) | WNS +9.639 ns, 모든 제약 만족 |

파형: `docs/sim_wave.png` (key 80→01 순서로 누를 때 `piezo` 토글 간격이 짧아짐).

## 교재 코드에서 바꾼 부분
- `square_tone`: 클록마다 `CLK_HZ/(2*frequency_hz)` 나눗셈을 하면 50 MHz에서 타이밍을 만족하지 못해(WNS -47.556 ns) 8개 음의 반주기를 상수 표로 바꿈.
- `input_stable`, `piano_top` 추가: 보드 버튼 동기화·채터링 제거(20 ms).

## 핀 (`Xilinx_S7_Pin_Map.xlsx`)
clk_50mhz B6, rst_p K2(KEY09), key[7:0] = KEY01..KEY08 = K4,N8,N4,N1,P6,N6,L5,J2 (262,294,330,349,392,440,494,523 Hz), piezo Y21.
