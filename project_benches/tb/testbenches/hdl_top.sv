import uvm_pkg::*;
`include "uvm_macros.svh"

import tests_pkg::*;

module hdl_top ();
    ///////////////////Global signals

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
    logic [1:0] rresp;
    logic [3:0] rstrb;		
    logic rlast;		
    logic rvalid;		
    logic rready;

    axi_if hdl_if(  clk, rstn, 
                    awvalid, awready, awid, awlen, awsize, awaddr, awburst, 
                    wvalid, wready, wid, wdata, wstrb, wlast,
                    bready, bvalid, bid, bresp,
                    arready, arid, araddr, arlen, arsize, arburst, arvalid,	
                    rid, rdata, rstrb, rresp, rlast, rvalid, rready
                );
    
    axi_driver_bfm bfm_drv(hdl_if);
    axi_monitor_bfm bfm_moni(hdl_if);

    axi_slave DUT(
        .clk(clk), .resetn(rstn), 
        .awvalid(awvalid), .awready(awready), .awid(awid), .awlen(awlen), .awsize(awsize), .awaddr(awaddr), .awburst(awburst), 
        .wvalid(wvalid), .wready(wready), .wid(wid), .wdata(wdata), .wstrb(wstrb), .wlast(wlast),
        .bready(bready), .bvalid(bvalid), .bid(bid), .bresp(bresp),
        .arready(arready), .arid(arid), .araddr(araddr), .arlen(arlen), .arsize(arsize), .arburst(arburst), .arvalid(arvalid),	
        .rid(rid),.rdata(rdata), .rresp(rresp), .rlast(rlast), .rvalid(rvalid), .rready(rready)
    );

    initial begin
        uvm_config_db #(virtual axi_if)::set(null,"*","axi_if",hdl_if);
    end

    initial begin
        uvm_config_db #(virtual axi_driver_bfm)::set(null,"*","axi_driver_bfm",bfm_drv);
    end

    initial begin
        uvm_config_db #(virtual axi_monitor_bfm)::set(null,"*","axi_monitor_bfm",bfm_moni);
    end

    initial begin
        rstn = 1'b0;
        #10
        rstn = 1'b1;
    end

    initial begin
        forever begin
            #5ns
            clk = ~clk;
        end
    end
endmodule