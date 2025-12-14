class axi_sequence_write extends uvm_sequence #(.REQ(axi_transaction), .RSP(axi_transaction));
    `uvm_object_utils(axi_sequence_write)

    axi_transaction req, rsp;

    function new(string name = "");
        super.new(name);
    endfunction //new()

    `uvm_declare_p_sequencer(axi_sequencer)

    virtual task body();
        logic [3:0] awlen; 
        logic [2:0] awsize; 
        logic [31:0] awaddr; 
        logic [1:0] awburst; 
        int count = 0;

        req = axi_transaction::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {wstrb == 4'hf;awsize <= 3'b010;awaddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
        end
        req.awvalid =  1;
        req.wvalid = 1;
        req.bready = 0;
        req.arvalid = 0;
        req.rready = 0;

        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        req.wlast = 0;

        awlen = req.awlen;      //len = 7
        awsize = req.awsize;
        awaddr = req.awaddr;
        awburst = req.awburst;

        count = req.awlen + 1;  //count = 8

        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);

        if(rsp.wready == 1) begin
            count--;    //count = 7
        end
        while (count >= 0) begin
        req = axi_transaction::type_id::create("req");                  
        start_item(req);
        if(count == 0) begin
            req.awvalid =  0;
            req.wvalid = 0;
            req.wlast = 1;
            req.bready = 1;
            req.awlen = 0;
            req.awsize = 0;
            req.awaddr = 0;
            req.awburst = 0;
        end
        else begin
            if(!req.randomize() with {wstrb == 4'hf; awsize <= 3'b010; awaddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
            end
            req.awvalid =  1;
            req.wvalid = 1;
            req.bready = 0;
            req.arvalid = 0;
            req.rready = 0;
            req.wlast = 0;
            req.awlen = awlen;
            req.awsize = awsize;
            req.awaddr = awaddr;
            req.awburst = awburst;
        end
        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;
        
        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);
        $display("\n-----------------------got response----------------------------------\n",count);
        `uvm_info(get_type_name(), rsp.convert2string(), UVM_FULL)
        if (rsp == null)
            `uvm_fatal(get_type_name(), "rsp was not sent")
        
        if (rsp.bvalid && req.bready)
            break;
        
        if(rsp.wready == 1) begin
            count--;    //count = 6,5,4,3,2,1,0
            $display("\n----------count %d---------------\n",count);
        end
        end

        // req = axi_transaction::type_id::create("req");                  
        // start_item(req);
        // req.awvalid =  0;
        // req.wvalid = 0;
        // req.bready = 1;
        // req.arvalid = 0;
        // req.rready = 0;
        
        // req.awid = 0;
        // req.wid = 0;
        // req.bid = 0;
        // req.arid = 0;
        // req.rid = 0;

        // req.wlast = 0;

        // req.awlen = 0;
        // req.awsize = 0;
        // req.awaddr = 0;
        // req.awburst = 0;

        // `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        // finish_item(req);
        // get_response(rsp);

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

        req.wlast = 0;

        req.awlen = 0;
        req.awsize = 0;
        req.awaddr = 0;
        req.awburst = 0;

        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);

    endtask

endclass //axi_sequence extends uvm_sequence