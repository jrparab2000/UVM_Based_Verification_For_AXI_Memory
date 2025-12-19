class axi_base_seq extends uvm_sequence #(.REQ(axi_transaction), .RSP(axi_transaction));
    `uvm_object_utils(axi_base_seq)

    axi_transaction req, rsp;

    function new(string name ="");
        super.new(name);
    endfunction //new()

    virtual task blank_transaction();
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

        req.arlen = 0;
        req.arsize = 0;
        req.araddr = 0;
        req.arburst = 0;

        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);
    endtask

    virtual task start_w_transaction(output logic [3:0] len, output logic [2:0] size, output logic [31:0] addr, output logic [1:0] burst, output logic [31:0] data, output int count, output logic [3:0] strb);
        req = axi_transaction::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {awsize <= 3'b010;awaddr < 128;}) begin
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

        len = req.awlen;      //len = 7
        size = req.awsize;
        addr = req.awaddr;
        burst = req.awburst;
        data = req.wdata;
        strb = req.wstrb;

        count = req.awlen + 1;  //count = 8

        req.arlen = 0;
        req.arsize = 0;
        req.araddr = 0;
        req.arburst = 0;

        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);
    endtask


    virtual task all_writes(input logic [3:0] len, input logic [2:0] size, input logic [31:0] addr, input logic [1:0] burst, input logic [31:0] data, input int count, input logic [3:0] strb);
        logic [31:0] wdata;
        logic [3:0] wstrb;
        bit flag = 0;
        wdata = data;
        wstrb = strb;
        while (count >= 0) begin
        req = axi_transaction::type_id::create("req");                  
        start_item(req);
        if(count == 0) begin
            req.awvalid =  0;
            req.wvalid = 1;
            req.wlast = 1;
            req.bready = 1;
            req.arvalid = 0;
            req.rready = 0;
            req.awlen = 0;
            req.awsize = 0;
            req.awaddr = 0;
            req.awburst = 0;
        end
        else begin
            if(!req.randomize() with {awsize <= 3'b010; awaddr < 128;}) begin
            `uvm_fatal(get_type_name(),"sequence randomization failed")
            end

            if(flag == 0) begin
                req.wdata = wdata;
                req.wstrb = wstrb;
            end
            else begin
                wdata = req.wdata;
                wstrb = req.wstrb;
                flag = 0;
            end

            req.awvalid =  1;
            req.wvalid = 1;
            req.bready = 0;
            req.arvalid = 0;
            req.rready = 0;
            req.wlast = 0;
            req.awlen = len;
            req.awsize = size;
            req.awaddr = addr;
            req.awburst = burst;
        end
        req.awid = 0;
        req.wid = 0;
        req.bid = 0;
        req.arid = 0;
        req.rid = 0;

        req.arlen = 0;
        req.arsize = 0;
        req.araddr = 0;
        req.arburst = 0;
        
        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp);
        // $display("\n-----------------------got response----------------------------------\n",count);
        `uvm_info(get_type_name(), rsp.convert2string(), UVM_FULL)
        if (rsp == null)
            `uvm_fatal(get_type_name(), "rsp was not sent")
        
        if (rsp.bvalid && req.bready)
            break;
        
        if(rsp.wready == 1) begin
            count--;    //count = 6,5,4,3,2,1,0
            // $display("\n----------count %d---------------\n",count);
            
            flag = 1;
        end
        end
    endtask

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

    virtual task start_r_transaction(output logic [3:0] len, output logic [2:0] size, output logic [31:0] addr, output logic [1:0] burst);
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

        len = req.arlen;
        size = req.arsize;
        addr = req.araddr;
        burst = req.arburst;
        
        req.awlen = 0;
        req.awsize = 0;
        req.awaddr = 0;
        req.awburst = 0;

        req.wlast = 0;

        `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
        finish_item(req);
        get_response(rsp); 
    endtask

    virtual task all_reads(input logic [3:0] len, input logic [2:0] size, input logic [31:0] addr, input logic [1:0] burst);
        forever begin
            req = axi_transaction::type_id::create("req");                  
            start_item(req);

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
            
            req.arlen = len;
            req.arsize = size;
            req.araddr = addr;
            req.arburst = burst;
            
            req.awlen = 0;
            req.awsize = 0;
            req.awaddr = 0;
            req.awburst = 0;

            req.wlast = 0;

            `uvm_info(get_type_name(), req.convert2string(), UVM_FULL)
            finish_item(req);
            get_response(rsp);
            
            // $display("\n-----------------------got response read----------------------------------\n");
            `uvm_info(get_type_name(), rsp.convert2string(), UVM_FULL)

            if(rsp.rlast == 1) begin
                break;    //count = 6,5,4,3,2,1,0
            end
        end
    endtask 

    virtual task body();
    endtask
endclass //axi_base_seq extends superClass