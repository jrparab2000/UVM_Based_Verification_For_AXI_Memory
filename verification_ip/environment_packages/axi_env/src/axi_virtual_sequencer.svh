class axi_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(axi_virtual_sequencer)

    axi_env_configuration env_config;
    axi_sequencer axi_seqr;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);    
    endfunction //new()

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db #(axi_env_configuration)::get(this,"","axi_env_configuration",env_config))
            `uvm_fatal(get_type_name(),"Failed to get the environment configuration")
    endfunction
endclass //axi_virtual_sequencer extends uvm_sequencer