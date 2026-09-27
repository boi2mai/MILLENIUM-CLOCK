# Millennium Clock

A hardware digital clock system designed in Verilog HDL to accurately track and display time spanning across seconds, minutes, hours, days, months, years, and millennia.

---

## Architecture Overview

The system architecture is partitioned into three primary functional blocks coordinated by a top-level integration module (`top_module.v`):

* **Control Block (`control_block.v`)**:
  * Manages operational modes (Normal Run, Set Time, Calibration) using a Finite State Machine (FSM).
  * Handles debounced user inputs (buttons, switches) for configuration.
  * Implements calendar exception handling, including leap-year detection and month-length calculation across centuries.

* **Counter Block (`counter_block.v`)**:
  * Generates synchronized time ticks from the master clock.
  * Implements cascaded synchronous counters for Seconds (0-59), Minutes (0-59), Hours (0-23), Days (1-28/29/30/31), Months (1-12), and Years/Millennia (0-9999+).
  * Generates overflow and carry pulses to trigger higher-order counters.

* **Display Block (`display_block.v`)**:
  * Converts raw binary/BCD time data from the counter block into display-ready formats.
  * Implements dynamic time-multiplexing for multi-digit 7-segment displays or external display interfaces.
  * Includes blinking and status indicators for configuration and active setting modes.

---

## Project Structure

```text
MILLENIUM-CLOCK/
├── src/
│   ├── control_block.v     # Control FSM and configuration logic
│   ├── counter_block.v     # Multi-stage synchronous time counters
│   ├── display_block.v     # 7-segment decoder and display driver
│   └── top_module.v        # Top-level integration module
├── sim/
│   └── tb_top_module.v     # Testbench for system verification
├── docs/                   # Waveforms, architecture specs, and schematics
└── README.md
```

---

## Simulation & Verification

Import the source files from the `src/` directory into your simulator. Run the testbench `tb_top_module.v` to verify year and millennium transitions.

```bash
# Clone the repository
git clone https://github.com/boi2mai/MILLENIUM-CLOCK.git
cd MILLENIUM-CLOCK

# Compile design and testbench using Icarus Verilog
iverilog -o sim/sim_clock src/*.v sim/tb_top_module.v

# Run simulation
vvp sim/sim_clock

# View waveforms
gtkwave sim/dump.vcd
```

---

## Contributors
* **Huy Le** ([@boi2mai](https://github.com/boi2mai))
