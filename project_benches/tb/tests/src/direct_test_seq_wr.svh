class direct_test_seq_wr extends uvm_test;
    `uvm_component_utils(direct_test_seq_wr)

    axi_environment environment;
    axi_env_configuration configuration;
    axi_seq_direct_wr seq;

    bit coverage_enable = 0;
    bit predict_enable = 0;
    int reads = 0;
    int writes = 0;
    int run_pairs = 5;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        environment = axi_environment::type_id::create("environment",this);
        // vseq = axi_virtual_sequence::type_id::create("vseq");
        seq = axi_seq_direct_wr::type_id::create("seq");
        configuration = axi_env_configuration::type_id::create("configuration");

        configuration.predict_enable = predict_enable;
        configuration.reads = reads;
        configuration.writes = writes;
        configuration.initialize(coverage_enable);

        uvm_config_db #(axi_env_configuration)::set(this,"*","axi_env_configuration",configuration);
    endfunction

    virtual function void end_of_elaboration_phase (uvm_phase phase);
         uvm_top.print_topology ();
      endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "==========Starting virtual sequence==========");
        repeat(run_pairs) begin
            seq.start(environment.agent.sequencer);
            seq = axi_seq_direct_wr::type_id::create("seq");
        end
        phase.drop_objection(this, "====End of Test====");
    endtask
endclass //test_top extendsuvm_tests