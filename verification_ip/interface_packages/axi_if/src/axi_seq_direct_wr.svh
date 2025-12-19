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

    // virtual task blank_transaction();
    //     req = axi_transaction::type_id::create("req");                  
    //     start_item(req);
    //     req.awvalid =  0;
    //     req.wvalid = 0;
    //     req.bready = 0;
    //     req.arvalid = 0;
    //     req.rready = 0;
        
    //     req.awid = 0;
    //     req.wid = 0;
    //     req.bid = 0;
    //     req.arid = 0;
    //     req.rid = 0;

    //     req.wlast = 0;

    //     req.awlen = 0;
    //     req.awsize = 0;
    //     req.awaddr = 0;
    //     req.awburst = 0;

    //     req.arlen = 0;
    //     req.arsize = 0;
    //     req.araddr = 0;
    //     req.arburst = 0;

    //     `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
    //     finish_item(req);
    //     get_response(rsp);
    // endtask

    // virtual task start_w_transaction();
    //     req = axi_transaction::type_id::create("req");
    //     start_item(req);
    //     if(!req.randomize() with {wstrb == 4'hf;awsize <= 3'b010;awaddr < 128;}) begin
    //         `uvm_fatal(get_type_name(),"sequence randomization failed")
    //     end
    //     req.awvalid =  1;
    //     req.wvalid = 1;
    //     req.bready = 0;
    //     req.arvalid = 0;
    //     req.rready = 0;

    //     req.awid = 0;
    //     req.wid = 0;
    //     req.bid = 0;
    //     req.arid = 0;
    //     req.rid = 0;

    //     req.wlast = 0;

    //     awlen = req.awlen;      //len = 7
    //     awsize = req.awsize;
    //     awaddr = req.awaddr;
    //     awburst = req.awburst;
    //     wdata = req.wdata;

    //     count = req.awlen + 1;  //count = 8

    //     req.arlen = 0;
    //     req.arsize = 0;
    //     req.araddr = 0;
    //     req.arburst = 0;

    //     `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
    //     finish_item(req);
    //     get_response(rsp);
    // endtask

    // virtual task all_writes();
    //     while (count >= 0) begin
    //     req = axi_transaction::type_id::create("req");                  
    //     start_item(req);
    //     if(count == 0) begin
    //         req.awvalid =  0;
    //         req.wvalid = 1;
    //         req.wlast = 1;
    //         req.bready = 1;
    //         req.arvalid = 0;
    //         req.rready = 0;
    //         req.awlen = 0;
    //         req.awsize = 0;
    //         req.awaddr = 0;
    //         req.awburst = 0;
    //     end
    //     else begin
    //         if(!req.randomize() with {wstrb == 4'hf; awsize <= 3'b010; awaddr < 128;}) begin
    //         `uvm_fatal(get_type_name(),"sequence randomization failed")
    //         end

    //         if(flag == 0) begin
    //             req.wdata = wdata;
    //         end
    //         else begin
    //             wdata = req.wdata;
    //             flag = 0;
    //         end

    //         req.awvalid =  1;
    //         req.wvalid = 1;
    //         req.bready = 0;
    //         req.arvalid = 0;
    //         req.rready = 0;
    //         req.wlast = 0;
    //         req.awlen = awlen;
    //         req.awsize = awsize;
    //         req.awaddr = awaddr;
    //         req.awburst = awburst;
    //     end
    //     req.awid = 0;
    //     req.wid = 0;
    //     req.bid = 0;
    //     req.arid = 0;
    //     req.rid = 0;

    //     req.arlen = 0;
    //     req.arsize = 0;
    //     req.araddr = 0;
    //     req.arburst = 0;
        
    //     `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
    //     finish_item(req);
    //     get_response(rsp);
    //     // $display("\n-----------------------got response----------------------------------\n",count);
    //     `uvm_info(get_type_name(), rsp.convert2string(), UVM_FULL)
    //     if (rsp == null)
    //         `uvm_fatal(get_type_name(), "rsp was not sent")
        
    //     if (rsp.bvalid && req.bready)
    //         break;
        
    //     if(rsp.wready == 1) begin
    //         count--;    //count = 6,5,4,3,2,1,0
    //         // $display("\n----------count %d---------------\n",count);
            
    //         flag = 1;
    //     end
    //     end
    // endtask

    // virtual task end_w_transaction();
    //     req = axi_transaction::type_id::create("req");                  
    //     start_item(req);
    //     req.awvalid =  0;
    //     req.wvalid = 0;
    //     req.bready = 1;
    //     req.arvalid = 0;
    //     req.rready = 0;
        
    //     req.awid = 0;
    //     req.wid = 0;
    //     req.bid = 0;
    //     req.arid = 0;
    //     req.rid = 0;

    //     req.wlast = 1;

    //     req.awlen = 0;
    //     req.awsize = 0;
    //     req.awaddr = 0;
    //     req.awburst = 0;

    //     `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
    //     finish_item(req);
    //     get_response(rsp);
    // endtask

    // virtual task all_reads();
    //     forever begin
    //         req = axi_transaction::type_id::create("req");                  
    //         start_item(req);
    //         // if(!req.randomize() with {arsize <= 3'b010;araddr < 128;}) begin
    //         //     `uvm_fatal(get_type_name(),"sequence randomization failed")
    //         // end

    //         req.awvalid =  0;
    //         req.wvalid = 0;
    //         req.bready = 0;
    //         req.arvalid = 1;
    //         req.rready = 1;

    //         req.awid = 0;
    //         req.wid = 0;
    //         req.bid = 0;
    //         req.arid = 0;
    //         req.rid = 0;

    //         req.arlen = awlen;
    //         req.arsize = awsize;
    //         req.araddr = awaddr;
    //         req.arburst = awburst;
            
    //         req.awlen = 0;
    //         req.awsize = 0;
    //         req.awaddr = 0;
    //         req.awburst = 0;

    //         req.wlast = 0;

    //         `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
    //         finish_item(req);
    //         get_response(rsp);
            
    //         $display("\n-----------------------got response read----------------------------------\n");
    //         `uvm_info(get_type_name(), rsp.convert2string(), UVM_FULL)

    //         if(rsp.rlast == 1) begin
    //             break;    //count = 6,5,4,3,2,1,0
    //         end
    //     end
    // endtask    

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