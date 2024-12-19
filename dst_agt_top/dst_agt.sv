class dst_agt extends uvm_agent;
	`uvm_component_utils(dst_agt)

	dst_config dst_cfg;

	dst_drv drvh;
	dst_mon monh;
	dst_seqr seqrh;

	function new(string name = "dst_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
			`uvm_fatal("DST_AGT","get failed")
		monh=dst_mon::type_id::create("monh",this);
		if(dst_cfg.is_active)	
		   begin
			drvh=dst_drv::type_id::create("drvh",this);
			seqrh=dst_seqr::type_id::create("seqrh",this);
		    end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(dst_cfg.is_active)
		   begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		   end
	endfunction
   
endclass

