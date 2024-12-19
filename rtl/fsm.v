
module fsm(input clk,rstn,pkt_valid,parity_done,sft_rst_0,sft_rst_1,sft_rst_2,fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,
	      input[1:0] data_in,
	      output detect_addr,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state,busy);

parameter DECODE_ADDRESS=3'b000,
	  LOAD_FRST_DATA=3'b001,
	  WAIT_TILL_EMPTY=3'b010,
	  LOAD_DATA=3'b011,
	  FIFO_FULL_STATE=3'b100,
	  LOAD_PARITY=3'b101,
	  LOAD_AFTER_FULL=3'b110,
	  CHECK_PARITY_ERROR=3'b111;

reg[2:0]s,ns;
reg[1:0]addr;

always@(posedge clk)
begin
	if(~rstn)
		s<= DECODE_ADDRESS;
	else if(sft_rst_0||sft_rst_1||sft_rst_2)
		s<= DECODE_ADDRESS;
	else 
		s<=ns;
end

always@(posedge clk)
begin
	if(~rstn)
		addr<=0;
	else
		addr<=data_in;
end


always@(*)
begin
	case(s)
		 DECODE_ADDRESS:
			 if((pkt_valid && data_in[1:0]==0 && empty_0)|
			   (pkt_valid && data_in[1:0]==1 && empty_1)|
			   (pkt_valid && data_in[1:0]==2 && empty_2))
			   ns=LOAD_FRST_DATA;
			 else if((pkt_valid && data_in[1:0]==0 && !empty_0)|
			   (pkt_valid && data_in[1:0]==1 && !empty_1)|
			   (pkt_valid && data_in[1:0]==2 && !empty_2))
			   ns= WAIT_TILL_EMPTY;
			 else
				 ns=DECODE_ADDRESS;
		LOAD_FRST_DATA:
			ns=LOAD_DATA;
		WAIT_TILL_EMPTY:
			 if((empty_0 && (addr==0))||
			   (empty_1 && (addr==1))||
			   (empty_2 && (addr==2)))
			   ns=LOAD_FRST_DATA;
			 else
				 ns=WAIT_TILL_EMPTY;
		 LOAD_DATA:
			if(fifo_full)
				ns=FIFO_FULL_STATE;
			else if(!fifo_full && !pkt_valid)
				ns=LOAD_PARITY;
			else
				ns= LOAD_DATA;
		FIFO_FULL_STATE: 
			if(!fifo_full)
				ns=LOAD_AFTER_FULL;
			else
				ns=FIFO_FULL_STATE;
		LOAD_PARITY:
			ns=CHECK_PARITY_ERROR;
		LOAD_AFTER_FULL:
			if(!parity_done && !low_pkt_valid)
				ns= LOAD_DATA;
			else if(!parity_done && low_pkt_valid)
				ns=LOAD_PARITY;
			else if(parity_done)
				ns=DECODE_ADDRESS;
			else 
				ns=LOAD_AFTER_FULL;
		CHECK_PARITY_ERROR:
			if(!fifo_full)
				ns= DECODE_ADDRESS;
			else if(fifo_full)
				ns=FIFO_FULL_STATE;
			else 
				ns=CHECK_PARITY_ERROR;
		default:
					ns= DECODE_ADDRESS;
	endcase
end

assign detect_addr=(s==DECODE_ADDRESS);
assign ld_state=(s==LOAD_DATA);
assign laf_state=(s==LOAD_AFTER_FULL);
assign full_state=(s==FIFO_FULL_STATE);
assign we_reg=(s==LOAD_DATA || s==LOAD_PARITY || s==LOAD_AFTER_FULL);
assign rst_int_reg=(s==CHECK_PARITY_ERROR);
assign lfd_state=(s==LOAD_FRST_DATA);
assign busy=(s== LOAD_FRST_DATA || s== WAIT_TILL_EMPTY || s== FIFO_FULL_STATE || s==LOAD_PARITY || s==LOAD_AFTER_FULL || s==CHECK_PARITY_ERROR);

endmodule











