module register(input clk,rstn,pkt_valid,fifo_full,detect_addr,ld_state,laf_state,full_state,rst_int_reg,lfd_state,
		input [7:0] data_in,
		output reg parity_done,low_pkt_valid,err,
		output reg [7:0] data_out);

reg [7:0] header,fifo_full_st_byte,int_parity,pkt_parity;

always@(posedge clk)
begin
	if(!rstn)
		header<=0;
	else if(detect_addr && pkt_valid && data_in[1:0]!=2'd3)
		header<=data_in;
	else
		header<=header;
end

always@(posedge clk)
begin
	if(!rstn)
		fifo_full_st_byte<=0;
   else if(fifo_full)
		fifo_full_st_byte<=data_in;
	else
		fifo_full_st_byte<=fifo_full_st_byte;
end

always@(posedge clk)
begin
	if(!rstn)
		int_parity<=0;
	else if(detect_addr)
		int_parity<=0;
	else
	begin
		if(lfd_state)
			int_parity<=int_parity^header;
		else
		begin
			if(pkt_valid && ld_state && !full_state)
				int_parity<=int_parity ^ data_in;
			else
				int_parity<=int_parity;
		end
	end
end

always@(posedge clk)
begin
	if(!rstn)
		pkt_parity<=0;
	else if(detect_addr)
		pkt_parity<=0;
	else
	begin
		if(ld_state && !pkt_valid)
			pkt_parity<=data_in;
		else
			pkt_parity<=pkt_parity;
	end
end

always@(posedge clk)
begin
	if(!rstn)
		parity_done<=0;
		else if(detect_addr)
		parity_done <= 0;
	else if(laf_state && low_pkt_valid && !parity_done)
		parity_done<=1'b1;
	else if(ld_state && !fifo_full && !pkt_valid)
		parity_done<=1'b1;
end

always@(posedge clk)
begin
	if(!rstn || rst_int_reg)
		low_pkt_valid<=0;
	else if(ld_state && !pkt_valid)
		low_pkt_valid<=1;
end

always@(posedge clk)
begin
	if(!rstn)
		err<=0;
		else if(rst_int_reg)
		begin
	 if(pkt_parity !=int_parity)
			err<=1;
	else
			err<=0;  end
end

always@(posedge clk)
begin
	if(!rstn)
		data_out<=0;
	else if(detect_addr && pkt_valid && data_in[1:0]!=2'd3)
		data_out<=data_out;
	else if(lfd_state)
		data_out<=header;
	else if(ld_state && !fifo_full)
		data_out<=data_in;
	else if(ld_state && fifo_full)
		data_out<=data_out;
	else if(laf_state)
		data_out<=fifo_full_st_byte;
	else
		data_out<=data_out;
end

endmodule






















		
