////////////////////////////ENV

class env extends uvm_env;
     	`uvm_component_utils(env)

	src_agt_top src_top;
	dst_agt_top dst_top;
	
	v_seqr v_sequencer;
	scoreboard sb;

        env_config env_cfg;

extern function new(string name = "env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass
//fn def
	function env::new(string name = "env", uvm_component parent);
		super.new(name,parent);
	endfunction

       	function void env::build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("ENV","get failed")
                if(env_cfg.has_srcagt) 
	                 src_top= src_agt_top::type_id::create("src_top",this);
                if(env_cfg.has_dstagt) 
                         dst_top=dst_agt_top::type_id::create("dst_top" ,this);
                if(env_cfg.has_virtual_sequencer)
	                 v_sequencer=v_seqr::type_id::create("v_sequencer",this);
                if(env_cfg.has_scoreboard) 
                         sb=scoreboard :: type_id::create("sb",this);
	     endfunction

	function void env::connect_phase(uvm_phase phase);
		if(env_cfg.has_virtual_sequencer) 
                     begin
                        if(env_cfg.has_srcagt)
	                 	v_sequencer.src_seqrh = src_top.srcagnth.seqrh;
                        if(env_cfg.has_dstagt) 
			    begin
                         	v_sequencer.dst_seqrh=new[env_cfg.no_of_dstagent];
				foreach(v_sequencer.dst_seqrh[i])
                        		v_sequencer.dst_seqrh[i] = dst_top.dstagnth[i].seqrh;	
                      	    end
			if(env_cfg.has_scoreboard) 
                     	    begin
    		       		src_top.srcagnth.monh.monitor_port.connect(sb.sfifo.analysis_export);
                       		foreach(dst_top.dstagnth[i])
      		       			dst_top.dstagnth[i].monh.monitor_port.connect(sb.dfifo[i].analysis_export);
                       		end
		   end
	endfunction 

