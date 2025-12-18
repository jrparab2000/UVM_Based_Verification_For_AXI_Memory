class axi_sequence_read extends uvm_sequence #(.REQ(axi_transaction), .RSP(axi_transaction));
    `uvm_object_utils(axi_sequence_read)

    axi_transaction req, rsp;

    function new(string name = "");
        super.new(name);
    endfunction //new()

    `uvm_declare_p_sequencer(axi_sequencer)

    virtual task body();
        logic [3:0] arlen; 
        logic [2:0] arsize; 
        logic [31:0] araddr; 
        logic [1:0] arburst; 
        int count = 0;

        req = axi_transaction::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {arsize <= 3'b010;araddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
        end
        req.awvalid =  0;
        req.wvalid = 0;
        req.bready = 0;
        req.arvalid = 1;
        req.rready = 1;

        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        arlen = req.arlen;      //len = 7
        arsize = req.arsize;
        araddr = req.araddr;
        arburst = req.arburst;

        count = req.arlen + 1;  //count = 8

        finish_item(req);
        get_response(rsp);

        // if(rsp.rvalid == 1 || rsp.rlast == 1) begin
        //     count--;    //count = 7
        //     // if(rsp.rlast ==)
        // end
        while (count >= 0) begin
        req = axi_transaction::type_id::create("req");                  
        start_item(req);
        if(!req.randomize() with {arsize <= 3'b010;araddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
        end

        req.awvalid =  0;
        req.wvalid = 0;
        req.bready = 0;
        req.arvalid = 1;
        req.rready = 1;

        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        req.arlen = arlen;
        req.arsize = arsize;
        req.araddr = araddr;
        req.arburst = arburst;

        finish_item(req);
        get_response(rsp);

        if(rsp.rvalid == 1 || rsp.rlast == 1) begin
            count--;    //count = 6,5,4,3,2,1,0
        end
        end

        req = axi_transaction::type_id::create("req");                  
        start_item(req);
        req.awvalid =  0;
        req.wvalid = 0;
        req.bready = 0;
        req.arvalid = 0;
        req.rready = 0;
        
        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        req.awlen = 0;
        req.awsize = 0;
        req.awaddr = 0;
        req.awburst = 0;

        
        finish_item(req);
        get_response(rsp);

        req = axi_transaction::type_id::create("req");                  
        start_item(req);
        req.awvalid =  0;
        req.wvalid = 0;
        req.bready = 0;
        req.arvalid = 0;
        req.rready = 0;
        
        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        req.awlen = 0;
        req.awsize = 0;
        req.awaddr = 0;
        req.awburst = 0;

        
        finish_item(req);
        get_response(rsp);
    endtask //
endclass //axi_sequence_read extends uvm_sequence #(.REQ(axi_transaction), .RSP(axi_transaction))