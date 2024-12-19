
//////////////////////////////////////TOP
module top;
       	import router_pkg::*;
 	import uvm_pkg::*;
	bit clock;

	always
	    begin
		#10 clock= ! clock;
            end

	src_if in0(clock);
	dst_if in1(clock);
	dst_if in2(clock);
	dst_if in3(clock);

	router_top DUV(.clk(clock),.data_in(in0.data_in),.rstn(in0.resetn),.pkt_valid(in0.pkt_valid),.err(in0.err),.busy(in0.busy),.data_out_0(in1.data_out),.data_out_1(in2.data_out),.data_out_2(in3.data_out),.vld_out_0(in1.vld_out),
				.vld_out_1(in2.vld_out),.vld_out_2(in3.vld_out),.re_0(in1.read_enb),.re_1(in2.read_enb),.re_2(in3.read_enb));   


	initial
	    begin
		`ifdef VCS
       		$fsdbDumpvars(0, top);
        	`endif

		uvm_config_db #(virtual src_if) :: set(null,"*", "vif",in0);
		uvm_config_db #(virtual dst_if) :: set(null,"*", "vif0",in1);
		uvm_config_db #(virtual dst_if) :: set(null,"*", "vif1",in2);
		uvm_config_db #(virtual dst_if) :: set(null,"*", "vif2",in3);

		run_test();
	    end



////////////ASSERTIONS

	property busy_check;
		disable iff(!in0.resetn)
		@(posedge clock) $rose(in0.pkt_valid) |=> (in0.busy);
	endproperty

	property datain_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in0.pkt_valid) |-> (in0.data_in !=0);
	endproperty

	property vld_check;
		disable iff(!in0.resetn)
		@(posedge clock) $rose(in0.pkt_valid) |-> ##3 ((in1.vld_out) || (in2.vld_out) || (in3.vld_out));
	endproperty

	property re0_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in1.vld_out) |-> ##[0:29](in1.read_enb);
	endproperty

	property re1_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in2.vld_out) |-> ##[0:29](in2.read_enb); 
	endproperty

	property re2_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in3.vld_out) |-> ##[0:29](in3.read_enb);
	endproperty

	property dataout0_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in1.read_enb) |=> in1.data_out!=0;
	endproperty


	property dataout1_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in2.read_enb) |=> in2.data_out!=0;
	endproperty

	property dataout2_check;
		disable iff(!in0.resetn)
		@(posedge clock) (in3.read_enb) |=> in3.data_out!=0;
	endproperty

	property datain_stable;
		disable iff(!in0.resetn)
		@(posedge clock)  in0.busy |-> $stable(in0.data_in);
	endproperty


	PROP1: assert property(busy_check);
	PROP2: assert property(datain_check);
	PROP3: assert property(vld_check);
	PROP4: assert property(re0_check);
	PROP5: assert property(re1_check);
	PROP6: assert property(re2_check);
	PROP7: assert property(dataout0_check);
	PROP8: assert property(dataout1_check);
	PROP9: assert property(dataout2_check);
	PROP10: assert property(datain_stable);

	
	COV1: cover property(busy_check);
	COV2: cover property(datain_check);
	COV3: cover property(vld_check);
	COV4: cover property(re0_check);
	COV5: cover property(re1_check);
	COV6: cover property(re2_check);
	COV7: cover property(dataout0_check);
	COV8: cover property(dataout1_check);
	COV9: cover property(dataout2_check);
	COV10: cover property(datain_stable);

	
endmodule  
   

