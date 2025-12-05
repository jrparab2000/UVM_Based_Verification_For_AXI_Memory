class axi_configuration extends uvm_object;
    `uvm_object_utils(axi_configuration)

    bit coverage_enable;
    
    function new(string name = "");
        super.new(name);
    endfunction
endclass