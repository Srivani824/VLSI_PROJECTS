class src_agt_top extends uvm_env;
	`uvm_component_utils(src_agt_top)
	
	src_agt srcagnth;
	env_config env_cfg;

	function new(string name = "src_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("SRC_AGT_TOP","get failed")
		uvm_config_db #(src_config)::set(this,"srcagnth*","src_config",env_cfg.src_cfg);
		srcagnth=src_agt::type_id::create("srcagnth",this);

	endfunction

	task run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask   


endclass


