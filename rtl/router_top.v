module router_top(input clk,rstn,re_0,re_1,re_2,pkt_valid,
	      input[7:0]data_in,
	      output vld_out_0,vld_out_1,vld_out_2,err,busy,
	      output[7:0]data_out_0,data_out_1,data_out_2);
wire [2:0]wri_enb;
wire[7:0]reg_dout;
wire sft_rst_0,sft_rst_1,sft_rst_2,lfd_state,full_0,full_1,full_2,empty_0,empty_1,empty_2,fifo_full;
wire detect_addr,ld_state,laf_state,full_state,rst_int_reg,parity_done,low_pkt_valid;
wire we_reg;

fifo z0(clk,rstn,sft_rst_0,wri_enb[0],re_0,lfd_state,reg_dout,data_out_0,full_0,empty_0);
fifo z2(clk,rstn,sft_rst_1,wri_enb[1],re_1,lfd_state,reg_dout,data_out_1,full_1,empty_1);
fifo z3(clk,rstn,sft_rst_2,wri_enb[2],re_2,lfd_state,reg_dout,data_out_2,full_2,empty_2);

register z4(clk,rstn,pkt_valid,fifo_full,detect_addr,ld_state,laf_state,full_state,rst_int_reg,lfd_state,data_in,parity_done,low_pkt_valid,err,reg_dout);

synchronizer z5(clk,rstn,detect_addr,we_reg,re_0,re_1,re_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,data_in[1:0],vld_out_0,vld_out_1,vld_out_2,
			sft_rst_0,sft_rst_1,sft_rst_2,fifo_full,wri_enb);

fsm z6(clk,rstn,pkt_valid,parity_done,sft_rst_0,sft_rst_1,sft_rst_2,fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,data_in[1:0],detect_addr,ld_state,
		laf_state,full_state,we_reg,rst_int_reg,lfd_state,busy);


endmodule

