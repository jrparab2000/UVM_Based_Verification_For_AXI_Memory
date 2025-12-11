class axi_environment extends uvm_environment;
    `uvm_component_utils(axi_environment)

    axi_agent agent;
    axi_env_configuration env_config;
    axi_predictor predict;
    axi_scoreboard score;
    axi_virtual_sequencer vseqr;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(axi_env_configuration)::get(this,"","axi_env_configuration",env_config))
            `uvm_fatal(get_type_name(), "Failed to get the environment configuration handle")
        if(env_config.predict_enable) begin
            predict = axi_predictor::type_id::create("predict",this);
            score = axi_scoreboard::type_id::create("score",this);
        end
        vseqr = axi_virtual_sequencer::type_id::create("vseqr",this);
        agent = axi_agent::type_id::create("agent",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        vseqr.axi_seqr = agent.sequencer;
        if(env_config.predict_enable) begin
            agent.ap.connect(predict.analysis_export);
            agent.ap.connect(score.actual);
            predictor.ap.connect(score.expected);
        end
    endfunction


endclass //axi_environment extends uvm_environment