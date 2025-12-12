package axi_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import axi_if_pkg::*;
    `include "src/axi_env_configuration.svh"
    `include "src/axi_predictor.svh"
    `include "src/axi_scoreboard.svh"
    `include "src/axi_virtual_sequencer.svh"
    `include "src/axi_virtual_sequence.svh"
    `include "src/axi_environment.svh"
endpackage