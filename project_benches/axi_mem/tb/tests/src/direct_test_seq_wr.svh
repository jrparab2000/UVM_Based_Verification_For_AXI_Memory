class direct_test_seq_wr extends uvm_test;
    `uvm_component_utils(direct_test_seq_wr)

    axi_environment environment;
    axi_env_configuration configuration;
    axi_seq_direct_wr seq;

    bit coverage_enable = 0;
    bit predict_enable = 0;
    int runs = 10;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        uvm_cmdline_processor clp;
        string arg;
        clp = uvm_cmdline_processor::get_inst();
        environment = axi_environment::type_id::create("environment",this);
        seq = axi_seq_direct_wr::type_id::create("seq");
        configuration = axi_env_configuration::type_id::create("configuration");

        if (!clp.get_arg_value("+RUNS=", arg))
            `uvm_info(get_type_name(), "RUNS not found in command so by default RUNS = 10", UVM_NONE)
        else begin
            if ($sscanf(arg, "%d", runs) != 1)
                `uvm_fatal("CMDLINE", "Invalid RUNS value")
        end 
        if (!clp.get_arg_value("+COV_EN=", arg))
            `uvm_info(get_type_name(), "COV_EN not found in command so by default COV_EN = DISABLED", UVM_NONE)
        else begin
            if ($sscanf(arg, "%d", coverage_enable) != 1)
                `uvm_fatal("CMDLINE", "Invalid COV_EN value")
        end 
        if (!clp.get_arg_value("+PRE_EN=", arg))
            `uvm_info(get_type_name(), "PRE_EN not found in command so by default PRE_EN = DISABLED", UVM_NONE)
        else begin
            if ($sscanf(arg, "%d", predict_enable) != 1)
                `uvm_fatal("CMDLINE", "Invalid PRE_EN value")
        end 
        configuration.predict_enable = (predict_enable > 0);
        configuration.reads = 0;
        configuration.writes = 0;
        configuration.initialize((coverage_enable>0));

        uvm_config_db #(axi_env_configuration)::set(this,"*","axi_env_configuration",configuration);
    endfunction

    virtual function void end_of_elaboration_phase (uvm_phase phase);
         uvm_top.print_topology ();
      endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "==========Starting virtual sequence==========");
        repeat(runs) begin
            seq.start(environment.agent.sequencer);
            seq = axi_seq_direct_wr::type_id::create("seq");
        end
        phase.drop_objection(this, "====End of Test====");
    endtask
endclass //test_top extendsuvm_tests