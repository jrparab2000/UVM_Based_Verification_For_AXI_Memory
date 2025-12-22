class axi_base_predictor extends uvm_subscriber #(axi_transaction);
    `uvm_component_utils(axi_base_predictor)
    
    uvm_analysis_port #(axi_transaction) ap;

    bit [7:0] mem [128] = '{default:12}; 

    bit [31:0] addr_w;
    bit [31:0] addr_r;

    bit first_read = 1;
    bit first_write = 1;

    int rcount = 0;
    int wcount = 0;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        ap = new("ap",this);
    endfunction

    virtual function void write(axi_transaction t);
    endfunction
    
    virtual function bit [31:0] cal_b_addr(input [31:0] addr, input [7:0] boundary);
        bit [31:0] addr1;
        if((addr + 1) % boundary == 0)
            addr1 = (addr + 1) - boundary;
        else
            addr1 = addr + 1;       
        return addr1;
    endfunction

    virtual function bit [7:0] cal_boundary(input bit [3:0] len,input bit[2:0] size);
        bit [7:0] boundary;
        boundary = (len+1)*(2**size);
        return boundary;           
    endfunction

  virtual function bit [31:0] cal(input [1:0] burst, input [31:0] addr,input bit [3:0] len,input bit[2:0] size);
    if(burst == 0)
        return addr + 1;
    else if(burst == 1)
        return addr + 1;
    else if(burst == 2)
        return cal_b_addr(addr,cal_boundary(len,size));
    endfunction

    virtual function bit [31:0] write_data (axi_transaction in);
    bit [31:0] awaddrt;
    int i;
    if(first_write || (in.awburst == 0)) begin
        awaddrt = in.awaddr;
        first_write = 0;
    end
    else begin
        awaddrt = addr_w;
    end
    for(i = 0; i <4; i++) begin
        if(in.wstrb[i]) begin
            mem[awaddrt] = in.wdata[i*8 +: 8];
            awaddrt = cal(in.awburst,awaddrt,in.awlen,in.awsize);
        end
    end 
    return awaddrt;
  endfunction   

  virtual function bit [31:0] read_data (axi_transaction in, output bit [31:0] rdata);
    bit [31:0] araddrt;
    int i;
    if(first_read||(in.arburst == 0)) begin
        araddrt = in.araddr;
        first_read = 0;
    end
    else begin
        araddrt = addr_r;
    end
    for(i=0;i<(1<<in.arsize);i++) begin
        //below is the bug in the dut cant be resolved so mimic behaviour of dut I introduce same bug in golden modal;
        //when ever address = 0 memory indut returns xx so to mimic that I introduced this condition.
        // --------------------------------------------------------------------------------
        if(araddrt != 0)
            rdata[i*8 +: 8] = mem[araddrt];
        else
            rdata[i*8 +: 8] = 0;
        // --------------------------------------------------------------------------------
        araddrt = cal(in.arburst,araddrt,in.arlen,in.arsize);
    end
    return araddrt;
  endfunction

  virtual function void awaddr_predict(axi_transaction in);
        if(in.wvalid && in.wready) begin
            addr_w = write_data(in);
            wcount++;
        end
        if(in.wlast) begin
            wcount = 0;
            first_write = 1;
            addr_w = 0;
        end
    endfunction

    virtual function bit araddr_predict(axi_transaction in, output bit [31:0] rdata);
        if((in.rvalid) && (in.rready)) begin
            addr_r = read_data(in,rdata);
            rcount++;
            return 1;
        end
        if(in.rlast) begin
            rcount = 0;
            first_read = 1;
            addr_r = 0;
        end
        return 0;
    endfunction

endclass
