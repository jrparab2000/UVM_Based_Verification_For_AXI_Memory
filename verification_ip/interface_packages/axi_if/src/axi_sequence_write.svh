class axi_sequence_write extends axi_base_seq;
    `uvm_object_utils(axi_sequence_write)

    // axi_transaction req, rsp;
    logic [3:0] awlen; 
    logic [2:0] awsize; 
    logic [31:0] awaddr; 
    logic [1:0] awburst; 
    logic [3:0] wstrb;
    logic [31:0] wdata; 

    int count = 0;

    function new(string name = "");
        super.new(name);
    endfunction //new()

    `uvm_declare_p_sequencer(axi_sequencer)

    virtual task body();
        start_w_transaction(awlen, awsize, awaddr, awburst, wdata, count, wstrb);
        all_writes(awlen, awsize, awaddr, awburst, wdata, count, wstrb);
        blank_transaction();
        blank_transaction(); 
    endtask

endclass //axi_sequence extends uvm_sequence