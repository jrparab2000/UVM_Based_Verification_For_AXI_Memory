class axi_sequencer extends uvm_sequencer #(.REQ(axi_transaction),.RSP(axi_transaction));
    `uvm_component_utils(axi_sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
endclass //decode_in_sequencer extends uvm_sequencer #(.REQ(decode_in_transaction),.RSP(decode_in_transaction))