# UVM_Based_Verification_For_AXI_Memory

## Overview

This project focuses on **verifying an AXI protocol–based memory** using the **UVM (Universal Verification Methodology)** library and **Siemens Questa** tools. The verification environment is designed to be modular, reusable, and automated.

The project implements:

* A **UVM-based AXI verification environment**
* A **simple functional coverage model**
* A **prediction and scoreboard model**
* **Regression automation** with coverage merging
* **Python-based simulation automation**

This repository is intended as a reference-quality AXI UVM verification framework suitable for learning, extension, and interview discussions.

---

## Key Features

* AXI Memory RTL verification
* Fully layered UVM testbench (agent, env, scoreboard, predictor)
* Functional coverage collection and UCDB merging
* Automated regressions using shell and Python scripts
* Support for both **CLI** and **GUI (Questa)** simulation flows
* Clean project separation: RTL, TB, VIP, scripts, and reports

---

## Tools & Technologies

* **Language**: SystemVerilog, Python, Shell scripting
* **Methodology**: UVM
* **Simulator**: Siemens Questa
* **Coverage**: UCDB, vcover merge
* **Automation**: Makefile, Python, bash

---

## Project Directory Structure

```
Project_benches/
└── axi_mem/
    ├── rtl/
    │   └── axi_mem.sv
    │
    ├── sim/
    │   ├── logs/                # Stores logs generated during each run
    │   ├── reports/
    │   │   └── report.csv       # Extracted metrics (matches, mismatches, coverage)
    │   ├── ucdb/                # Coverage databases (.ucdb / .txt)
    │   ├── cli.do               # Script invoked during make cli
    │   ├── filelist.f           # List of SV files for compilation
    │   ├── Makefile             # Build and simulation control
    │   ├── process.do           # GUI-based Questa script
    │   ├── regress.sh           # Runs regression & merges coverage
    │   ├── script.py            # Python automation for simulations
    │   └── wave.do              # Adds signals to waveform window
    │
    └── tb/
        ├── sequences/
        │   ├── src/
        │   │   ├── axi_base_seq.svh
        │   │   ├── axi_seq_direct_wr.svh
        │   │   ├── axi_sequence_read.svh
        │   │   ├── axi_sequence.write.svh
        │   │   └── axi_virtual_sequence.svh
        │   └── axi_sequence_pkg.sv
        │
        ├── testbenches/
        │   ├── hdl_top.sv
        │   └── hvl_top.sv
        │
        └── tests/
            ├── src/
            │   ├── direct_test_seq_wr.svh
            │   └── test_top.svh
            ├── axi_tests_filelist.f
            ├── Makefile
            └── tests_pkg.sv

verification_ip/
├── environment_packages/
│   └── axi_env/
│       ├── src/
│       │   ├── axi_base_predictor.svh
│       │   ├── axi_env_configuration.svh
│       │   ├── axi_environment.svh
│       │   ├── axi_predictor.svh
│       │   ├── axi_scoreboard.svh
│       │   └── axi_virtual_sequencer.svh
│       ├── axi_env_pkg.sv
│       └── Makefile
│
└── interface_packeages/
    └── axi_if/
        ├── src/
        │   ├── axi_agent.svh
        │   ├── axi_configuration.svh
        │   ├── axi_coverage.svh
        │   ├── axi_driver_bfm.svh
        │   ├── axi_driver.svh
        │   ├── axi_if.sv
        │   ├── axi_monitor_bfm.svh
        │   ├── axi_monitor.svh
        │   ├── axi_sequencer.svh
        │   ├── axi_transaction.svh
        │   └── axi_typedef.svh
        ├── axi_if_pkg.sv
        ├── axi_pkg_filelist.f
        ├── axi_pkg_hdl.sv
        └── Makefile

README.md
```

---

## Verification Architecture

### AXI Interface Package

* Defines AXI protocol types and transactions
* Implements AXI agent (driver, monitor, sequencer)
* Collects functional coverage

