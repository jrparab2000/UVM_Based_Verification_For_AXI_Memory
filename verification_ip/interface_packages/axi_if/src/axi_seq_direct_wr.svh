class axi_seq_direct_wr extends axi_base_seq;
    `uvm_object_utils(axi_seq_direct_wr)

    // axi_transaction req, rsp;
    logic [3:0] awlen; 
    logic [2:0] awsize; 
    logic [31:0] awaddr; 
    logic [1:0] awburst; 

    logic [31:0] wdata; 
    logic [3:0] wstrb;
    
    int count = 0;
    bit flag = 0;

    function new(string name = "");
        super.new(name);
    endfunction //new()

    `uvm_declare_p_sequencer(axi_sequencer)  

    virtual task body();
        // ----------------------------------WRITE-------------------------------------------
        start_w_transaction(awlen, awsize, awaddr, awburst, wdata, count, wstrb);
        all_writes(awlen, awsize, awaddr, awburst, wdata, count, wstrb);
        // end_w_transaction();

        blank_transaction();
        blank_transaction();    

        // ----------------------------------READ-------------------------------------------

        all_reads(awlen, 3'b010, awaddr, awburst);

        blank_transaction();
        blank_transaction();
    endtask

    

endclass //axi_sequence extends uvm_sequence