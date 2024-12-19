
module fifo #(parameter D=16, W=9,A=4,T=7)
	(input clk,rstn,sftrst,we,re,lfd_state,
	input[W-2:0]data_in,
	output reg [W-2:0]data_out,
	output full,empty); 
reg[W-1:0] mem [0:D-1];
reg [A-1:0]wptr,rptr;
reg[T-1:0]temp;
integer i;
reg lfd;

always@(posedge clk)
begin
	if(!rstn)
		lfd<=0;
	else
		lfd<=lfd_state;
end

always@(posedge clk)
begin
	if(~rstn)
	begin
		for(i=0;i<D;i=i+1)
		begin
			mem[i]<=0;
		   wptr<=0;
		end	
		
	end
	else if(sftrst)
	begin
		for(i=0;i<D;i=i+1)
		begin
			mem[i]<=0; 
		end	
		wptr<=0;
	end

	else if(we && !full)
	begin
	/*if(wptr[4])
	  wptr<=0;
	  else begin*/
		mem[wptr]<={lfd,data_in};
		wptr<=wptr+1'b1;
		//end
	end
end

always@(posedge clk)
begin
	
	if(~rstn)
	begin
		data_out<=0;
		rptr<=0;
	end
	else if(sftrst)
	begin
		data_out<=8'bz;
		rptr<=0;
	end
   else if(temp == 0 && data_out!=0)
		data_out<=8'bz;
	else if(re && !empty)
	begin
	/*if(rptr[4])
	rptr<=0;
	else 
	begin*/
		data_out<=mem[rptr[A-1:0]][7:0];
		rptr<=rptr+1'b1;
		//end
	end
end

always@(posedge clk)
begin
	if(~rstn)
	begin
		temp<=0;
	end
	else if(sftrst)
	begin
		temp<=0;
	end
   else if(re && ~empty)
       	       begin
	       	       if(mem[rptr[A-1:0]][W-1] == 1'b1)
						 temp<=mem[rptr[A-1:0]][7:2]+1'b1;
						 else 
						 begin
						 if(temp!= 0)
						 temp<=temp-1'b1;
						 else
						 temp<=temp; 
						 end
					 end
	       else
		       temp<=temp;
end

assign empty=(wptr==rptr);
assign full=(wptr+1==rptr);

endmodule 
