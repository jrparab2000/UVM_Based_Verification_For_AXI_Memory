`uvm_analysis_imp_decl(_predicted)
`uvm_analysis_imp_decl(_actual)

class axi_scoreboard extends uvm_component;
    `uvm_component_utils(axi_scoreboard)

    uvm_analysis_imp_predicted #(axi_transaction, axi_scoreboard) predicted;
    uvm_analysis_imp_actual #(axi_transaction, axi_scoreboard) actual;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    bit [31:0] expected[$];
    bit [31:0] orignal[$];
    int missmatch;
    int match;
    int count;

    virtual function void build_phase(uvm_phase phase);
        predicted = new("predicted",this);
        actual = new("actual",this);
    endfunction

    virtual function void write_predicted(axi_transaction t);
        expected.push_back(t.rdata);
    endfunction

    virtual function void write_actual(axi_transaction t);
        bit [31:0] temp;
        bit [31:0] temp_1;
        if(t.rvalid && t.rready) begin
            orignal.push_back(t.rdata);
            if(expected.size() != 0) begin
                count++;
                temp = expected.pop_front();
                temp_1 = orignal.pop_front();
                if(temp == temp_1) begin
                    match++;
                end
                else begin
                    missmatch++;
                    `uvm_info(get_type_name(),$sformatf("expected 0x%0h got 0x%0h", temp, temp_1),UVM_HIGH);
                end
            end
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("Total:         %0d", count),UVM_NONE)
        `uvm_info(get_type_name(),$sformatf("Matches:       %0d", match), UVM_NONE)
        `uvm_info(get_type_name(),$sformatf("Miss-Matches:  %0d", missmatch), UVM_NONE)
    endfunction
    
endclass //axi_scoreboard extends uvm_subscriber