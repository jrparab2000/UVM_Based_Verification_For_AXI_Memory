class axi_env_configuration extends uvm_object;
    `uvm_object_utils(axi_env_configuration)

    axi_configuration axi_if_config;
    bit predict_enable;
    int reads;
    int writes;

    function new(string name = "");
        super.new(name);
    endfunction

    function void initialize(bit coverage_enable);
        axi_if_config = axi_configuration::type_id::create("axi_if_config");
        axi_if_config.coverage_enable = coverage_enable;
        uvm_config_db #(axi_if_config)::set(this,"*","axi_configuration",axi_if_config);
    endfunction
endclass