### AXI Environment Package

* Integrates AXI agent(s)
* Includes predictor and scoreboard
* Supports virtual sequencing

### Testbench

* Modular test structure
* Virtual sequences for complex scenarios
* Easy test scalability

---

## Simulation Flow

### 1. Compilation

Controlled via Makefiles and filelists.

### 2. Simulation Modes

* **CLI Mode**: `make cli` Uses `cli.do` and `wave.do`
* **GUI Mode**: `make debug` Uses `process.do` and `wave.do`

### 3. Regression

* `regress.sh` runs multiple simulations with different seeds
* Coverage databases are merged
* Final coverage is reported

### 4. Automation

* `script.py` allows running N tests with configurable inputs
* Automatically extracts logs and generates CSV reports

---

## Coverage & Reporting

* Functional coverage collected in UCDB format
* Merged using `vcover merge`
* Final results exported to `report.csv`
* Metrics include:

  * Total runs
  * Matches / Mismatches
  * Overall coverage percentage

---

## How to Run

### Makefile Parameters (sim/Makefile)

The `Makefile` inside the `sim` directory supports multiple configurable parameters to control simulation, coverage, prediction, and logging behavior.

```makefile
SV_SEED   ?= 123456789   # Seed for randomization
UVM_TEST  ?= test_top    # Test to be executed
VERBOSITY ?= UVM_HIGH    # UVM verbosity level
LOGS      ?= $(UVM_TEST)_$(SV_SEED)  # Log directory name
READS     ?= 5           # Number of read transactions
WRITES    ?= 5           # Number of write transactions
COV_EN    ?= 1           # Enable functional coverage
PRE_EN    ?= 1           # Enable prediction model
RUNS      ?= 10          # Number of read/write pairs
COV_NAME  ?= test_top    # Coverage database name
```

These parameters can be overridden directly from the command line:

```bash
make UVM_TEST=test_top SV_SEED=999 READS=10 WRITES=10 VERBOSITY=UVM_MEDIUM
```

---

### Basic Simulation

```bash
# Run in CLI mode
make cli

# Run GUI mode
make debug

# Run regression
make regress

# To merge coverage
make mergecover

# To merge and view coverage in questa sim
make viewcover
```

The `make regress` command internally invokes `regress.sh`, which:

* Runs multiple simulations with different seeds and parameters
* Collects UCDB coverage data
* Merges coverage using `vcover merge`
* Produces a final overall coverage report

---

### Automated Flow (Python)

The entire simulation flow can also be automated using the provided Python script:

```bash
python3 script.py [options]
```

#### Supported Command-Line Arguments

```text
-t, --test            Test name: test_top | direct_test_seq_wr | random (required)
-u, --uvm_verbose     Set UVM verbosity (default: UVM_NONE)
-v, --verbose         Enable Python script verbosity
-r, --random          Enable randomized inputs
-l, --loop            Number of tests to run (required)
--seeds               List of seeds (count must match --loop) (required if not randomized)
--runs                List of read-write pairs per run (count must match --loop) (required if not randomized)
--writes              List of write transactions per run (count must match --loop) (required if not randomized)
--reads               List of read transactions per run (count must match --loop) (required if not randomized)
```

#### Example: Deterministic Runs

```bash
python3 script.py \
  --test test_top \
  --loop 2 \
  --seeds 101 202 \
  --runs 10 20 \
  --writes 5 10 \
  --reads 5 10
```

#### Example: Randomized Runs

```bash
python3 script.py \
  --test random \
  --loop 5 \
  --random
```

In random mode, seeds and transaction counts are automatically generated.

---

```

---

## Future Enhancements
- AXI burst and out-of-order transaction support
- Assertion-based verification (SVA)
- Simultaneous R/W support
- Integration with CI pipelines

---

## Author
**Jayesh Parab**  
Master's in Computer Engineering  
NCSU (May 2025)

---

## License
This project is intended for educational and demonstration purposes.

```
