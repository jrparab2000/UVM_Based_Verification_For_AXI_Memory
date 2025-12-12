class axi_agent extends uvm_agent;
    `uvm_component_utils(axi_agent)

    axi_configuration configuration;
    axi_driver driver;
    axi_monitor monitor;
    axi_sequencer sequencer;
    axi_coverage coverage;

    uvm_analysis_port #(axi_transaction) ap;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(axi_configuration)::get(this,"","axi_configuration",configuration))
            `uvm_fatal(get_type_name(), "Failed to get the configuration")

        if(get_is_active()) begin
            driver = axi_driver::type_id::create("driver",this);
            sequencer = axi_sequencer::type_id::create("sequencer",this);
        end
        else begin
            `uvm_info(get_type_name(), "Agent is working in Passive mode", UVM_DEBUG)
        end

        monitor = axi_monitor::type_id::create("monitor", this);
        if(configuration.coverage_enable)
            coverage = axi_coverage::type_id::create("coverage", this);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        ap = monitor.ap;
        if(get_is_active()) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
        if(configuration.coverage_enable) begin
            monitor.ap.connect(coverage.analysis_export);
        end
    endfunction

endclass //axi_agent extends uvm_agent