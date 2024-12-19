class src_agt extends uvm_agent;
	`uvm_component_utils(src_agt)

	src_config src_cfg;

	src_drv drvh;
	src_mon monh;
	src_seqr seqrh;

	function new(string name = "src_agt", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(src_config)::get(this,"","src_config",src_cfg))
			`uvm_fatal("SRC_AGT","get failed")
		monh=src_mon::type_id::create("monh",this);
		if(src_cfg.is_active==UVM_ACTIVE)	
		   begin
			drvh=src_drv::type_id::create("drvh",this);
			seqrh=src_seqr::type_id::create("seqrh",this);
		    end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(src_cfg.is_active==UVM_ACTIVE)
		   begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		   end
	endfunction
   
endclass


	
	
	
