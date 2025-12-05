typedef struct {
     ///////////////////write address channel

    logic  awvalid;  /// master is sending new address  
    // logic awready;  /// slave is ready to accept request
    logic [3:0] awid; ////// unique ID for each transaction
    logic [3:0] awlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    logic [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    logic [31:0] awaddr; ////write adress of transaction
    logic [1:0] awburst; ////burst type : fixed , INCR , WRAP

    /////////////////////write data channel

    logic wvalid; //// master is sending new data
    // logic wready; //// slave is ready to accept new data 
    logic [3:0] wid; /// unique id for transaction
    logic [31:0] wdata; //// data 
    logic [3:0] wstrb; //// lane having valid data
    logic wlast; //// last transfer in write burst

    ///////////////write response channel

    logic bready; ///master is ready to accept response
    // logic bvalid; //// slave has valid response
    // logic [3:0] bid; ////unique id for transaction
    // logic [1:0] bresp; /// status of write transaction 

    ////////////// read address channel

    // logic	arready;  //read address ready signal from slave
    logic [3:0]	arid;      //read address id
    logic [31:0]	araddr;		//read address signal
    logic [3:0]	arlen;      //length of the burst
    logic [2:0]	arsize;		//number of bytes in a transfer
    logic [1:0]	arburst;	//burst type - fixed, incremental, wrapping
    logic	arvalid;	//address read valid signal

    ///////////////////read data channel
    // logic [3:0] rid;		//read data id
    // logic [31:0]rdata;     //read data from slave
    // logic [1:0] rresp;		//read response signal
    // logic rlast;		//read data last signal
    // logic rvalid;		//read data valid signal
    logic rready;
    
} axi_initiator_struct;

typedef struct {
     ///////////////////write address channel

    // logic  awvalid;  /// master is sending new address  
    logic awready;  /// slave is ready to accept request
    // logic [3:0] awid; ////// unique ID for each transaction
    // logic [3:0] awlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    // logic [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    // logic [31:0] awaddr; ////write adress of transaction
    // logic [1:0] awburst; ////burst type : fixed , INCR , WRAP

    /////////////////////write data channel

    // logic wvalid; //// master is sending new data
    logic wready; //// slave is ready to accept new data 
    // logic [3:0] wid; /// unique id for transaction
    // logic [31:0] wdata; //// data 
    // logic [3:0] wstrb; //// lane having valid data
    // logic wlast; //// last transfer in write burst

    ///////////////write response channel

    // logic bready; ///master is ready to accept response
    logic bvalid; //// slave has valid response
    logic [3:0] bid; ////unique id for transaction
    logic [1:0] bresp; /// status of write transaction 

    ////////////// read address channel

    logic	arready;  //read address ready signal from slave
    // logic [3:0]	arid;      //read address id
    // logic [31:0]	araddr;		//read address signal
    // logic [3:0]	arlen;      //length of the burst
    // logic [2:0]	arsize;		//number of bytes in a transfer
    // logic [1:0]	arburst;	//burst type - fixed, incremental, wrapping
    // logic	arvalid;	//address read valid signal

    ///////////////////read data channel
    logic [3:0] rid;		//read data id
    logic [31:0]rdata;     //read data from slave
    logic [3:0] rstrb;
    logic [1:0] rresp;		//read response signal
    logic rlast;		//read data last signal
    logic rvalid;		//read data valid signal
    // logic rready;
    
} axi_responder_struct;

typedef struct {
     ///////////////////write address channel

    logic  awvalid;  /// master is sending new address  
    logic awready;  /// slave is ready to accept request
    logic [3:0] awid; ////// unique ID for each transaction
    logic [3:0] awlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
    logic [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
    logic [31:0] awaddr; ////write adress of transaction
    logic [1:0] awburst; ////burst type : fixed , INCR , WRAP

    /////////////////////write data channel

    logic wvalid; //// master is sending new data
    logic wready; //// slave is ready to accept new data 
    logic [3:0] wid; /// unique id for transaction
    logic [31:0] wdata; //// data 
    logic [3:0] wstrb; //// lane having valid data
    logic wlast; //// last transfer in write burst

    ///////////////write response channel

    logic bready; ///master is ready to accept response
    logic bvalid; //// slave has valid response
    logic [3:0] bid; ////unique id for transaction
    logic [1:0] bresp; /// status of write transaction 

    ////////////// read address channel

    logic	arready;  //read address ready signal from slave
    logic [3:0]	arid;      //read address id
    logic [31:0]	araddr;		//read address signal
    logic [3:0]	arlen;      //length of the burst
    logic [2:0]	arsize;		//number of bytes in a transfer
    logic [1:0]	arburst;	//burst type - fixed, incremental, wrapping
    logic	arvalid;	//address read valid signal

    ///////////////////read data channel
    logic [3:0] rid;		//read data id
    logic [31:0]rdata;     //read data from slave
    logic [3:0] rstrb;
    logic [1:0] rresp;		//read response signal
    logic rlast;		//read data last signal
    logic rvalid;		//read data valid signal
    logic rready;
    
} axi_monitor_struct;