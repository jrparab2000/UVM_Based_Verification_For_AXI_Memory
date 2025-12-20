class axi_coverage extends uvm_subscriber #(axi_transaction);
    `uvm_component_utils(axi_coverage)

    axi_transaction trans;

    covergroup write_add_cp;
        awlen   :   coverpoint trans.awlen ;
        awsize  :   coverpoint trans.awsize{illegal_bins not_allowed = {[3:7]};}
        awaddr  :   coverpoint trans.awaddr{bins range[10] = {[0:127]};
                                            illegal_bins invalid_addr = {[128:$]};}
        awburst :   coverpoint trans.awburst{illegal_bins reserve = {3};}
    endgroup    :   write_add_cp

    covergroup write_data_cp;
        wdata   :   coverpoint trans.wdata{bins range[10000] = {[0:$]};}
        wstrb   :   coverpoint trans.wstrb{illegal_bins non_zero = {0};}
        wlast   :   coverpoint trans.wlast;
    endgroup    :   write_data_cp

    covergroup  read_add_cp;
        araddr  :   coverpoint trans.araddr{bins range[10] = {[0:127]};
                                            illegal_bins invalid_addr = {[128:$]};}
        arlen   :   coverpoint trans.arlen;
        arsize  :   coverpoint trans.arsize {illegal_bins not_allowed = {[3:7]};}
        arburst :   coverpoint trans.arburst{illegal_bins reserve = {3};}
    endgroup    :   read_add_cp

    covergroup  read_data_cp;
        rdata   :   coverpoint trans.rdata{bins range[10000] = {[0:$]};}
        // rstrb   :   coverpoint trans.rstrb;
        rlast   :   coverpoint trans.rlast;
    endgroup    :   read_data_cp

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
        write_add_cp = new();
        write_data_cp = new();
        read_add_cp = new();
        read_data_cp = new();
    endfunction //new()

   

    virtual function void write(axi_transaction t);
        trans = axi_transaction::type_id::create("trans");
        trans.copy(t);
        if(trans.awvalid)
            write_add_cp.sample();
        if(trans.wvalid)
            write_data_cp.sample();
        if(trans.arvalid)
            read_add_cp.sample();
        if(trans.rready)
            read_data_cp.sample();
    endfunction
endclass //axi_coverage extends uvm_subscriber