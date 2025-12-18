package axi_if_pkg;
    import uvm_pkg::*;
    import axi_pkg_hdl::*;

    `include "uvm_macros.svh"
    
    export axi_pkg_hdl::*;

    // `include "src/axi_typedef.svh"
    `include "src/axi_transaction.svh"
    `include "src/axi_coverage.svh"
    `include "src/axi_configuration.svh"
    `include "src/axi_sequencer.svh"
    `include "src/axi_sequence_read.svh"
    `include "src/axi_sequence_write.svh"
    `include "src/axi_seq_direct_wr.svh"
    `include "src/axi_monitor.svh"
    `include "src/axi_driver.svh"
    `include "src/axi_agent.svh"
endpackage