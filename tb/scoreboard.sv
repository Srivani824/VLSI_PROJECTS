class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo#(src_xtn) sfifo;
	uvm_tlm_analysis_fifo#(dst_xtn) dfifo[];

	src_xtn sxtn;
	dst_xtn dxtn;

	env_config env_cfg;
	bit[1:0] addr;

	static int src,dst,com,drp;
	
	covergroup src_cov;
		option.per_instance=1;
		
		ADDR : coverpoint sxtn.header[1:0] {
						bins zero = {0};
						bins one = {1};
						bins two = {2};
							}

		DATA : coverpoint sxtn.header[7:2] {
						bins smalll = {[1:13]};
						bins mediumm = {[14:25]};
						bins largee = {[26:63]};
							}

		ERROR : coverpoint sxtn.err {
					bins zero = {0};
					bins one = {1};
						}
	endgroup


	covergroup dst_cov;
		option.per_instance=1;
		
		ADDR : coverpoint dxtn.header[1:0] {
						bins zero = {0};
						bins one = {1};
						bins two = {2};
							}

		DATA : coverpoint dxtn.header[7:2] {
						bins smalll = {[1:13]};
						bins mediumm = {[14:25]};
						bins largee = {[26:63]};
							}

	endgroup
						

	function new(string name = "scoreboard", uvm_component parent);
		super.new(name,parent);
		src_cov=new();
		dst_cov=new();
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("SB","get failed")
		sfifo=new("sfifo",this);
		dfifo=new[env_cfg.no_of_dstagent];
		foreach(dfifo[i])
			dfifo[i]=new($sformatf("dfifo[%0d]",i),this);
	endfunction

	task run_phase(uvm_phase phase);
		   forever
			begin
				sfifo.get(sxtn);
				src++;
				src_cov.sample();

				dfifo[sxtn.header[1:0]].get(dxtn);
				dst++;
				dst_cov.sample();
				check_data(dxtn);
		  	end
	endtask

	task check_data(dst_xtn dxtn);
		if(!sxtn.err)
		begin
			if(sxtn.header == dxtn.header && sxtn.payload == dxtn.payload && sxtn.parity == dxtn.parity) begin
				`uvm_info("SB","COMPARED SUCCESSFULLY",UVM_NONE)
				`uvm_info("SB",$sformatf("frm smon: \n %s",sxtn.sprint()),UVM_LOW)
				`uvm_info("SB",$sformatf("frm dmon: \n %s",dxtn.sprint()),UVM_LOW) 
				com++;  end
			else  begin
				`uvm_error("SB","COMPARISON FAILED")
				`uvm_info("SB",$sformatf("frm smon: \n %s",sxtn.sprint()),UVM_LOW)
				`uvm_info("SB",$sformatf("frm dmon: \n %s",dxtn.sprint()),UVM_LOW) 
				drp++;   end

		end
		else  begin
			`uvm_error("SB","PACKET MISMATICH")
			drp++;   end

	endtask

	function void report_phase(uvm_phase phase);
		`uvm_info("SB",$sformatf("collected frm src: %0d \n collected frm dst: %0d \n compared: %0d \n dropped:%0d",src,dst,com,drp),UVM_LOW)
	endfunction
endclass

