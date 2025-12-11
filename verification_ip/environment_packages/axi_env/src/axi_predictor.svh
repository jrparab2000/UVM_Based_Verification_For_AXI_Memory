class axi_predictor extends uvm_subscriber #(axi_transaction);
    `uvm_component_utils(axi_predictor)

    axi_transaction in;
    axi_transaction out;
    uvm_analysis_port #(axi_transaction) ap;
    bit [7:0] mem [31:0];

    bit [31:0] araddr [$];
    bit [31:0] awaddr [$];

    int rcount = 0;
    int wcount = 0;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        ap = new("ap",this);
    endfunction

    virtual function void write(axi_transaction t);
        in = axi_transaction::type_id::create("in");
        out = axi_transaction::type_id::create("out");
        in.copy(t);
        bit flag = axi_mem_predict(in, out.rdata);
        if (flag) begin
            ap.write(out);
        end
    endfunction

    virtual function bit axi_mem_predict(axi_transaction in, output bit [31:0] out);
        bit flag = 0;
        if(in.wvalid && in.wready) begin
            awaddr_predict(in);
            if(awaddr.size() != 0) begin
                mem[awaddr.pop_front()] == in.wdata[31:24];
                mem[awaddr.pop_front()+1] == in.wdata[23:16];
                mem[awaddr.pop_front()+2] == in.wdata[15:8];
                mem[awaddr.pop_front()+3] == in.wdata[7:0];
                flag = 0;
            end
        end
        if(in.rvalid && in.rready) begin
            araddr_predict(in);
            if(awaddr.size() != 0) begin
                out[31:24] = mem[araddr.pop_front()];
                out[23:16] = mem[araddr.pop_front()+1];
                out[15:8] = mem[araddr.pop_front()+2];
                out[7:0] = mem[araddr.pop_front()+3];
                flag = 1;
            end
        end
        return flag;
    endfunction

    virtual function void awaddr_predict(axi_transaction in);
        bit [31:0] addr;
        if((in.awvaild) && (in.awready)) begin
            if (in.awburst == 0)
                addr = in.awaddr;
            else if (in.awburst == 1)
                addr = in.awaddr + wcount*4;
            else if (in.awburst == 2) begin
                int boundary = (in.awlen + 1)*(in.awsize);
                int wrap_boundary = in.awaddr/boundary;
                wrap_boundary = wrap_boundary*boundary + boundary;
                addr = in.awaddr + wcount*4;
                if(addr >= wrap_boundary) begin
                    wcount = 0;
                    addr = in.awaddr + wcount*4;
                end
            end
            awaddr.push_back(addr);
            wcount++;
        end
        else if(!in.awvaild) begin
            wcount = 0;
        end
    endfunction

    virtual function void araddr_predict(axi_transaction in);
        bit [31:0] addr;
        if((in.arvaild) && (in.arready)) begin
            if (in.arburst == 0)
                addr = in.araddr;
            else if (in.arburst == 1)
                addr = in.araddr + rcount*4;
            else if (in.arburst == 2) begin
                int boundary = (in.arlen + 1)*(in.arsize);
                int wrap_boundary = in.araddr/boundary;
                wrap_boundary = wrap_boundary*boundary + boundary;
                addr = in.araddr + rcount*4;
                if(addr >= wrap_boundary) begin
                    rcount = 0;
                    addr = in.araddr + rcount*4;
                end
            end
            araddr.push_back(addr);
            rcount++;
        end
        else if(!in.arvaild) begin
            rcount = 0;
        end
    endfunction
endclass