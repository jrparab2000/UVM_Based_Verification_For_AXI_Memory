class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)

    virtual axi_monitor_bfm vif;
    uvm_analysis_port #(axi_transaction) ap;
    time time_stamp;

    function new(string name = "",uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual axi_monitor_bfm)::get("this","", "axi_monitor_bfm", vif))
        `uvm_fatal(get_type_name(), "Failed to get monitor bfm handle");
        vif.proxy = this;
        ap = new("monitor_analysis", this);    
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.start_monitoring();
    endtask

    virtual task notify_transaction(input axi_monitor_struct monitor);
        axi_transaction trans = axi_transaction::type_id::create("trans");
        trans.from_monitor_struct(monitor);
        trans.start_time = time_stamp;
        trans.end_time = $time;
        time_stamp = trans.end_time;
        `uvm_info(get_type_name(), trans.convert2string(),UVM_DEBUG)
        ap.write(trans);
    endtask



endclass //axi_monitor extends superClass