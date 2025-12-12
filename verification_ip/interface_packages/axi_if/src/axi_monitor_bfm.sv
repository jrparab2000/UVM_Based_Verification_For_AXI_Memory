import uvm_pkg::*;
import axi_pkg_hdl::*;
// `include "src/axi_typedef.svh"

interface axi_monitor_bfm( axi_if bus);


    axi_if_pkg::axi_monitor proxy;
    axi_monitor_struct moni;
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

    assign awvalid = bus.awvalid;  
    assign awready = bus.awready;  
    assign awid = bus.awid; 
    assign awlen = bus.awlen; 
    assign awsize = bus.awsize; 
    assign awaddr = bus.awaddr; 
    assign awburst = bus.awburst;

    assign wvalid = bus.wvalid; 
    assign wready = bus.wready; 
    assign wid = bus.wid; 
    assign wdata = bus.wdata; 
    assign wstrb = bus.wstrb; 
    assign wlast = bus.wlast;

    assign bready = bus.bready; 
    assign bvalid = bus.bvalid; 
    assign bid = bus.bid; 
    assign bresp = bus.bresp;

    assign	arready = bus.arready;  
    assign arid = bus.arid;      
    assign araddr = bus.araddr;		
    assign arlen = bus.arlen;      
    assign arsize = bus.arsize;		
    assign arburst = bus.arburst;	
    assign arvalid = bus.arvalid;

    assign rid = bus.rid;		
    assign rdata = bus.rdata; 
    assign rstrb = bus.rstrb;    
    assign rresp = bus.rresp;		
    assign rlast = bus.rlast;		
    assign rvalid = bus.rvalid;		
    assign rready = bus.rready;

    event go;
    function void start_monitoring();
        -> go;
    endfunction
    
    initial begin
        @go;
        forever begin
            wait(rstn != 0);
            @(posedge clk);
            do_monitor(moni);
            proxy.notify_transaction(moni);
        end
    end

    task do_monitor(output axi_monitor_struct monitor);

        monitor.awvalid = awvalid;
        monitor.awready = awready;
        monitor.awid = awid;
        monitor.awlen = awlen;
        monitor.awsize = awsize;
        monitor.awaddr =  awaddr;
        monitor.awburst = awburst;

        monitor.wvalid = wvalid;
        monitor.wready = wready;
        monitor.wid  =  wid;
        monitor.wdata = wdata;
        monitor.wstrb = wstrb;
        monitor.wlast =  wlast;

        monitor.bready = bready;
        monitor.bvalid = bvalid;
        monitor.bid = bid;
        monitor.bresp = bresp;

        monitor.arready = arready;
        monitor.arid = arid;
        monitor.araddr = araddr;
        monitor.arlen = arlen;
        monitor.arsize = arsize;
        monitor.arburst =  arburst;
        monitor.arvalid = arvalid;

        monitor.rid = rid;
        monitor.rdata = rdata;
        monitor.rstrb = rstrb;
        monitor.rresp = rresp;
        monitor.rlast = rlast;
        monitor.rvalid = rvalid;
        monitor.rready = rready; 
    endtask

endinterface