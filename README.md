# VHDL-Based 32 MHz Clock Divider

This project implements a 10-stage clock divider using VHDL-93. It uses a 32 MHz input clock and a 10-bit binary counter to generate ten successive divide-by-2 outputs, reducing the frequency from 16 MHz to 31.25 kHz.

Features
- 32 MHz input clock generation in the simulation testbench.
- Ten successive frequency-divider outputs.
- Active-high asynchronous reset.
- Synthesizable VHDL-93 design.
- Testbench assertions to check reset behaviour, output HIGH times, and clock periods.
- Questa waveform configuration for visualizing the input clock, reset, counter, and divided outputs.

Expected Output

The output frequencies range from 16 MHz at Stage 1 to 31.25 kHz at Stage 10. Each stage operates at half the frequency of the previous stage.

Tools and Technologies
- VHDL-93
- Microchip Libero SoC
- Siemens Questa Advanced Simulator

Files
- `clock_divider_10.vhd` — Main clock-divider design.
- `tb_clock_divider_10.vhd` — Simulation testbench.
- `wave.do` — Questa waveform configuration.

Objective:To implement and simulate a multi-stage digital clock divider and verify its frequency division and reset behaviour.
