
module synchronizer(input clk,rstn,detect_addr,we_reg,re_0,re_1,re_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,
			input[1:0]data_in,
			output vld_out_0,vld_out_1,vld_out_2,
			output reg sft_rst_0,sft_rst_1,sft_rst_2,fifo_full,
			output reg[2:0]we);

reg[1:0]addr;
reg[4:0]cnt_0,cnt_1,cnt_2;

always@(posedge clk)
begin
	if(~rstn)
		addr<=0;
	else if(detect_addr)
		addr<=data_in;
end

always@(*)
begin
	if(we_reg)
	begin
		case(addr)
			2'b00:we=3'b1;
			2'b01:we=3'b10;
			2'b10:we=3'b100;
			default:we=3'b0;
		endcase
	end
	else
		we=3'b0;
end

always@(*)
begin
	case(addr)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		default:fifo_full=0;
	endcase
end


assign vld_out_0= ~empty_0;
assign vld_out_1= ~empty_1;
assign vld_out_2= ~empty_2;

always@(posedge clk)
begin
	if(~rstn)
	begin
		cnt_0<=5'b1;
		sft_rst_0<=0;
	end
	else if(~vld_out_0)
	begin
		cnt_0<=5'b1;
		sft_rst_0<=0;
	end
	else if(re_0)
	begin
		cnt_0<=5'b1;
		sft_rst_0<=0;
	end
	else
	begin
		if(cnt_0==5'd30)
		begin
			cnt_0<=5'b1;
			sft_rst_0<=1'b1;
		end
		else
		begin
			sft_rst_0<=0;
			cnt_0<=cnt_0+1'b1;
		end
	end

end

always@(posedge clk)
begin
	if(~rstn)
	begin
		cnt_1<=5'b1;
		sft_rst_1<=0;
	end
	else if(~vld_out_1)
	begin
		cnt_1<=5'b1;
		sft_rst_1<=0;
	end
	else if(re_1)
	begin
		cnt_1<=5'b1;
		sft_rst_1<=0;
	end
	else
	begin
		if(cnt_1==5'd30)
		begin
			cnt_1<=5'b1;
			sft_rst_1<=1'b1;
		end
		else
		begin
			sft_rst_1<=0;
			cnt_1<=cnt_1+1'b1;
		end
	end

end

always@(posedge clk)
begin
	if(~rstn)
	begin
		cnt_2<=5'b1;
		sft_rst_2<=0;
	end
	else if(~vld_out_2)
	begin
		cnt_2<=5'b1;
		sft_rst_2<=0;
	end
	else if(re_2)
	begin
		cnt_2<=5'b1;
		sft_rst_2<=0;
	end
	else
	begin
		if(cnt_2==5'd30)
		begin
			cnt_2<=5'b1;
			sft_rst_2<=1'b1;
		end
		else
		begin
			sft_rst_2<=0;
			cnt_2<=cnt_2+1'b1;
		end
	end

end
endmodule














