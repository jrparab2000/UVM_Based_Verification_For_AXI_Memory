package axi_sequences_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import axi_if_pkg::*;
    import axi_env_pkg::*;
    `include "src/axi_base_seq.svh"
    `include "src/axi_sequence_read.svh"
    `include "src/axi_sequence_write.svh"
    `include "src/axi_seq_direct_wr.svh"
    `include "src/axi_virtual_sequence.svh"
endpackage