class axi_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(axi_virtual_sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);    
    endfunction //new()

    axi_sequencer axi_seqr;
endclass //axi_virtual_sequencer extends uvm_sequencer