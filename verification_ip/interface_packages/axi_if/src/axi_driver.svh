class axi_driver extends uvm_driver#(.REQ(axi_transaction),.RSP(axi_transaction));
    `uvm_component_utils(axi_driver)

    virtual axi_driver_bfm bfm;

    axi_responder_struct responder;
    axi_transaction req;
    axi_transaction rsp;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //newstring name = "", uvm_component parent = null()

    virtual function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi_driver_bfm)::get(this,"", "axi_driver_bfm", bfm))
            `uvm_fatal(get_type_name(), "Unable to get the driver bfm...")
        bfm.proxy = this;
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            rsp = axi_transaction::type_id::create("rsp");
            seq_item_port.get_next_item(req);
            bfm.initiate_and_get_response(req.to_initiator_struct(),responder);
            rsp.from_responder_struct(responder);
            rsp.set_id_info(req);
            seq_item_port.item_done(rsp);
        end
    endtask

    virtual task write_address(input axi_initiator_struct initator, output axi_responder_struct responder);
        wait(bfm.rstn);
        @(posedge bfm.clk)
        if(initator.awvalid) begin
        bfm.awvalid <= initator.awvalid;
        wait(initator.awvalid && bfm.awready);
        bfm.awid <= initator.awid;
        bfm.awlen <= initator.awlen;
        bfm.awsize <= initator.awsize;
        bfm.awaddr <=  initator.awaddr;
        bfm.awburst <= initator.awburst;
        responder.awready = bfm.awready;
        end
        else begin
            bfm.awvalid <= 0;
            // wait(initator.awvalid && bfm.awready);
            bfm.awid <= 0;
            bfm.awlen <= 0;
            bfm.awsize <= 0;
            bfm.awaddr <=  0;
            bfm.awburst <= 0;
            // responder.awready <= 0;
        end
        // if(initator.awvalid && initator.wvalid) begin
        //     wait(bfm.wready == 0);
        //     bfm.awvalid <= initator.awvalid;
        //     bfm.wvalid <= initator.wvalid;
        //     bfm.wid  <=  initator.wid;
        //     bfm.wdata <= initator.wdata;
        //     bfm.wstrb <= initator.wstrb;
        //     bfm.wlast <=  initator.wlast;

        //     @(posedge bfm.awready)
        //     bfm.awid <= initator.awid;
        //     bfm.awlen <= initator.awlen;
        //     bfm.awsize <= initator.awsize;
        //     bfm.awaddr <=  initator.awaddr;
        //     bfm.awburst <= initator.awburst;

        //     @(posedge bfm.clk)  
        // end
        // else if(initator.wlast) begin
        //     wait(bfm.wready == 0)
        //     bfm.awvalid <= initator.awvalid;
        //     bfm.wvalid <= initator.wvalid;
        //     bfm.wlast <=  initator.wlast;
        //     bfm.bready <= initator.bready;
        //     wait(bvalid == 1);
        //     responder.bid <= bfm.bid;
        //     responder.bresp <= bfm.bresp;
        //     wait(bvalid == 0);
        //     bfm.awvalid <= 0;
        //     bfm.wvalid <= 0;
        // end
        // else begin
        //     wait();
        // end
    endtask

    virtual task write_data(input axi_initiator_struct initator, output axi_responder_struct responder);
        wait(bfm.rstn);
        @(posedge bfm.clk)
        if(initator.wvalid) begin
        bfm.wvalid <= initator.wvalid;
        wait(initator.wvalid && bfm.wready);
        bfm.wid  <=  initator.wid;
        bfm.wdata <= initator.wdata;
        bfm.wstrb <= initator.wstrb;
        bfm.wlast <=  initator.wlast;
        responder.wready = bfm.wready;
        end
        else begin
            bfm.wvalid <= 0;
            bfm.wid  <=  0;
            bfm.wdata <= 0;
            bfm.wstrb <= 0;
            bfm.wlast <= initator.wlast;
        end
    endtask

    virtual task write_response(input axi_initiator_struct initator, output axi_responder_struct responder);
        wait(bfm.rstn);
        @(posedge bfm.clk)
        if(initator.bready) begin
        bfm.bready <= initator.bready;
        wait(initator.bready && bfm.bvalid);
        responder.bid = bfm.bid;
        responder.bresp = bfm.bresp;
        responder.bvalid = bfm.bvalid;
        end
        else begin
            bfm.bready <= 0;
        // wait(initator.bready && bfm.bvalid);
        end
    endtask

     virtual task read_address(input axi_initiator_struct initator, output axi_responder_struct responder);
        wait(bfm.rstn);
        @(posedge bfm.clk)
        if(initator.arvalid) begin
        bfm.arvalid <= initator.arvalid;
        wait(initator.arvalid && bfm.arready);
        bfm.arid <= initator.arid;
        bfm.araddr <= initator.araddr;
        bfm.arlen <= initator.arlen;
        bfm.arsize <= initator.arsize;
        bfm.arburst <=  initator.arburst;
        responder.arready = bfm.arready;
        end
        else begin
            bfm.arvalid <= 0;
            // wait(initator.arvalid && bfm.arready);
            bfm.arid <= 0;
            bfm.araddr <= 0;
            bfm.arlen <= 0;
            bfm.arsize <= 0;
            bfm.arburst <=  0;
            // responder.arready <= 0;
        end
    endtask

    
    virtual task read_data(input axi_initiator_struct initator, output axi_responder_struct responder);
        // bit flag  <= 0;
        wait(bfm.rstn);
        @(posedge bfm.clk)
        if(initator.rready)begin
        bfm.rready <= initator.rready;
        wait(initator.rready && (bfm.rvalid || bfm.rlast));
        responder.rid = bfm.rid;
        responder.rdata = bfm.rdata;
        responder.rstrb = bfm.rstrb;
        responder.rresp = bfm.rresp;
        responder.rvalid = bfm.rvalid;
        end
        else begin
            bfm.rready <= 0;
            // wait(initator.rready && (bfm.rvalid || bfm.rlast));
            // responder.rid <= 0;
            // responder.rdata <= 0;
            // responder.rstrb <= 0;
            // responder.rresp <= 0;
            // responder.rvalid <= 0;
        end
        // if (initator.arvalid) begin
        //     bfm.arid <= initator.arid;
        //     bfm.araddr <= initator.araddr;
        //     bfm.arlen <= initator.arlen;
        //     bfm.arsize <= initator.arsize;
        //     bfm.arburst <=  initator.arburst;
        //     bfm.arvalid <= initator.arvalid;
        //     @(posedge bfm.rvalid)
        //     responder.rid <= bfm.rid;
        //     responder.rdata <= bfm.rdata;
        //     responder.rresp <= bfm.rresp;
        //     @(posedge bfm.rvalid or posedge bfm.rlast)
        //     if(bfm.rlast) begin
        //         @(negedge bfm.rlast)
        //         bfm.arid <= 0;
        //         bfm.araddr <= 0;
        //         bfm.arlen <= 0;
        //         bfm.arsize <= 0;
        //         bfm.arburst <=  0;
        //         bfm.arvalid <= 0;
        //     end
        // end
    endtask
endclass //axi_driver extends uvm_driver#(.REQ(axi_transaction),.RSP(axi_transaction))