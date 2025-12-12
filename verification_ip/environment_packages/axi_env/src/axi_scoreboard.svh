`uvm_analysis_imp_decl(_predicted)
`uvm_analysis_imp_decl(_actual)

class axi_scoreboard extends uvm_component;
    `uvm_component_utils(axi_scoreboard)

    uvm_analysis_imp_predicted #(axi_transaction, axi_scoreboard) predicted;
    uvm_analysis_imp_actual #(axi_transaction, axi_scoreboard) actual;

    function new(string name = "", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    axi_transaction expected[$];
    axi_transaction orignal[$];
    int missmatch;
    int match;

    virtual function void build_phase(uvm_phase phase);
        predicted = new("predicted",this);
        actual = new("actual",this);
    endfunction

    virtual function void write_predicted(axi_transaction t);
        expected.push_back(t);
    endfunction

    virtual function void write_actual(axi_transaction t);
        axi_transaction temp;
        orignal.push_back(t);
        if(expected.size() != 0) begin
            temp = expected.pop_front();
            if(temp.compare(orignal.pop_front())) begin
                match++;
            end
            else begin
                missmatch++;
            end
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("Matches:    %0d", match), UVM_LOW);
        `uvm_info(get_type_name(),$sformatf("Miss-Matches:    %0d", missmatch), UVM_LOW);
    endfunction
    
endclass //axi_scoreboard extends uvm_subscriber