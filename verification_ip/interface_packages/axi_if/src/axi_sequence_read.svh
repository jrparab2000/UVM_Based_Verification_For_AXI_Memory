class axi_sequence_read extends axi_base_seq;
    `uvm_object_utils(axi_sequence_read)

    // axi_transaction req, rsp;
    logic [3:0] arlen; 
    logic [2:0] arsize; 
    logic [31:0] araddr; 
    logic [1:0] arburst; 

    function new(string name = "");
        super.new(name);
    endfunction //new()

    `uvm_declare_p_sequencer(axi_sequencer)

    virtual task body();
        // start_r_transaction(arlen, arsize, araddr, arburst);
        req = axi_transaction::type_id::create("req"); 
        if(!req.randomize() with {arsize <= 3'b010;araddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
        end
        all_reads(req.arlen, req.arsize, req.araddr, req.arburst);
        blank_transaction();
        blank_transaction();
    endtask //
endclass //axi_sequence_read extends uvm_sequence #(.REQ(axi_transaction), .RSP(axi_transaction))