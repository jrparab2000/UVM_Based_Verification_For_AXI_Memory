interface axi_if(
                    clk, rstn, 
                    awvalid, awready, awid, awlen, awsize, awaddr, awburst, 
                    wvalid, wready, wid, wdata, wstrb, wlast,
                    bready, bvalid, bid, bresp,
                    arready, arid, araddr, arlen, arsize, arburst, arvalid,	
                    rid,rdata, rstrb, rresp, rlast, rvalid, rready
                );
    ///////////////////Global signals

    input logic clk;
    input logic rstn;

    ///////////////////write address channel

    output logic  awvalid;  /// master is sending new address  
    input logic awready;  /// slave is ready to accept request
    output logic [3:0] awid; ////// unique ID for each transaction
    output logic [3:0] awlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    output logic [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    output logic [31:0] awaddr; ////write adress of transaction
    output logic [1:0] awburst; ////burst type : fixed , INCR , WRAP

    /////////////////////write data channel

    output logic wvalid; //// master is sending new data
    input logic wready; //// slave is ready to accept new data 
    output logic [3:0] wid; /// unique id for transaction
    output logic [31:0] wdata; //// data 
    output logic [3:0] wstrb; //// lane having valid data
    output logic wlast; //// last transfer in write burst

    ///////////////write response channel

    output logic bready; ///master is ready to accept response
    input logic bvalid; //// slave has valid response
    input logic [3:0] bid; ////unique id for transaction
    input logic [1:0] bresp; /// status of write transaction 

    ////////////// read address channel

    input logic	arready;  //read address ready signal from slave
    output logic [3:0]	arid;      //read address id
    output logic [31:0]	araddr;		//read address signal
    output logic [3:0]	arlen;      //length of the burst
    output logic [2:0]	arsize;		//number of bytes in a transfer
    output logic [1:0]	arburst;	//burst type - fixed, incremental, wrapping
    output logic	arvalid;	//address read valid signal

    ///////////////////read data channel
    input logic [3:0] rid;		//read data id
    input logic [31:0]rdata;     //read data from slave
    input logic [3:0] rstrb;
    input logic [1:0] rresp;		//read response signal
    input logic rlast;		//read data last signal
    input logic rvalid;		//read data valid signal
    output logic rready;

endinterface //axi_if( logic logic clk,  logic logic rst)