class axi_virtual_sequence extends uvm_sequence;
    `uvm_object_utils(axi_virtual_sequence)
    `uvm_declare_p_sequencer(axi_virtual_sequencer)

    axi_sequence_read read_seq;
    axi_sequence_write write_seq;
    axi_env_configuration env_config;

    function new(string name = "");
        super.new(name);
    endfunction //new()

    virtual task pre_body();
        read_seq = axi_sequence_read::type_id::create("read_seq");
        write_seq = axi_sequence_write::type_id::create("write_seq");
        // if (!uvm_config_db #(axi_env_configuration)::get(this,"","axi_env_configuration",env_config))
        //     `uvm_fatal(get_type_name(),"Failed to get the environment configuration")
         if (p_sequencer == null)
        `uvm_fatal(get_type_name(), "p_sequencer is NULL")

        env_config = p_sequencer.env_config;

        if (env_config == null)
            `uvm_fatal(get_type_name(),"env_config is NULL")
    endtask

    virtual task body();
        repeat(env_config.writes) begin
            write_seq.start(p_sequencer.axi_seqr);
            write_seq = axi_sequence_write::type_id::create("write_seq");
        end
        repeat(env_config.reads) begin
            read_seq.start(p_sequencer.axi_seqr);
            read_seq = axi_sequence_read::type_id::create("read_seq");
        end
    endtask

endclass //axi_virtual_sequence extends uvm_sequence #(axi_transaction)