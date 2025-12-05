class axi_coverage extends uvm_subscriber #(axi_transaction);
    `uvm_component_utils(axi_coverage)

    axi_transaction trans;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    covergroup write_add_cp;
        awlen   :   coverpoint trans.awlen ;
        awsize  :   coverpoint trans.awsize{illegal_bins awsize = {[4:7]};}
        awaddr  :   coverpoint trans.awaddr{bins range[100000] = {[0:$]};}
        awburst :   coverpoint trans.awburst{illegal_bins awburst = 2'b11;}
    endgroup    :   write_add_cp

    covergroup write_data_cp;
        wdata   :   coverpoint trans.wdata{bins range[100000] = {[0:$]};};
        wstrb   :   coverpoint trans.wstrb;
        wlast   :   coverpoint trans.wlast;
    endgroup    :   write_data_cp

    covergroup  read_add_cp;
        araddr  :   coverpoint trans.araddr{bins range[100000] = {[0:$]};};
        arlen   :   coverpoint trans.arlen;
        arsize  :   coverpoint trans.arsize {illegal_bins awsize = {[4:7]};}
        arburst :   coverpoint trans.arburst{illegal_bins arburst = 2'b11;}
    endgroup    :   read_add_cp

    covergroup  read_data_cp;
        rdata   :   coverpoint trans.rdata{bins range[100000] = {[0:$]};};
        rstrb   :   coverpoint trans.rstrb;
        rlast   :   coverpoint trans.rlast;
    endgroup    :   read_data_cp

    virtual function void write(axi_transaction t);
        trans = axi_transaction::type_id::create("trans");
        trans.copy(t);
        if(trans.awvaild)
            write_add_cp.sample();
        if(trans.wvalid)
            write_data_cp.sample();
        if(trans.arvalid)
            read_add_cp.sample();
        if(trans.rready)
            read_data_cp.sample();
    endfunction
endclass //axi_coverage extends uvm_subscriber