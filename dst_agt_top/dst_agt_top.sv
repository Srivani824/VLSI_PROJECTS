class dst_agt_top extends uvm_env;
	`uvm_component_utils(dst_agt_top)
	
	dst_agt dstagnth[];
	env_config env_cfg;
	
	function new(string name = "dst_agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("DST_AGT_TOP","get failed")
		dstagnth=new[env_cfg.no_of_dstagent];
		foreach(dstagnth[i])
		   begin
			dstagnth[i]=dst_agt::type_id::create($sformatf("dstagnth[%0d]",i),this);
       	 		uvm_config_db #(dst_config)::set(this,$sformatf("dstagnth[%0d]*",i),"dst_config",env_cfg.dst_cfg[i]);
		   end
	endfunction

	//task run_phase(uvm_phase phase);
	//	uvm_top.print_topology;
	//endtask   


endclass


