class axi_transaction extends uvm_sequence_item;
    `uvm_object_utils(axi_transaction)

    function new(string name = "");
        super.new(name);
    endfunction //new()

    ///////////////////write address channel
    logic  awvalid;  
    logic awready; 
    logic [3:0] awid; 
    rand logic [3:0] awlen; 
    rand logic [2:0] awsize; 
    rand logic [31:0] awaddr; 
    rand logic [1:0] awburst; 

    /////////////////////write data channel  
    logic wvalid; 
    logic wready; 
    logic [3:0] wid; 
    rand logic [31:0] wdata; 
    rand logic [3:0] wstrb; 
    logic wlast; 

    ///////////////write response channel
    logic bready; 
    logic bvalid;
    logic [3:0] bid; 
    logic [1:0] bresp; 

    ////////////// read address channel
    logic	arready;  
    logic [3:0]	arid;      
    rand logic [31:0]	araddr;		
    rand logic [3:0]	arlen;      
    rand logic [2:0]	arsize;		
    rand logic [1:0]	arburst;	
    logic	arvalid;	

    ///////////////////read data channel
    logic [3:0] rid;		
    logic [31:0]rdata;     
    logic [1:0] rresp;
    logic [3:0] rstrb;		
    logic rlast;		
    logic rvalid;		
    logic rready;

    ///////////////////time data
    time start_time;
    time end_time;
    int transaction_view_h;

    constraint c_size{awsize < 3'b101; arsize < 3'b101; awsize > 0; arsize > 0;}  //cannot be more then 4-bytes which is 32-bits
    constraint c_address{awaddr < 2**(8*awsize); araddr < 2**(8*arsize);}  //cannot be more then 4-bytes which is 32-bits
    constraint c_burst{awburst < 2'b11; arburst < 2'b11;}

    virtual function string convert2string();
        string temp = $sformatf("---------------------------------------write address channel-------------------------------------\n");
        temp = $sformatf(temp,"awvalid = %b | awready = %b | awid = %x | awlen = %x | awsize = %x | awaddr = 0x%x | awburst = %x\n",awvalid, awready, awid, awlen, awsize, awaddr, awburst);
        temp = $sformatf(temp,"-----------------------------------------write data channel--------------------------------------\n");
        temp = $sformatf(temp,"wvalid = %b | wready = %b | wid = %x | wdata = 0x%x | wstrb = %x | wlast = %b\n",wvalid, wready, wid, wdata, wstrb, wlast);
        temp = $sformatf(temp,"---------------------------------------write response channel------------------------------------\n");
        temp = $sformatf(temp,"bready = %b | bvalid = %b | bid = %x | bresp = %x",bready, bvalid, bid, bresp);
        temp = $sformatf(temp,"----------------------------------------read address channel-------------------------------------\n");
        temp = $sformatf(temp,"arready = %b | arid = %x | araddr = 0x%x | arlen = %x | arsize = %x | arburst = %x | arvalid = %b\n",arready, arid, araddr, arlen, arsize, arburst, arvalid);
        temp = $sformatf(temp,"------------------------------------------read data channel--------------------------------------\n");
        temp = $sformatf(temp,"rid = %b | rdata = 0x%x | rstrb = %x | rresp = %x | rlast = %b | rvalid = %b | rready = %b\n",rid,rdata, rstrb, rresp, rlast, rvalid, rready);
        return temp;
    endfunction

    virtual function void do_print(uvm_printer printer);
        $display(convert2string());
    endfunction

    virtual function void do_copy(uvm_object rhs);
        axi_transaction RHS;
        super.do_copy(rhs);
        
        if(!$cast(RHS,rhs)) begin 
            `uvm_error(get_type_name(), "Cannot copy this data please check")
            return;
        end

        awvalid = RHS.awvalid;  
        awready = RHS.awready;  
        awid = RHS.awid; 
        awlen = RHS.awlen; 
        awsize = RHS.awsize; 
        awaddr = RHS.awaddr; 
        awburst = RHS.awburst;

        wvalid = RHS.wvalid; 
        wready = RHS.wready; 
        wid = RHS.wid; 
        wdata = RHS.wdata; 
        wstrb = RHS.wstrb; 
        wlast = RHS.wlast;

        bready = RHS.bready; 
        bvalid = RHS.bvalid; 
        bid = RHS.bid; 
        bresp = RHS.bresp;

        arready = RHS.arready;  
        arid = RHS.arid;      
        araddr = RHS.araddr;		
        arlen = RHS.arlen;      
        arsize = RHS.arsize;		
        arburst = RHS.arburst;	
        arvalid = RHS.arvalid;

        rid = RHS.rid;		
        rdata = RHS.rdata;
        rstrb = RHS.rstrb;     
        rresp = RHS.rresp;		
        rlast = RHS.rlast;		
        rvalid = RHS.rvalid;		
        rready = RHS.rready;
    endfunction

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        bit res;
        axi_transaction RHS;
        if(!$cast(RHS,rhs)) return 0;

        res =   super.do_compare(rhs,comparer) & (rdata == RHS.rdata);
        /*
                // awvalid == rhs.awvalid &  
                // awready == rhs.awready &  
                // awid == rhs.awid & 
                // awlen == rhs.awlen & 
                // awsize == rhs.awsize & 
                // awaddr == rhs.awaddr & 
                // awburst == rhs.awburst & 
                                
                // wvalid == rhs.wvalid & 
                // wready == rhs.wready & 
                // wid == rhs.wid & 
                // wdata == rhs.wdata & 
                // wstrb == rhs.wstrb & 
                // wlast == rhs.wlast &

                // bready == rhs.bready & 
                // bvalid == rhs.bvalid & 
                // bid == rhs.bid & 
                // bresp == rhs.bresp &
                                
                // arready == rhs.arready & 
                // arid == rhs.arid & 
                // araddr == rhs.araddr & 
                // arlen == rhs.arlen & 
                // arsize == rhs.arsize & 
                // arburst == rhs.arburst & 
                // arvalid == rhs.arvalid &	
                                
                // rid == rhs.rid &
                // rdata == rhs.rdata &
                // rresp == rhs.rresp & 
                // rlast == rhs.rlast & 
                // rvalid == rhs.rvalid & 
                // rready == rhs.rready ; 
            */
        return res;
    endfunction

    virtual function void add_to_wave(int transaction_viewing_stream_h);
        
        transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"Axi transaction", start_time);
        
        $add_attribute( transaction_view_h,awvalid, "awvalid");
        $add_attribute( transaction_view_h,awready, "awready");  
        $add_attribute( transaction_view_h,awid , "awid");
        $add_attribute( transaction_view_h,awlen , "awlen");
        $add_attribute( transaction_view_h,awsize , "awsize");
        $add_attribute( transaction_view_h,awaddr , "awaddr");
        $add_attribute( transaction_view_h,awburst, "awburst");

        $add_attribute( transaction_view_h,wvalid, "wvalid");
        $add_attribute( transaction_view_h,wready, "wready");
        $add_attribute( transaction_view_h,wid, "wid");
        $add_attribute( transaction_view_h,wdata, "wdata");
        $add_attribute( transaction_view_h,wstrb, "wstrb");
        $add_attribute( transaction_view_h,wlast, "wlast");

        $add_attribute( transaction_view_h,bready, "bready");
        $add_attribute( transaction_view_h,bvalid, "bvalid");
        $add_attribute( transaction_view_h,bid, "bid");
        $add_attribute( transaction_view_h,bresp, "bresp");

        $add_attribute( transaction_view_h,arready, "arready");
        $add_attribute( transaction_view_h,arid, "arid");
        $add_attribute( transaction_view_h,araddr, "araddr");
        $add_attribute( transaction_view_h,arlen, "arlen");
        $add_attribute( transaction_view_h,arsize, "arsize");
        $add_attribute( transaction_view_h,arburst, "arburst");
        $add_attribute( transaction_view_h,arvalid, "arvalid");

        $add_attribute( transaction_view_h,rid, "rid");
        $add_attribute( transaction_view_h,rdata, "rdata");
        $add_attribute( transaction_view_h,rstrb, "rstrb");
        $add_attribute( transaction_view_h,rresp, "rresp");
        $add_attribute( transaction_view_h,rlast, "rlast");
        $add_attribute( transaction_view_h,rvalid, "rvalid");
        $add_attribute( transaction_view_h,rready, "rready");

        $end_transaction(transaction_view_h, end_time);
        $free_transaction(transaction_view_h);

    endfunction

    virtual function axi_initiator_struct to_initiator_struct();
        axi_initiator_struct lhs;
        lhs.awvalid = awvalid;  
        // lhs.awready = awready;  
        lhs.awid = awid; 
        lhs.awlen = awlen; 
        lhs.awsize = awsize; 
        lhs.awaddr = awaddr; 
        lhs.awburst = awburst;

        lhs.wvalid = wvalid; 
        // lhs.wready = wready; 
        lhs.wid = wid; 
        lhs.wdata = wdata; 
        lhs.wstrb = wstrb; 
        lhs.wlast = wlast;

        lhs.bready = bready; 
        // lhs.bvalid = bvalid; 
        // lhs.bid = bid; 
        // lhs.bresp = bresp;

        // lhs.arready = arready;  
        lhs.arid = arid;      
        lhs.araddr = araddr;		
        lhs.arlen = arlen;      
        lhs.arsize = arsize;		
        lhs.arburst = arburst;	
        lhs.arvalid = arvalid;

        // lhs.rid = rid;		
        // lhs.rdata = rdata;     
        // lhs.rresp = rresp;		
        // lhs.rlast = rlast;		
        // lhs.rvalid = rvalid;		
        lhs.rready = rready;
        return lhs;
    endfunction

    virtual function void from_responder_struct(axi_responder_struct rhs);        
        // awvalid = rhs.awvalid;  
        awready = rhs.awready;  
        // awid = rhs.awid; 
        // awlen = rhs.awlen; 
        // awsize = rhs.awsize; 
        // awaddr = rhs.awaddr; 
        // awburst = rhs.awburst;

        // wvalid = rhs.wvalid; 
        wready = rhs.wready; 
        // wid = rhs.wid; 
        // wdata = rhs.wdata; 
        // wstrb = rhs.wstrb; 
        // wlast = rhs.wlast;

        // bready = rhs.bready; 
        bvalid = rhs.bvalid; 
        bid = rhs.bid; 
        bresp = rhs.bresp;

        arready = rhs.arready;  
        // arid = rhs.arid;      
        // araddr = rhs.araddr;		
        // arlen = rhs.arlen;      
        // arsize = rhs.arsize;		
        // arburst = rhs.arburst;	
        // arvalid = rhs.arvalid;

        rid = rhs.rid;		
        rdata = rhs.rdata;
        rstrb = rhs.rstrb;     
        rresp = rhs.rresp;		
        rlast = rhs.rlast;		
        rvalid = rhs.rvalid;		
        // rready = rhs.rready;
    endfunction

    virtual function axi_responder_struct to_responder_struct();
        axi_responder_struct lhs;
        // lhs.awvalid = awvalid;  
        lhs.awready = awready;  
        // lhs.awid = awid; 
        // lhs.awlen = awlen; 
        // lhs.awsize = awsize; 
        // lhs.awaddr = awaddr; 
        // lhs.awburst = awburst;

        // lhs.wvalid = wvalid; 
        lhs.wready = wready; 
        // lhs.wid = wid; 
        // lhs.wdata = wdata; 
        // lhs.wstrb = wstrb; 
        // lhs.wlast = wlast;

        // lhs.bready = bready; 
        lhs.bvalid = bvalid; 
        lhs.bid = bid; 
        lhs.bresp = bresp;

        lhs.arready = arready;  
        // lhs.arid = arid;      
        // lhs.araddr = araddr;		
        // lhs.arlen = arlen;      
        // lhs.arsize = arsize;		
        // lhs.arburst = arburst;	
        // lhs.arvalid = arvalid;

        lhs.rid = rid;		
        lhs.rdata = rdata;
        lhs.rstrb = rstrb;     
        lhs.rresp = rresp;		
        lhs.rlast = rlast;		
        lhs.rvalid = rvalid;		
        // lhs.rready = rready;
        return lhs;
    endfunction

    virtual function void from_initiator_struct(axi_initiator_struct rhs);        
        awvalid = rhs.awvalid;  
        // awready = rhs.awready;  
        awid = rhs.awid; 
        awlen = rhs.awlen; 
        awsize = rhs.awsize; 
        awaddr = rhs.awaddr; 
        awburst = rhs.awburst;

        wvalid = rhs.wvalid; 
        // wready = rhs.wready; 
        wid = rhs.wid; 
        wdata = rhs.wdata; 
        wstrb = rhs.wstrb; 
        wlast = rhs.wlast;

        bready = rhs.bready; 
        // bvalid = rhs.bvalid; 
        // bid = rhs.bid; 
        // bresp = rhs.bresp;

        // arready = rhs.arready;  
        arid = rhs.arid;      
        araddr = rhs.araddr;		
        arlen = rhs.arlen;      
        arsize = rhs.arsize;		
        arburst = rhs.arburst;	
        arvalid = rhs.arvalid;

        // rid = rhs.rid;		
        // rdata = rhs.rdata;     
        // rresp = rhs.rresp;		
        // rlast = rhs.rlast;		
        // // rvalid = rhs.rvalid;		
        rready = rhs.rready;
    endfunction
    
    virtual function void from_monitor_struct(axi_monitor_struct rhs);        
        awvalid = rhs.awvalid;  
        awready = rhs.awready;  
        awid = rhs.awid; 
        awlen = rhs.awlen; 
        awsize = rhs.awsize; 
        awaddr = rhs.awaddr; 
        awburst = rhs.awburst;

        wvalid = rhs.wvalid; 
        wready = rhs.wready; 
        wid = rhs.wid; 
        wdata = rhs.wdata; 
        wstrb = rhs.wstrb; 
        wlast = rhs.wlast;

        bready = rhs.bready; 
        bvalid = rhs.bvalid; 
        bid = rhs.bid; 
        bresp = rhs.bresp;

        arready = rhs.arready;  
        arid = rhs.arid;      
        araddr = rhs.araddr;		
        arlen = rhs.arlen;      
        arsize = rhs.arsize;		
        arburst = rhs.arburst;	
        arvalid = rhs.arvalid;

        rid = rhs.rid;		
        rdata = rhs.rdata;
        rstrb = rhs.rstrb;     
        rresp = rhs.rresp;		
        rlast = rhs.rlast;		
        rvalid = rhs.rvalid;		
        rready = rhs.rready;
    endfunction

endclass //axi_transaction extends uvm_seq_item