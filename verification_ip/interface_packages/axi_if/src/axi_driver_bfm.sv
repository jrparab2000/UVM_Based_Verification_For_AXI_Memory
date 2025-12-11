import uvm_pkg::*;
import axi_pkg_hdl::*;
`include "src/axi_typedef.svh"

interface axi_driver_bfm( axi_if bus);

    axi_if_pkg::axi_driver proxy;
    ///////////////////global signals
    logic clk;
    logic rstn;

    ///////////////////write address channel
    logic  awvalid;  
    logic awready;  
    logic [3:0] awid; 
    logic [3:0] awlen; 
    logic [2:0] awsize; 
    logic [31:0] awaddr; 
    logic [1:0] awburst; 
    /////////////////////write data channel  
    logic wvalid; 
    logic wready; 
    logic [3:0] wid; 
    logic [31:0] wdata; 
    logic [3:0] wstrb; 
    logic wlast; 
    ///////////////write response channel
    logic bready; 
    logic bvalid; 
    logic [3:0] bid; 
    logic [1:0] bresp; 
    ////////////// read address channel
    logic	arready;  
    logic [3:0]	arid;      
    logic [31:0]	araddr;		
    logic [3:0]	arlen;      
    logic [2:0]	arsize;		
    logic [1:0]	arburst;	
    logic	arvalid;	
    ///////////////////read data channel
    logic [3:0] rid;		
    logic [31:0]rdata;
    logic [3:0] rstrb; 
    logic [1:0] rresp;		
    logic rlast;		
    logic rvalid;		
    logic rready;

    assign clk = bus.clk;
    assign rstn = bus.rstn;

    assign bus.awvalid = awvalid;  
    assign awready = bus.awready;  
    assign bus.awid = awid; 
    assign bus.awlen = awlen; 
    assign bus.awsize = awsize; 
    assign bus.awaddr = awaddr; 
    assign bus.awburst = awburst;

    assign bus.wvalid = wvalid; 
    assign wready = bus.wready; 
    assign bus.wid = wid; 
    assign bus.wdata = wdata; 
    assign bus.wstrb = wstrb; 
    assign bus.wlast = wlast;

    assign bus.bready = bready; 
    assign bvalid = bus.bvalid; 
    assign bid = bus.bid; 
    assign bresp = bus.bresp;

    assign	arready = bus.arready;  
    assign bus.arid = arid;      
    assign bus.araddr = araddr;		
    assign bus.arlen = arlen;      
    assign bus.arsize = arsize;		
    assign bus.arburst = arburst;	
    assign bus.arvalid = arvalid;

    assign rid = bus.rid;		
    assign rdata = bus.rdata;  
    assign rstrb = bus.rstrb;   
    assign rresp = bus.rresp;		
    assign rlast = bus.rlast;		
    assign rvalid = bus.rvalid;		
    assign bus.rready = rready;


    task initiate_and_get_response(input axi_initiator_struct initator, output axi_responder_struct responder);
        wait(rstn != 0);
        fork: channel_driver_fork
            proxy.write_address(initator,responder);
            proxy.write_data(initator, responder);
            proxy.write_response(initator, responder);
            proxy.read_address(initator, responder);
            proxy.read_data(initator, responder);
        join
        disable channel_driver_fork
        // @(posedge clk)
        // awvalid <= req.awvaild;
        // awid <= req.awid;
        // awlen <= req.awlen;
        // awsize <= req.awsize;
        // awaddr <=  req.awaddr;
        // awburst <= req.awburst;

        // wvaild <= req.wvaild;
        // wid  <=  req.wid;
        // wdata <= req.wdata;
        // wstrb <= req.wstrb;
        // wlast <=  req.wlast;

        // bready <= req.bready;

        // arid <= req.arid;
        // araddr <= req.araddr;
        // arlen <= req.arlen;
        // arsize <= req.arsize;
        // arburst <=  req.arburst;
        // arvaild <= req.arvaild;

        // rready <= req.rready;

        //getting value from pins and giving it to rsp transaction

        // rsp.awvalid <= req.awvaild;
        // rsp.awready <= awready;
        // rsp.awid <= req.awid;
        // rsp.awlen <= req.awlen;
        // rsp.awsize <= req.awsize;
        // rsp.awaddr <=  req.awaddr;
        // rsp.awburst <= req.awburst;

        // rsp.wvaild <= req.wvaild;
        // rsp.wready <= wready;
        // rsp.wid  <=  req.wid;
        // rsp.wdata <= req.wdata;
        // rsp.wstrb <= req.wstrb;
        // rsp.wlast <=  req.wlast;

        // rsp.bready <= req.bready;
        // rsp.bvaild <= bvalid;
        // rsp.bid <= bid;
        // rsp.bresp <= bresp;

        // rsp.arready <= arready;
        // rsp.arid <= req.arid;
        // rsp.araddr <= req.araddr;
        // rsp.arlen <= req.arlen;
        // rsp.arsize <= req.arsize;
        // rsp.arburst <=  req.arburst;
        // rsp.arvaild <= req.arvaild;

        // rsp.rid <= rid;
        // rsp.rdata <= rdata;
        // rsp.rresp <= rresp;
        // rsp.rlast <= rlast;
        // rsp.rvalid <= rvalid;
        // rsp.rready <= req.rready;        
    endtask //automatic
endinterface 