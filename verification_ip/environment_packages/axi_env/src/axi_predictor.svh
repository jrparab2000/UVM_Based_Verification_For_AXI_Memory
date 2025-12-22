class axi_predictor extends axi_base_predictor;
    `uvm_component_utils(axi_predictor)

    axi_transaction in;
    axi_transaction out;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void write(axi_transaction t);
        bit flag = 0;
        in = axi_transaction::type_id::create("in");
        out = axi_transaction::type_id::create("out");
        in.copy(t);
        // `uvm_info(get_type_name(), in.convert2string(),UVM_HIGH);
        awaddr_predict(in);
        flag = araddr_predict(in,out.rdata);
        if (flag) begin
            ap.write(out);
        end
    endfunction
endclass